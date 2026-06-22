import numpy as np
import sys
import os
import scipy.io
import joblib
import matplotlib.pyplot as plt
from scipy.spatial.distance import cdist

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from Battery.battery_data_reader import get_battery_data, get_capacity, get_capacity_max_and_min
from RBF.postmnmx import reverse_min_max_normalize, min_max_normalize

class RBFNet:
    """
    模拟 MATLAB newrb 的 RBF 神经网络。
    
    newrb 算法:
    1. 从空网络开始，逐次添加 RBF 神经元
    2. 每次选择当前误差最大的样本作为新神经元的中心
    3. 高斯径向基函数: radbas(n) = exp(-n^2)
    4. 偏置 b = 0.8326 / spread，使得距离中心为 spread 时输出为 0.5
    5. 输出层通过线性最小二乘求解权重
    6. 当 MSE < goal 或达到最大神经元数时停止
    """
    
    def __init__(self, spread, mn, goal=5e-5):
        self.spread = spread
        self.mn = int(mn)
        self.goal = goal
        self.iw = None
        self.lw = None
        self.ib = None
        self.lb = None
        self.n_neurons = 0
    
    def fit(self, X, y):
        """
        训练 RBF 网络，模仿 MATLAB newrb 算法。
        
        X: (n_samples, n_features)
        y: (n_samples,)
        """
        n_samples = X.shape[0]
        b = 0.8326 / self.spread
        
        used_indices = []
        remaining = list(range(n_samples))
        current_output = np.zeros(n_samples)
        
        for _ in range(min(self.mn, n_samples)):
            errors = y - current_output
            mse = np.mean(errors ** 2)
            
            if mse < self.goal:
                break
            
            abs_errors = np.abs(errors[remaining])
            if np.max(abs_errors) < 1e-15:
                break
            
            best_idx_in_remaining = np.argmax(abs_errors)
            best_idx = remaining[best_idx_in_remaining]
            
            used_indices.append(best_idx)
            remaining.remove(best_idx)
            self.n_neurons = len(used_indices)
            
            centers = X[used_indices]
            dist = cdist(centers, X)  # (n_neurons, n_samples)
            H = np.exp(-(dist * b) ** 2).T  # (n_samples, n_neurons)
            H_aug = np.hstack([H, np.ones((n_samples, 1))])
            
            weights_aug = np.linalg.lstsq(H_aug, y, rcond=None)[0]
            self.lw = weights_aug[:-1].reshape(1, -1)  # (1, n_neurons)
            self.lb = weights_aug[-1]
            self.iw = centers
            self.ib = np.full(self.n_neurons, b)
            
            current_output = H @ self.lw.flatten() + self.lb
        
        self.iw = X[used_indices]
        self.ib = np.full(self.n_neurons, b)
        return self
    
    def predict(self, X):
        """
        前向传播，与 MATLAB 代码逻辑一致:
        input_weight = dist(iw, input)
        input_bias = netprod(input_weight, ib)
        input_hidden = radbas(input_bias)
        output = dotprod(lw, input_hidden)
        ty = netsum(output, lb)
        
        X: (n_samples, n_features)
        Returns: (n_samples,)
        """
        dist_mat = cdist(self.iw, X)  # (n_neurons, n_samples)
        input_bias = dist_mat * self.ib.reshape(-1, 1)
        input_hidden = np.exp(-input_bias ** 2)
        output = self.lw @ input_hidden + self.lb
        return output.flatten()
    
    def __getstate__(self):
        state = self.__dict__.copy()
        return state
    
    def __setstate__(self, state):
        self.__dict__.update(state)


def RBF(spread, mn, trainnumber, testnumber, save_model):
    Battery_data_train = get_battery_data(trainnumber)
    Battery_data_test = get_battery_data(testnumber)
    
    Capacity_train_temp = get_capacity(trainnumber)
    Capacity_test = get_capacity(testnumber)
    Capacity_max_and_min = get_capacity_max_and_min(testnumber)
    Capacity_train = Capacity_train_temp.reshape(-1, 1)
    
    net = RBFNet(spread=spread, mn=mn, goal=5e-5)
    net.fit(Battery_data_train.T, Capacity_train.T.flatten())
    
    ty = net.predict(Battery_data_test.T)
    
    Capacity_new = reverse_min_max_normalize(Capacity_test, Capacity_max_and_min[1], Capacity_max_and_min[0])
    Capacity_new = Capacity_new / Capacity_max_and_min[0] * 100
    
    ty_temp = reverse_min_max_normalize(ty, Capacity_max_and_min[1], Capacity_max_and_min[0])
    ty_new = ty_temp / Capacity_max_and_min[0] * 100
    
    #print(ty_new)
    #print(Capacity_new)

    test_error = ty_new - Capacity_new
    #print(test_error)
    test_mse = np.mean(test_error ** 2)
    test_se = np.sum(test_error ** 2)
    test_rmse = np.sqrt(test_mse)
    test_mae = np.mean(np.abs(test_error))
    test_mape = np.mean(np.abs(test_error / Capacity_new)) * 100

    if save_model:
        project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        models_dir = os.path.join(project_root, 'models')
        if not os.path.exists(models_dir):
            os.makedirs(models_dir)
        model_path = os.path.join(models_dir, save_model)

        model_data = {
            'net': net,
            'spread': spread,
            'mn': mn,
            'trainnumber': trainnumber,
            'testnumber': testnumber,
            'Capacity_max_and_min': Capacity_max_and_min,
            'ty_new': ty_new,
            'test_error': test_error,
            'test_se': test_se,
            'test_mse': test_mse,
            'test_rmse': test_rmse,
            'test_mae': test_mae,
            'test_mape': test_mape,
            'n_neurons': net.n_neurons
        }
        joblib.dump(model_data, model_path)
        #print("模型已保存到:", model_path)
        

    return spread, mn, test_error, test_se, test_mse, test_rmse, test_mae, test_mape



def load_rbf_model(model_name):
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    model_path = os.path.join(project_root, 'models', model_name)
    
    model_data = joblib.load(model_path)
    return model_data
