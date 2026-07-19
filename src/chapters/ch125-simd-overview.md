# Chapter 125: SIMD Overview

## Prerequisites
- CPU architecture basics

## Interview Frequency: ★

SIMD (Single Instruction Multiple Data) processes multiple values simultaneously.

---

## 125.1 Concept

SIMD instructions operate on vectors of data (e.g., 4 ints, 8 floats) in one cycle.

| Instruction Set | Width | Integers | Floats |
|---|---|---|---|
| SSE | 128-bit | 4 × int32 | 4 × float |
| AVX2 | 256-bit | 8 × int32 | 8 × float |
| AVX-512 | 512-bit | 16 × int32 | 16 × float |

---

## 125.2 Auto-Vectorization

Compilers auto-vectorize simple loops.

```cpp
#include <iostream>
#include <vector>
#include <numeric>

// This loop is likely auto-vectorized by the compiler
void addArrays(const float* a, const float* b, float* c, int n) {
    for (int i = 0; i < n; i++)
        c[i] = a[i] + b[i];
}

int main() {
    const int N = 1000;
    std::vector<float> a(N, 1.0f), b(N, 2.0f), c(N);
    addArrays(a.data(), b.data(), c.data(), N);
    std::cout << "c[0] = " << c[0] << "\n"; // 3.0
    return 0;
}
```

---

## Summary

| Aspect | Value |
|---|---|
| Speedup | 4-16x for suitable loops |
| Compiler support | Auto-vectorization with -O2/-O3 |
| Best for | Element-wise operations on arrays |
