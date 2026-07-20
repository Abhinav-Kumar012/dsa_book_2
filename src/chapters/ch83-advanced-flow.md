# Chapter 83: Advanced Network Flow

## Prerequisites
- Max flow basics (Ford-Fulkerson, Edmonds-Karp)
- Graph fundamentals ([Chapter 22](ch22-graph-fundamentals.md))

## Interview Frequency: ★★

Advanced flow algorithms appear in **Google** and competitive programming interviews for hard optimization problems.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Dinic's Algorithm | ★★★ | Hard | O(V²E) max flow |
| Push-Relabel | ★★ | Hard | O(V³) max flow |
| Min-Cut applications | ★★★ | Medium | Network reliability |
| Bipartite Matching | ★★★ | Medium | Via max flow |

---

## Definition

**Dinic's Algorithm** is an improvement over Edmonds-Karp that uses level graphs and blocking flows. It runs in O(V²E) for general graphs and O(E√V) for unit networks.

**Push-Relabel** is a different paradigm that maintains a preflow (excess flow at nodes) and pushes flow toward the sink. It runs in O(V³) with FIFO selection.

## Motivation

Edmonds-Karp is O(VE²) — too slow for dense graphs. Dinic's achieves O(V²E) by finding blocking flows (multiple augmenting paths at once). Push-Relabel is often faster in practice for dense graphs.

## Intuition

- **Dinic's**: Build a "level graph" using BFS. Then find all augmenting paths in this level graph at once (blocking flow). Repeat.
- **Push-Relabel**: Imagine water flowing downhill. Each node has a "height." Flow is pushed from higher to lower nodes. Excess flow at a node is pushed toward the sink.

---

## 83.1 Dinic's Algorithm

### Algorithm

1. **BFS**: Build level graph (distance from source)
2. **DFS**: Find blocking flow (max set of shortest augmenting paths)
3. Repeat until no more augmenting paths

### C++ Implementation

```cpp
#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>
#include <climits>

struct Edge { int to, cap, flow; };

class Dinic {
    int n;
    std::vector<std::vector<int>> adj;
    std::vector<Edge> edges;
    std::vector<int> level, ptr;

    bool bfs(int s, int t) {
        std::fill(level.begin(), level.end(), -1);
        level[s] = 0;
        std::queue<int> q;
        q.push(s);
        while (!q.empty()) {
            int u = q.front(); q.pop();
            for (int idx : adj[u]) {
                auto& e = edges[idx];
                if (e.cap - e.flow > 0 && level[e.to] == -1) {
                    level[e.to] = level[u] + 1;
                    q.push(e.to);
                }
            }
        }
        return level[t] != -1;
    }

    int dfs(int u, int t, int pushed) {
        if (u == t || pushed == 0) return pushed;
        for (int& cid = ptr[u]; cid < (int)adj[u].size(); cid++) {
            int idx = adj[u][cid];
            auto& e = edges[idx];
            if (level[e.to] != level[u] + 1) continue;
            int tr = dfs(e.to, t, std::min(pushed, e.cap - e.flow));
            if (tr == 0) continue;
            e.flow += tr;
            edges[idx ^ 1].flow -= tr;
            return tr;
        }
        return 0;
    }

public:
    Dinic(int n) : n(n), adj(n), level(n), ptr(n) {}

    void addEdge(int u, int v, int cap) {
        adj[u].push_back(edges.size());
        edges.push_back({v, cap, 0});
        adj[v].push_back(edges.size());
        edges.push_back({u, 0, 0});
    }

    int maxFlow(int s, int t) {
        int flow = 0;
        while (bfs(s, t)) {
            std::fill(ptr.begin(), ptr.end(), 0);
            while (int pushed = dfs(s, t, INT_MAX))
                flow += pushed;
        }
        return flow;
    }

    std::vector<std::pair<int,int>> minCut(int s) {
        std::vector<bool> reachable(n, false);
        std::queue<int> q;
        q.push(s); reachable[s] = true;
        while (!q.empty()) {
            int u = q.front(); q.pop();
            for (int idx : adj[u]) {
                auto& e = edges[idx];
                if (e.cap - e.flow > 0 && !reachable[e.to]) {
                    reachable[e.to] = true;
                    q.push(e.to);
                }
            }
        }
        std::vector<std::pair<int,int>> cut;
        for (int u = 0; u < n; u++)
            if (reachable[u])
                for (int idx : adj[u])
                    if (!reachable[edges[idx].to] && edges[idx].cap > 0)
                        cut.push_back({u, edges[idx].to});
        return cut;
    }
};

int main() {
    Dinic mf(6);
    mf.addEdge(0, 1, 16); mf.addEdge(0, 2, 13);
    mf.addEdge(1, 2, 10); mf.addEdge(1, 3, 12);
    mf.addEdge(2, 1, 4);  mf.addEdge(2, 4, 14);
    mf.addEdge(3, 2, 9);  mf.addEdge(3, 5, 20);
    mf.addEdge(4, 3, 7);  mf.addEdge(4, 5, 4);

    std::cout << "Max flow: " << mf.maxFlow(0, 5) << "\n";

    auto cut = mf.minCut(0);
    std::cout << "Min cut edges:\n";
    for (auto& [u, v] : cut)
        std::cout << "  " << u << " -> " << v << "\n";

    return 0;
}
```

### Python Implementation

```python
from collections import deque

class Dinic:
    def __init__(self, n):
        self.n = n
        self.adj = [[] for _ in range(n)]
        self.edges = []

    def add_edge(self, u, v, cap):
        self.adj[u].append(len(self.edges))
        self.edges.append([v, cap, 0])
        self.adj[v].append(len(self.edges))
        self.edges.append([u, 0, 0])

    def bfs(self, s, t):
        self.level = [-1] * self.n
        self.level[s] = 0
        q = deque([s])
        while q:
            u = q.popleft()
            for idx in self.adj[u]:
                e = self.edges[idx]
                if e[1] - e[2] > 0 and self.level[e[0]] == -1:
                    self.level[e[0]] = self.level[u] + 1
                    q.append(e[0])
        return self.level[t] != -1

    def dfs(self, u, t, pushed):
        if u == t or pushed == 0:
            return pushed
        for i in range(self.ptr[u], len(self.adj[u])):
            self.ptr[u] = i
            idx = self.adj[u][i]
            e = self.edges[idx]
            if self.level[e[0]] != self.level[u] + 1:
                continue
            tr = self.dfs(e[0], t, min(pushed, e[1] - e[2]))
            if tr == 0:
                continue
            e[2] += tr
            self.edges[idx ^ 1][2] -= tr
            return tr
        return 0

    def max_flow(self, s, t):
        flow = 0
        while self.bfs(s, t):
            self.ptr = [0] * self.n
            while pushed := self.dfs(s, t, float('inf')):
                flow += pushed
        return flow

# Example
mf = Dinic(6)
mf.add_edge(0, 1, 16); mf.add_edge(0, 2, 13)
mf.add_edge(1, 2, 10); mf.add_edge(1, 3, 12)
mf.add_edge(2, 1, 4);  mf.add_edge(2, 4, 14)
mf.add_edge(3, 2, 9);  mf.add_edge(3, 5, 20)
mf.add_edge(4, 3, 7);  mf.add_edge(4, 5, 4)
print(f"Max flow: {mf.max_flow(0, 5)}")
```

### Complexity

| Algorithm | Time | Best For |
|---|---|---|
| Ford-Fulkerson | O(E × max_flow) | Small capacities |
| Edmonds-Karp | O(VE²) | General |
| Dinic | O(V²E) | General, unit networks |
| Push-Relabel | O(V³) | Dense graphs |

---

## 83.2 Applications of Max-Flow/Min-Cut

| Application | Source | Sink | Edge Capacities |
|---|---|---|---|
| Network reliability | Source | Sink | Link capacities |
| Image segmentation | Super-source | Super-sink | Pixel similarities |
| Baseball elimination | Games | Teams | Remaining games |
| Project selection | Source | Sink | Profits/costs |

---

## 83.3 Bipartite Matching via Max Flow

```
Source → (all left nodes, cap 1) → (edges, cap 1) → (all right nodes, cap 1) → Sink
Max flow = max matching
```

---

## Exercises

1. **Implement Push-Relabel**: Implement the push-relabel algorithm with FIFO selection. Compare with Dinic's on random graphs.

2. **Image segmentation**: Use min-cut to segment an image into foreground/background. Model pixel similarities as edge capacities.

3. **Baseball elimination**: Given team standings and remaining games, determine if a team can still win the division using max-flow.

4. **Project selection**: Given projects with profits/costs and dependencies, select projects to maximize profit using min-cut.

---

## Interview Questions

1. **Q: How does Dinic's algorithm improve over Edmonds-Karp?**
   A: Edmonds-Karp finds one augmenting path per BFS. Dinic's finds a blocking flow (all augmenting paths in the level graph) per BFS. This reduces the number of BFS phases from O(VE) to O(V).

2. **Q: What is a blocking flow?**
   A: A blocking flow is a set of augmenting paths in the level graph such that every path from source to sink in the level graph uses at least one saturated edge. After finding a blocking flow, the level graph must be rebuilt.

3. **Q: When is Push-Relabel faster than Dinic's?**
   A: Push-Relabel is often faster in practice for dense graphs because it doesn't need BFS phases. It processes nodes locally, which is more cache-friendly. Dinic's is better for sparse graphs and unit networks.

---

## Cross-References

- [Chapter 29: Network Flow](ch29-network-flow.md) — Ford-Fulkerson and Edmonds-Karp
- [Chapter 22: Graph Fundamentals](ch22-graph-fundamentals.md) — BFS foundation for level graphs

---

## Summary

| Algorithm | Time | Best For |
|---|---|---|
| Ford-Fulkerson | O(E × max_flow) | Small capacities |
| Edmonds-Karp | O(VE²) | General |
| Dinic | O(V²E) | General, unit networks |
| Push-Relabel | O(V³) | Dense graphs |
