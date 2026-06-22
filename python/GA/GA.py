import numpy as np
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from RBF.RBF import RBF


def GA(spreadmin, spreadmax, mnmin, mnmax, trainnumber, testnumber):
    pop_size = 30
    max_gen = 20
    n_var = 2
    elite_count = max(1, int(np.ceil(0.05 * pop_size)))
    crossover_fraction = 0.8

    n_parents = pop_size - elite_count
    n_crossover = 2 * int(crossover_fraction * n_parents / 2)
    n_mutation = n_parents - n_crossover

    popmin = np.array([spreadmin, mnmin])
    popmax = np.array([spreadmax, mnmax])

    pop = np.zeros((pop_size, n_var))
    for i in range(pop_size):
        pop[i, 0] = spreadmin + (spreadmax - spreadmin) * np.random.rand()
        pop[i, 1] = int(mnmin + (mnmax - mnmin) * np.random.rand())

    fitness = np.full(pop_size, np.inf)
    for i in range(pop_size):
        spread = float(pop[i, 0])
        mn = int(pop[i, 1])
        spread, mn, test_error, test_se, test_mse, test_rmse, test_mae, test_mape = RBF(spread, mn, trainnumber, testnumber, save_model=False)
        print(f"train_test_error:GA gen {(i+1)}: spread={spread:.5f}, mn={mn}, test_se={test_se:.2f}, test_mse={test_mse:.2f}")
        fitness[i] = test_se

    sorted_idx = np.argsort(fitness)
    pop = pop[sorted_idx]
    fitness = fitness[sorted_idx]

    best_fitness_history = np.zeros((max_gen, 1))
    best_var_history = np.zeros((max_gen, 2))

    for gen in range(max_gen):
        ranks = np.arange(1, pop_size + 1)
        expectations = 1.0 / np.sqrt(ranks)
        expectations = expectations / expectations.sum()

        parents = stochastic_uniform_selection(expectations, pop_size - elite_count)
        np.random.shuffle(parents)

        new_pop = np.zeros_like(pop)
        new_fitness = np.full(pop_size, np.inf)

        for i in range(elite_count):
            new_pop[i] = pop[i].copy()
            new_fitness[i] = fitness[i]

        idx = elite_count
        for i in range(0, n_crossover, 2):
            p1 = pop[parents[i]].copy()
            p2 = pop[parents[i + 1]].copy()
            c1, c2 = scattered_crossover(p1, p2)
            c1 = bound_repair(c1, popmin, popmax)
            c2 = bound_repair(c2, popmin, popmax)
            new_pop[idx] = c1
            new_pop[idx + 1] = c2
            idx += 2

        for i in range(n_mutation):
            p = pop[parents[n_crossover + i]].copy()
            p = gaussian_mutation(p, gen, max_gen, popmin, popmax)
            p = bound_repair(p, popmin, popmax)
            new_pop[idx] = p
            idx += 1

        pop = new_pop
        fitness = new_fitness

        for i in range(elite_count, pop_size):
            spread = float(pop[i, 0])
            mn = int(pop[i, 1])
            spread, mn, test_error, test_se, test_mse, test_rmse, test_mae, test_mape = RBF(spread, mn, trainnumber, testnumber, save_model=False)
            print(f"train_rbf_new:GA gen {gen*pop_size+i+1}: spread={spread:.5f}, mn={mn}, test_se={test_se:.2f}, test_mse={test_mse:.2f}")
            fitness[i] = test_se

        sorted_idx = np.argsort(fitness)
        pop = pop[sorted_idx]
        fitness = fitness[sorted_idx]

        best_fitness_history[gen, 0] = fitness[0]
        best_var_history[gen, 0] = pop[0, 0]
        best_var_history[gen, 1] = pop[0, 1]

    spreadbest = float(pop[0, 0])
    mnbest = int(pop[0, 1])
    print(f"rbf_end:GA best spread={spreadbest:.5f}, mn={mnbest}, fitness={fitness[0]:.2f}, pbestfitness={np.mean(fitness):.2f}")
    return spreadbest, mnbest, best_var_history, best_fitness_history


def stochastic_uniform_selection(expectations, n_select):
    n = len(expectations)
    cumsum = np.cumsum(expectations)
    step = 1.0 / n_select
    start = np.random.rand() * step

    selected = np.zeros(n_select, dtype=int)
    for i in range(n_select):
        point = start + i * step
        if point > 1.0:
            point -= 1.0
        idx = np.searchsorted(cumsum, point)
        selected[i] = min(idx, n - 1)

    return selected


def scattered_crossover(p1, p2):
    mask = np.random.rand(len(p1)) < 0.5
    c1 = np.where(mask, p1, p2)
    c2 = np.where(mask, p2, p1)
    c1[1] = int(round(c1[1]))
    c2[1] = int(round(c2[1]))
    return c1, c2


def gaussian_mutation(ind, gen, max_gen, popmin, popmax):
    scale = 1.0
    shrink = 1.0
    sigma = scale * (1.0 - shrink * gen / max_gen) * (popmax - popmin)
    ind = ind.copy()
    ind[0] = ind[0] + sigma[0] * np.random.randn()
    if np.random.rand() < 0.5:
        ind[1] = int(ind[1] + np.random.choice([-1, 1]))
    return ind


def bound_repair(ind, lb, ub):
    ind[0] = np.clip(ind[0], lb[0], ub[0])
    ind[1] = int(np.clip(ind[1], lb[1], ub[1]))
    return ind
