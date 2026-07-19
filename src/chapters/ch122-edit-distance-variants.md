# Chapter 122: Edit Distance Variants

## Prerequisites
- DP basics, LCS

## Interview Frequency: ★★★★

Edit distance and variants appear at **Google**, **Meta**, **Amazon**.

---

## 122.1 Standard Edit Distance

```cpp
#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

int editDistance(const std::string& a, const std::string& b) {
    int n = a.size(), m = b.size();
    std::vector<std::vector<int>> dp(n + 1, std::vector<int>(m + 1));
    
    for (int i = 0; i <= n; i++) dp[i][0] = i;
    for (int j = 0; j <= m; j++) dp[0][j] = j;
    
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++) {
            if (a[i-1] == b[j-1]) dp[i][j] = dp[i-1][j-1];
            else dp[i][j] = 1 + std::min({dp[i-1][j], dp[i][j-1], dp[i-1][j-1]});
        }
    
    return dp[n][m];
}

int main() {
    std::cout << "Edit distance (kitten, sitting): " 
              << editDistance("kitten", "sitting") << "\n"; // 3
    std::cout << "Edit distance (saturday, sunday): " 
              << editDistance("saturday", "sunday") << "\n"; // 3
    return 0;
}
```

---

## 122.2 Damerau-Levenshtein Distance

Adds transposition operation (swap adjacent characters).

```cpp
#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

int damerauLevenshtein(const std::string& a, const std::string& b) {
    int n = a.size(), m = b.size();
    std::vector<std::vector<int>> dp(n + 1, std::vector<int>(m + 1));
    
    for (int i = 0; i <= n; i++) dp[i][0] = i;
    for (int j = 0; j <= m; j++) dp[0][j] = j;
    
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++) {
            int cost = (a[i-1] == b[j-1]) ? 0 : 1;
            dp[i][j] = std::min({dp[i-1][j] + 1, dp[i][j-1] + 1, dp[i-1][j-1] + cost});
            if (i > 1 && j > 1 && a[i-1] == b[j-2] && a[i-2] == b[j-1])
                dp[i][j] = std::min(dp[i][j], dp[i-2][j-2] + cost);
        }
    
    return dp[n][m];
}

int main() {
    std::cout << "Damerau-Levenshtein (ab, ba): " 
              << damerauLevenshtein("ab", "ba") << "\n"; // 1 (transposition)
    return 0;
}
```

---

## Summary

| Variant | Operations | Time |
|---|---|---|
| Levenshtein | Insert, delete, replace | O(nm) |
| Damerau-Levenshtein | + Transpose | O(nm) |
| LCS | Insert, delete | O(nm) |
| Hamming | Replace only (same length) | O(n) |
