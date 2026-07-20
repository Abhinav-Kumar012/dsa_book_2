# Chapter 81: SCC, Bridges, and Articulation Points

## Prerequisites

- DFS
- Graph fundamentals

## Interview Frequency: ★★★

Strongly Connected Components, bridges, and articulation points are fundamental graph concepts. **Google** and **Amazon** test these for network reliability problems.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| SCC (Kosaraju) | ★★★ | Medium | Two-pass DFS |
| SCC (Tarjan) | ★★★ | Medium | Single-pass DFS |
| Bridges | ★★★ | Medium | Critical edges |
| Articulation points | ★★★ | Medium | Critical vertices |

---

## 81.1 Strongly Connected Components (Kosaraju's Algorithm)

1. DFS to get finish order
2. Transpose the graph
3. DFS on transposed graph in reverse finish order

```cpp
#include <iostream>
#include <vector>
#include <stack>
#include <algorithm>

class KosarajuSCC {
    int n;
    std::vector<std::vector<int>> adj, rev;
    
    void dfs1(int u, std::vector<bool>& visited, std::stack<int>& order) {
        visited[u] = true;
        for (int v : adj[u])
            if (!visited[v]) dfs1(v, visited, order);
        order.push(u);
    }
    
    void dfs2(int u, std::vector<bool>& visited, std::vector<int>& component) {
        visited[u] = true;
        component.push_back(u);
        for (int v : rev[u])
            if (!visited[v]) dfs2(v, visited, component);
    }
    
public:
    KosarajuSCC(int n) : n(n), adj(n), rev(n) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
        rev[v].push_back(u);
    }
    
    std::vector<std::vector<int>> findSCCs() {
        std::vector<bool> visited(n, false);
        std::stack<int> order;
        
        for (int i = 0; i < n; i++)
            if (!visited[i]) dfs1(i, visited, order);
        
        std::fill(visited.begin(), visited.end(), false);
        std::vector<std::vector<int>> sccs;
        
        while (!order.empty()) {
            int u = order.top(); order.pop();
            if (!visited[u]) {
                std::vector<int> component;
                dfs2(u, visited, component);
                sccs.push_back(component);
            }
        }
        
        return sccs;
    }
};

int main() {
    KosarajuSCC g(8);
    g.addEdge(0, 1); g.addEdge(1, 2); g.addEdge(2, 0);
    g.addEdge(2, 3); g.addEdge(3, 4); g.addEdge(4, 5);
    g.addEdge(5, 3); g.addEdge(6, 5); g.addEdge(6, 7);
    
    auto sccs = g.findSCCs();
    std::cout << "Strongly Connected Components:\n";
    for (auto& scc : sccs) {
        std::cout << "  {";
        for (int v : scc) std::cout << v << " ";
        std::cout << "}\n";
    }
    
    return 0;
}
```

---

## 81.2 Bridges

A **bridge** is an edge whose removal disconnects the graph.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

class BridgeFinder {
    int n, timer;
    std::vector<std::vector<int>> adj;
    std::vector<int> tin, low;
    std::vector<bool> visited;
    std::vector<std::pair<int,int>> bridges;
    
    void dfs(int u, int p) {
        visited[u] = true;
        tin[u] = low[u] = timer++;
        
        for (int v : adj[u]) {
            if (v == p) continue;
            if (visited[v]) {
                low[u] = std::min(low[u], tin[v]);
            } else {
                dfs(v, u);
                low[u] = std::min(low[u], low[v]);
                if (low[v] > tin[u]) {
                    bridges.push_back({u, v});
                }
            }
        }
    }
    
public:
    BridgeFinder(int n) : n(n), timer(0), adj(n), tin(n), low(n), visited(n, false) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    std::vector<std::pair<int,int>> findBridges() {
        for (int i = 0; i < n; i++)
            if (!visited[i]) dfs(i, -1);
        return bridges;
    }
};

int main() {
    BridgeFinder g(5);
    g.addEdge(0, 1); g.addEdge(1, 2); g.addEdge(2, 0);
    g.addEdge(1, 3); g.addEdge(3, 4);
    
    auto bridges = g.findBridges();
    std::cout << "Bridges:\n";
    for (auto& [u, v] : bridges)
        std::cout << "  " << u << " - " << v << "\n";
    
    return 0;
}
```

---

## 81.3 Articulation Points

An **articulation point** is a vertex whose removal disconnects the graph.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <set>

class ArticulationFinder {
    int n, timer;
    std::vector<std::vector<int>> adj;
    std::vector<int> tin, low;
    std::vector<bool> visited;
    std::set<int> articulationPoints;
    
    void dfs(int u, int p) {
        visited[u] = true;
        tin[u] = low[u] = timer++;
        int children = 0;
        
        for (int v : adj[u]) {
            if (v == p) continue;
            if (visited[v]) {
                low[u] = std::min(low[u], tin[v]);
            } else {
                dfs(v, u);
                low[u] = std::min(low[u], low[v]);
                if (low[v] >= tin[u] && p != -1)
                    articulationPoints.insert(u);
                children++;
            }
        }
        
        if (p == -1 && children > 1)
            articulationPoints.insert(u);
    }
    
public:
    ArticulationFinder(int n) : n(n), timer(0), adj(n), tin(n), low(n), 
                                 visited(n, false) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    std::set<int> findArticulationPoints() {
        for (int i = 0; i < n; i++)
            if (!visited[i]) dfs(i, -1);
        return articulationPoints;
    }
};

int main() {
    ArticulationFinder g(7);
    g.addEdge(0, 1); g.addEdge(1, 2); g.addEdge(2, 0);
    g.addEdge(1, 3); g.addEdge(1, 4); g.addEdge(3, 4);
    g.addEdge(1, 5); g.addEdge(5, 6);
    
    auto aps = g.findArticulationPoints();
    std::cout << "Articulation Points: ";
    for (int v : aps) std::cout << v << " ";
    std::cout << "\n";
    
    return 0;
}
```

---

## Summary

| Concept | Definition | Algorithm | Time |
|---|---|---|---|
| SCC | Maximal strongly connected subgraph | Kosaraju/Tarjan | O(V+E) |
| Bridge | Edge whose removal disconnects | DFS with low/tin | O(V+E) |
| Articulation Point | Vertex whose removal disconnects | DFS with low/tin | O(V+E) |

---



---

## Interview Questions

### Q1: What is a Strongly Connected Component?
**Answer**: An SCC is a maximal subgraph where every vertex is reachable from every other vertex. In other words, for any two vertices u and v in the SCC, there exists a path from u to v and from v to u. Directed graphs can be decomposed into SCCs, forming a DAG when each SCC is contracted to a single node.

### Q2: Compare Kosaraju's and Tarjan's SCC algorithms.
**Answer**: Both run in O(V+E). Kosaraju does two DFS passes (forward then on transposed graph) and is conceptually simpler. Tarjan does a single DFS pass using a stack and low-link values, making it faster in practice (one pass, better cache behavior). Both produce the same result.

### Q3: How do you find bridges, and what's the key condition?
**Answer**: Use DFS with `tin[u]` (discovery time) and `low[u]` (lowest discovery time reachable from subtree of u). An edge (u,v) is a bridge if `low[v] > tin[u]` — meaning v's subtree cannot reach u or any ancestor of u without using edge (u,v).

### Q4: What's the difference between a bridge and an articulation point?
**Answer**: A bridge is an **edge** whose removal disconnects the graph. An articulation point is a **vertex** whose removal disconnects the graph. A vertex u is an articulation point if it has a child v where `low[v] >= tin[u]`, or if u is the root of the DFS tree and has more than one child.

### Q5: How do SCCs relate to 2-SAT?
**Answer**: In 2-SAT, construct an implication graph. If variable x and ¬x are in the same SCC, the formula is unsatisfiable. Otherwise, a topological order of the SCC condensation graph gives a valid assignment: process SCCs in reverse topological order, assigning false to any unassigned literal. This runs in O(V+E).

---

## Exercises

1. **Tarjan's Algorithm**: Implement Tarjan's SCC algorithm. Compare its performance with Kosaraju's on the same graph instances.

2. **Bridge Count in a Tree**: Prove that every edge in a tree is a bridge. Then write an algorithm that counts bridges in a general graph.

3. **2-Edge-Connected Components**: Modify the bridge-finding algorithm to output the 2-edge-connected components (maximal subgraphs with no bridges).

4. **SCC Condensation DAG**: After finding SCCs, build the condensation DAG (each SCC becomes a node). Implement topological sort on it and verify it matches the expected order.

5. **Network Reliability**: Given an undirected graph representing a network, find all critical connections (bridges). If you could add one edge to the network, which edge would maximize reliability (minimize the number of bridges)?

---

## See Also

- [Chapter 23: Depth-First Search](ch23-dfs.md) — SCC and bridge-finding algorithms are built on DFS with timestamps and low-link values.
- [Chapter 25: Topological Sort](ch25-topological-sort.md) — SCC condensation produces a DAG; topological sort on the condensation graph enables further analysis.
- [Chapter 22: Graph Fundamentals](ch22-graph-fundamentals.md) — Prerequisite: graph representations, connectivity, and basic DFS.
- [Chapter 28: Advanced Graphs](ch28-advanced-graphs.md) — Biconnected components, ear decomposition, and other advanced connectivity concepts.
- [Chapter 109: Bridge Trees and Treewidth](ch109-bridge-trees-treewidth.md) — Bridge trees compress 2-edge-connected components; related to the bridge-finding algorithms here.
- [Chapter 17: Disjoint Set Union](ch17-dsu.md) — DSU can maintain connectivity information and is sometimes used alongside SCC algorithms.
- [Chapter 29: Network Flow](ch29-network-flow.md) — Flow algorithms use graph connectivity; SCC decomposition is useful in flow network analysis.
- [Chapter 24: Breadth-First Search](ch24-bfs.md) — BFS-based approaches for connectivity and bipartiteness testing complement DFS-based SCC methods.
