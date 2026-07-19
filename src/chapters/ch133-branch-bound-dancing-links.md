# Chapter 133: Branch and Bound and Dancing Links

## Prerequisites
- Backtracking, DFS

## Interview Frequency: ★

Advanced backtracking with pruning.

---

## 133.1 Branch and Bound

Backtracking with lower/upper bounds to prune unpromising branches.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>

// TSP with branch and bound
class TSPBnB {
    int n;
    std::vector<std::vector<int>> dist;
    int bestCost;
    
    void solve(int u, int visited, int cost, int depth) {
        if (cost >= bestCost) return; // Prune
        
        if (depth == n) {
            bestCost = std::min(bestCost, cost + dist[u][0]);
            return;
        }
        
        for (int v = 0; v < n; v++) {
            if (visited & (1 << v)) continue;
            solve(v, visited | (1 << v), cost + dist[u][v], depth + 1);
        }
    }
    
public:
    TSPBnB(const std::vector<std::vector<int>>& d) : n(d.size()), dist(d), bestCost(INT_MAX) {}
    
    int solve() {
        solve(0, 1, 0, 1);
        return bestCost;
    }
};

int main() {
    std::vector<std::vector<int>> dist = {
        {0, 10, 15, 20},
        {10, 0, 35, 25},
        {15, 35, 0, 30},
        {20, 25, 30, 0}
    };
    
    TSPBnB tsp(dist);
    std::cout << "TSP min cost: " << tsp.solve() << "\n"; // 80
    
    return 0;
}
```

---

## 133.2 Dancing Links (Overview)

Algorithm X implemented using doubly linked lists for exact cover problems. Used for Sudoku, tiling.

**Key idea**: Cover/uncover rows and columns efficiently using circular doubly linked lists.

---

## Summary

| Technique | Time | Best For |
|---|---|---|
| Branch and Bound | Exponential, pruned | Optimization with bounds |
| Dancing Links | Exponential, efficient | Exact cover problems |
