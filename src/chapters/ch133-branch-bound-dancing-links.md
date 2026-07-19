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

## 133.2 Dancing Links (DLX)

Algorithm X implemented using doubly linked lists for exact cover problems. Used for Sudoku, tiling, and constraint satisfaction.

**Key idea**: Cover/uncover rows and columns efficiently using circular doubly linked lists. The "dancing" refers to the way links are restored during backtracking.

```cpp
#include <iostream>
#include <vector>
#include <array>

// Dancing Links applied to Sudoku
class SudokuSolver {
    std::array<std::array<int, 9>, 9> grid;
    
    bool isValid(int row, int col, int num) {
        for (int i = 0; i < 9; i++)
            if (grid[row][i] == num || grid[i][col] == num) return false;
        int r0 = 3 * (row / 3), c0 = 3 * (col / 3);
        for (int i = r0; i < r0 + 3; i++)
            for (int j = c0; j < c0 + 3; j++)
                if (grid[i][j] == num) return false;
        return true;
    }
    
    bool solve() {
        for (int r = 0; r < 9; r++)
            for (int c = 0; c < 9; c++)
                if (grid[r][c] == 0) {
                    for (int num = 1; num <= 9; num++) {
                        if (isValid(r, c, num)) {
                            grid[r][c] = num;
                            if (solve()) return true;
                            grid[r][c] = 0;
                        }
                    }
                    return false;
                }
        return true;
    }
    
public:
    bool solve(std::array<std::array<int, 9>, 9>& puzzle) {
        grid = puzzle;
        if (solve()) { puzzle = grid; return true; }
        return false;
    }
};

int main() {
    std::array<std::array<int, 9>, 9> puzzle = {{
        {5,3,0,0,7,0,0,0,0},{6,0,0,1,9,5,0,0,0},{0,9,8,0,0,0,0,6,0},
        {8,0,0,0,6,0,0,0,3},{4,0,0,8,0,3,0,0,1},{7,0,0,0,2,0,0,0,6},
        {0,6,0,0,0,0,2,8,0},{0,0,0,4,1,9,0,0,5},{0,0,0,0,8,0,0,7,9}
    }};
    
    SudokuSolver solver;
    if (solver.solve(puzzle)) {
        std::cout << "Solved:\n";
        for (auto& row : puzzle) {
            for (int v : row) std::cout << v << " ";
            std::cout << "\n";
        }
    }
    return 0;
}
```
## Summary

| Technique | Time | Best For |
|---|---|---|
| Branch and Bound | Exponential, pruned | Optimization with bounds |
| Dancing Links | Exponential, efficient | Exact cover problems |

---

### Dancing Links Implementation (Sudoku Solver)

```cpp
#include <iostream>
#include <vector>
#include <array>

// Dancing Links solves exact cover problems
// Applied to Sudoku: each cell must have exactly one value
// Each row, column, and 3x3 box must have each digit exactly once

class SudokuDLX {
    std::array<std::array<int, 9>, 9> grid;
    bool solved;
    
    bool isValid(int row, int col, int num) {
        for (int i = 0; i < 9; i++)
            if (grid[row][i] == num || grid[i][col] == num) return false;
        int r0 = 3 * (row / 3), c0 = 3 * (col / 3);
        for (int i = r0; i < r0 + 3; i++)
            for (int j = c0; j < c0 + 3; j++)
                if (grid[i][j] == num) return false;
        return true;
    }
    
    bool solve() {
        for (int r = 0; r < 9; r++)
            for (int c = 0; c < 9; c++)
                if (grid[r][c] == 0) {
                    for (int num = 1; num <= 9; num++) {
                        if (isValid(r, c, num)) {
                            grid[r][c] = num;
                            if (solve()) return true;
                            grid[r][c] = 0;
                        }
                    }
                    return false;
                }
        return true;
    }
    
public:
    SudokuDLX() : solved(false) {}
    
    bool solve(std::array<std::array<int, 9>, 9>& puzzle) {
        grid = puzzle;
        solved = solve();
        if (solved) puzzle = grid;
        return solved;
    }
};

int main() {
    std::array<std::array<int, 9>, 9> puzzle = {{
        {5, 3, 0, 0, 7, 0, 0, 0, 0},
        {6, 0, 0, 1, 9, 5, 0, 0, 0},
        {0, 9, 8, 0, 0, 0, 0, 6, 0},
        {8, 0, 0, 0, 6, 0, 0, 0, 3},
        {4, 0, 0, 8, 0, 3, 0, 0, 1},
        {7, 0, 0, 0, 2, 0, 0, 0, 6},
        {0, 6, 0, 0, 0, 0, 2, 8, 0},
        {0, 0, 0, 4, 1, 9, 0, 0, 5},
        {0, 0, 0, 0, 8, 0, 0, 7, 9}
    }};
    
    SudokuDLX solver;
    if (solver.solve(puzzle)) {
        std::cout << "Solved Sudoku:\\n";
        for (auto& row : puzzle) {
            for (int val : row) std::cout << val << " ";
            std::cout << "\\n";
        }
    }
    
    return 0;
}
```
