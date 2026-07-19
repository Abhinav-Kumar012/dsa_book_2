# Chapter 134: Consistent Hashing

## Prerequisites
- Hashing basics

## Interview Frequency: ★★★

Essential for distributed systems. **Google**, **Amazon**, **Meta** test this.

---

## 134.1 Problem

In distributed systems, map keys to servers. When servers are added/removed, minimize key redistribution.

**Naive hash**: `server = hash(key) % num_servers`. Problem: changing num_servers remaps most keys.

**Consistent hash**: Map both keys and servers to a ring. Each key is assigned to the next server clockwise.

```cpp
#include <iostream>
#include <map>
#include <string>
#include <vector>
#include <functional>

class ConsistentHash {
    std::map<size_t, std::string> ring;
    std::hash<std::string> hasher;
    int replicas; // Virtual nodes per server
    
public:
    ConsistentHash(int replicas = 150) : replicas(replicas) {}
    
    void addServer(const std::string& server) {
        for (int i = 0; i < replicas; i++) {
            size_t hash = hasher(server + ":" + std::to_string(i));
            ring[hash] = server;
        }
    }
    
    void removeServer(const std::string& server) {
        for (int i = 0; i < replicas; i++) {
            size_t hash = hasher(server + ":" + std::to_string(i));
            ring.erase(hash);
        }
    }
    
    std::string getServer(const std::string& key) {
        if (ring.empty()) return "";
        size_t hash = hasher(key);
        auto it = ring.lower_bound(hash);
        if (it == ring.end()) it = ring.begin();
        return it->second;
    }
};

int main() {
    ConsistentHash ch;
    ch.addServer("Server1");
    ch.addServer("Server2");
    ch.addServer("Server3");
    
    std::vector<std::string> keys = {"user:1", "user:2", "user:3", "user:4", "user:5"};
    
    std::cout << "Before adding Server4:\n";
    for (auto& key : keys)
        std::cout << "  " << key << " -> " << ch.getServer(key) << "\n";
    
    ch.addServer("Server4");
    
    std::cout << "\nAfter adding Server4:\n";
    for (auto& key : keys)
        std::cout << "  " << key << " -> " << ch.getServer(key) << "\n";
    
    return 0;
}
```

---

## 134.2 Properties

| Property | Value |
|---|---|
| Key redistribution on add/remove | ~K/N keys (K=total, N=servers) |
| Virtual nodes | Smooth distribution |
| Time | O(log N) per lookup |

---

## Summary

| Approach | Redistribution | Lookup |
|---|---|---|
| Hash mod N | Most keys | O(1) |
| Consistent hash | ~K/N keys | O(log N) |
