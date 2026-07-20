# Chapter 85: Digit DP

## Prerequisites

- Dynamic programming basics
- Recursion with memoization

## Interview Frequency: ★★★

Digit DP counts numbers with specific digit properties. Common in **Google** and competitive programming.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Count numbers with property | ★★★ | Medium | Classic digit DP |
| Sum of digits | ★★ | Medium | Variant |
| Digit constraints | ★★★ | Medium | Tight/loose bounds |

---

## 85.1 Core Concept

Count integers in [L, R] satisfying some property that depends on digits.

**State**: `dp[pos][tight][state]` where:
- `pos`: current digit position
- `tight`: whether we're still bounded by the upper limit
- `state`: problem-specific state (sum, count, etc.)

---

## 85.2 Example: Count numbers without consecutive identical digits

```cpp
#include <iostream>
#include <vector>
#include <cstring>
#include <string>

long long dp[20][10][2]; // pos, last_digit, tight

long long solve(const std::string& num, int pos, int lastDigit, bool tight) {
    if (pos == (int)num.size()) return 1;
    
    if (dp[pos][lastDigit][tight] != -1) return dp[pos][lastDigit][tight];
    
    long long result = 0;
    int limit = tight ? num[pos] - '0' : 9;
    
    for (int d = 0; d <= limit; d++) {
        if (d == lastDigit && pos > 0) continue; // Skip consecutive same
        result += solve(num, pos + 1, d, tight && (d == limit));
    }
    
    return dp[pos][lastDigit][tight] = result;
}

long long countNoConsecutive(long long n) {
    std::string num = std::to_string(n);
    memset(dp, -1, sizeof(dp));
    return solve(num, 0, 0, true);
}

int main() {
    long long L = 1, R = 100;
    std::cout << "Count in [1, 100] without consecutive digits: "
              << countNoConsecutive(R) - countNoConsecutive(L - 1) << "\n";
    
    R = 1000;
    std::cout << "Count in [1, 1000] without consecutive digits: "
              << countNoConsecutive(R) - countNoConsecutive(L - 1) << "\n";
    
    return 0;
}
```

---

## 85.3 Example: Count numbers where digit sum equals K

```cpp
#include <iostream>
#include <vector>
#include <cstring>
#include <string>

long long dp[20][200][2]; // pos, sum, tight

long long solve(const std::string& num, int pos, int sum, bool tight, int target) {
    if (pos == (int)num.size()) return sum == target ? 1 : 0;
    
    if (dp[pos][sum][tight] != -1) return dp[pos][sum][tight];
    
    long long result = 0;
    int limit = tight ? num[pos] - '0' : 9;
    
    for (int d = 0; d <= limit; d++) {
        if (sum + d > target) break;
        result += solve(num, pos + 1, sum + d, tight && (d == limit), target);
    }
    
    return dp[pos][sum][tight] = result;
}

long long countWithDigitSum(long long n, int target) {
    std::string num = std::to_string(n);
    memset(dp, -1, sizeof(dp));
    return solve(num, 0, 0, true, target);
}

int main() {
    std::cout << "Count in [1, 1000] with digit sum = 10: "
              << countWithDigitSum(1000, 10) << "\n";
    
    return 0;
}
```

---

## 85.4 Common Digit DP Patterns

| Problem | State | Transition |
|---|---|---|
| Count with digit sum = K | `dp[pos][sum][tight]` | Add digit to sum |
| No consecutive same | `dp[pos][last][tight]` | Skip if same as last |
| Divisible by K | `dp[pos][remainder][tight]` | Update remainder |
| Contains digit D | `dp[pos][found][tight]` | Mark found |
| At most K distinct digits | `dp[pos][mask][tight]` | Update bitmask |

---

## Summary

| Aspect | Value |
|---|---|
| Time | O(digits × state × 10) |
| Space | O(digits × state) |
| Key insight | Process digit by digit |
| Common states | sum, remainder, last digit, bitmask |

---

## See Also

- [Chapter 30: DP Fundamentals](ch30-dp-fundamentals.md) — Prerequisite: understand state design, transitions, and memoization before tackling digit DP.
- [Chapter 31: DP Patterns](ch31-dp-patterns.md) — Digit DP is one of many DP patterns; see also bitmask DP, interval DP, and tree DP.
- [Chapter 86: DP Optimization](ch86-dp-optimization.md) — Digit DP states can sometimes be optimized using matrix exponentiation or other techniques.
- [Chapter 33: Bit Manipulation](ch33-bit-manipulation.md) — When tracking which digits have been used, bitmask states are common in digit DP.
