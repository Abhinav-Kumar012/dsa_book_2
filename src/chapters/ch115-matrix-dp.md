# Chapter 115: Matrix DP

## Prerequisites
- Matrix operations, DP

## Interview Frequency: ★★

Matrix DP uses matrix exponentiation to compute linear recurrences in O(k³ log n).

---

## 115.1 Fibonacci via Matrix Exponentiation

```cpp
#include <iostream>
#include <vector>

const long long MOD = 1e9 + 7;
using Matrix = std::vector<std::vector<long long>>;

Matrix multiply(const Matrix& a, const Matrix& b) {
    int n = a.size();
    Matrix c(n, std::vector<long long>(n, 0));
    for (int i = 0; i < n; i++)
        for (int k = 0; k < n; k++)
            for (int j = 0; j < n; j++)
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

long long fibonacci(long long n) {
    if (n <= 1) return n;
    Matrix M = {{1, 1}, {1, 0}};
    Matrix Mn = power(M, n);
    return Mn[0][1];
}

// General linear recurrence: f(n) = c1*f(n-1) + c2*f(n-2) + ... + ck*f(n-k)
long long linearRecurrence(const std::vector<long long>& coeffs,
                           const std::vector<long long>& init, long long n) {
    int k = coeffs.size();
    if (n < k) return init[n];
    Matrix M(k, std::vector<long long>(k, 0));
    for (int j = 0; j < k; j++) M[0][j] = coeffs[j];
    for (int i = 1; i < k; i++) M[i][i-1] = 1;
    Matrix Mn = power(M, n - k + 1);
    long long result = 0;
    for (int j = 0; j < k; j++)
        result = (result + Mn[0][j] * init[k-1-j]) % MOD;
    return result;
}

int main() {
    std::cout << "F(10) = " << fibonacci(10) << "\n";
    std::cout << "F(50) = " << fibonacci(50) << "\n";
    
    // Tribonacci: f(n) = f(n-1) + f(n-2) + f(n-3)
    std::vector<long long> coeffs = {1, 1, 1};
    std::vector<long long> init = {0, 0, 1};
    for (int i = 0; i <= 10; i++)
        std::cout << "T(" << i << ") = " << linearRecurrence(coeffs, init, i) << "\n";
    
    return 0;
}
```

---

## Summary

| Application | Matrix Size | Time |
|---|---|---|
| Fibonacci | 2×2 | O(log n) |
| k-step recurrence | k×k | O(k³ log n) |
| Count paths of length n | V×V | O(V³ log n) |
