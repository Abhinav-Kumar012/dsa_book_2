# Chapter 112: Hopcroft-Karp and Blossom Algorithm

## Prerequisites
- Bipartite matching, DFS

## Interview Frequency: ★★★

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Hopcroft-Karp | ★★★ | Hard | O(E√V) bipartite matching |
| Blossom (overview) | ★ | Hard | General graph matching |

---

## 112.1 Hopcroft-Karp Algorithm

Find maximum bipartite matching by finding multiple augmenting paths simultaneously using BFS layers.

```cpp
#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>

class HopcroftKarp {
    int n, m;
    std::vector<std::vector<int>> adj;
    std::vector<int> pairU, pairV, dist;
    
    bool bfs() {
        std::queue<int> q;
        for (int u = 0; u < n; u++) {
            if (pairU[u] == -1) { dist[u] = 0; q.push(u); }
            else dist[u] = INT_MAX;
        }
        bool found = false;
        while (!q.empty()) {
            int u = q.front(); q.pop();
            for (int v : adj[u]) {
                if (pairV[v] == -1) found = true;
                else if (dist[pairV[v]] == INT_MAX) {
                    dist[pairV[v]] = dist[u] + 1;
                    q.push(pairV[v]);
                }
            }
        }
        return found;
    }
    
    bool dfs(int u) {
        for (int v : adj[u]) {
            if (pairV[v] == -1 || (dist[pairV[v]] == dist[u] + 1 && dfs(pairV[v]))) {
                pairU[u] = v; pairV[v] = u;
                return true;
            }
        }
        dist[u] = INT_MAX;
        return false;
    }
    
public:
    HopcroftKarp(int n, int m) : n(n), m(m), adj(n), pairU(n, -1), pairV(m, -1), dist(n) {}
    void addEdge(int u, int v) { adj[u].push_back(v); }
    
    int maxMatching() {
        int matching = 0;
        while (bfs())
            for (int u = 0; u < n; u++)
                if (pairU[u] == -1 && dfs(u)) matching++;
        return matching;
    }
    
    std::vector<std::pair<int,int>> getMatching() {
        std::vector<std::pair<int,int>> result;
        for (int u = 0; u < n; u++)
            if (pairU[u] != -1) result.push_back({u, pairU[u]});
        return result;
    }
};

int main() {
    HopcroftKarp hk(4, 4);
    hk.addEdge(0, 0); hk.addEdge(0, 1);
    hk.addEdge(1, 0); hk.addEdge(1, 2);
    hk.addEdge(2, 1); hk.addEdge(3, 2); hk.addEdge(3, 3);
    
    std::cout << "Max matching: " << hk.maxMatching() << "\n";
    auto matching = hk.getMatching();
    for (auto& [u, v] : matching)
        std::cout << "  U" << u << " -> V" << v << "\n";
    
    return 0;
}
```

---

## 112.2 Blossom Algorithm (Overview)

For general (non-bipartite) graph matching. Uses **blossom contraction** to handle odd cycles.

**Key idea**: When an odd cycle is found, contract it into a single vertex and continue searching.

---

## Summary

| Algorithm | Graph Type | Time | Notes |
|---|---|---|---|
| Hopcroft-Karp | Bipartite | O(E√V) | BFS + DFS layers |
| Blossom | General | O(V³) | Contract odd cycles |
