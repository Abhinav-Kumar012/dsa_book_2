# Chapter 117: Monotone Queue Optimization

## Prerequisites
- DP basics, monotonic deque, sliding window

## Interview Frequency: ★★

Monotone queue optimization speeds up DP transitions where the optimal decision point forms a monotone sequence. Used when `dp[i] = min(dp[j] + cost(j, i))` for j in a sliding window.

---

## 117.1 Core Concept

When computing `dp[i]`, we only need to look at j in some window [i-k, i-1]. If the cost function has certain properties, we can maintain a deque of candidate j values in decreasing order of their dp values.

---

## 117.2 Sliding Window Minimum

The foundation: find minimum in each window of size k in O(n).

```cpp
#include <iostream>
#include <vector>
#include <deque>

std::vector<int> slidingWindowMin(const std::vector<int>& arr, int k) {
    int n = arr.size();
    std::deque<int> dq; // Stores indices
    std::vector<int> result;
    
    for (int i = 0; i < n; i++) {
        // Remove elements outside window
        while (!dq.empty() && dq.front() < i - k + 1) dq.pop_front();
        
        // Maintain decreasing order: remove smaller elements from back
        while (!dq.empty() && arr[dq.back()] >= arr[i]) dq.pop_back();
        
        dq.push_back(i);
        
        // Window is full, record answer
        if (i >= k - 1) result.push_back(arr[dq.front()]);
    }
    return result;
}

int main() {
    std::vector<int> arr = {1, 3, -1, -3, 5, 3, 6, 7};
    auto result = slidingWindowMin(arr, 3);
    
    std::cout << "Array: ";
    for (int x : arr) std::cout << x << " ";
    std::cout << "\nSliding window minimum (k=3): ";
    for (int x : result) std::cout << x << " ";
    std::cout << "\n";
    
    return 0;
}
```

---

## 117.3 DP with Monotone Queue

When `dp[i] = min over j in [L(i), R(i)] of (dp[j] + cost(j, i))`, and the optimal j is monotone, use a deque.

```cpp
#include <iostream>
#include <vector>
#include <deque>
#include <climits>

// Problem: dp[i] = min(dp[j] + (sum[i] - sum[j])^2) for j in [i-k, i-1]
// This has the convex hull structure, but when k is fixed, monotone queue works.

// Simpler example: dp[i] = min(dp[j]) for j in [i-k, i-1] + arr[i]
int minCostWithWindow(const std::vector<int>& arr, int k) {
    int n = arr.size();
    std::vector<int> dp(n, INT_MAX);
    dp[0] = arr[0];
    
    std::deque<int> dq; // Stores indices with increasing dp values
    dq.push_back(0);
    
    for (int i = 1; i < n; i++) {
        // Remove elements outside window
        while (!dq.empty() && dq.front() < i - k) dq.pop_front();
        
        // dp[i] = min in window + arr[i]
        dp[i] = dp[dq.front()] + arr[i];
        
        // Maintain increasing dp order
        while (!dq.empty() && dp[dq.back()] >= dp[i]) dq.pop_back();
        dq.push_back(i);
    }
    
    return dp[n - 1];
}

int main() {
    std::vector<int> arr = {1, 3, 2, 4, 1, 5, 2, 3};
    int k = 3;
    
    std::cout << "Array: ";
    for (int x : arr) std::cout << x << " ";
    std::cout << "\nMin cost with window k=" << k << ": " 
              << minCostWithWindow(arr, k) << "\n";
    
    return 0;
}
```

---

## 117.4 When to Use

| Condition | Use Monotone Queue? |
|---|---|
| DP transition over sliding window | Yes |
| Optimal j is monotone | Yes |
| Cost function is convex | Yes (or use CHT) |
| Arbitrary transitions | No (use segment tree) |

---

## Summary

| Pattern | Time | Key Idea |
|---|---|---|
| Sliding window min | O(n) | Deque with decreasing values |
| Monotone queue DP | O(n) | Maintain deque of DP candidates |
| When to use | — | Fixed window, monotone opt |
