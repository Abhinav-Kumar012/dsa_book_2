# Chapter 130: Coordinate Compression

## Prerequisites
- Sorting, binary search

## Interview Frequency: ★★★

Map large/sparse values to compact range. **Google**, **Amazon** test this.

---

## 130.1 Technique

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <map>

class CoordinateCompression {
    std::vector<int> sorted;
    std::map<int,int> compressed;
    
public:
    void add(int x) { sorted.push_back(x); }
    
    void build() {
        std::sort(sorted.begin(), sorted.end());
        sorted.erase(std::unique(sorted.begin(), sorted.end()), sorted.end());
        for (int i = 0; i < (int)sorted.size(); i++)
            compressed[sorted[i]] = i;
    }
    
    int compress(int x) { return compressed[x]; }
    int decompress(int idx) { return sorted[idx]; }
    int size() { return sorted.size(); }
};

int main() {
    std::vector<int> arr = {1000000000, 5, 1000000000, 3, 5, 7, 3};
    
    CoordinateCompression cc;
    for (int x : arr) cc.add(x);
    cc.build();
    
    std::cout << "Compressed values:\n";
    for (int x : arr) std::cout << x << " -> " << cc.compress(x) << "\n";
    std::cout << "Compact range: [0, " << cc.size() - 1 << "]\n";
    
    return 0;
}
```

---

## 130.2 Applications

| Problem | Use |
|---|---|
| Sparse segment tree | Compress coordinates first |
| Counting sort variant | Map to compact range |
| Grid compression | Compress row/col indices |
| Sweep line | Compress y-coordinates |

---

## Summary

| Step | Time | Notes |
|---|---|---|
| Sort + unique | O(n log n) | Remove duplicates |
| Build map | O(n) | Map value to index |
| Query | O(log n) | Binary search or map lookup |
