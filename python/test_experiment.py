import matplotlib.pyplot as plt
import numpy as np
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

from Battery.battery_data_reader import get_capacity, get_capacity_max_and_min
from Peukert.peukert_model import peukert_model_train, peukert_model
from RBF.postmnmx import reverse_min_max_normalize
from RBF.RBF_TEST import rbf_test
from RBF.RBF import load_rbf_model

def test_experiment():
    # 加载训练好的模型
    
    model_data2 = load_rbf_model('GA_RBF_model.pkl')
    net2 = model_data2['net']
    print(f"spreadbest: {model_data2['spread']}")
    print(f"mnbest: {model_data2['mn']}")
    model_data3 = load_rbf_model('PSO_RBF_model.pkl')
    net3 = model_data3['net']
    print(f"spreadbest: {model_data3['spread']}")
    print(f"mnbest: {model_data3['mn']}")
    model_data4 = load_rbf_model('IPSO_RBF_model.pkl')
    net4 = model_data4['net']
    print(f"spreadbest: {model_data4['spread']}")
    print(f"mnbest: {model_data4['mn']}")
    
    trainnumber = 5
    testnumber = 6
    
    capacity_train = get_capacity(testnumber)

    capacity_max, capacity_min = get_capacity_max_and_min(testnumber)
    capacity_new = np.zeros_like(capacity_train)
    capacity_temp = reverse_min_max_normalize(capacity_train, capacity_min, capacity_max)
    for i in range(len(capacity_temp)):
        capacity_new[i] = capacity_temp[i]/capacity_max*100;
    p = peukert_model_train(trainnumber)
    
    ty0 = capacity_new
    ty1, test_mse_1, test_rmse_1, test_mae_1, test_mape_1 = peukert_model(p, testnumber)
    ty2,test_mse_2,test_rmse_2,test_mae_2,test_mape_2 = rbf_test(net2,testnumber);#GA
    ty3,test_mse_3,test_rmse_3,test_mae_3,test_mape_3 = rbf_test(net3,testnumber);#PSO
    ty4,test_mse_4,test_rmse_4,test_mae_4,test_mape_4 = rbf_test(net4,testnumber);#IPSO
    
    plt.figure(1, figsize=(10, 6))
    plt.plot(ty0, 'r-', linewidth=2, label='实际输出')
    plt.plot(ty1, 'g-.', linewidth=2, label='Peukert')
    plt.plot(ty2, 'b-', linewidth=2, label='GA')
    plt.plot(ty3, 'y-', linewidth=6, label='PSO')
    plt.plot(ty4, 'm-', linewidth=2, label='IPSO')
    
    plt.grid(True)
    plt.legend(fontsize=12)
    plt.xlabel('循环次数', fontsize=20)
    plt.ylabel('SOH', fontsize=20)
    
    plt.rcParams['font.sans-serif'] = ['SimHei']
    plt.rcParams['axes.unicode_minus'] = False
    
    plt.tight_layout()
    plt.show()

if __name__ == '__main__':
    test_experiment()
