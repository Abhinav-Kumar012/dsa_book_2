# Chapter 132: IDA* and Beam Search

## Prerequisites
- DFS, BFS, A*

## Interview Frequency: ★

Advanced search strategies for large state spaces.

---

## 132.1 IDA* (Iterative Deepening A*)

Combines iterative deepening with heuristic pruning. Memory-efficient alternative to A*.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>

// 8-puzzle heuristic (Manhattan distance)
int manhattan(const std::vector<int>& state) {
    int dist = 0;
    for (int i = 0; i < 9; i++) {
        if (state[i] == 0) continue;
        int targetRow = (state[i] - 1) / 3;
        int targetCol = (state[i] - 1) % 3;
        int currRow = i / 3;
        int currCol = i % 3;
        dist += abs(targetRow - currRow) + abs(targetCol - currCol);
    }
    return dist;
}

int idaStar(std::vector<int> state, int bound, int& nextBound) {
    int h = manhattan(state);
    if (h == 0) return 0;
    int f = h;
    if (f > bound) { nextBound = std::min(nextBound, f); return -1; }
    
    int zeroPos = 0;
    for (int i = 0; i < 9; i++) if (state[i] == 0) { zeroPos = i; break; }
    
    int dx[] = {0, 0, 1, -1};
    int dy[] = {1, -1, 0, 0};
    
    for (int d = 0; d < 4; d++) {
        int nx = zeroPos / 3 + dx[d];
        int ny = zeroPos % 3 + dy[d];
        if (nx < 0 || nx >= 3 || ny < 0 || ny >= 3) continue;
        
        int newPos = nx * 3 + ny;
        std::swap(state[zeroPos], state[newPos]);
        
        int newBound = INT_MAX;
        int result = idaStar(state, bound, newBound);
        if (result >= 0) { std::swap(state[zeroPos], state[newPos]); return result + 1; }
        nextBound = std::min(nextBound, newBound);
        
        std::swap(state[zeroPos], state[newPos]);
    }
    
    return -1;
}

int main() {
    std::vector<int> state = {1, 2, 3, 4, 0, 5, 6, 7, 8};
    int bound = manhattan(state);
    
    while (true) {
        int nextBound = INT_MAX;
        int result = idaStar(state, bound, nextBound);
        if (result >= 0) {
            std::cout << "Solution found in " << result << " moves\n";
            break;
        }
        if (nextBound == INT_MAX) break;
        bound = nextBound;
    }
    
    return 0;
}
```

---

## 132.2 Beam Search (Overview)

Beam search keeps only the top-k states at each level. It's a memory-bounded best-first search.

**Key parameter**: beam width k. Larger k = better solutions but more memory.

---

## Summary

| Algorithm | Memory | Optimal? | Best For |
|---|---|---|---|
| IDA* | O(d) depth | Yes | Memory-constrained A* |
| Beam Search | O(k) per level | No | Large state spaces |
