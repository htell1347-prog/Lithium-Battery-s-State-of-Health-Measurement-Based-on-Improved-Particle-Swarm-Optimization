from calendar import c
import numpy as np
from Battery.battery_data_reader import get_capacity, get_capacity_max_and_min, get_time
from RBF.postmnmx import reverse_min_max_normalize



def peukert_model_train(trainnumber):
    capacity_train = get_capacity(trainnumber)
    current_measured_train = 2
    time_train = get_time(trainnumber)
    
    capacity_max, capacity_min = get_capacity_max_and_min(trainnumber)
    capacity_train_temp = reverse_min_max_normalize(capacity_train, capacity_min, capacity_max)
    capacity_train_ln = np.log(capacity_train_temp)
    time_train_ln = np.log(time_train / 3600) 
    current_measured_train_ln = np.log(current_measured_train)
    
    p_temp = (capacity_train_ln - time_train_ln) / current_measured_train_ln
    p = np.mean(p_temp)
    
    return p


def peukert_model(p, testnumber):
    capacity_test = get_capacity(testnumber)
    current_measured_test = 2
    time_test = get_time(testnumber)
    
    time_test_ln = np.log(time_test / 3600)
    current_measured_test_ln = np.log(current_measured_test)
    ty_temp = np.exp(p * current_measured_test_ln + time_test_ln)
    
    capacity_max, capacity_min = get_capacity_max_and_min(testnumber)
    capacity_test_temp = reverse_min_max_normalize(capacity_test, capacity_min, capacity_max)
    capacity_test_new = capacity_test_temp * 100
    
    ty_new = ty_temp / capacity_max * 100
    
    test_error = ty_new - capacity_test_new
    
    test_mse = np.mean(test_error ** 2)
    test_rmse = np.sqrt(test_mse)
    test_mae = np.mean(np.abs(test_error))
    test_mape = np.mean(np.abs(test_error / capacity_test_new)) * 100
    
    return ty_new, test_mse, test_rmse, test_mae, test_mape
