# Chapter 163: Advanced Mathematics for Algorithms

## Prerequisites
- Linear algebra, probability

## Interview Frequency: ★

---

## 163.1 Singular Value Decomposition (SVD)

Any m×n matrix A can be factored as A = UΣV^T where:
- U: m×m orthogonal matrix (left singular vectors)
- Σ: m×n diagonal matrix (singular values)
- V: n×n orthogonal matrix (right singular vectors)

**Applications**: PCA, recommendation systems, dimensionality reduction, low-rank approximation.

```cpp
#include <iostream>
#include <vector>
#include <cmath>

// Power iteration to find dominant singular vector (simplified)
std::vector<double> powerIteration(const std::vector<std::vector<double>>& A, 
                                    int iterations = 100) {
    int m = A.size(), n = A[0].size();
    std::vector<double> v(n, 1.0 / std::sqrt(n));
    
    for (int iter = 0; iter < iterations; iter++) {
        // u = Av
        std::vector<double> u(m, 0);
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n; j++)
                u[i] += A[i][j] * v[j];
        
        // v = A^T u
        std::vector<double> newV(n, 0);
        for (int j = 0; j < n; j++)
            for (int i = 0; i < m; i++)
                newV[j] += A[i][j] * u[i];
        
        // Normalize
        double norm = 0;
        for (double x : newV) norm += x * x;
        norm = std::sqrt(norm);
        for (double& x : newV) x /= norm;
        v = newV;
    }
    return v;
}

int main() {
    std::vector<std::vector<double>> A = {{1, 2}, {3, 4}, {5, 6}};
    auto v = powerIteration(A);
    std::cout << "Dominant right singular vector: (";
    for (int i = 0; i < (int)v.size(); i++)
        std::cout << v[i] << (i+1 < (int)v.size() ? ", " : ")\n");
    return 0;
}
```

---

## 163.2 Markov Chains

A stochastic process with memoryless transitions. Transition matrix P where P_ij = Pr(j | i).

**Stationary distribution** π: π = πP. Exists and is unique for irreducible, aperiodic chains.

**Mixing time**: Number of steps until distribution is close to stationary. Related to spectral gap (1 - λ₂).

---

## 163.3 Entropy and Information Theory

**Shannon entropy**: H(X) = -Σ p(x) log₂ p(x)

Measures uncertainty/information content. Used in:
- Compression (Huffman, arithmetic coding)
- Decision trees (information gain)
- Machine learning (cross-entropy loss)

---

## 163.4 Probability Generating Functions

G_X(z) = E[z^X] = Σ p_k z^k

**Properties**:
- G(1) = 1
- G'(1) = E[X]
- G''(1) + G'(1) - (G'(1))² = Var(X)

---

## 163.5 Martingales

A sequence X₀, X₁, ... where E[X_{n+1} | X₀, ..., Xₙ] = Xₙ. The future expectation equals the current value.

**Examples**:
- Random walk: position after n steps
- Fair gambling: wealth after n rounds
- Doob martingale: E[f(X) | X₁, ..., Xₙ]

**Key tools**:
- **Doob's martingale convergence**: Converges under bounded variance
- **Azuma-Hoeffding inequality**: P(|X_n - X_0| ≥ t) ≤ 2exp(-t²/(2Σc_i²))
- **Stopped martingale**: Stopping a martingale at a stopping time preserves the martingale property

**Applications**: Concentration inequalities, randomized algorithm analysis, proving bounds on random processes.

---

## Summary

| Tool | Key Formula | Application |
|---|---|---|
| SVD | A = UΣV^T | Dimensionality reduction |
| Markov Chains | π = πP | Random walks, mixing |
| Entropy | H = -Σ p log p | Compression, info theory |
| PGF | G(z) = E[z^X] | Moment extraction |
| Martingales | E[X_{n+1} | history] = X_n | Concentration bounds |
