# Chapter 118: Bitset DP and Memory Optimization

## Prerequisites
- Bit manipulation, DP

## Interview Frequency: ★★

Bitset optimizations speed up subset DP by a factor of 64.

---

## 118.1 Bitset Optimization

Use `std::bitset` to represent DP states compactly, enabling bitwise operations.

```cpp
#include <iostream>
#include <vector>
#include <bitset>

// Subset sum using bitset
std::bitset<100001> subsetSum(const std::vector<int>& arr) {
    std::bitset<100001> dp;
    dp[0] = 1;
    for (int x : arr)
        dp |= dp << x;
    return dp;
}

// Count ways to make sum S
long long countSubsetSum(const std::vector<int>& arr, int S) {
    std::vector<long long> dp(S + 1, 0);
    dp[0] = 1;
    for (int x : arr)
        for (int s = S; s >= x; s--)
            dp[s] += dp[s - x];
    return dp[S];
}

int main() {
    std::vector<int> arr = {3, 1, 4, 1, 5, 9, 2, 6};
    
    auto dp = subsetSum(arr);
    std::cout << "Can make sum 10: " << dp[10] << "\n";
    std::cout << "Can make sum 100: " << dp[100] << "\n";
    std::cout << "Can make sum 31: " << dp[31] << "\n";
    
    std::cout << "Count ways to make sum 10: " << countSubsetSum(arr, 10) << "\n";
    
    return 0;
}
```

---

## 118.2 Rolling Array

Reduce DP space from O(n × m) to O(m) when only previous row is needed.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// 0/1 Knapsack with O(W) space
int knapsack(const std::vector<int>& weights, const std::vector<int>& values, int W) {
    std::vector<int> dp(W + 1, 0);
    for (int i = 0; i < (int)weights.size(); i++)
        for (int w = W; w >= weights[i]; w--)
            dp[w] = std::max(dp[w], dp[w - weights[i]] + values[i]);
    return dp[W];
}

int main() {
    std::vector<int> w = {2, 3, 4, 5};
    std::vector<int> v = {3, 4, 5, 6};
    std::cout << "Knapsack: " << knapsack(w, v, 8) << "\n";
    return 0;
}
```

---

## Summary

| Technique | Space Reduction | Time |
|---|---|---|
| Bitset | 64x | O(nW/64) |
| Rolling array | O(n×m) → O(m) | Same |
| Hirschberg | O(n×m) → O(m) | 2× time, full reconstruction |
