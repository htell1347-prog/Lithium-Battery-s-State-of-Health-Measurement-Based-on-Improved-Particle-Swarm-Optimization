import numpy as np
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from RBF.RBF import RBF


def IPSO(spreadmin, spreadmax, mnmin, mnmax, trainnumber, testnumber):
    N = 30
    M = 20

    vmax1 = (spreadmax - spreadmin) * 0.1
    vmax2 = (mnmax - mnmin) * 0.1
    v1max = vmax1
    v1min = -vmax1
    v2max = vmax2
    v2min = -vmax2
    c1 = 2.05
    c2 = 2.05
    c = c1 + c2
    f = 2 / abs(2 - c - np.sqrt((c ** 2) - 4 * c))
    popmax = np.array([spreadmax, mnmax])
    popmin = np.array([spreadmin, mnmin])
    
    pop = np.zeros((N, 2))
    v = np.zeros((N, 2))
    
    for i in range(N):
        pop[i, 0] = spreadmin + (spreadmax - spreadmin) * np.random.rand()
        pop[i, 1] = int(mnmin + (mnmax - mnmin) * np.random.rand())
        v[i, 0] = v1min + (v1max - v1min) * np.random.rand()
        v[i, 1] = v2min + (v2max - v2min) * np.random.rand()
    
    #popstart = pop.copy()
    #vstart = v.copy()
    
    pbest = np.zeros((N, 2))
    pbestfitness = np.zeros(N)
    
    for i in range(N):
        pbest[i, :] = pop[i, :]
        spread = float(pop[i, 0])
        mn = int(pop[i, 1])
        spread, mn, test_error, test_se, test_mse, test_rmse, test_mae, test_mape = RBF(spread, mn, trainnumber, testnumber, None)
        print(f"train_test_error:IPSO gen {(i+1)}: spread={spread:.5f}, mn={mn}, test_se={test_se:.2f}, test_mse={test_mse:.2f}")
        pbestfitness[i] = test_se
    
    gbestfitness_idx = np.argmin(pbestfitness)
    gbestfitness = pbestfitness[gbestfitness_idx]
    gbest = pbest[gbestfitness_idx, :]
    
    k = 0.2
    pbestfitnessaveragesum = np.zeros((M, 1))
    gbestsum = np.zeros((M, 3))
    
    for j in range(M):
        popold = pop.copy()
        f1 = c1 * np.random.rand()
        f2 = c2 * np.random.rand()
        
        for i in range(N):
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
            
            v[i, 0] = f * (v[i, 0] + f1 * (pbest[i, 0] - (1 + k) * pop[i, 0] + k * popold[i, 0]) + f2 * (gbest[0] - (1 + k) * pop[i, 0] + k * popold[i, 0]))
            v[i, 1] = f * (v[i, 1] + f1 * (pbest[i, 1] - (1 + k) * pop[i, 1] + k * popold[i, 1]) + f2 * (gbest[1] - (1 + k) * pop[i, 1] + k * popold[i, 1]))
            
            spread = float(pop[i, 0])
            mn = int(pop[i, 1])
            spread, mn, test_error, test_se, test_mse, test_rmse, test_mae, test_mape = RBF(spread, mn, trainnumber, testnumber, None)
            print(f"train_rbf_new:IPSO gen {j*N+i+1}: spread={spread:.5f}, mn={mn}, test_se={test_se:.2f}, test_mse={test_mse:.2f}")
            
            if test_se < pbestfitness[i]:
                pbestfitness[i] = test_se
                pbest[i, :] = pop[i, :]
        
        gbestfitness_idx = np.argmin(pbestfitness)
        gbestfitness = pbestfitness[gbestfitness_idx]
        gbest = pbest[gbestfitness_idx, :]
        
        pbestfitnessaveragesum[j, 0] = np.mean(pbestfitness)
        gbestsum[j, 0] = gbest[0]
        gbestsum[j, 1] = gbest[1]
        gbestsum[j, 2] = gbestfitness
    
    spreadbest = gbest[0]
    mnbest = gbest[1]
    print(f"rbf_end:IPSO best spread={spreadbest:.5f}, mn={mnbest}, gbestfitness={gbestfitness:.2f}, pbestfitness={np.mean(pbestfitness):.2f}")

    
    return spreadbest, mnbest, gbestsum, pbestfitnessaveragesum
