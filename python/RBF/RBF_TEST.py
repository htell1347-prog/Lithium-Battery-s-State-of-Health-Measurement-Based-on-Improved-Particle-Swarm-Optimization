import numpy as np
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from Battery.battery_data_reader import get_battery_data, get_capacity, get_capacity_max_and_min
from RBF.postmnmx import reverse_min_max_normalize


def rbf_test(net, testnumber):
    Battery_data_test = get_battery_data(testnumber)
    Capacity_test = get_capacity(testnumber)
    Capacity_max_and_min = get_capacity_max_and_min(testnumber)
    
    ty = net.predict(Battery_data_test.T)
    
    Capacity_new = reverse_min_max_normalize(Capacity_test, Capacity_max_and_min[1], Capacity_max_and_min[0])
    Capacity_new = Capacity_new / Capacity_max_and_min[0] * 100
    
    ty_temp = reverse_min_max_normalize(ty, Capacity_max_and_min[1], Capacity_max_and_min[0])
    ty_new = ty_temp / Capacity_max_and_min[0] * 100
    
    test_error = ty_new - Capacity_new
    
    test_mse = np.mean(test_error ** 2)
    test_rmse = np.sqrt(test_mse)
    test_mae = np.mean(np.abs(test_error))
    test_mape = np.mean(np.abs(test_error / Capacity_new)) * 100
    
    return ty_new, test_mse, test_rmse, test_mae, test_mape
