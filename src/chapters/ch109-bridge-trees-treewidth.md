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

## 109.2 Treewidth

A graph has treewidth k if it can be decomposed into a tree of bags, each containing at most k+1 vertices, such that for every edge, both endpoints appear in some bag.

**Key insight**: Many NP-hard problems become polynomial on bounded-treewidth graphs using tree DP on the decomposition.

**Examples**: Trees have treewidth 1, cycles have treewidth 2, Kn has treewidth n-1.

```cpp
#include <iostream>
#include <vector>

// Check if graph is a tree (treewidth 1)
bool isTree(int n, const std::vector<std::vector<int>>& adj) {
    std::vector<bool> visited(n, false);
    std::vector<int> parent(n, -1);
    std::vector<int> stack = {0};
    visited[0] = true;
    int edges = 0;
    while (!stack.empty()) {
        int u = stack.back(); stack.pop();
        for (int v : adj[u]) {
            edges++;
            if (!visited[v]) { visited[v] = true; parent[v] = u; stack.push_back(v); }
            else if (v != parent[u]) return false;
        }
    }
    for (bool v : visited) if (!v) return false;
    return edges / 2 == n - 1;
}

int main() {
    std::vector<std::vector<int>> adj(4);
    adj[0] = {1, 2}; adj[1] = {0, 3}; adj[2] = {0}; adj[3] = {1};
    std::cout << "Is tree: " << isTree(4, adj) << "
";
    return 0;
}
```

---

## Summary

| Structure | Build | Key Property |
|---|---|---|
| Bridge tree | O(V+E) | Tree of 2-edge-connected components |
| Tree decomposition | NP-hard to find optimal | Enables DP on graphs |

---

## 109.3 Chordal Graphs

A graph is chordal if every cycle of length >= 4 has a chord (edge connecting non-adjacent vertices).

**Properties**:
- Perfect elimination ordering exists
- Can be recognized in O(V + E) using Maximum Cardinality Search
- Many NP-hard problems become polynomial on chordal graphs

```cpp
#include <iostream>
#include <vector>
#include <set>

// Maximum Cardinality Search for chordal graph recognition
std::vector<int> mcs(const std::vector<std::vector<int>>& adj) {
    int n = adj.size();
    std::vector<int> order(n, -1), weight(n, 0);
    std::set<int> remaining;
    for (int i = 0; i < n; i++) remaining.insert(i);
    
    for (int i = n - 1; i >= 0; i--) {
        int best = -1, bestW = -1;
        for (int v : remaining)
            if (weight[v] > bestW) { bestW = weight[v]; best = v; }
        order[i] = best;
        remaining.erase(best);
        for (int v : adj[best]) weight[v]++;
    }
    return order;
}

int main() {
    std::vector<std::vector<int>> adj(4);
    adj[0] = {1, 2}; adj[1] = {0, 2, 3}; adj[2] = {0, 1, 3}; adj[3] = {1, 2};
    auto order = mcs(adj);
    std::cout << "MCS order: ";
    for (int v : order) std::cout << v << " ";
    std::cout << "\n";
    return 0;
}
```
## 109.4 Dynamic Graph Connectivity (Overview)

| Type | Operation | Time |
|---|---|---|
| Incremental | Add edges only | O(α(n)) per op |
| Decremental | Remove edges only | O(α(n)) amortized |
| Fully Dynamic | Add + remove | O(√n) amortized |

**Technique**: ETT (Euler Tour Tree) for forests, link-cut trees for trees.

---

### Treewidth Example

A tree has treewidth 1. A cycle has treewidth 2. A complete graph Kn has treewidth n-1.

```cpp
#include <iostream>
#include <vector>

// Treewidth-related: Check if graph is a tree (treewidth 1)
bool isTree(int n, const std::vector<std::vector<int>>& adj) {
    if (adj.empty()) return true;
    std::vector<bool> visited(n, false);
    std::vector<int> parent(n, -1);
    
    // BFS from node 0
    std::vector<int> stack = {0};
    visited[0] = true;
    int edges = 0;
    
    while (!stack.empty()) {
        int u = stack.back(); stack.pop();
        for (int v : adj[u]) {
            edges++;
            if (!visited[v]) {
                visited[v] = true;
                parent[v] = u;
                stack.push_back(v);
            } else if (v != parent[u]) {
                return false; // Cycle found
            }
        }
    }
    
    // Check connectivity and edge count
    for (bool v : visited) if (!v) return false;
    return edges / 2 == n - 1; // Tree has exactly n-1 edges
}

int main() {
    // Tree: 0-1, 0-2, 1-3
    std::vector<std::vector<int>> adj(4);
    adj[0] = {1, 2}; adj[1] = {0, 3}; adj[2] = {0}; adj[3] = {1};
    std::cout << "Is tree: " << isTree(4, adj) << "\\n";
    
    // Cycle: 0-1, 1-2, 2-0
    std::vector<std::vector<int>> adj2(3);
    adj2[0] = {1, 2}; adj2[1] = {0, 2}; adj2[2] = {0, 1};
    std::cout << "Is tree: " << isTree(3, adj2) << "\\n";
    
    return 0;
}
```

### Chordal Graph Recognition

A graph is chordal iff it has a perfect elimination ordering. Can be found using Maximum Cardinality Search (MCS).

### Dynamic Connectivity with Link-Cut Trees

Link-Cut Trees maintain connectivity in a dynamic forest with O(log n) per operation:
- `link(u, v)`: Add edge between trees
- `cut(u, v)`: Remove edge
- `connected(u, v)`: Check connectivity
- `findRoot(u)`: Find root of tree containing u
