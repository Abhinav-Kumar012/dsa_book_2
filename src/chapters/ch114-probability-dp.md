# Chapter 114: Probability and Expected Value DP

## Prerequisites
- DP basics, probability

## Interview Frequency: ★★★

Expected value problems appear at **Google**, **Two Sigma**, **Jane Street**.

---

## 114.1 Expected Dice Throws

```cpp
#include <iostream>
#include <vector>
#include <iomanip>

double expectedDiceThrows(int n) {
    std::vector<double> E(n + 1, 0.0);
    for (int i = n - 1; i >= 0; i--) {
        E[i] = 1.0;
        for (int d = 1; d <= 6; d++)
            E[i] += E[std::min(i + d, n)] / 6.0;
    }
    return E[0];
}

int main() {
    for (int n : {10, 20, 30})
        std::cout << "Expected throws to reach " << n << ": " 
                  << std::fixed << std::setprecision(4) << expectedDiceThrows(n) << "\n";
    return 0;
}
```

---

## 114.2 Consecutive Heads

```cpp
#include <iostream>
#include <vector>
#include <iomanip>

double probConsecutiveHeads(int k) {
    // dp[i] = expected flips to get i consecutive heads
    // dp[i] = dp[i-1] + 1 + (1/2) * dp[i] (if tails after i-1 heads)
    // dp[i] = 2 * (dp[i-1] + 1)
    std::vector<double> dp(k + 1, 0);
    for (int i = 1; i <= k; i++)
        dp[i] = 2 * (dp[i-1] + 1);
    return dp[k];
}

int main() {
    for (int k = 1; k <= 5; k++)
        std::cout << "Expected flips for " << k << " consecutive heads: " 
                  << std::fixed << std::setprecision(1) << probConsecutiveHeads(k) << "\n";
    return 0;
}
```

---

## Summary

| Pattern | State | Transition |
|---|---|---|
| Expected steps | E[s] | E[s] = 1 + Σ p × E[s'] |
| Win probability | P[s] | P[s] = Σ p × P[s'] |
| Expected reward | R[s] | R[s] = reward + Σ p × R[s'] |
