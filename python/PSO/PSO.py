import numpy as np
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from RBF.RBF import RBF

def PSO(spreadmin, spreadmax, mnmin, mnmax, trainnumber, testnumber):
    N = 30
    M = 20

    vmax1 = (spreadmax - spreadmin) * 0.1
    vmax2 = (mnmax - mnmin) * 0.1
    v1max = vmax1
    v1min = -vmax1
    v2max = vmax2
    v2min = -vmax2
    w = 0.9
    c1 = 1.49445
    c2 = 1.49445
    popmax = np.array([spreadmax, mnmax])
    popmin = np.array([spreadmin, mnmin])
    
    pop = np.zeros((N, 2))
    v = np.zeros((N, 2))
    
    for i in range(N):
        pop[i, 0] = spreadmin + (spreadmax - spreadmin) * np.random.rand()
        pop[i, 1] = int(mnmin + (mnmax - mnmin) * np.random.rand())
        v[i, 0] = v1min + (v1max - v1min) * np.random.rand()
        v[i, 1] = v2min + (v2max - v2min) * np.random.rand()
    
    pbest = np.zeros((N, 2))
    pbestfitness = np.zeros(N)
    
    for i in range(N):
        pbest[i, :] = pop[i, :]
        spread = float(pop[i, 0])
        mn = int(pop[i, 1])
        
        spread, mn, test_error, test_se, test_mse, test_rmse, test_mae, test_mape = RBF(spread, mn, trainnumber, testnumber, None)
        print(f"train_test_error:PSO gen {(i+1)}: spread={spread:.5f}, mn={mn}, test_se={test_se:.2f}, test_mse={test_mse:.2f}")
        pbestfitness[i] = test_se
    
    gbestfitness_idx = np.argmin(pbestfitness)
    gbestfitness = pbestfitness[gbestfitness_idx]
    gbest = pbest[gbestfitness_idx, :]
    
    pbestfitnessaveragesum = np.zeros((M, 1))
    gbestsum = np.zeros((M, 3))
    
    for t in range(M):
        for i in range(N):
            v[i, 0] = w * v[i, 0] + c1 * np.random.rand() * (pbest[i, 0] - pop[i, 0]) + c2 * np.random.rand() * (gbest[0] - pop[i, 0])
            v[i, 1] = w * v[i, 1] + c1 * np.random.rand() * (pbest[i, 1] - pop[i, 1]) + c2 * np.random.rand() * (gbest[1] - pop[i, 1])
            
            if v[i, 0] >= v1max:
                v[i, 0] = v1max
            elif v[i, 0] < v1min:
                v[i, 0] = v1min
            
            if v[i, 1] >= v2max:
                v[i, 1] = v2max
            elif v[i, 1] < v2min:
                v[i, 1] = v2min
            
            pop[i, 0] = pop[i, 0] + v[i, 0]
            pop[i, 1] = int(pop[i, 1] + v[i, 1])
            
            if pop[i, 0] >= popmax[0]:
                pop[i, 0] = popmax[0]
            elif pop[i, 0] < popmin[0]:
                pop[i, 0] = popmin[0]
            
            if pop[i, 1] >= popmax[1]:
                pop[i, 1] = popmax[1]
            elif pop[i, 1] < popmin[1]:
                pop[i, 1] = popmin[1]
            
            spread = float(pop[i, 0])
            mn = int(pop[i, 1])
            spread, mn, test_error, test_se, test_mse, test_rmse, test_mae, test_mape = RBF(spread, mn, trainnumber, testnumber, None)
            print(f"train_rbf_new:PSO gen {t*N+i+1}: spread={spread:.5f}, mn={mn}, test_se={test_se:.2f}, test_mse={test_mse:.2f}")
            if test_se < pbestfitness[i]:
                pbestfitness[i] = test_se
                pbest[i, :] = pop[i, :]
        
        gbestfitness_idx = np.argmin(pbestfitness)
        gbestfitness = pbestfitness[gbestfitness_idx]
        gbest = pbest[gbestfitness_idx, :]
        
        pbestfitnessaveragesum[t, 0] = np.mean(pbestfitness)
        gbestsum[t, 0] = gbest[0]
        gbestsum[t, 1] = gbest[1]
        gbestsum[t, 2] = gbestfitness
    
    spreadbest = gbest[0]
    mnbest = gbest[1]
    print(f"rbf_end:PSO best spread={spreadbest:.5f}, mn={mnbest}, gbestfitness={gbestfitness:.2f}, pbestfitness={np.mean(pbestfitness):.2f}")
    
    return spreadbest, mnbest, gbestsum, pbestfitnessaveragesum
