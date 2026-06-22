import numpy as np
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from GA.GA import GA
from RBF.RBF import RBF


def main():
    trainnumber = 5
    testnumber = 6

    print("\nRunning GA_RBF...")
    spreadbest, mnbest, gbestsum, pbestfitnessaveragesum = GA(1, 10, 1, 10, trainnumber, testnumber)
    spreadbest = float(spreadbest)
    mnbest = int(mnbest)
    spread, mn, test_error, test_se, test_mse, test_rmse, test_mae, test_mape = RBF(spreadbest, mnbest, trainnumber, testnumber, 'GA_RBF_model.pkl')

    print(f"\nGA_RBF Results:")
    print(f"spreadbest: {spreadbest}")
    print(f"mnbest: {mnbest}")
    print(f"test_mse: {test_mse}")
    print(f"test_rmse: {test_rmse}")
    print(f"test_mae: {test_mae}")
    print(f"test_mape: {test_mape}")


if __name__ == '__main__':
    main()
