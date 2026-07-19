# Chapter 164: Advanced String Processing

## Prerequisites
- Suffix arrays, BWT, compression basics

## Interview Frequency: ★

---

## 164.1 Grammar Compression

Represent a string as a context-free grammar. Smallest grammar problem is NP-hard, but approximation algorithms exist.

**Applications**: Compressed pattern matching, compressed computation.

---

## 164.2 Lempel-Ziv Family

| Algorithm | Description | Used In |
|---|---|---|
| LZ77 | Reference previous occurrences via (offset, length) | gzip, PNG |
| LZ78 | Build dictionary incrementally | LZW compression |
| LZW | Simplified LZ78 (no explicit dictionary) | GIF, TIFF |

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <map>

// Simple LZ77-style compression (simplified)
struct LZToken { int offset, length; char next; };

std::vector<LZToken> lz77Compress(const std::string& s, int windowSize = 20) {
    std::vector<LZToken> tokens;
    int pos = 0;
    
    while (pos < (int)s.size()) {
        int bestOffset = 0, bestLength = 0;
        
        // Search in window
        int start = std::max(0, pos - windowSize);
        for (int i = start; i < pos; i++) {
            int len = 0;
            while (pos + len < (int)s.size() && s[i + len] == s[pos + len])
                len++;
            if (len > bestLength) {
                bestLength = len;
                bestOffset = pos - i;
            }
        }
        
        char next = (pos + bestLength < (int)s.size()) ? s[pos + bestLength] : '\0';
        tokens.push_back({bestOffset, bestLength, next});
        pos += bestLength + 1;
    }
    
    return tokens;
}

int main() {
    std::string s = "abracadabra";
    auto tokens = lz77Compress(s);
    
    std::cout << "LZ77 tokens for \"" << s << "\":\n";
    for (auto& t : tokens)
        std::cout << "  (" << t.offset << ", " << t.length << ", '" << t.next << "')\n";
    
    return 0;
}
```

---

## 164.3 Compressed Pattern Matching

Search for patterns directly in compressed representation without decompressing.

**Key result**: Can search in BWT-compressed text in O(m) time using FM-Index.

---

## 164.4 Dynamic String Algorithms

Maintain string operations under updates:
- **Dynamic suffix array**: O(log² n) per update
- **Dynamic LCP**: O(log n) per update
- **Rolling hash**: O(1) per update

---

## Summary

| Technique | Compression | Search Time | Notes |
|---|---|---|---|
| BWT + RLE | Repetitive text | O(m) | Static |
| LZ77/LZW | General | Decompress + search | Streaming |
| Grammar | Highly repetitive | Various | NP-hard to optimize |
| FM-Index | nH_k bits | O(m) | Succinct |
