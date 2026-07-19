# Chapter 73: Linear Algebra for Programming

## Prerequisites

- Basic math
- Matrix operations

## Interview Frequency: ★★

Linear algebra appears in matrix exponentiation, graph algorithms, and optimization problems. **Google** and competitive programming interviews occasionally test matrix operations.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Matrix multiplication | ★★★ | Easy | Foundation |
| Matrix exponentiation | ★★★★ | Medium | Fibonacci, recurrences |
| Eigenvalues | ★ | Hard | Advanced applications |

---

## 73.1 Matrix Operations

```cpp
#include <iostream>
#include <vector>

using Matrix = std::vector<std::vector<long long>>;
const long long MOD = 1e9 + 7;

Matrix multiply(const Matrix& a, const Matrix& b) {
    int n = a.size(), m = b[0].size(), p = b.size();
    Matrix c(n, std::vector<long long>(m, 0));
    for (int i = 0; i < n; i++)
        for (int k = 0; k < p; k++)
            for (int j = 0; j < m; j++)
                c[i][j] = (c[i][j] + a[i][k] * b[k][j]) % MOD;
    return c;
}

Matrix power(Matrix base, long long exp) {
    int n = base.size();
    Matrix result(n, std::vector<long long>(n, 0));
    for (int i = 0; i < n; i++) result[i][i] = 1;
    
    while (exp > 0) {
        if (exp & 1) result = multiply(result, base);
        base = multiply(base, base);
        exp >>= 1;
    }
    return result;
}

// Fibonacci: F(n) using matrix exponentiation
long long fibonacci(long long n) {
    if (n <= 1) return n;
    Matrix M = {{1, 1}, {1, 0}};
    Matrix Mn = power(M, n);
    return Mn[0][1];
}

// Count paths of length k in a graph
long long countPaths(const std::vector<std::vector<int>>& adj, int k, 
                     int start, int end) {
    int n = adj.size();
    Matrix M(n, std::vector<long long>(n, 0));
    for (int i = 0; i < n; i++)
        for (int j : adj[i])
            M[i][j] = 1;
    
    Matrix Mk = power(M, k);
    return Mk[start][end];
}

int main() {
    // Fibonacci
    std::cout << "F(10) = " << fibonacci(10) << "\n"; // 55
    std::cout << "F(50) = " << fibonacci(50) << "\n";
    
    // Count paths in graph
    // 0 -> 1 -> 2 -> 0 (cycle)
    std::vector<std::vector<int>> adj = {{1}, {2}, {0}};
    std::cout << "\nPaths of length 3 from 0 to 0: " 
              << countPaths(adj, 3, 0, 0) << "\n"; // 1 (0->1->2->0)
    std::cout << "Paths of length 6 from 0 to 0: " 
              << countPaths(adj, 6, 0, 0) << "\n"; // 2
    
    return 0;
}
```

---

## 73.2 Gaussian Elimination

Solve systems of linear equations in O(n³).

```cpp
#include <iostream>
#include <vector>
#include <cmath>
#include <iomanip>

// Solve Ax = b using Gaussian elimination
std::vector<double> gaussianElimination(std::vector<std::vector<double>> A,
                                         std::vector<double> b) {
    int n = A.size();
    
    // Forward elimination
    for (int col = 0; col < n; col++) {
        // Find pivot
        int maxRow = col;
        for (int row = col + 1; row < n; row++) {
            if (std::abs(A[row][col]) > std::abs(A[maxRow][col])) {
                maxRow = row;
            }
        }
        std::swap(A[col], A[maxRow]);
        std::swap(b[col], b[maxRow]);
        
        // Eliminate below
        for (int row = col + 1; row < n; row++) {
            double factor = A[row][col] / A[col][col];
            for (int j = col; j < n; j++) {
                A[row][j] -= factor * A[col][j];
            }
            b[row] -= factor * b[col];
        }
    }
    
    // Back substitution
    std::vector<double> x(n);
    for (int i = n - 1; i >= 0; i--) {
        x[i] = b[i];
        for (int j = i + 1; j < n; j++) {
            x[i] -= A[i][j] * x[j];
        }
        x[i] /= A[i][i];
    }
    
    return x;
}

int main() {
    // 2x + y = 5
    // x + 3y = 7
    std::vector<std::vector<double>> A = {{2, 1}, {1, 3}};
    std::vector<double> b = {5, 7};
    
    auto x = gaussianElimination(A, b);
    
    std::cout << std::fixed << std::setprecision(4);
    std::cout << "Solution: x = " << x[0] << ", y = " << x[1] << "\n";
    // x = 1.6, y = 1.8
    
    return 0;
}
```

---

## 73.3 Matrix Applications in Algorithms

| Application | Matrix Size | Time |
|---|---|---|
| Fibonacci | 2×2 | O(log n) |
| k-step recurrence | k×k | O(k³ log n) |
| Count paths of length k | V×V | O(V³ log k) |
| System of equations | n×n | O(n³) |
| Graph connectivity | V×V | O(V³) |
| Linear transformation | k×k | O(k³) |

---

## Summary

| Operation | Time | Application |
|---|---|---|
| Matrix multiply | O(n³) | Foundation |
| Matrix power | O(n³ log k) | Recurrences, path counting |
| Gaussian elimination | O(n³) | Linear systems |
| Determinant | O(n³) | Volume, invertibility |
