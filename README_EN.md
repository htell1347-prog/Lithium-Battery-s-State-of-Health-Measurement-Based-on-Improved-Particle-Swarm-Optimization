[中文](https://github.com/htell1347-prog/Lithium-Battery-s-State-of-Health-Measurement-Based-on-Improved-Particle-Swarm-Optimization/blob/main/README.md) | English

# Lithium Battery's State of Health Measurement Based on Improved Particle Swarm Optimization

**Lithium Battery ’s State of Health Measurement Based on Improved Particle Swarm Optimization**

[![Platform](https://img.shields.io/badge/Platform-MATLAB%20%7C%20Python-blue)]()
[![License](https://img.shields.io/badge/License-MIT-green)]()

---
(Undergraduate thesis archive with Python reimplementation)

## Abstract

Aiming at the problem of lithium battery State of Health (SOH) measurement, this paper proposes a method based on **Improved Particle Swarm Optimization (IPSO)** to optimize a **Radial Basis Function (RBF)** neural network. The standard Particle Swarm Optimization (PSO) algorithm suffers from premature convergence. By introducing a **constriction factor** and a **second-order oscillation term**, the global search capability and convergence accuracy are improved. On this basis, IPSO is used to automatically optimize the spread and maximum number of neurons (MN) of the RBF neural network to construct a lithium battery SOH prediction model.

---

## Project Structure

```
├── matlab/                     # MATLAB implementation
│   ├── IPSO.m                  # Improved PSO core algorithm
│   ├── PSO.m                   # Standard PSO algorithm
│   ├── IPSO_RBF.m / PSO_RBF.m  # IPSO/PSO optimized RBF main workflow
│   ├── RBF.m / RBF_train.m     # RBF neural network training and testing
│   ├── RBF_test.m              # RBF model testing
│   ├── Peukert_model.m/.train.m# Peukert empirical model
│   ├── GA.mat / IPSO.mat       # Trained model parameters
│   ├── get_Battery_data.m      # Battery data extraction
│   ├── get_Capacity.m          # Capacity data
│   ├── get_Voltage_*.m         # Voltage feature extraction
│   ├── get_Temperature_*.m     # Temperature feature extraction
│   ├── get_Time.m              # Discharge time feature
│   ├── Ackley/Griewank/Rastrigrin/Rosenbrock/Schaffer4/Sphere.m  # Benchmark functions
│   ├── IPSO_main.m / PSO_main.m# Main entry points
│   ├── test_experiment.m       # Comparative experiment script
│   ├── B0005/6/7/18.mat        # NASA lithium battery dataset
│   └── README.txt              # Dataset description
│
├── python/                     # Python implementation
│   ├── IPSO/                   # IPSO algorithm module
│   │   └── IPSO.py
│   ├── PSO/                    # PSO algorithm module
│   │   └── PSO.py
│   ├── GA/                     # Genetic Algorithm module
│   │   └── GA.py
│   ├── RBF/                    # RBF neural network module
│   │   ├── RBF.py              # RBF training (with RBFNet class)
│   │   ├── RBF_TEST.py         # RBF model testing
│   │   └── postmnmx.py         # Normalization/denormalization utilities
│   ├── Battery/                # Battery data reader module
│   │   ├── battery_data_reader.py
│   │   └── B0005/6/7/18.mat    # NASA dataset
│   ├── Peukert/                # Peukert empirical model
│   │   └── peukert_model.py
│   ├── models/                 # Trained model files (.pkl)
│   ├── IPSO_RBF_main.py        # IPSO-RBF main entry
│   ├── PSO_RBF_main.py         # PSO-RBF main entry
│   ├── GA_RBF_main.py          # GA-RBF main entry
│   └── test_experiment.py      # Comparative experiment + visualization
│
├── .gitignore
└── README.md
```

---

## Dataset

The **NASA Ames Research Center lithium battery accelerated aging dataset** is used, consisting of 4 18650 lithium batteries (#5, #6, #7, #18):

| Parameter | Description |
|-----------|-------------|
| Charging mode | Constant current 1.5A to 4.2V → constant voltage until current drops to 20mA |
| Discharge current | Constant current 2A |
| Discharge cutoff voltage | #5: 2.7V, #6: 2.5V, #7: 2.2V, #18: 2.5V |
| Termination condition | Rated capacity (2Ahr) decays by 30% (drops to 1.4Ahr) |
| EIS frequency range | 0.1Hz ~ 5kHz |

**Extracted health indicators**:
1. Average discharge temperature (normalized)
2. Maximum discharge temperature (normalized)
3. Average discharge voltage (normalized)
4. Maximum discharge voltage (normalized)
5. Discharge time (normalized)

---

## Methodology

### 1. RBF Neural Network

The RBF network is constructed using the MATLAB [`newrb`](https://www.mathworks.com/help/deeplearning/ref/newrb.html) algorithm framework:
- Starts from an empty network, adding RBF neurons one by one
- Each time selects the sample with the largest error as the new neuron center
- Gaussian radial basis function:
  $\phi(x) = e^{-(\text{dist} \cdot b)^2}$ 
  where $b = 0.8326 / \text{spread}$
- The output layer solves for weights via linear least squares
- Stops when MSE < goal($5\times10^{-5}$) or the maximum number of neurons is reached

### 2. Improved Particle Swarm Optimization (IPSO)

Improvements over standard PSO:

**Standard PSO**:
$$v_i = w \cdot v_i + c_1 r_1 (p_i - x_i) + c_2 r_2 (p_g - x_i)$$

**IPSO improvements**:

| Improvement | Description | Effect |
|-------------|-------------|--------|
| **Constriction factor** | $\chi = \frac{2}{\lvert 2 - C - \sqrt{C^2 - 4C} \rvert}$ , where $C = c_1 + c_2$ | Guarantees algorithm convergence, equivalent to PSO with inertia weight |
| **Second-order oscillation term** | $v_i = \chi[v_i + c_1 r_1(p_i - (1+k)x_i + k x_i^{old}) + c_2 r_2(p_g - (1+k)x_i + k x_i^{old})]$ | Increases population diversity, avoids premature convergence |

Parameter settings: $c_1 = c_2 = 2.05$, $k = 0.2$ (oscillation factor), population size 30, 20 iterations

### 3. Comparison Algorithms

| Algorithm | Description |
|-----------|-------------|
| **Peukert model** | Classical empirical model: $C = I^p \cdot t$ |
| **GA-RBF** | Genetic Algorithm + RBF (elitism 5%, crossover rate 80%, Gaussian mutation) |
| **PSO-RBF** | Standard PSO + RBF ($w=0.9$, $c_1=c_2=1.49445$) |
| **IPSO-RBF** | Improved PSO + RBF (proposed method) |

---

## Quick Start

### MATLAB

```matlab
% Run IPSO-RBF model training
IPSO_main

% Run PSO-RBF model training
PSO_main

% Comparative experiment (Peukert / GA / PSO / IPSO)
test_experiment
```

### Python

```bash
# Install dependencies
pip install numpy scipy matplotlib scikit-learn joblib

# Run IPSO-RBF model training
python IPSO_RBF_main.py

# Run PSO-RBF model training
python PSO_RBF_main.py

# Run GA-RBF model training
python GA_RBF_main.py

# Comparative experiment
python test_experiment.py
```

---

## Experimental Results

`test_experiment.py` / `test_experiment.m` compares four models (Peukert, GA-RBF, PSO-RBF, IPSO-RBF) using the following evaluation metrics:

| Metric | Formula |
|--------|---------|
| MSE | $\text{MSE} = \frac{1}{n}\sum_{i=1}^{n}(y_i - \hat{y}_i)^2$ |
| RMSE | $\text{RMSE} = \sqrt{\text{MSE}}$ |
| MAE | $\text{MAE} = \frac{1}{n}\sum_{i=1}^{n}\lvert y_i - \hat{y}_i \rvert$ |
| MAPE | $\text{MAPE} = \frac{1}{n}\sum_{i=1}^{n}\left\lvert\frac{y_i - \hat{y}_i}{y_i}\right\rvert \times100\%$ |

According to the training results, IPSO-RBF achieves the lowest prediction error among the four methods, validating the effectiveness and superiority of the improved algorithm.

---

## Dependencies

| Environment | Version |
|-------------|---------|
| MATLAB | R2019b or earlier, requires Neural Network Toolbox and Genetic Algorithm and Direct Search Toolbox (GADS) |
| Python | 3.11.1 |
| NumPy | 1.26.4 |
| SciPy | 1.15.3 |
| Matplotlib | 3.8.3 |
| Joblib | 1.5.1 |
| Pandas | 2.0.0 |
| Scikit-learn | 1.4.2 |
| Torch | 2.7.1 |
| Opencv-python | 4.11.0.86 |
| Ultralytics | 8.3.155 |

---

## Notes

Since the MATLAB version is an early version and the Python version is a later reimplementation, there are certain differences in the RBF neural network implementation between the two. Additionally, the MATLAB version contains some data errors, leading to significant differences in experimental results between the two versions. Please choose the appropriate version accordingly.

---

## License

MIT License. Dataset copyright belongs to NASA Ames Research Center.
