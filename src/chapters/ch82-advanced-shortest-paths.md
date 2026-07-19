# Chapter 82: Advanced Shortest Paths

## Prerequisites

- Dijkstra's algorithm
- BFS
- Graph fundamentals

## Interview Frequency: ★★★

Advanced shortest path algorithms handle negative weights, all-pairs queries, and specialized graphs. **Google** and **Amazon** test these for complex graph problems.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Bellman-Ford | ★★★ | Medium | Negative weights |
| Floyd-Warshall | ★★★★ | Medium | All-pairs shortest |
| 0-1 BFS | ★★★ | Medium | Weights 0 or 1 |
| SPFA | ★★ | Medium | Faster Bellman-Ford |

---

## 82.1 Bellman-Ford Algorithm

Handles negative edge weights. Detects negative cycles.

**Time**: O(VE)

```cpp
#include <iostream>
#include <vector>
#include <climits>

struct Edge { int u, v, w; };

std::vector<long long> bellmanFord(int n, const std::vector<Edge>& edges, 
                                    int src) {
    std::vector<long long> dist(n, LLONG_MAX);
    dist[src] = 0;
    
    // Relax all edges n-1 times
    for (int i = 0; i < n - 1; i++) {
        for (auto& [u, v, w] : edges) {
            if (dist[u] != LLONG_MAX && dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w;
            }
        }
    }
    
    // Check for negative cycles
    for (auto& [u, v, w] : edges) {
        if (dist[u] != LLONG_MAX && dist[u] + w < dist[v]) {
            std::cout << "Negative cycle detected!\n";
            return {};
        }
    }
    
    return dist;
}

int main() {
    int n = 5;
    std::vector<Edge> edges = {
        {0, 1, 6}, {0, 3, 7}, {1, 2, 5}, {1, 3, 8},
        {1, 4, -4}, {2, 1, -2}, {3, 2, -3}, {3, 4, 9}, {4, 0, 2}
    };
    
    auto dist = bellmanFord(n, edges, 0);
    
    std::cout << "Distances from 0:\n";
    for (int i = 0; i < n; i++)
        std::cout << "  To " << i << ": " << dist[i] << "\n";
    
    return 0;
}
```

---

## 82.2 Floyd-Warshall Algorithm

All-pairs shortest paths in O(V³).

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>

std::vector<std::vector<long long>> floydWarshall(int n, 
    const std::vector<std::vector<long long>>& adj) {
    
    auto dist = adj;
    
    for (int k = 0; k < n; k++)
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++)
                if (dist[i][k] != LLONG_MAX && dist[k][j] != LLONG_MAX)
                    dist[i][j] = std::min(dist[i][j], dist[i][k] + dist[k][j]);
    
    return dist;
}

int main() {
    int n = 4;
    long long INF = LLONG_MAX;
    std::vector<std::vector<long long>> adj = {
        {0, 5, INF, 10},
        {INF, 0, 3, INF},
        {INF, INF, 0, 1},
        {INF, INF, INF, 0}
    };
    
    auto dist = floydWarshall(n, adj);
    
    std::cout << "All-pairs shortest paths:\n";
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++)
            std::cout << (dist[i][j] == INF ? -1 : dist[i][j]) << "\t";
        std::cout << "\n";
    }
    
    return 0;
}
```

---

## 82.3 0-1 BFS

For graphs with edge weights 0 or 1, use a deque instead of a priority queue.

**Time**: O(V + E)

```cpp
#include <iostream>
#include <vector>
#include <deque>
#include <climits>

struct Edge { int to, weight; };

std::vector<int> bfs01(int n, const std::vector<std::vector<Edge>>& adj, int src) {
    std::vector<int> dist(n, INT_MAX);
    std::deque<int> dq;
    
    dist[src] = 0;
    dq.push_front(src);
    
    while (!dq.empty()) {
        int u = dq.front(); dq.pop_front();
        
        for (auto& [v, w] : adj[u]) {
            if (dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w;
                if (w == 0) dq.push_front(v);
                else dq.push_back(v);
            }
        }
    }
    
    return dist;
}

int main() {
    int n = 5;
    std::vector<std::vector<Edge>> adj(n);
    adj[0] = {{1, 0}, {2, 1}};
    adj[1] = {{3, 1}};
    adj[2] = {{3, 0}};
    adj[3] = {{4, 1}};
    
    auto dist = bfs01(n, adj, 0);
    
    std::cout << "0-1 BFS distances from 0:\n";
    for (int i = 0; i < n; i++)
        std::cout << "  To " << i << ": " << dist[i] << "\n";
    
    return 0;
}
```

---

## Summary

| Algorithm | Time | Negative Weights | All-Pairs | Negative Cycle |
|---|---|---|---|---|
| Dijkstra | O((V+E)log V) | No | No | No |
| Bellman-Ford | O(VE) | Yes | No | Yes |
| Floyd-Warshall | O(V³) | Yes | Yes | Yes |
| 0-1 BFS | O(V+E) | No (0/1 only) | No | No |
| SPFA | O(VE) avg | Yes | No | Yes |
