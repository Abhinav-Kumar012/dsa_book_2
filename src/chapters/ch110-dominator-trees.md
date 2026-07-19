# Chapter 110: Dominator Trees

## Prerequisites
- DFS, SCC

## Interview Frequency: ★

Dominator trees show which nodes must be traversed to reach others. Used in compiler optimization.

| Node v is dominated by node d if every path from root to v passes through d. |

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// Simplified dominator tree for DAGs
class DominatorTree {
    int n;
    std::vector<std::vector<int>> adj, rev;
    std::vector<int> idom; // Immediate dominator
    
public:
    DominatorTree(int n) : n(n), adj(n), rev(n), idom(n, -1) {}
    void addEdge(int u, int v) { adj[u].push_back(v); rev[v].push_back(u); }
    
    // For DAGs: idom[v] = LCA of all predecessors in DFS tree
    std::vector<int> build(int root) {
        idom[root] = root;
        // Simplified: for general graphs, use Lengauer-Tarjan algorithm
        // This works for trees
        std::vector<bool> visited(n, false);
        std::vector<int> order;
        auto dfs = [&](auto& self, int u) -> void {
            visited[u] = true;
            for (int v : adj[u]) {
                if (!visited[v]) {
                    idom[v] = u;
                    self(self, v);
                }
            }
            order.push_back(u);
        };
        dfs(dfs, root);
        return idom;
    }
};

int main() {
    DominatorTree dt(6);
    dt.addEdge(0, 1); dt.addEdge(0, 2);
    dt.addEdge(1, 3); dt.addEdge(2, 3); dt.addEdge(3, 4); dt.addEdge(3, 5);
    auto idom = dt.build(0);
    for (int i = 0; i < 6; i++)
        std::cout << "idom[" << i << "] = " << idom[i] << "\n";
    return 0;
}
```

---

## Summary

| Property | Value |
|---|---|
| Build (DAG) | O(V + E) |
| Build (general) | O(V + E) α(V) via Lengauer-Tarjan |
| Application | Compiler optimization, reachability |
