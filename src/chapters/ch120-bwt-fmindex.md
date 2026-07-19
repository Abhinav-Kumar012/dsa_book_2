# Chapter 120: Burrows-Wheeler Transform and FM-Index

## Prerequisites
- Suffix array, string basics

## Interview Frequency: ★

The Burrows-Wheeler Transform (BWT) rearranges a string to group similar characters together, enabling compression and fast pattern matching. Used in bioinformatics (BWA, Bowtie) and compression (bzip2).

---

## 120.1 BWT Construction

Sort all cyclic rotations of the string, take the last column.

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

std::string bwt(const std::string& s) {
    int n = s.size();
    std::vector<std::string> rotations;
    for (int i = 0; i < n; i++)
        rotations.push_back(s.substr(i) + s.substr(0, i));
    std::sort(rotations.begin(), rotations.end());
    std::string result;
    for (auto& r : rotations) result += r.back();
    return result;
}

std::string inverseBwt(const std::string& bwt_str) {
    int n = bwt_str.size();
    std::vector<std::string> table(n, "");
    for (int iter = 0; iter < n; iter++) {
        for (int i = 0; i < n; i++)
            table[i] = bwt_str[i] + table[i];
        std::sort(table.begin(), table.end());
    }
    for (auto& row : table)
        if (row.back() == '$') return row;
    return "";
}

int main() {
    std::string s = "banana$";
    std::string transformed = bwt(s);
    std::cout << "Original: \"" << s << "\"\n";
    std::cout << "BWT:      \"" << transformed << "\"\n";
    
    std::string recovered = inverseBwt(transformed);
    std::cout << "Recovered: \"" << recovered << "\"\n";
    
    return 0;
}
```

---

## 120.2 BWT Properties

| Property | Description |
|---|---|
| Groups similar chars | Runs of identical characters |
| Enables compression | Run-length encoding works well |
| Preserves information | Can reconstruct original |
| LF-mapping | Navigate between sorted/unsorted |

---

## 120.3 FM-Index

Combines BWT with suffix array sampling for O(m) pattern matching on the BWT string.

**Key operations**:
- `count(c)`: Number of occurrences of character c before position i
- `locate(i)`: Find original position of BWT[i]

**Space**: O(n) with LF-mapping, O(n log n) with suffix array sampling.

---

## 120.4 Applications

| Application | Tool | Use Case |
|---|---|---|
| Genome alignment | BWA, Bowtie | Read mapping |
| Compression | bzip2 | General compression |
| Full-text search | FM-Index | Search in large texts |

---

## Summary

| Component | Purpose | Time |
|---|---|---|
| BWT | Rearrange string | O(n) |
| LF-mapping | Navigate BWT | O(1) per step |
| FM-Index | Pattern matching | O(m) search |
| Space | — | O(n) with sampling |
