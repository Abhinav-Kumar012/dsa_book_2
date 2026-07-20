# Chapter 29: Network Flow

Network flow is one of the most elegant and powerful areas of graph theory. From its foundation — the max-flow problem — spring solutions to bipartite matching, minimum cuts, circulation problems, and countless optimization tasks. Despite its theoretical depth, the core algorithms are surprisingly implementable and appear in advanced interviews and competitive programming.

In this chapter, we build from the fundamentals of flow networks through Ford-Fulkerson, Edmonds-Karp, and Dinic's algorithm, and explore the rich landscape of applications.

---

## 29.1 Flow Networks

### Definition

A **flow network** is a directed graph $G = (V, E)$ with:

- **Source** $s$: vertex with no incoming edges (or we designate it).
- **Sink** $t$: vertex with no outgoing edges (or we designate it).
- **Capacity** $c(e) \geq 0$ for each edge $e$.
- **Flow** $f(e)$ on each edge, satisfying:
  1. **Capacity constraint:** $0 \leq f(e) \leq c(e)$ for all edges.
  2. **Flow conservation:** For every vertex $v \neq s, t$: total flow in = total flow out.

$$\sum_{u: (u,v) \in E} f(u,v) = \sum_{w: (v,w) \in E} f(v,w) \quad \forall v \neq s, t$$

### Value of a Flow

The **value** of a flow $f$ is the total flow out of the source (or equivalently, into the sink):

$$|f| = \sum_{v: (s,v) \in E} f(s,v) - \sum_{u: (u,s) \in E} f(u,s)$$

### Example

```
        s ----(10)---> A ----(10)---> t
        |              ^              
       (10)            | (5)          
        v              |              
        B ----(10)-----+              
```

Maximum flow from $s$ to $t$: 15 (10 via $s \to A \to t$, 5 via $s \to B \to A \to t$).

### Residual Graph

The **residual graph** $G_f$ shows how much more flow we can push through each edge:

- **Forward edge** $(u, v)$: residual capacity = $c(u,v) - f(u,v)$. We can push more flow.
- **Backward edge** $(v, u)$: residual capacity = $f(u,v)$. We can "undo" flow by pushing flow in reverse.

```cpp
struct FlowEdge {
    int v;       // destination
    long long cap; // residual capacity
    int rev;     // index of reverse edge in adj[v]
};

class FlowNetwork {
public:
    int V;
    std::vector<std::vector<FlowEdge>> adj;

    FlowNetwork(int V) : V(V), adj(V) {}

    void addEdge(int u, int v, long long cap) {
        adj[u].push_back({v, cap, (int)adj[v].size()});
        adj[v].push_back({u, 0, (int)adj[u].size() - 1});
        // For undirected: change the second cap from 0 to cap
    }
};
```

---

## 29.2 Max-Flow Min-Cut Theorem

### Statement

**Max-Flow Min-Cut Theorem (Ford-Fulkerson, 1956):** In any flow network, the maximum flow value equals the minimum cut capacity.

### Cut

A **cut** $(S, T)$ partitions $V$ into two sets with $s \in S$ and $t \in T$. The **capacity** of the cut is:

$$c(S, T) = \sum_{u \in S, v \in T, (u,v) \in E} c(u,v)$$

### Intuition

Think of the network as pipes carrying water. A cut represents a set of pipes you'd sever to stop all flow from $s$ to $t$. The minimum cut is the cheapest set of pipes to sever. The theorem says you can't push more water than the weakest bottleneck.

### Proof Sketch

1. **Weak duality:** Any flow ≤ any cut capacity (flow through a cut ≤ cut capacity).
2. **Strong duality:** When there are no augmenting paths (residual graph has no $s \to t$ path), the flow equals the cut capacity of the cut defined by reachable vertices from $s$ in the residual graph.

---

## 29.3 Ford-Fulkerson Method

### Idea

Repeatedly find an **augmenting path** (a path from $s$ to $t$ in the residual graph) and push flow along it. When no augmenting path exists, the flow is maximum.

### Algorithm

1. Initialize all flows to 0.
2. While there exists an augmenting path $P$ from $s$ to $t$ in the residual graph:
   a. Find the bottleneck capacity: $b = \min_{e \in P} c_f(e)$.
   b. Augment: for each edge in $P$, increase flow by $b$ (forward) or decrease by $b$ (backward).
3. Return the total flow.

### Implementation (DFS-based)

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>

class FordFulkerson {
public:
    struct Edge {
        int v;
        long long cap;
        int rev;
    };

    int V;
    std::vector<std::vector<Edge>> adj;

    FordFulkerson(int V) : V(V), adj(V) {}

    void addEdge(int u, int v, long long cap) {
        adj[u].push_back({v, cap, (int)adj[v].size()});
        adj[v].push_back({u, 0, (int)adj[u].size() - 1});
    }

    long long dfs(int u, int t, long long flow, std::vector<bool>& visited) {
        if (u == t) return flow;
        visited[u] = true;

        for (auto& e : adj[u]) {
            if (!visited[e.v] && e.cap > 0) {
                long long pushed = dfs(e.v, t, std::min(flow, e.cap), visited);
                if (pushed > 0) {
                    e.cap -= pushed;
                    adj[e.v][e.rev].cap += pushed;
                    return pushed;
                }
            }
        }
        return 0;
    }

    long long maxFlow(int s, int t) {
        long long totalFlow = 0;
        while (true) {
            std::vector<bool> visited(V, false);
            long long pushed = dfs(s, t, LLONG_MAX, visited);
            if (pushed == 0) break;
            totalFlow += pushed;
        }
        return totalFlow;
    }
};

int main() {
    FordFulkerson g(6);
    // s=0, A=1, B=2, C=3, D=4, t=5
    g.addEdge(0, 1, 10);
    g.addEdge(0, 2, 10);
    g.addEdge(1, 2, 2);
    g.addEdge(1, 3, 8);
    g.addEdge(2, 4, 9);
    g.addEdge(3, 5, 10);
    g.addEdge(4, 3, 6);
    g.addEdge(4, 5, 10);

    std::cout << "Maximum flow: " << g.maxFlow(0, 5) << "\n";
}
```

**Time Complexity:** $O(E \cdot |f^*|)$ where $|f^*|$ is the max flow value. This can be very slow if capacities are large (not polynomial).

### Dry Run

Network: $s \to A(10), s \to B(10), A \to B(2), A \to C(8), B \to D(9), C \to t(10), D \to C(6), D \to t(10)$.

| Iteration | Augmenting Path | Bottleneck | Total Flow |
|-----------|----------------|------------|------------|
| 1 | $s \to A \to C \to t$ | 8 | 8 |
| 2 | $s \to A \to B \to D \to t$ | 2 | 10 |
| 3 | $s \to B \to D \to t$ | 9 | 19 |
| 4 | $s \to A \to C \to t$ (via D→C) | 2 | 21 |

Maximum flow: **21**.

---

## 29.4 Edmonds-Karp Algorithm

### Idea

Edmonds-Karp is Ford-Fulkerson but always finds the augmenting path with the **fewest edges** using BFS. This guarantees polynomial time.

### Complete Implementation

```cpp
#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>
#include <climits>

class EdmondsKarp {
public:
    struct Edge {
        int v;
        long long cap;
        int rev;
    };

    int V;
    std::vector<std::vector<Edge>> adj;

    EdmondsKarp(int V) : V(V), adj(V) {}

    void addEdge(int u, int v, long long cap) {
        adj[u].push_back({v, cap, (int)adj[v].size()});
        adj[v].push_back({u, 0, (int)adj[u].size() - 1});
    }

    // BFS to find shortest augmenting path
    long long bfs(int s, int t, std::vector<int>& parent,
                  std::vector<int>& parentEdge) {
        std::fill(parent.begin(), parent.end(), -1);
        parent[s] = s;
        std::queue<std::pair<int, long long>> q;
        q.push({s, LLONG_MAX});

        while (!q.empty()) {
            auto [u, flow] = q.front();
            q.pop();
            for (int i = 0; i < (int)adj[u].size(); ++i) {
                auto& e = adj[u][i];
                if (parent[e.v] == -1 && e.cap > 0) {
                    parent[e.v] = u;
                    parentEdge[e.v] = i;
                    long long newFlow = std::min(flow, e.cap);
                    if (e.v == t) return newFlow;
                    q.push({e.v, newFlow});
                }
            }
        }
        return 0;
    }

    long long maxFlow(int s, int t) {
        long long totalFlow = 0;
        std::vector<int> parent(V), parentEdge(V);
        long long pushed;

        while ((pushed = bfs(s, t, parent, parentEdge)) > 0) {
            totalFlow += pushed;
            int cur = t;
            while (cur != s) {
                int prev = parent[cur];
                int idx = parentEdge[cur];
                adj[prev][idx].cap -= pushed;
                adj[cur][adj[prev][idx].rev].cap += pushed;
                cur = prev;
            }
        }
        return totalFlow;
    }

    // Find the minimum cut after computing max flow
    std::pair<std::vector<int>, std::vector<int>> minCut(int s, int t) {
        maxFlow(s, t);

        // BFS in residual graph to find reachable vertices from s
        std::vector<bool> visited(V, false);
        std::queue<int> q;
        visited[s] = true;
        q.push(s);
        while (!q.empty()) {
            int u = q.front(); q.pop();
            for (auto& e : adj[u]) {
                if (!visited[e.v] && e.cap > 0) {
                    visited[e.v] = true;
                    q.push(e.v);
                }
            }
        }

        std::vector<int> S, T;
        for (int i = 0; i < V; ++i) {
            if (visited[i]) S.push_back(i);
            else T.push_back(i);
        }
        return {S, T};
    }
};

int main() {
    EdmondsKarp g(6);
    g.addEdge(0, 1, 16);
    g.addEdge(0, 2, 13);
    g.addEdge(1, 2, 10);
    g.addEdge(1, 3, 12);
    g.addEdge(2, 1, 4);
    g.addEdge(2, 4, 14);
    g.addEdge(3, 2, 9);
    g.addEdge(3, 5, 20);
    g.addEdge(4, 3, 7);
    g.addEdge(4, 5, 4);

    std::cout << "Maximum flow: " << g.maxFlow(0, 5) << "\n";

    auto [S, T] = g.minCut(0, 5);
    std::cout << "Min cut S: ";
    for (int v : S) std::cout << v << " ";
    std::cout << "\nMin cut T: ";
    for (int v : T) std::cout << v << " ";
    std::cout << "\n";
}
```

**Time Complexity:** $O(VE^2)$ — each BFS is $O(E)$, and there are at most $O(VE)$ augmentations.

**Why $O(VE)$ augmentations?** Each augmentation increases the shortest path length. The distance from $s$ to $t$ can increase at most $V-1$ times. Each vertex's distance increases at most $V$ times. So the total number of augmentations is $O(VE)$.

---

## 29.5 Dinic's Algorithm

### Idea

Dinic's algorithm improves on Edmonds-Karp by finding **blocking flows** on **level graphs**:

1. Build a **level graph** using BFS: `level[v]` = shortest distance from $s$ to $v$ in the residual graph.
2. Find a **blocking flow**: a flow where every $s \to t$ path in the level graph has at least one saturated edge.
3. Repeat until no $s \to t$ path exists.

The key insight is using **DFS with current-arc optimization** to find blocking flows efficiently.

### Complete Implementation

```cpp
#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>
#include <climits>

class Dinic {
public:
    struct Edge {
        int v;
        long long cap;
        int rev;
    };

    int V;
    std::vector<std::vector<Edge>> adj;
    std::vector<int> level;
    std::vector<int> ptr; // current-arc optimization

    Dinic(int V) : V(V), adj(V), level(V), ptr(V) {}

    void addEdge(int u, int v, long long cap) {
        adj[u].push_back({v, cap, (int)adj[v].size()});
        adj[v].push_back({u, 0, (int)adj[u].size() - 1});
    }

    bool bfs(int s, int t) {
        std::fill(level.begin(), level.end(), -1);
        level[s] = 0;
        std::queue<int> q;
        q.push(s);

        while (!q.empty()) {
            int u = q.front();
            q.pop();
            for (auto& e : adj[u]) {
                if (level[e.v] == -1 && e.cap > 0) {
                    level[e.v] = level[u] + 1;
                    q.push(e.v);
                }
            }
        }
        return level[t] != -1;
    }

    long long dfs(int u, int t, long long pushed) {
        if (u == t) return pushed;
        for (int& cid = ptr[u]; cid < (int)adj[u].size(); ++cid) {
            auto& e = adj[u][cid];
            if (level[e.v] == level[u] + 1 && e.cap > 0) {
                long long tr = dfs(e.v, t, std::min(pushed, e.cap));
                if (tr > 0) {
                    e.cap -= tr;
                    adj[e.v][e.rev].cap += tr;
                    return tr;
                }
            }
        }
        return 0;
    }

    long long maxFlow(int s, int t) {
        long long totalFlow = 0;
        while (bfs(s, t)) {
            std::fill(ptr.begin(), ptr.end(), 0);
            while (long long pushed = dfs(s, t, LLONG_MAX)) {
                totalFlow += pushed;
            }
        }
        return totalFlow;
    }
};

int main() {
    Dinic g(6);
    g.addEdge(0, 1, 16);
    g.addEdge(0, 2, 13);
    g.addEdge(1, 2, 10);
    g.addEdge(1, 3, 12);
    g.addEdge(2, 1, 4);
    g.addEdge(2, 4, 14);
    g.addEdge(3, 2, 9);
    g.addEdge(3, 5, 20);
    g.addEdge(4, 3, 7);
    g.addEdge(4, 5, 4);

    std::cout << "Maximum flow (Dinic): " << g.maxFlow(0, 5) << "\n";
}
```

**Time Complexity:** $O(V^2 E)$ in general. For **unit capacity** graphs (all capacities 1): $O(E\sqrt{V})$.

### Why Dinic's Is Fast

- BFS builds the level graph in $O(E)$.
- DFS with current-arc optimization finds a blocking flow in $O(VE)$ (each edge is traversed at most once per phase, and each vertex's pointer only advances forward).
- There are at most $V$ phases (level of $t$ increases by at least 1 each phase).
- Total: $O(V \cdot VE) = O(V^2 E)$.

### Current-Arc Optimization

The `ptr[u]` array remembers which edge to try next for vertex $u`. Without it, DFS would repeatedly try edges that are already saturated, wasting time. With it, each edge is examined at most once per phase.

---

## 29.6 Minimum Cost Maximum Flow

### Problem

Each edge has both a **capacity** and a **cost** per unit of flow. Find a flow of maximum value that also minimizes the total cost:

$$\text{minimize} \sum_{(u,v) \in E} f(u,v) \cdot \text{cost}(u,v)$$

### Successive Shortest Paths Algorithm

1. Find the maximum flow (ignoring costs).
2. In the residual graph, find the shortest path from $s$ to $t$ by cost (using Bellman-Ford or SPFA for negative costs).
3. Augment along this cheapest path.
4. Repeat until no more augmenting paths.

**Optimization:** Use potentials (Johnson's reweighting) to avoid negative edges and use Dijkstra instead of Bellman-Ford.

### Implementation

```cpp
#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>
#include <climits>

class MinCostMaxFlow {
public:
    struct Edge {
        int v;
        long long cap, cost;
        int rev;
    };

    int V;
    std::vector<std::vector<Edge>> adj;

    MinCostMaxFlow(int V) : V(V), adj(V) {}

    void addEdge(int u, int v, long long cap, long long cost) {
        adj[u].push_back({v, cap, cost, (int)adj[v].size()});
        adj[v].push_back({u, 0, -cost, (int)adj[u].size() - 1});
    }

    // Returns {flow, cost}
    std::pair<long long, long long> solve(int s, int t) {
        long long totalFlow = 0, totalCost = 0;
        std::vector<long long> potential(V, 0); // Johnson's potentials

        while (true) {
            // Find shortest path by cost using Dijkstra with potentials
            std::vector<long long> dist(V, LLONG_MAX);
            std::vector<int> parent(V, -1), parentEdge(V, -1);
            std::vector<bool> inQueue(V, false);
            dist[s] = 0;

            // SPFA (works with negative costs)
            std::queue<int> q;
            q.push(s);
            inQueue[s] = true;

            while (!q.empty()) {
                int u = q.front();
                q.pop();
                inQueue[u] = false;
                for (int i = 0; i < (int)adj[u].size(); ++i) {
                    auto& e = adj[u][i];
                    long long newDist = dist[u] + e.cost;
                    if (e.cap > 0 && newDist < dist[e.v]) {
                        dist[e.v] = newDist;
                        parent[e.v] = u;
                        parentEdge[e.v] = i;
                        if (!inQueue[e.v]) {
                            q.push(e.v);
                            inQueue[e.v] = true;
                        }
                    }
                }
            }

            if (dist[t] == LLONG_MAX) break; // no more augmenting paths

            // Find bottleneck along the path
            long long flow = LLONG_MAX;
            for (int v = t; v != s; v = parent[v]) {
                int u = parent[v];
                int idx = parentEdge[v];
                flow = std::min(flow, adj[u][idx].cap);
            }

            // Augment
            for (int v = t; v != s; v = parent[v]) {
                int u = parent[v];
                int idx = parentEdge[v];
                adj[u][idx].cap -= flow;
                adj[v][adj[u][idx].rev].cap += flow;
            }

            totalFlow += flow;
            totalCost += flow * dist[t];
        }
        return {totalFlow, totalCost};
    }
};

int main() {
    MinCostMaxFlow g(4);
    // s=0, A=1, B=2, t=3
    g.addEdge(0, 1, 10, 2);  // s→A, cap=10, cost=2
    g.addEdge(0, 2, 10, 3);  // s→B, cap=10, cost=3
    g.addEdge(1, 2, 5, 1);   // A→B, cap=5, cost=1
    g.addEdge(1, 3, 10, 4);  // A→t, cap=10, cost=4
    g.addEdge(2, 3, 10, 2);  // B→t, cap=10, cost=2

    auto [flow, cost] = g.solve(0, 3);
    std::cout << "Max flow: " << flow << "\n";
    std::cout << "Min cost: " << cost << "\n";
}
```

**Time:** $O(VE \cdot \text{maxFlow})$ with SPFA. With Dijkstra + potentials: $O(VE \log V \cdot \text{maxFlow})$.

---

## 29.7 Applications

### Bipartite Matching

**Problem:** Given a bipartite graph with left set $L$ and right set $R$, find the maximum matching (maximum set of edges with no shared vertices).

**Reduction to max-flow:**
1. Add source $s$ connected to all vertices in $L$ with capacity 1.
2. Add all original edges from $L$ to $R$ with capacity 1.
3. Add edges from all vertices in $R$ to sink $t$ with capacity 1.
4. Max flow = max matching.

```cpp
#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>

class BipartiteMatching {
public:
    struct Edge {
        int v;
        long long cap;
        int rev;
    };

    int V;
    std::vector<std::vector<Edge>> adj;
    std::vector<int> level, ptr;

    BipartiteMatching(int V) : V(V), adj(V), level(V), ptr(V) {}

    void addEdge(int u, int v, long long cap) {
        adj[u].push_back({v, cap, (int)adj[v].size()});
        adj[v].push_back({u, 0, (int)adj[u].size() - 1});
    }

    bool bfs(int s, int t) {
        std::fill(level.begin(), level.end(), -1);
        level[s] = 0;
        std::queue<int> q;
        q.push(s);
        while (!q.empty()) {
            int u = q.front(); q.pop();
            for (auto& e : adj[u]) {
                if (level[e.v] == -1 && e.cap > 0) {
                    level[e.v] = level[u] + 1;
                    q.push(e.v);
                }
            }
        }
        return level[t] != -1;
    }

    long long dfs(int u, int t, long long pushed) {
        if (u == t) return pushed;
        for (int& cid = ptr[u]; cid < (int)adj[u].size(); ++cid) {
            auto& e = adj[u][cid];
            if (level[e.v] == level[u] + 1 && e.cap > 0) {
                long long tr = dfs(e.v, t, std::min(pushed, e.cap));
                if (tr > 0) {
                    e.cap -= tr;
                    adj[e.v][e.rev].cap += tr;
                    return tr;
                }
            }
        }
        return 0;
    }

    long long maxFlow(int s, int t) {
        long long total = 0;
        while (bfs(s, t)) {
            std::fill(ptr.begin(), ptr.end(), 0);
            while (long long pushed = dfs(s, t, 1LL << 60))
                total += pushed;
        }
        return total;
    }

    // Find maximum bipartite matching
    // L = {0, ..., nL-1}, R = {0, ..., nR-1}
    // s = nL + nR, t = nL + nR + 1
    static std::vector<std::pair<int, int>> findMatching(
        int nL, int nR, const std::vector<std::pair<int, int>>& edges) {

        int s = nL + nR, t = s + 1;
        BipartiteMatching g(t + 1);

        for (int i = 0; i < nL; ++i) g.addEdge(s, i, 1);
        for (int i = 0; i < nR; ++i) g.addEdge(nL + i, t, 1);
        for (auto [u, v] : edges) g.addEdge(u, nL + v, 1);

        g.maxFlow(s, t);

        // Extract matching from residual graph
        std::vector<std::pair<int, int>> matching;
        for (int u = 0; u < nL; ++u) {
            for (auto& e : g.adj[u]) {
                if (e.v >= nL && e.v < nL + nR && e.cap == 0) {
                    matching.push_back({u, e.v - nL});
                    break;
                }
            }
        }
        return matching;
    }
};

int main() {
    // Left: {0, 1, 2}, Right: {0, 1, 2}
    std::vector<std::pair<int, int>> edges = {
        {0, 0}, {0, 1}, {1, 1}, {1, 2}, {2, 0}
    };

    auto matching = BipartiteMatching::findMatching(3, 3, edges);
    std::cout << "Maximum matching size: " << matching.size() << "\n";
    for (auto [u, v] : matching) {
        std::cout << "  L" << u << " -- R" << v << "\n";
    }
}
```

### Project Assignment

Assign $n$ workers to $n$ projects. Each worker has a preference/cost for each project. Find the assignment minimizing total cost (or maximizing total profit).

**Reduction:** Min-cost max-flow. Source → workers (cap=1, cost=0), workers → projects (cap=1, cost=preference), projects → sink (cap=1, cost=0). Min-cost flow of value $n$.

### Airline Scheduling

Schedule flights to maximize profit. Each flight has a departure city, arrival city, time, and profit. Crew must be positioned at the right city.

**Reduction:** Min-cost max-flow with time-expanded network. Create a node for each city at each time point. Connect with "wait" edges (cost 0) and "flight" edges (capacity 1, cost = -profit). Find min-cost flow.

---

## Interview Tips

1. **Recognize flow problems.** If the problem involves matching, assignment, connectivity constraints, or "bottleneck" reasoning, consider max-flow.
2. **Start with the reduction.** The hardest part is modeling the problem as a flow network. Practice common reductions (bipartite matching, minimum cut).
3. **Edmonds-Karp is sufficient** for most interview problems. Dinic's is for competitive programming with tight constraints.
4. **Min-cut = max-flow.** If the problem asks for a minimum cut, compute max-flow and find the cut from the residual graph.
5. **Bipartite matching = max-flow.** This is the most common interview application of network flow.
6. **Use `long long`** for capacities and flows to avoid overflow.

## Common Mistakes

| Mistake | Consequence | Fix |
|---------|-------------|-----|
| Forgetting reverse edges | Can't "undo" flow | Always add reverse edge with cap=0 |
| Wrong reverse edge index | Wrong residual graph | Track `rev` index carefully |
| Not handling multiple edges | Capacity summed incorrectly | Either combine or handle separately |
| Integer overflow | Wrong flow value | Use `long long` |
| Confusing min-cut with min-edge-cut | Wrong problem | Min-cut is about capacity, not edge count |

## Practice Problems

### Maximum Bipartite Matching

*Already covered above in Section 29.7.*

### Minimum Cut

After computing max-flow with Edmonds-Karp or Dinic's, find the minimum cut:

```cpp
// After maxFlow(s, t):
// BFS from s in residual graph
// S = reachable vertices, T = unreachable
// Min cut edges = edges from S to T in original graph
```

### Network Flow Problem Template

For competitive programming, here's a compact Dinic's template:

```cpp
#include <bits/stdc++.h>
using namespace std;

struct Dinic {
    struct Edge { int v; long long cap; int rev; };
    int V;
    vector<vector<Edge>> adj;
    vector<int> level, ptr;

    Dinic(int V) : V(V), adj(V), level(V), ptr(V) {}

    void addEdge(int u, int v, long long cap) {
        adj[u].push_back({v, cap, (int)adj[v].size()});
        adj[v].push_back({u, 0, (int)adj[u].size() - 1});
    }

    bool bfs(int s, int t) {
        fill(level.begin(), level.end(), -1);
        level[s] = 0;
        queue<int> q; q.push(s);
        while (!q.empty()) {
            int u = q.front(); q.pop();
            for (auto& e : adj[u])
                if (level[e.v] == -1 && e.cap > 0) {
                    level[e.v] = level[u] + 1;
                    q.push(e.v);
                }
        }
        return level[t] != -1;
    }

    long long dfs(int u, int t, long long f) {
        if (u == t) return f;
        for (int& i = ptr[u]; i < adj[u].size(); ++i) {
            auto& e = adj[u][i];
            if (level[e.v] == level[u]+1 && e.cap > 0) {
                long long pushed = dfs(e.v, t, min(f, e.cap));
                if (pushed) {
                    e.cap -= pushed;
                    adj[e.v][e.rev].cap += pushed;
                    return pushed;
                }
            }
        }
        return 0;
    }

    long long maxFlow(int s, int t) {
        long long flow = 0;
        while (bfs(s, t)) {
            fill(ptr.begin(), ptr.end(), 0);
            while (long long pushed = dfs(s, t, LLONG_MAX))
                flow += pushed;
        }
        return flow;
    }
};
```

---

## See Also

- [Chapter 22: Graph Fundamentals](ch22-graph-fundamentals.md) — Prerequisite: graph representations and basic traversal algorithms.
- [Chapter 26: Shortest Paths](ch26-shortest-paths.md) — Dijkstra and Bellman-Ford; flow algorithms build on shortest path concepts.
- [Chapter 28: Advanced Graphs](ch28-advanced-graphs.md) — Biconnected components, Euler tours, and other advanced graph techniques.
- [Chapter 81: SCC, Bridges, and Articulation Points](ch81-scc-bridges.md) — Connectivity analysis is essential for understanding flow networks.
- [Chapter 83: Advanced Flow](ch83-advanced-flow.md) — Min-cost max-flow, circulation, and other advanced flow algorithms.
- [Chapter 27: Minimum Spanning Tree](ch27-mst.md) — The max-flow min-cut theorem has deep connections to MST algorithms.

*This concludes the graph algorithms section of the book. You now have a comprehensive toolkit for tackling graph problems in interviews and competitive programming. Master these algorithms, practice the patterns, and you'll be well-prepared for any graph question that comes your way.*
