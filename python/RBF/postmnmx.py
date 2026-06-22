import numpy as np

def min_max_normalize(data, new_min=-1, new_max=1):
    """
    对数据进行最小-最大归一化。
    
    参数:
    data (array-like): 要归一化的数据。
    new_min (float): 归一化后的最小值，默认为0。
    new_max (float): 归一化后的最大值，默认为1。
    
    返回:
    array: 归一化后的数据。
    """
    data = np.array(data, dtype=float)
    original_min = np.min(data)
    original_max = np.max(data)
    
    # 防止除以0的错误
    if original_min == original_max:
        return data - original_min  # 或者其他处理方式，例如返回原始数据或抛出异常
    
    normalized_data = (data - original_min) / (original_max - original_min) * (new_max - new_min) + new_min
    return normalized_data

def reverse_min_max_normalize(normalized_data, original_min, original_max):
    """
    反归一化函数，将归一化后的数据恢复到原始范围
    返回:
        恢复到原始范围的数据
    """
    new_min = -1
    new_max = 1
    normalized_data = np.array(normalized_data, dtype=float)
    range_factor = original_max - original_min
    reverse_normalized_data = ((normalized_data - new_min) / (new_max - new_min)) * range_factor + original_min
    return reverse_normalized_data