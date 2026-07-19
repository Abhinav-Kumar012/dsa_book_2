# Chapter 123: Regular Expression and Wildcard Matching

## Prerequisites
- DP basics, string matching

## Interview Frequency: ★★★

Pattern matching with wildcards/regex appears at **Google**, **Meta**, **Amazon**.

---

## 123.1 Wildcard Matching

Pattern contains `?` (match any char) and `*` (match any sequence).

```cpp
#include <iostream>
#include <string>
#include <vector>

bool isMatch(const std::string& s, const std::string& p) {
    int n = s.size(), m = p.size();
    std::vector<std::vector<bool>> dp(n + 1, std::vector<bool>(m + 1, false));
    dp[0][0] = true;
    
    for (int j = 1; j <= m; j++)
        if (p[j-1] == '*') dp[0][j] = dp[0][j-1];
    
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++) {
            if (p[j-1] == '*')
                dp[i][j] = dp[i-1][j] || dp[i][j-1];
            else if (p[j-1] == '?' || s[i-1] == p[j-1])
                dp[i][j] = dp[i-1][j-1];
        }
    
    return dp[n][m];
}

int main() {
    std::cout << "isMatch(\"aa\", \"a*\"): " << isMatch("aa", "a*") << "\n";
    std::cout << "isMatch(\"cb\", \"?a\"): " << isMatch("cb", "?a") << "\n";
    std::cout << "isMatch(\"adceb\", \"*a*b\"): " << isMatch("adceb", "*a*b") << "\n";
    return 0;
}
```

---

## 123.2 Regex Matching

Pattern contains `.` (match any) and `*` (match zero or more of preceding).

```cpp
#include <iostream>
#include <string>
#include <vector>

bool isRegexMatch(const std::string& s, const std::string& p) {
    int n = s.size(), m = p.size();
    std::vector<std::vector<bool>> dp(n + 1, std::vector<bool>(m + 1, false));
    dp[0][0] = true;
    
    for (int j = 2; j <= m; j++)
        if (p[j-1] == '*') dp[0][j] = dp[0][j-2];
    
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++) {
            if (p[j-1] == '*') {
                dp[i][j] = dp[i][j-2];
                if (p[j-2] == '.' || p[j-2] == s[i-1])
                    dp[i][j] = dp[i][j] || dp[i-1][j];
            } else if (p[j-1] == '.' || s[i-1] == p[j-1]) {
                dp[i][j] = dp[i-1][j-1];
            }
        }
    
    return dp[n][m];
}

int main() {
    std::cout << "isRegexMatch(\"aa\", \"a*\"): " << isRegexMatch("aa", "a*") << "\n";
    std::cout << "isRegexMatch(\"ab\", \".*\"): " << isRegexMatch("ab", ".*") << "\n";
    std::cout << "isRegexMatch(\"aab\", \"c*a*b\"): " << isRegexMatch("aab", "c*a*b") << "\n";
    return 0;
}
```

---

## Summary

| Pattern | Special Chars | Time | Space |
|---|---|---|---|
| Wildcard | ?, * | O(nm) | O(nm) |
| Regex | ., * | O(nm) | O(nm) |
