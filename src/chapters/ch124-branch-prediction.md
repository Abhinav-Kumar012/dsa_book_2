# Chapter 124: Branch Prediction

## Prerequisites
- CPU architecture basics

## Interview Frequency: ★★

Branch prediction awareness matters for high-performance code. **Google**, **Meta**, and trading firms test this.

---

## 124.1 What Is Branch Prediction?

CPUs pipeline instructions. When a branch (if/else) is encountered, the CPU predicts which path to take. Mispredictions cost ~15-20 cycles.

---

## 124.2 Impact on Sorting

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <chrono>
#include <random>

int main() {
    const int N = 1000000;
    std::vector<int> arr(N);
    std::mt19937 rng(42);
    for (int& x : arr) x = rng() % 256;
    
    // Unsorted: branch prediction fails often
    auto start = std::chrono::high_resolution_clock::now();
    long long sum = 0;
    for (int x : arr) if (x >= 128) sum += x;
    auto end = std::chrono::high_resolution_clock::now();
    auto unsorted = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
    
    // Sorted: branch prediction succeeds
    std::sort(arr.begin(), arr.end());
    start = std::chrono::high_resolution_clock::now();
    sum = 0;
    for (int x : arr) if (x >= 128) sum += x;
    end = std::chrono::high_resolution_clock::now();
    auto sorted = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
    
    std::cout << "Unsorted: " << unsorted.count() << "μs\n";
    std::cout << "Sorted: " << sorted.count() << "μs\n";
    std::cout << "Speedup: " << (double)unsorted.count() / sorted.count() << "x\n";
    
    return 0;
}
```

---

## 124.3 Branchless Code

Replace branches with arithmetic to avoid mispredictions.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// Branchless: instead of if (x >= 128) sum += x;
// Use: sum += (x >= 128) * x;

int main() {
    std::vector<int> arr = {100, 200, 50, 150, 80, 130};
    
    // Branchless sum
    long long sum = 0;
    for (int x : arr) sum += (x >= 128) * x;
    std::cout << "Branchless sum of >= 128: " << sum << "\n";
    
    return 0;
}
```

---

## Summary

| Scenario | Impact |
|---|---|
| Sorted data | Predictable branches → fast |
| Random data | Unpredictable → slow |
| Branchless | No prediction needed → consistent |
