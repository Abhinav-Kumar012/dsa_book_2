# Chapter 87: Suffix Tree

## Prerequisites

- Suffix array
- String basics

## Interview Frequency: ★★

Suffix trees solve many string problems in linear time. **Google** tests suffix tree concepts for hard string problems.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Ukkonen's algorithm | ★ | Hard | Online O(n) construction |
| Applications | ★★★ | Medium | LCS, pattern matching |

---

## 87.1 Structure

A suffix tree for string S is a compressed trie of all suffixes of S$ (where $ is a unique terminator).

**Properties**:
- O(n) nodes and edges
- Each edge stores a substring (represented as indices)
- Each suffix corresponds to a unique leaf

---

## 87.2 Applications

| Problem | Time with Suffix Tree |
|---|---|
| Pattern matching | O(m) |
| Longest common substring | O(n) |
| Longest repeated substring | O(n) |
| Count distinct substrings | O(n) |

---

## 87.3 Practical Alternative: Suffix Array + LCP

Suffix arrays are easier to implement and solve most suffix tree problems.

```cpp
#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

// Suffix array construction - O(n log n)
std::vector<int> buildSuffixArray(const std::string& s) {
    int n = s.size();
    std::vector<int> sa(n), rank(n), tmp(n);
    
    for (int i = 0; i < n; i++) {
        sa[i] = i;
        rank[i] = s[i];
    }
    
    for (int k = 1; k < n; k *= 2) {
        auto cmp = [&](int a, int b) {
            if (rank[a] != rank[b]) return rank[a] < rank[b];
            int ra = a + k < n ? rank[a + k] : -1;
            int rb = b + k < n ? rank[b + k] : -1;
            return ra < rb;
        };
        std::sort(sa.begin(), sa.end(), cmp);
        
        tmp[sa[0]] = 0;
        for (int i = 1; i < n; i++)
            tmp[sa[i]] = tmp[sa[i-1]] + (cmp(sa[i-1], sa[i]) ? 1 : 0);
        rank = tmp;
    }
    
    return sa;
}

// LCP array - O(n)
std::vector<int> buildLCP(const std::string& s, const std::vector<int>& sa) {
    int n = s.size();
    std::vector<int> rank(n), lcp(n - 1);
    for (int i = 0; i < n; i++) rank[sa[i]] = i;
    
    int h = 0;
    for (int i = 0; i < n; i++) {
        if (rank[i] == 0) continue;
        int j = sa[rank[i] - 1];
        while (i + h < n && j + h < n && s[i + h] == s[j + h]) h++;
        lcp[rank[i] - 1] = h;
        if (h > 0) h--;
    }
    
    return lcp;
}

int main() {
    std::string s = "banana";
    auto sa = buildSuffixArray(s);
    auto lcp = buildLCP(s, sa);
    
    std::cout << "Suffix Array for \"" << s << "\":\n";
    for (int i = 0; i < (int)sa.size(); i++) {
        std::cout << "  " << sa[i] << ": " << s.substr(sa[i]);
        if (i < (int)lcp.size()) std::cout << " (LCP=" << lcp[i] << ")";
        std::cout << "\n";
    }
    
    return 0;
}
```

---

## Summary

| Structure | Build Time | Space | Pattern Match | Notes |
|---|---|---|---|---|
| Suffix Tree | O(n) | O(n) | O(m) | Complex implementation |
| Suffix Array | O(n log n) | O(n) | O(m log n) | Simpler, practical |
| Suffix Array + LCP | O(n log n) | O(n) | O(m + log n) | Best practical |
