# Chapter 153: Advanced Optimization

## Prerequisites
- LP, calculus basics

## Interview Frequency: ★

---

## 153.1 Gradient Descent (Overview)

Iteratively move in direction of steepest descent. Convergence depends on step size and convexity.

```cpp
#include <iostream>
#include <cmath>
#include <functional>

// Gradient descent for f(x) = (x-3)^2
double gradientDescent(double start, double lr, int iterations) {
    double x = start;
    for (int i = 0; i < iterations; i++) {
        double grad = 2 * (x - 3); // derivative of (x-3)^2
        x -= lr * grad;
    }
    return x;
}

int main() {
    double result = gradientDescent(0.0, 0.1, 100);
    std::cout << "Minimum at x = " << result << " (expected: 3)\n";
    return 0;
}
```

---

## 153.2 Multiplicative Weights Update

Update weights multiplicatively based on loss. Used in online learning, game theory, and LP solving.

**Algorithm**: For each expert i with weight w_i and loss l_i:
- w_i ← w_i × (1 - η × l_i)
- Normalize weights
- η = learning rate (step size)

**Guarantee**: Regret ≤ O(√(T log n)) after T rounds with n experts.

---

## 153.3 Min Cost Flow

Find minimum cost flow in a network. Can be solved with successive shortest paths or network simplex.

---

## Summary

| Method | Convergence | Use Case |
|---|---|---|
| Gradient Descent | O(1/t) convex, O(e^{-t}) strongly | Convex optimization |
| Multiplicative Weights | O(√(T log n)) | Online learning |
| Network Simplex | Polynomial | Min cost flow |
