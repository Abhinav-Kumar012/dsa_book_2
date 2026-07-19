# Chapter 109: Bridge Trees and Treewidth

## Prerequisites
- SCC, bridges, tree decomposition

## Interview Frequency: ★★

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Bridge tree | ★★ | Medium | Compress 2-edge-connected components |
| Treewidth | ★ | Hard | Graph width parameter |

---

## 109.1 Bridge Tree

Compress each 2-edge-connected component into a single node. The resulting structure is a tree (since bridges connect components).

```cpp
#include <iostream>
#include <vector>
#include <set>

class BridgeTree {
    int n, timer;
    std::vector<std::vector<int>> adj;
    std::vector<int> tin, low, comp;
    std::vector<std::pair<int,int>> bridges;
    std::vector<bool> visited;
    
    void findBridges(int u, int p) {
        visited[u] = true;
        tin[u] = low[u] = timer++;
        for (int v : adj[u]) {
            if (v == p) continue;
            if (visited[v]) {
                low[u] = std::min(low[u], tin[v]);
            } else {
                findBridges(v, u);
                low[u] = std::min(low[u], low[v]);
                if (low[v] > tin[u]) bridges.push_back({u, v});
            }
        }
    }
    
    void assignComponent(int u, int c) {
        comp[u] = c;
        for (int v : adj[u])
            if (comp[v] == -1) assignComponent(v, c);
    }
    
public:
    BridgeTree(int n) : n(n), timer(0), adj(n), tin(n), low(n), comp(n, -1), visited(n, false) {}
    void addEdge(int u, int v) { adj[u].push_back(v); adj[v].push_back(u); }
    
    int build() {
        for (int i = 0; i < n; i++)
            if (!visited[i]) findBridges(i, -1);
        
        // Remove bridges from adjacency
        std::set<std::pair<int,int>> bridgeSet(bridges.begin(), bridges.end());
        std::vector<std::vector<int>> adjNoBridges(n);
        for (int u = 0; u < n; u++)
            for (int v : adj[u])
                if (!bridgeSet.count({u, v}) && !bridgeSet.count({v, u}))
                    adjNoBridges[u].push_back(v);
        
        // Assign components
        int numComponents = 0;
        for (int i = 0; i < n; i++)
            if (comp[i] == -1) assignComponent(i, numComponents++);
        
        return numComponents;
    }
    
    std::vector<int> getComponents() { return comp; }
    std::vector<std::pair<int,int>> getBridges() { return bridges; }
};

int main() {
    BridgeTree bt(7);
    bt.addEdge(0, 1); bt.addEdge(1, 2); bt.addEdge(2, 0);
    bt.addEdge(1, 3); bt.addEdge(3, 4); bt.addEdge(4, 5); bt.addEdge(5, 3);
    bt.addEdge(3, 6);
    
    int components = bt.build();
    std::cout << "Components: " << components << "\n";
    std::cout << "Bridges:\n";
    for (auto& [u, v] : bt.getBridges())
        std::cout << "  " << u << " - " << v << "\n";
    
    return 0;
}
```

---

## 109.2 Treewidth (Overview)

A graph has treewidth k if it can be decomposed into a tree of bags, each containing at most k+1 vertices, such that for every edge, both endpoints appear in some bag.

**Key insight**: Many NP-hard problems become polynomial on bounded-treewidth graphs.

---

## Summary

| Structure | Build | Key Property |
|---|---|---|
| Bridge tree | O(V+E) | Tree of 2-edge-connected components |
| Tree decomposition | NP-hard to find optimal | Enables DP on graphs |

---

## 109.3 Chordal Graphs (Overview)

A graph is chordal if every cycle of length ≥ 4 has a chord (edge connecting non-adjacent vertices).

**Properties**:
- Perfect elimination ordering exists
- Can be recognized in O(V + E) using Maximum Cardinality Search
- Many NP-hard problems become polynomial on chordal graphs

---

## 109.4 Dynamic Graph Connectivity (Overview)

| Type | Operation | Time |
|---|---|---|
| Incremental | Add edges only | O(α(n)) per op |
| Decremental | Remove edges only | O(α(n)) amortized |
| Fully Dynamic | Add + remove | O(√n) amortized |

**Technique**: ETT (Euler Tour Tree) for forests, link-cut trees for trees.
