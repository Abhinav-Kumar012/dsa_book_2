# Chapter 129: Compiler Optimizations

## Prerequisites
- C++ basics

## Interview Frequency: ★★

Understanding what compilers optimize helps write better code.

---

## 129.1 Common Optimizations

| Optimization | Description | Impact |
|---|---|---|
| Inlining | Replace function call with body | Eliminates call overhead |
| Loop unrolling | Replicate loop body | Reduces branch overhead |
| Constant folding | Compute constants at compile time | Eliminates runtime work |
| Dead code elimination | Remove unused code | Smaller binary |
| Tail call optimization | Reuse stack frame for tail calls | Prevents stack overflow |
| Vectorization (SIMD) | Use SIMD instructions | 4-16x speedup |

```cpp
#include <iostream>

// Inlining example
inline int square(int x) { return x * x; }

// Loop unrolling example (compiler does this automatically)
void sumArray(const int* arr, int n) {
    int sum = 0;
    for (int i = 0; i < n; i++) sum += arr[i];
    // Compiler may unroll to:
    // for (int i = 0; i < n; i += 4)
    //     sum += arr[i] + arr[i+1] + arr[i+2] + arr[i+3];
}

// Tail call optimization
int factorialTail(int n, int acc = 1) {
    if (n <= 1) return acc;
    return factorialTail(n - 1, n * acc); // Tail position
}

int main() {
    std::cout << "5² = " << square(5) << "\n";
    std::cout << "5! = " << factorialTail(5) << "\n";
    return 0;
}
```

---

## 129.2 Optimization Levels

| Flag | Description | Compile Time | Code Quality |
|---|---|---|---|
| `-O0` | No optimization | Fast | Poor |
| `-O1` | Basic optimizations | Medium | Good |
| `-O2` | Most optimizations | Slow | Better |
| `-O3` | Aggressive (incl. vectorization) | Slower | Best (may be larger) |
| `-Os` | Optimize for size | Medium | Good, smaller |
| `-Ofast` | O3 + fast-math | Slow | Best, may break IEEE |

---

## Summary

| Optimization | Benefit | Risk |
|---|---|---|
| Inlining | Eliminates call overhead | Larger binary |
| Vectorization | 4-16x speedup | Requires data alignment |
| Unrolling | Reduces branch overhead | Larger code |
| Fast-math | Faster FP operations | May break IEEE compliance |
