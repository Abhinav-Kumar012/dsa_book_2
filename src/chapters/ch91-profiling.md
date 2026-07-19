# Chapter 91: Profiling and Benchmarking

## Prerequisites

- C++ basics
- Command line tools

## Interview Frequency: ★★

Profiling skills show engineering maturity. **Google** and **Amazon** value candidates who can measure and optimize.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Time measurement | ★★★ | Easy | chrono |
| Memory profiling | ★★ | Medium | Valgrind, sanitizers |
| Benchmark methodology | ★★ | Medium | Proper measurement |

---

## 91.1 Measuring Time

```cpp
#include <iostream>
#include <chrono>
#include <vector>
#include <algorithm>
#include <random>

template<typename Func>
double measureMs(Func f, int iterations = 100) {
    auto start = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < iterations; i++) f();
    auto end = std::chrono::high_resolution_clock::now();
    return std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() 
           / 1000.0 / iterations;
}

int main() {
    const int N = 1000000;
    std::vector<int> arr(N);
    std::mt19937 rng(42);
    for (int& x : arr) x = rng();
    
    // Benchmark sort
    std::vector<int> copy = arr;
    double sortTime = measureMs([&]() {
        copy = arr;
        std::sort(copy.begin(), copy.end());
    }, 10);
    
    std::cout << "std::sort (" << N << " elements): " << sortTime << "ms\n";
    
    // Benchmark linear search
    int target = arr[N / 2];
    double searchTime = measureMs([&]() {
        volatile auto it = std::find(arr.begin(), arr.end(), target);
    }, 100);
    
    std::cout << "Linear search: " << searchTime << "ms\n";
    
    return 0;
}
```

---

## 91.2 Benchmark Best Practices

| Practice | Why |
|---|---|
| Warm up cache | First run may be slower |
| Multiple iterations | Reduce variance |
| Median/percentile | More stable than mean |
| Prevent optimization | Use `volatile` or `DoNotOptimize` |
| Same input | Control variables |
| Report distribution | Mean ± stddev |

---

## 91.3 Profiling Tools

| Tool | Type | Platform |
|---|---|---|
| `gprof` | Function profiling | Linux |
| `perf` | CPU profiling | Linux |
| `valgrind --tool=callgrind` | Call profiling | Linux/Mac |
| `Instruments` | CPU/Memory | Mac |
| `Visual Studio Profiler` | CPU/Memory | Windows |
| `gperftools` | CPU/Heap | Linux |

---

## Summary

| Metric | Tool | What to Look For |
|---|---|---|
| CPU time | chrono, perf | Hot functions |
| Memory | Valgrind, ASan | Leaks, overflows |
| Cache misses | perf | Cache-friendly code |
| Branch mispredict | perf | Branchless opportunities |
