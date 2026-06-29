中文 | [English](https://github.com/htell1347-prog/Lithium-Battery-s-State-of-Health-Measurement-Based-on-Improved-Particle-Swarm-Optimization/blob/main/README_EN.md)

# 基于改进粒子群算法的锂电池健康度测量问题研究

**Lithium Battery ’s State of Health Measurement Based on Improved Particle Swarm Optimization**

[![Platform](https://img.shields.io/badge/Platform-MATLAB%20%7C%20Python-blue)]()
[![License](https://img.shields.io/badge/License-MIT-green)]()

---
（本科毕业论文课题归档及使用python语言重置）

## 摘要

针对锂电池健康状态（State of Health, SOH）测量问题，本文提出了一种基于**改进粒子群算法（IPSO）**优化**径向基函数（RBF）神经网络**的方法。传统粒子群算法（PSO）存在早熟收敛问题，通过引入**压缩因子**和**二阶振荡环节**，提高了全局搜索能力和收敛精度。在此基础上，利用IPSO自动优化RBF神经网络的扩展速度（spread）和最大神经元数（max neurons, MN），构建锂电池SOH预测模型。

---

## 项目结构

```
├── matlab/                     # MATLAB版本实现
│   ├── IPSO.m                  # 改进粒子群算法核心
│   ├── PSO.m                   # 标准粒子群算法
│   ├── IPSO_RBF.m / PSO_RBF.m  # IPSO/PSO 优化 RBF 主流程
│   ├── RBF.m / RBF_train.m     # RBF 神经网络训练与测试
│   ├── RBF_test.m              # RBF 模型测试
│   ├── Peukert_model.m/.train.m# Peukert 经验模型
│   ├── GA.mat / IPSO.mat       # 训练好的模型参数
│   ├── get_Battery_data.m      # 电池数据提取
│   ├── get_Capacity.m          # 容量数据
│   ├── get_Voltage_*.m         # 电压特征提取
│   ├── get_Temperature_*.m     # 温度特征提取
│   ├── get_Time.m              # 放电时间特征
│   ├── Ackley/Griewank/Rastrigrin/Rosenbrock/Schaffer4/Sphere.m  # 基准测试函数
│   ├── IPSO_main.m / PSO_main.m# 主入口
│   ├── test_experiment.m       # 对比实验脚本
│   ├── B0005/6/7/18.mat        # NASA 锂电池数据集
│   └── README.txt              # 数据集说明
│
├── python/                     # Python版本实现
│   ├── IPSO/                   # IPSO 算法模块
│   │   └── IPSO.py
│   ├── PSO/                    # PSO 算法模块
│   │   └── PSO.py
│   ├── GA/                     # GA 遗传算法模块
│   │   └── GA.py
│   ├── RBF/                    # RBF 神经网络模块
│   │   ├── RBF.py              # RBF 训练 (含 RBFNet 类)
│   │   ├── RBF_TEST.py         # RBF 模型测试
│   │   └── postmnmx.py         # 归一化/反归一化工具
│   ├── Battery/                # 电池数据读取模块
│   │   ├── battery_data_reader.py
│   │   └── B0005/6/7/18.mat    # NASA 数据集
│   ├── Peukert/                # Peukert 经验模型
│   │   └── peukert_model.py
│   ├── models/                 # 训练好的模型文件 (.pkl)
│   ├── IPSO_RBF_main.py        # IPSO-RBF 主入口
│   ├── PSO_RBF_main.py         # PSO-RBF 主入口
│   ├── GA_RBF_main.py          # GA-RBF 主入口
│   └── test_experiment.py      # 对比实验 + 可视化
│
├── .gitignore
└── README.md
```

---

## 数据集

使用 **NASA Ames Research Center 锂电池加速老化数据集**，共4节18650锂电池（#5, #6, #7, #18）：

| 参数 | 说明 |
|------|------|
| 充电模式 | 恒流 1.5A 至 4.2V → 恒压至电流降至 20mA |
| 放电电流 | 恒流 2A |
| 放电截止电压 | #5: 2.7V, #6: 2.5V, #7: 2.2V, #18: 2.5V |
| 终止条件 | 额定容量（2Ahr）衰减 30%（降至 1.4Ahr） |
| EIS 频率范围 | 0.1Hz ~ 5kHz |

**提取的健康因子**:
1. 平均放电温度（归一化）
2. 最高放电温度（归一化）
3. 平均放电电压（归一化）
4. 最高放电电压（归一化）
5. 放电时间（归一化）

---

## 方法论

### 1. RBF 神经网络

使用 MATLAB [`newrb`](https://www.mathworks.com/help/deeplearning/ref/newrb.html) 算法框架构建 RBF 网络：
- 从空网络开始，逐次添加 RBF 神经元
- 每次选择误差最大的样本作为新神经元中心
- 高斯径向基函数：
  $\phi(x) = e^{-(\text{dist} \cdot b)^2}$ 
  其中 $b = 0.8326 / \text{spread}$
- 输出层通过线性最小二乘求解权重
- 当 MSE < goal($5\times10^{-5}$)或达到最大神经元数时停止

### 2. 改进粒子群算法 (IPSO)

对标准 PSO 的改进：

**标准 PSO**：
$$v_i = w \cdot v_i + c_1 r_1 (p_i - x_i) + c_2 r_2 (p_g - x_i)$$

**IPSO 改进**：

| 改进点 | 说明 | 效果 |
|--------|------|------|
| **压缩因子** | $\chi = \frac{2}{\lvert 2 - C - \sqrt{C^2 - 4C} \rvert}$ , 其中 $C = c_1 + c_2$ | 保证算法收敛，等价于带惯性权重的 PSO |
| **二阶振荡环节** | $v_i = \chi[v_i + c_1 r_1(p_i - (1+k)x_i + k x_i^{old}) + c_2 r_2(p_g - (1+k)x_i + k x_i^{old})]$ | 增加种群多样性，避免早熟收敛 |

参数设置： $c_1 = c_2 = 2.05$, $k = 0.2$（振荡因子），种群数 30，迭代 20 代

### 3. 对比算法

| 算法 | 描述 |
|------|------|
| **Peukert 模型** | 经典经验模型: $C = I^p \cdot t$ |
| **GA-RBF** | 遗传算法 + RBF（精英保留 5%，交叉率 80%，高斯变异） |
| **PSO-RBF** | 标准粒子群 + RBF ($w=0.9$, $c_1=c_2=1.49445$) |
| **IPSO-RBF** | 改进粒子群 + RBF（本文方法） |

---

## 快速开始

### MATLAB

```matlab
% 运行 IPSO-RBF 模型训练
IPSO_main

% 运行 PSO-RBF 模型训练
PSO_main

% 对比实验 (Peukert / GA / PSO / IPSO)
test_experiment
```

### Python

```bash
# 安装依赖
pip install numpy scipy matplotlib scikit-learn joblib

# 运行 IPSO-RBF 模型训练
python IPSO_RBF_main.py

# 运行 PSO-RBF 模型训练
python PSO_RBF_main.py

# 运行 GA-RBF 模型训练
python GA_RBF_main.py

# 对比实验
python test_experiment.py
```

---

## 实验结果

`test_experiment.py` / `test_experiment.m` 对四种模型（Peukert, GA-RBF, PSO-RBF, IPSO-RBF）进行对比，评估指标：

| 指标 | 公式 |
|-------|-------|
| MSE | $\text{MSE} = \frac{1}{n}\sum_{i=1}^{n}(y_i - \hat{y}_i)^2$ |
| RMSE | $\text{RMSE} = \sqrt{\text{MSE}}$ |
| MAE |  $\text{MAE} = \frac{1}{n}\sum_{i=1}^{n}\lvert y_i - \hat{y}_i \rvert$ |
| MAPE | $\text{MAPE} = \frac{1}{n}\sum_{i=1}^{n}\left\lvert\frac{y_i - \hat{y}_i}{y_i}\right\rvert \times100\text{%}$ |

根据训练结果，IPSO-RBF 在四种方法中取得最低的预测误差，验证了改进算法的有效性和优越性。

---

## 依赖环境

| 环境 | 版本 |
|------|------|
| MATLAB | R2019b 或更低，需要神经网络工具箱(Neural Network Toolbox) 和遗传算法与直接搜索工具箱 (GADS)  |
| Python | 3.11.1 |
| NumPy | 1.26.4 |
| SciPy | 1.15.3 |
| Matplotlib | 3.8.3 |
| Joblib | 1.5,1 |
| Pandas | 2.0.0 |
| Scikit-learn | 1.4.2 |
| Torch | 2.7.1 |
| Opencv-python | 4.11.0.86 |
| Ultralytics | 8.3.155 |

---

## 备注

由于matlab版本为早期版本，python版本为后期重置版本，二者在RBF神经网络的实现上有一定差异，且matlab版本存在一些数据错误，导致二者实验结果存在显著差异，请酌情选择相应版本。

---

## License

MIT License. 数据集版权归 NASA Ames Research Center 所有。
