# Chapter 83: Advanced Network Flow

## Prerequisites

- Max flow basics (Ford-Fulkerson, Edmonds-Karp)
- Graph fundamentals

## Interview Frequency: ★★

Advanced flow algorithms appear in **Google** and competitive programming interviews for hard optimization problems.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Dinic's Algorithm | ★★★ | Hard | O(V²E) max flow |
| Push-Relabel | ★★ | Hard | O(V³) max flow |
| Min-Cut applications | ★★★ | Medium | Network reliability |
| Gomory-Hu Tree | ★ | Hard | All-pairs min-cut |

---

## 83.1 Dinic's Algorithm

Dinic's algorithm uses BFS to build level graphs and DFS to find blocking flows.

**Time**: O(V²E) general, O(E√V) for unit networks.

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
        q.push(s);
        reachable[s] = true;
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
    mf.addEdge(0, 1, 16);
    mf.addEdge(0, 2, 13);
    mf.addEdge(1, 2, 10);
    mf.addEdge(1, 3, 12);
    mf.addEdge(2, 1, 4);
    mf.addEdge(2, 4, 14);
    mf.addEdge(3, 2, 9);
    mf.addEdge(3, 5, 20);
    mf.addEdge(4, 3, 7);
    mf.addEdge(4, 5, 4);
    
    std::cout << "Max flow: " << mf.maxFlow(0, 5) << "\n";
    
    auto cut = mf.minCut(0);
    std::cout << "Min cut edges:\n";
    for (auto& [u, v] : cut)
        std::cout << "  " << u << " -> " << v << "\n";
    
    return 0;
}
```

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

```cpp
// Add source connected to all left nodes (cap 1)
// Add sink connected from all right nodes (cap 1)
// All original edges have cap 1
// Max flow = max matching
```

---

## Summary

| Algorithm | Time | Best For |
|---|---|---|
| Ford-Fulkerson | O(E × max_flow) | Small capacities |
| Edmonds-Karp | O(VE²) | General |
| Dinic | O(V²E) | General, unit networks |
| Push-Relabel | O(V³) | Dense graphs |
