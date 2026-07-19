# Chapter 111: K-Core Decomposition and Transitive Closure

## Prerequisites
- Graph basics, BFS

## Interview Frequency: ★★

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| K-Core | ★★ | Medium | Degeneracy ordering |
| Transitive Closure | ★★ | Medium | Reachability matrix |
| Transitive Reduction | ★ | Hard | Minimal equivalent DAG |

---

## 111.1 K-Core Decomposition

The k-core of a graph is the maximal subgraph where every vertex has degree ≥ k.

```cpp
#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>

std::vector<int> kCoreDecomposition(int n, const std::vector<std::vector<int>>& adj) {
    std::vector<int> degree(n), core(n, 0);
    for (int i = 0; i < n; i++) degree[i] = adj[i].size();
    
    std::queue<int> q;
    std::vector<bool> removed(n, false);
    
    // Process vertices in order of increasing degree
    int maxDegree = 0;
    for (int i = 0; i < n; i++) maxDegree = std::max(maxDegree, degree[i]);
    
    std::vector<std::vector<int>> buckets(maxDegree + 1);
    for (int i = 0; i < n; i++) buckets[degree[i]].push_back(i);
    
    for (int k = 0; k <= maxDegree; k++) {
        for (int u : buckets[k]) {
            if (removed[u]) continue;
            removed[u] = true;
            core[u] = k;
            for (int v : adj[u]) {
                if (removed[v]) continue;
                degree[v]--;
                if (degree[v] >= 0) buckets[degree[v]].push_back(v);
            }
        }
    }
    
    return core;
}

int main() {
    int n = 9;
    std::vector<std::vector<int>> adj(n);
    auto addEdge = [&](int u, int v) { adj[u].push_back(v); adj[v].push_back(u); };
    addEdge(0, 1); addEdge(1, 2); addEdge(2, 0);
    addEdge(1, 3); addEdge(3, 4); addEdge(4, 5); addEdge(5, 3);
    addEdge(4, 6); addEdge(6, 7); addEdge(7, 8); addEdge(8, 6);
    
    auto core = kCoreDecomposition(n, adj);
    std::cout << "K-core values:\n";
    for (int i = 0; i < n; i++)
        std::cout << "  Vertex " << i << ": core = " << core[i] << "\n";
    
    return 0;
}
```

---

## 111.2 Transitive Closure

Floyd-Warshall variant: `reach[i][j] = 1` if there's a path from i to j.

```cpp
#include <iostream>
#include <vector>

std::vector<std::vector<bool>> transitiveClosure(int n, 
    const std::vector<std::vector<int>>& adj) {
    std::vector<std::vector<bool>> reach(n, std::vector<bool>(n, false));
    for (int i = 0; i < n; i++) {
        reach[i][i] = true;
        for (int j : adj[i]) reach[i][j] = true;
    }
    for (int k = 0; k < n; k++)
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++)
                reach[i][j] = reach[i][j] || (reach[i][k] && reach[k][j]);
    return reach;
}

int main() {
    std::vector<std::vector<int>> adj = {{1}, {2}, {0, 3}, {}};
    auto reach = transitiveClosure(4, adj);
    std::cout << "Transitive closure:\n";
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++)
            std::cout << reach[i][j] << " ";
        std::cout << "\n";
    }
    return 0;
}
```

---

## Summary

| Algorithm | Time | Application |
|---|---|---|
| K-Core | O(V + E) | Community detection, degeneracy |
| Transitive Closure | O(V³) | Reachability queries |
| Transitive Reduction | O(V³) | Minimal DAG representation |

---

## 111.3 Minimum Path Cover

Find the minimum number of vertex-disjoint paths that cover all vertices of a DAG.

**Reduction**: Transform to bipartite matching.
- Create bipartite graph: left copy and right copy of vertices
- Add edge (u_left, v_right) for each edge (u, v) in DAG
- Min path cover = n - max matching

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// Simplified: min path cover in DAG via bipartite matching
int minPathCover(int n, const std::vector<std::pair<int,int>>& edges) {
    // Build bipartite graph
    std::vector<std::vector<int>> adj(n);
    for (auto& [u, v] : edges) adj[u].push_back(v);
    
    // Greedy matching (for demo; use Hopcroft-Karp for optimal)
    std::vector<int> match(n, -1);
    int matching = 0;
    for (int u = 0; u < n; u++) {
        for (int v : adj[u]) {
            if (match[v] == -1) {
                match[v] = u;
                matching++;
                break;
            }
        }
    }
    
    return n - matching;
}

int main() {
    // DAG: 0->1, 0->2, 1->3, 2->3
    int n = 4;
    std::vector<std::pair<int,int>> edges = {{0,1}, {0,2}, {1,3}, {2,3}};
    std::cout << "Min path cover: " << minPathCover(n, edges) << "\n"; // 2
    return 0;
}
```
