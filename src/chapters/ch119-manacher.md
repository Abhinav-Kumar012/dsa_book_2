# Chapter 119: Manacher's Algorithm

## Prerequisites
- Palindromes, string basics

## Interview Frequency: ★★★

Find all palindromic substrings in O(n). **Google** and **Amazon** test this.

---

## 119.1 Algorithm

Manacher's finds the longest palindrome centered at each position in O(n) by reusing previously computed information.

```cpp
#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

// Returns array where d1[i] = radius of odd palindrome centered at i
// d2[i] = radius of even palindrome centered between i-1 and i
std::pair<std::vector<int>, std::vector<int>> manacher(const std::string& s) {
    int n = s.size();
    std::vector<int> d1(n), d2(n);
    
    // Odd length palindromes
    for (int i = 0, l = 0, r = -1; i < n; i++) {
        int k = (i > r) ? 1 : std::min(d1[l + r - i], r - i + 1);
        while (i - k >= 0 && i + k < n && s[i - k] == s[i + k]) k++;
        d1[i] = k--;
        if (i + k > r) { l = i - k; r = i + k; }
    }
    
    // Even length palindromes
    for (int i = 0, l = 0, r = -1; i < n; i++) {
        int k = (i > r) ? 0 : std::min(d2[l + r - i + 1], r - i + 1);
        while (i - k - 1 >= 0 && i + k < n && s[i - k - 1] == s[i + k]) k++;
        d2[i] = k--;
        if (i + k > r) { l = i - k - 1; r = i + k; }
    }
    
    return {d1, d2};
}

int main() {
    std::string s = "abacaba";
    auto [d1, d2] = manacher(s);
    
    // Longest palindromic substring
    int maxLen = 0, center = 0;
    for (int i = 0; i < (int)s.size(); i++) {
        if (2 * d1[i] - 1 > maxLen) { maxLen = 2 * d1[i] - 1; center = i; }
        if (2 * d2[i] > maxLen) { maxLen = 2 * d2[i]; center = i; }
    }
    
    std::cout << "Longest palindrome length: " << maxLen << "\n";
    std::cout << "Count of odd palindromes: ";
    long long count = 0;
    for (int x : d1) count += x;
    std::cout << count << "\n";
    
    return 0;
}
```

---

## Summary

| Operation | Time | Space |
|---|---|---|
| All palindromes | O(n) | O(n) |
| Longest palindrome | O(n) | O(n) |
| Count palindromes | O(n) | O(n) |
