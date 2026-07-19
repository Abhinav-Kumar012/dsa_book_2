# Chapter 152: Integer Programming and LP Duality

## Prerequisites
- Linear programming basics

## Interview Frequency: ★

Integer programming (IP) extends LP with integrality constraints. LP duality provides powerful theoretical tools.

---

## 152.1 Integer Programming

LP with some or all variables constrained to be integers. NP-hard in general.

**Applications**: Scheduling, routing, facility location, packing.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// Simple branch-and-bound for 0/1 knapsack (IP)
struct Item { int weight, value; };

class KnapsackIP {
    int capacity;
    std::vector<Item> items;
    int bestValue;
    
    void solve(int idx, int remaining, int currentVal, 
               std::vector<int>& currentSol, std::vector<int>& bestSol) {
        if (idx == (int)items.size()) {
            if (currentVal > bestValue) {
                bestValue = currentVal;
                bestSol = currentSol;
            }
            return;
        }
        
        // Bound: optimistic estimate
        double bound = currentVal;
        int remCap = remaining;
        for (int i = idx; i < (int)items.size() && remCap > 0; i++) {
            if (items[i].weight <= remCap) {
                bound += items[i].value;
                remCap -= items[i].weight;
            } else {
                bound += (double)items[i].value * remCap / items[i].weight;
                break;
            }
        }
        if (bound <= bestValue) return; // Prune
        
        // Don't take item idx
        solve(idx + 1, remaining, currentVal, currentSol, bestSol);
        
        // Take item idx
        if (items[idx].weight <= remaining) {
            currentSol[idx] = 1;
            solve(idx + 1, remaining - items[idx].weight, 
                  currentVal + items[idx].value, currentSol, bestSol);
            currentSol[idx] = 0;
        }
    }
    
public:
    KnapsackIP(int cap, std::vector<Item> items) : capacity(cap), items(items), bestValue(0) {
        // Sort by value/weight ratio for better bounds
        std::sort(this->items.begin(), this->items.end(), [](const Item& a, const Item& b) {
            return (double)a.value / a.weight > (double)b.value / b.weight;
        });
    }
    
    std::pair<int, std::vector<int>> solve() {
        std::vector<int> currentSol(items.size(), 0), bestSol(items.size(), 0);
        solve(0, capacity, 0, currentSol, bestSol);
        return {bestValue, bestSol};
    }
};

int main() {
    std::vector<Item> items = {{2,3},{3,4},{4,5},{5,6},{9,10}};
    KnapsackIP ks(10, items);
    auto [val, sol] = ks.solve();
    std::cout << "Optimal value: " << val << "\n";
    std::cout << "Selected items: ";
    for (int i = 0; i < (int)sol.size(); i++)
        if (sol[i]) std::cout << i << " ";
    std::cout << "\n";
    return 0;
}
```

---

## 152.2 LP Duality

Every LP has a dual. The dual of:

**Primal**: min c^T x s.t. Ax ≥ b, x ≥ 0

**Dual**: max b^T y s.t. A^T y ≤ c, y ≥ 0

**Weak duality**: For all feasible x and y: b^T y ≤ c^T x.

**Strong duality**: At optimality: b^T y* = c^T x*.

---

## 152.3 Complementary Slackness

At optimality:
- x_i* · (c_i - (A^T y*)_i) = 0 for all i
- y_j* · (A x* - b)_j = 0 for all j

Used to verify optimality and design primal-dual approximation algorithms.

---

## 152.4 LP Relaxation for IP

Relax integrality constraints → solve LP → round solution. Quality depends on rounding strategy.

```cpp
#include <iostream>
#include <vector>
#include <cmath>

// LP relaxation rounding for vertex cover
// LP: min Σ x_v s.t. x_u + x_v ≥ 1 for each edge (u,v), 0 ≤ x_v ≤ 1
// Rounding: if x_v ≥ 0.5, include v in cover

std::vector<int> lpRoundingVertexCover(const std::vector<std::pair<int,int>>& edges, int n) {
    // Solve LP relaxation (simplified: just use 0.5 for all)
    // In practice, solve with simplex/interior point
    std::vector<double> lpSolution(n, 0.5);
    
    // Round
    std::vector<int> cover;
    for (int v = 0; v < n; v++)
        if (lpSolution[v] >= 0.5)
            cover.push_back(v);
    
    return cover;
}

int main() {
    std::vector<std::pair<int,int>> edges = {{0,1},{1,2},{2,3},{3,0}};
    auto cover = lpRoundingVertexCover(edges, 4);
    std::cout << "LP rounding vertex cover: ";
    for (int v : cover) std::cout << v << " ";
    std::cout << "\nSize: " << cover.size() << " (optimal is 2)\n";
    return 0;
}
```

---

## Summary

| Concept | Key Property |
|---|---|
| Integer Programming | NP-hard, use branch & bound |
| Weak duality | Dual ≤ Primal always |
| Strong duality | Dual = Primal at optimum |
| Complementary slackness | Optimality conditions |
| LP Relaxation | Round to get approximation |
