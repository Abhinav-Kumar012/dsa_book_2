# Chapter 108: DSU on Tree and Rerooting DP

## Prerequisites
- DFS, DSU, Tree DP

## Interview Frequency: ★★★

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| DSU on Tree | ★★★ | Hard | Small-to-large merging |
| Rerooting DP | ★★★ | Medium-Hard | DP from all roots |

---

## 108.1 DSU on Tree

Answer subtree queries by merging smaller sets into larger ones. Each element is moved O(log n) times.

```cpp
#include <iostream>
#include <vector>
#include <map>

class DSUonTree {
    int n;
    std::vector<std::vector<int>> adj;
    std::vector<int> val, sz, heavy, answer;
    std::map<int,int> cnt;
    
    int dfsSize(int u, int p) {
        sz[u] = 1; int maxSize = 0;
        for (int v : adj[u]) {
            if (v != p) {
                int subSize = dfsSize(v, u);
                sz[u] += subSize;
                if (subSize > maxSize) { maxSize = subSize; heavy[u] = v; }
            }
        }
        return sz[u];
    }
    
    void add(int u, int p) {
        cnt[val[u]]++;
        for (int v : adj[u]) if (v != p) add(v, u);
    }
    
    void remove(int u, int p) {
        cnt[val[u]]--;
        if (cnt[val[u]] == 0) cnt.erase(val[u]);
        for (int v : adj[u]) if (v != p) remove(v, u);
    }
    
    void dfs(int u, int p, bool keep) {
        for (int v : adj[u])
            if (v != p && v != heavy[u]) dfs(v, u, false);
        if (heavy[u] != -1) dfs(heavy[u], u, true);
        for (int v : adj[u])
            if (v != p && v != heavy[u]) add(v, u);
        cnt[val[u]]++;
        answer[u] = cnt.size(); // Count distinct values in subtree
        if (!keep) remove(u, p);
    }
    
public:
    DSUonTree(int n) : n(n), adj(n), val(n), sz(n), heavy(n, -1), answer(n) {}
    void addEdge(int u, int v) { adj[u].push_back(v); adj[v].push_back(u); }
    
    std::vector<int> solve(int root, const std::vector<int>& values) {
        val = values;
        dfsSize(root, -1);
        dfs(root, -1, false);
        return answer;
    }
};

int main() {
    DSUonTree dsu(6);
    dsu.addEdge(0, 1); dsu.addEdge(0, 2);
    dsu.addEdge(1, 3); dsu.addEdge(1, 4); dsu.addEdge(2, 5);
    std::vector<int> values = {1, 2, 1, 3, 2, 3};
    auto ans = dsu.solve(0, values);
    for (int i = 0; i < 6; i++)
        std::cout << "Subtree " << i << ": " << ans[i] << " distinct\n";
    return 0;
}
```

---

## 108.2 Rerooting DP

Compute DP for every node as root in O(n).

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// Max distance from each node to any other node
class Rerooting {
    int n;
    std::vector<std::vector<int>> adj;
    std::vector<int> down, up, ans;
    
    int dfsDown(int u, int p) {
        int d = 0;
        for (int v : adj[u])
            if (v != p) d = std::max(d, dfsDown(v, u) + 1);
        down[u] = d;
        return d;
    }
    
    void dfsUp(int u, int p, int pUp) {
        up[u] = pUp;
        int max1 = 0, max2 = 0;
        for (int v : adj[u]) {
            if (v == p) continue;
            int val = down[v] + 1;
            if (val > max1) { max2 = max1; max1 = val; }
            else if (val > max2) max2 = val;
        }
        for (int v : adj[u]) {
            if (v == p) continue;
            int val = down[v] + 1;
            int use = (val == max1) ? max2 : max1;
            dfsUp(v, u, std::max(pUp + 1, use + 1));
        }
        ans[u] = std::max(down[u], up[u]);
    }
    
public:
    Rerooting(int n) : n(n), adj(n), down(n), up(n), ans(n) {}
    void addEdge(int u, int v) { adj[u].push_back(v); adj[v].push_back(u); }
    
    std::vector<int> solve(int root) {
        dfsDown(root, -1);
        dfsUp(root, -1, 0);
        return ans;
    }
};

int main() {
    Rerooting tree(6);
    tree.addEdge(0, 1); tree.addEdge(0, 2);
    tree.addEdge(1, 3); tree.addEdge(1, 4); tree.addEdge(2, 5);
    auto ans = tree.solve(0);
    for (int i = 0; i < 6; i++)
        std::cout << "Node " << i << ": max dist = " << ans[i] << "\n";
    return 0;
}
```

---

## Summary

| Technique | Time | Key Idea |
|---|---|---|
| DSU on Tree | O(n log n) | Small-to-large merging |
| Rerooting DP | O(n) | DFS down + up |
