# Chapter 113: Profile DP (Broken Profile DP)

## Prerequisites
- Bitmask DP, grid problems

## Interview Frequency: ★★

Profile DP counts tilings and grid configurations using bitmask states.

| Problem | Profile Width | State |
|---|---|---|
| Domino tiling | m bits | 1 = filled from above |
| L-tromino tiling | m bits + extra | Complex transitions |

---

## 113.1 Domino Tiling

Count ways to tile an N×M grid with 1×2 dominoes.

```cpp
#include <iostream>
#include <vector>
#include <cstring>

long long dominoTiling(int n, int m) {
    if (n < m) std::swap(n, m);
    int maxMask = 1 << m;
    std::vector<long long> dp(maxMask, 0), next(maxMask, 0);
    dp[0] = 1;
    
    for (int col = 0; col < n; col++) {
        for (int row = 0; row < m; row++) {
            std::fill(next.begin(), next.end(), 0);
            for (int mask = 0; mask < maxMask; mask++) {
                if (dp[mask] == 0) continue;
                if (mask & (1 << row)) {
                    next[mask ^ (1 << row)] += dp[mask];
                } else {
                    if (col + 1 < n) next[mask | (1 << row)] += dp[mask];
                    if (row + 1 < m && !(mask & (1 << (row + 1))))
                        next[mask | (1 << (row + 1))] += dp[mask];
                }
            }
            dp = next;
        }
    }
    return dp[0];
}

int main() {
    for (int n = 1; n <= 8; n++)
        for (int m = 1; m <= 8; m++)
            if (n * m % 2 == 0)
                std::cout << n << "x" << m << ": " << dominoTiling(n, m) << " ways\n";
    return 0;
}
```

---

## Summary

| Aspect | Value |
|---|---|
| State | Bitmask of m bits |
| Time | O(n × m × 2^m) |
| Space | O(2^m) |
| Best for | Grid tiling, chess problems |
