import numpy as np
import scipy.io
import os
from RBF.postmnmx import min_max_normalize, reverse_min_max_normalize


def get_capacity(number):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    mat_file = os.path.join(script_dir, f"B000{number}.mat") if number in [5, 6, 7] else os.path.join(script_dir, f"B00{number}.mat")
    data = scipy.io.loadmat(mat_file)
    
    var_name = f'B000{number}' if number in [5, 6, 7] else f'B00{number}'
    battery_data = data[var_name][0][0]
    cycles = battery_data['cycle'][0]
    capacity_sum = []
    
    for cycle in cycles:
        if cycle['type'][0] == 'discharge':
            capacity_data = cycle['data'][0]['Capacity'][0]
            capacity_sum.append(capacity_data[0])
    
    capacity_sum = np.array(capacity_sum).reshape(-1, 1)
    capacity_sum_normalized = min_max_normalize(capacity_sum)
    
    return capacity_sum_normalized.flatten()


def get_capacity_max_and_min(number):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    mat_file = os.path.join(script_dir, f"B000{number}.mat") if number in [5, 6, 7] else os.path.join(script_dir, f"B00{number}.mat")
    data = scipy.io.loadmat(mat_file)

    
    var_name = f'B000{number}' if number in [5, 6, 7] else f'B00{number}'
    battery_data = data[var_name][0][0]
    cycles = battery_data['cycle'][0]
    capacity = []
    
    for cycle in cycles:
        if cycle['type'][0] == 'discharge':
            capacity_data = cycle['data'][0]['Capacity'][0]
            #print(capacity_data)
            capacity.append(capacity_data[0])
    capacity_max = np.array(capacity).max()
    capacity_min = np.array(capacity).min()
    return capacity_max, capacity_min


def get_temperature_measured_average(number):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    mat_file = os.path.join(script_dir, f"B000{number}.mat") if number in [5, 6, 7] else os.path.join(script_dir, f"B00{number}.mat")
    data = scipy.io.loadmat(mat_file)
    
    var_name = f'B000{number}' if number in [5, 6, 7] else f'B00{number}'
    battery_data = data[var_name][0][0]
    cycles = battery_data['cycle'][0]
    temperature_averages = []
    
    for cycle in cycles:
        if cycle['type'][0] == 'discharge':
            temp_data = cycle['data'][0]['Temperature_measured'][0]
            temperature_averages.append(temp_data.mean())
    
    temperature_averages = np.array(temperature_averages).reshape(-1, 1)
    temperature_averages_normalized = min_max_normalize(temperature_averages)
    
    return temperature_averages_normalized.flatten()


def get_temperature_measured_max(number):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    mat_file = os.path.join(script_dir, f"B000{number}.mat") if number in [5, 6, 7] else os.path.join(script_dir, f"B00{number}.mat")
    data = scipy.io.loadmat(mat_file)
    
    var_name = f'B000{number}' if number in [5, 6, 7] else f'B00{number}'
    battery_data = data[var_name][0][0]
    cycles = battery_data['cycle'][0]
    temperature_max_values = []
    
    for cycle in cycles:
        if cycle['type'][0] == 'discharge':
            temp_data = cycle['data'][0]['Temperature_measured'][0]
            temperature_max_values.append(temp_data.max())
    
    temperature_max_values = np.array(temperature_max_values).reshape(-1, 1)
    temperature_max_values_normalized = min_max_normalize(temperature_max_values)
    
    return temperature_max_values_normalized.flatten()


def get_time(number):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    mat_file = os.path.join(script_dir, f"B000{number}.mat") if number in [5, 6, 7] else os.path.join(script_dir, f"B00{number}.mat")
    data = scipy.io.loadmat(mat_file)
    
    var_name = f'B000{number}' if number in [5, 6, 7] else f'B00{number}'
    battery_data = data[var_name][0][0]
    cycles = battery_data['cycle'][0]
    times = []
    
    for cycle in cycles:
        if cycle['type'][0] == 'discharge':
            time_data = cycle['data'][0]['Time'][0]
            times.append(time_data[0, -1])
    
    return np.array(times)


def get_voltage_measured_average(number):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    mat_file = os.path.join(script_dir, f"B000{number}.mat") if number in [5, 6, 7] else os.path.join(script_dir, f"B00{number}.mat")
    data = scipy.io.loadmat(mat_file)
    
    var_name = f'B000{number}' if number in [5, 6, 7] else f'B00{number}'
    battery_data = data[var_name][0][0]
    cycles = battery_data['cycle'][0]
    voltage_averages = []
    
    for cycle in cycles:
        if cycle['type'][0] == 'discharge':
            voltage_data = cycle['data'][0]['Voltage_measured'][0]
            voltage_averages.append(voltage_data.mean())
    
    voltage_averages = np.array(voltage_averages).reshape(-1, 1)
    voltage_averages_normalized = min_max_normalize(voltage_averages)
    
    return voltage_averages_normalized.flatten()


def get_voltage_measured_max(number):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    mat_file = os.path.join(script_dir, f"B000{number}.mat") if number in [5, 6, 7] else os.path.join(script_dir, f"B00{number}.mat")
    data = scipy.io.loadmat(mat_file)
    
    var_name = f'B000{number}' if number in [5, 6, 7] else f'B00{number}'
    battery_data = data[var_name][0][0]
    cycles = battery_data['cycle'][0]
    voltage_max_values = []
    
    for cycle in cycles:
        if cycle['type'][0] == 'discharge':
            voltage_data = cycle['data'][0]['Voltage_measured'][0]
            voltage_max_values.append(voltage_data[0, -1])
    
    voltage_max_values = np.array(voltage_max_values).reshape(-1, 1)
    voltage_max_values_normalized = min_max_normalize(voltage_max_values)
    
    return voltage_max_values_normalized.flatten()


def get_battery_data(number):
    temperature_average = get_temperature_measured_average(number)
    temperature_max = get_temperature_measured_max(number)
    voltage_average = get_voltage_measured_average(number)
    voltage_max = get_voltage_measured_max(number)
    time_data = get_time(number)
    
    time_normalized = min_max_normalize(time_data)
    
    battery_data = np.array([
        temperature_average,
        temperature_max,
        voltage_average,
        voltage_max,
        time_normalized
    ])
    
    return battery_data
