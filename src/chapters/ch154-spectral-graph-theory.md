# Chapter 154: Spectral Graph Theory

## Prerequisites
- Linear algebra, graph basics

## Interview Frequency: ★

Spectral graph theory uses eigenvalues of graph matrices to analyze structure.

---

## 154.1 Adjacency Matrix Eigenvalues

The adjacency matrix A has eigenvalues λ₁ ≥ λ₂ ≥ ... ≥ λₙ.

**Properties**: λ₁ ≥ 0 for connected graphs. λ₁ = max degree for regular graphs.

---

## 154.2 Laplacian Matrix

L = D - A where D = degree matrix, A = adjacency matrix.

**Properties**: L is symmetric, positive semi-definite. Smallest eigenvalue is 0. Second smallest λ₂ is the **Fiedler value** (algebraic connectivity).

```cpp
#include <iostream>
#include <vector>
#include <cmath>

// Compute Laplacian matrix
std::vector<std::vector<double>> laplacian(const std::vector<std::vector<int>>& adj) {
    int n = adj.size();
    std::vector<std::vector<double>> L(n, std::vector<double>(n, 0.0));
    
    for (int i = 0; i < n; i++) {
        L[i][i] = adj[i].size(); // Degree on diagonal
        for (int j : adj[i]) {
            L[i][j] = -1.0; // -1 for edges
        }
    }
    return L;
}

// Power iteration to find largest eigenvalue
double largestEigenvalue(const std::vector<std::vector<double>>& M, int iterations = 100) {
    int n = M.size();
    std::vector<double> v(n, 1.0 / std::sqrt(n));
    
    for (int iter = 0; iter < iterations; iter++) {
        std::vector<double> newV(n, 0.0);
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++)
                newV[i] += M[i][j] * v[j];
        
        // Normalize
        double norm = 0;
        for (double x : newV) norm += x * x;
        norm = std::sqrt(norm);
        for (double& x : newV) x /= norm;
        v = newV;
    }
    
    // Compute Rayleigh quotient
    double lambda = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            lambda += v[i] * M[i][j] * v[j];
    return lambda;
}

int main() {
    // Path graph: 0-1-2-3
    std::vector<std::vector<int>> adj = {{1},{0,2},{1,3},{2}};
    auto L = laplacian(adj);
    
    std::cout << "Laplacian matrix:\n";
    for (auto& row : L) {
        for (double x : row) std::cout << x << " ";
        std::cout << "\n";
    }
    
    // Fiedler value (algebraic connectivity)
    // For path graph P4, λ₂ ≈ 0.586
    double lambda2 = largestEigenvalue(L);
    std::cout << "Largest Laplacian eigenvalue: " << lambda2 << "\n";
    
    return 0;
}
```

---

## 154.3 Cheeger's Inequality

Relates λ₂ to the graph's expansion:

```
λ₂/2 ≤ h(G) ≤ √(2λ₂)
```

where h(G) = min over subsets S of |cut(S,S̄)| / min(|S|,|S̄|).

---

## 154.4 Applications

| Application | Use |
|---|---|
| Spectral clustering | Partition using Fiedler vector |
| Random walk mixing | Convergence rate = 1 - λ₂ |
| Expander graphs | λ₂ bounded away from 0 |
| Community detection | Fiedler vector gives partition |
| Graph sparsification | Preserve spectral properties |

---

## Summary

| Matrix | Eigenvalues | Application |
|---|---|---|
| Adjacency A | λ₁ ≥ ... ≥ λₙ | Walk counting |
| Laplacian L | 0 = λ₁ ≤ ... ≤ λₙ | Connectivity, clustering |
| Normalized L | 0 ≤ ... ≤ 2 | Random walks |
