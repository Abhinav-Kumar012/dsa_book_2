# Chapter 94: Hashing Deep Dive

## Prerequisites

- Hash tables basics
- Modular arithmetic

## Interview Frequency: ★★★

Deep hashing knowledge is tested at **Google**, **Amazon**, and in system design interviews.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Rolling hash | ★★★★ | Medium | String matching |
| Zobrist hashing | ★★ | Medium | Game states |
| Consistent hashing | ★★★ | Medium | Distributed systems |
| Hash collision attacks | ★★ | Medium | Security awareness |

---

## 94.1 Rolling Hash

Compute hash of all substrings in O(n).

```cpp
#include <iostream>
#include <string>
#include <vector>

class RollingHash {
    static const long long BASE = 91138233;
    static const long long MOD = 1e9 + 7;
    std::vector<long long> hash, power;
    
public:
    RollingHash(const std::string& s) : hash(s.size() + 1), power(s.size() + 1) {
        int n = s.size();
        hash[0] = 0;
        power[0] = 1;
        for (int i = 0; i < n; i++) {
            hash[i + 1] = (hash[i] * BASE + s[i]) % MOD;
            power[i + 1] = power[i] * BASE % MOD;
        }
    }
    
    // Hash of s[l..r] (0-indexed, inclusive)
    long long getHash(int l, int r) {
        return (hash[r + 1] - hash[l] * power[r - l + 1] % MOD + MOD) % MOD;
    }
};

int main() {
    std::string s = "abcabcabc";
    RollingHash rh(s);
    
    // Check if "abc" appears at position 3
    long long hash1 = rh.getHash(0, 2); // "abc"
    long long hash2 = rh.getHash(3, 5); // "abc"
    
    std::cout << "Hash of s[0..2]: " << hash1 << "\n";
    std::cout << "Hash of s[3..5]: " << hash2 << "\n";
    std::cout << "Equal: " << (hash1 == hash2) << "\n";
    
    return 0;
}
```

---

## 94.2 Zobrist Hashing

For hashing game states or sets. XOR of random values for each element.

```cpp
#include <iostream>
#include <vector>
#include <random>
#include <unordered_set>

class ZobristHash {
    std::vector<long long> table;
    std::mt19937_64 rng;
    
public:
    ZobristHash(int maxElements) : table(maxElements), rng(42) {
        for (int i = 0; i < maxElements; i++)
            table[i] = rng();
    }
    
    long long hash(const std::vector<int>& elements) {
        long long h = 0;
        for (int e : elements) h ^= table[e];
        return h;
    }
    
    // Add element to existing hash
    long long add(long long currentHash, int element) {
        return currentHash ^ table[element];
    }
    
    // Remove element from existing hash
    long long remove(long long currentHash, int element) {
        return currentHash ^ table[element]; // XOR is its own inverse
    }
};

int main() {
    ZobristHash zh(100);
    
    std::vector<int> set1 = {1, 3, 5, 7};
    std::vector<int> set2 = {7, 5, 3, 1};
    
    std::cout << "Hash of {1,3,5,7}: " << zh.hash(set1) << "\n";
    std::cout << "Hash of {7,5,3,1}: " << zh.hash(set2) << "\n";
    std::cout << "Same hash: " << (zh.hash(set1) == zh.hash(set2)) << "\n";
    
    return 0;
}
```

---

## 94.3 Consistent Hashing

Used in distributed systems to map keys to servers with minimal redistribution when servers are added/removed.

---

## Summary

| Technique | Use Case | Key Property |
|---|---|---|
| Rolling hash | Substring comparison | O(1) substring hash |
| Zobrist hashing | Set/game state hash | XOR-based, order-independent |
| Consistent hashing | Distributed systems | Minimal redistribution |

---

## 94.4 Non-Cryptographic Hash Functions

| Hash | Speed | Quality | Use Case |
|---|---|---|---|
| MurmurHash3 | Very fast | Good | Hash tables, bloom filters |
| xxHash | Fastest | Excellent | General purpose |
| SipHash | Moderate | Cryptographic | Hash DoS prevention |
| CityHash | Fast | Good | Google internal |
| FNV-1a | Fast | Decent | Simple hashing |

```cpp
#include <iostream>
#include <cstdint>

// FNV-1a hash (simple, widely used)
uint32_t fnv1a(const void* data, size_t len) {
    uint32_t hash = 2166136261u;
    const uint8_t* bytes = (const uint8_t*)data;
    for (size_t i = 0; i < len; i++) {
        hash ^= bytes[i];
        hash *= 16777619u;
    }
    return hash;
}

// Simple hash combining (like boost::hash_combine)
size_t hashCombine(size_t seed, size_t val) {
    seed ^= val + 0x9e3779b9 + (seed << 6) + (seed >> 2);
    return seed;
}

int main() {
    std::string s = "Hello, World!";
    std::cout << "FNV-1a hash: " << fnv1a(s.data(), s.size()) << "\n";
    std::cout << "Combined hash: " << hashCombine(42, 17) << "\n";
    return 0;
}
```

---

## 94.5 Rendezvous Hashing

Also called "highest random weight" hashing. Each key is hashed with every server, and the server with the highest hash value gets the key. Adding/removing a server only remaps keys assigned to that server.

```cpp
#include <iostream>
#include <vector>
#include <string>
#include <functional>
#include <float.h>

std::string rendezvousHash(const std::string& key, 
                            const std::vector<std::string>& servers) {
    std::hash<std::string> hasher;
    std::string best;
    double bestScore = -DBL_MAX;
    
    for (auto& server : servers) {
        double score = hasher(key + server); // Combine key + server
        if (score > bestScore) {
            bestScore = score;
            best = server;
        }
    }
    return best;
}

int main() {
    std::vector<std::string> servers = {"S1", "S2", "S3"};
    for (auto& key : {"user:1", "user:2", "user:3", "user:4"})
        std::cout << key << " -> " << rendezvousHash(key, servers) << "\n";
    return 0;
}
```

---

## 94.6 Locality-Sensitive Hashing (Overview)

LSH maps similar items to the same hash bucket with high probability. Unlike regular hashing (which minimizes collisions), LSH maximizes collisions for similar items.

**Applications**: Near-duplicate detection, similarity search, recommendation systems.

**Technique**: Use multiple hash functions; items are "similar" if they collide in many functions.

---

### Locality-Sensitive Hashing Implementation

```cpp
#include <iostream>
#include <vector>
#include <random>
#include <set>

// LSH for cosine similarity using random hyperplanes
class LSH {
    int dim, numHashes, numBands;
    std::vector<std::vector<double>> hyperplanes;
    
public:
    LSH(int dim, int numHashes, int numBands) 
        : dim(dim), numHashes(numHashes), numBands(numBands) {
        std::mt19937 rng(42);
        std::normal_distribution<double> dist(0.0, 1.0);
        for (int i = 0; i < numHashes; i++) {
            std::vector<double> hp(dim);
            for (int j = 0; j < dim; j++) hp[j] = dist(rng);
            hyperplanes.push_back(hp);
        }
    }
    
    // Hash a vector to a signature (vector of +1/-1)
    std::vector<int> hash(const std::vector<double>& vec) {
        std::vector<int> sig(numHashes);
        for (int i = 0; i < numHashes; i++) {
            double dot = 0;
            for (int j = 0; j < dim; j++)
                dot += vec[j] * hyperplanes[i][j];
            sig[i] = dot >= 0 ? 1 : 0;
        }
        return sig;
    }
    
    // Find candidate pairs using banded signatures
    std::set<std::pair<int,int>> findCandidates(
        const std::vector<std::vector<double>>& vectors) {
        int n = vectors.size();
        int bandSize = numHashes / numBands;
        
        std::set<std::pair<int,int>> candidates;
        
        for (int band = 0; band < numBands; band++) {
            std::map<std::vector<int>, std::vector<int>> buckets;
            for (int i = 0; i < n; i++) {
                auto sig = hash(vectors[i]);
                std::vector<int> bandSig(sig.begin() + band * bandSize, 
                                         sig.begin() + (band + 1) * bandSize);
                buckets[bandSig].push_back(i);
            }
            for (auto& [key, ids] : buckets) {
                for (int i = 0; i < (int)ids.size(); i++)
                    for (int j = i + 1; j < (int)ids.size(); j++)
                        candidates.insert({std::min(ids[i], ids[j]), 
                                          std::max(ids[i], ids[j])});
            }
        }
        return candidates;
    }
};

---

## See Also

- [Chapter 7: Hashing](ch07-hashing.md) — The fundamentals: hash maps, hash sets, collision handling, and basic applications.
- [Chapter 105: Cuckoo and Robin Hood Hashing](ch105-cuckoo-robin-hood-hashing.md) — Advanced open-addressing strategies that guarantee O(1) worst-case lookup or equalize probe lengths.
- [Chapter 40: Rolling Hash](ch40-rolling-hash.md) — Hash-based string matching; rolling hash enables O(1) substring hash computation.
- [Chapter 134: Consistent Hashing](ch134-consistent-hashing.md) — Distributed systems use consistent hashing for load balancing across servers.
- [Chapter 79: Probabilistic Data Structures](ch79-probabilistic-ds.md) — Bloom filters, count-min sketches, and other hash-based probabilistic structures.
