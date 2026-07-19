# Chapter 151: Linear Programming

## Prerequisites
- Matrix operations, optimization basics

## Interview Frequency: ★★

LP is the foundation of many optimization algorithms.

---

## 151.1 Standard Form

Minimize c^T x subject to Ax ≤ b, x ≥ 0.

---

## 151.2 LP Relaxation

Relax integer constraints to get an LP. Use the LP solution to guide integer solutions.

---

## 151.3 Simplex Method

The simplex method moves along vertices of the feasible polytope, improving the objective at each step. Exponential worst case but fast in practice (polynomial average case).

**Key ideas**:
- Start at a feasible vertex
- Find an adjacent vertex with better objective
- Repeat until no improvement (optimal)
- Use tableau or revised simplex for implementation

---

## 151.4 LP Duality

Every LP has a dual. Weak duality: dual ≥ primal. Strong duality: dual = primal (at optimality).

```cpp
#include <iostream>
#include <vector>
#include <iomanip>

// Simple 2-variable LP solver (brute force for small instances)
// Maximize 3x + 4y subject to:
//   x + 2y ≤ 8
//   3x + 2y ≤ 12
//   x, y ≥ 0

double solveSimpleLP() {
    double best = 0, bestX = 0, bestY = 0;
    
    // Check corner points
    std::vector<std::pair<double,double>> corners = {
        {0, 0}, {4, 0}, {0, 4}, {2, 3}
    };
    
    for (auto& [x, y] : corners) {
        if (x + 2*y <= 8 && 3*x + 2*y <= 12 && x >= 0 && y >= 0) {
            double val = 3*x + 4*y;
            if (val > best) { best = val; bestX = x; bestY = y; }
        }
    }
    
    std::cout << "Optimal: x=" << bestX << " y=" << bestY << " value=" << best << "\n";
    return best;
}

int main() {
    solveSimpleLP();
    return 0;
}
```

---

## Summary

| Method | Time | Use Case |
|---|---|---|
| Simplex | Exponential worst, fast practice | General LP |
| Interior Point | O(n^3.5 log(1/ε)) | Polynomial LP |
| Ellipsoid | Polynomial | Theoretical |
