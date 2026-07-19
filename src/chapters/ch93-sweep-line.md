# Chapter 93: Sweep Line Algorithms

## Prerequisites

- Sorting
- Data structures (set, segment tree)

## Interview Frequency: ★★★

Sweep line solves geometric and interval problems by processing events in order. **Google** and **Amazon** test this for interval and geometry problems.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Line sweep for intervals | ★★★ | Medium | Active set |
| Closest pair | ★★ | Medium | Divide and conquer |
| Rectangle union area | ★★ | Hard | Coordinate compression |

---

## 93.1 Core Concept

1. Sort events by one coordinate (usually x)
2. Maintain an "active set" of elements crossing the sweep line
3. Process events, updating the active set
4. Answer queries using the active set

---

## 93.2 Example: Maximum Overlapping Intervals

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

int maxOverlap(std::vector<std::pair<int,int>>& intervals) {
    std::vector<std::pair<int,int>> events;
    for (auto& [l, r] : intervals) {
        events.push_back({l, 1});   // Start
        events.push_back({r, -1});  // End
    }
    
    std::sort(events.begin(), events.end(), [](auto& a, auto& b) {
        if (a.first != b.first) return a.first < b.first;
        return a.second < b.second; // Process ends before starts
    });
    
    int current = 0, maxCount = 0;
    for (auto& [pos, type] : events) {
        current += type;
        maxCount = std::max(maxCount, current);
    }
    
    return maxCount;
}

int main() {
    std::vector<std::pair<int,int>> intervals = {{1, 5}, {2, 6}, {3, 7}, {4, 8}};
    std::cout << "Max overlapping: " << maxOverlap(intervals) << "\n"; // 4
    
    return 0;
}
```

---

## 93.3 Example: Merge Intervals

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

std::vector<std::pair<int,int>> mergeIntervals(std::vector<std::pair<int,int>> intervals) {
    if (intervals.empty()) return {};
    
    std::sort(intervals.begin(), intervals.end());
    std::vector<std::pair<int,int>> result = {intervals[0]};
    
    for (int i = 1; i < (int)intervals.size(); i++) {
        if (intervals[i].first <= result.back().second) {
            result.back().second = std::max(result.back().second, intervals[i].second);
        } else {
            result.push_back(intervals[i]);
        }
    }
    
    return result;
}

int main() {
    std::vector<std::pair<int,int>> intervals = {{1,3}, {2,6}, {8,10}, {15,18}};
    auto merged = mergeIntervals(intervals);
    
    std::cout << "Merged intervals:\n";
    for (auto& [l, r] : merged)
        std::cout << "  [" << l << ", " << r << "]\n";
    
    return 0;
}
```

---

## Summary

| Problem | Events | Active Set | Time |
|---|---|---|---|
| Max overlap | Start/End | Counter | O(n log n) |
| Merge intervals | Start/End | Current interval | O(n log n) |
| Rectangle union | Vertical edges | Segment tree | O(n log n) |
| Closest pair | Sort by x | Points near line | O(n log n) |
