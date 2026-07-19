# Chapter 121: Lyndon Factorization

## Prerequisites
- String basics

## Interview Frequency: ★

A Lyndon word is strictly smaller than all its rotations. Every string has a unique Lyndon factorization.

---

## 121.1 Duval's Algorithm

Compute Lyndon factorization in O(n).

```cpp
#include <iostream>
#include <string>
#include <vector>

// Returns starting positions of Lyndon factors
std::vector<int> lyndonFactorization(const std::string& s) {
    int n = s.size();
    std::vector<int> result;
    int i = 0;
    while (i < n) {
        int j = i + 1, k = i;
        while (j < n && s[k] <= s[j]) {
            if (s[k] < s[j]) k = i;
            else k++;
            j++;
        }
        while (i <= k) {
            result.push_back(i);
            i += j - k;
        }
    }
    return result;
}

int main() {
    std::string s = "abcabc";
    auto factors = lyndonFactorization(s);
    std::cout << "Lyndon factors of \"" << s << "\":\n";
    for (int i = 0; i < (int)factors.size(); i++) {
        int start = factors[i];
        int end = (i + 1 < (int)factors.size()) ? factors[i+1] : s.size();
        std::cout << "  \"" << s.substr(start, end - start) << "\"\n";
    }
    return 0;
}
```

---

## Summary

| Property | Value |
|---|---|
| Time | O(n) |
| Unique factorization | Yes |
| Application | Minimal string rotation, string matching |
