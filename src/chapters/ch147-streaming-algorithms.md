# Chapter 147: Streaming Algorithms

## Prerequisites
- Probability, hash functions

## Interview Frequency: ★★

Streaming algorithms process data in one pass with limited memory.

---

## 147.1 Streaming Model

- Input arrives as a stream (one pass)
- Memory: O(polylog n) or O(n^ε)
- Must answer queries approximately

---

## 147.2 Misra-Gries (Heavy Hitters)

Find all elements with frequency > n/k using O(k) space.

```cpp
#include <iostream>
#include <vector>
#include <map>
#include <algorithm>

class MisraGries {
    int k;
    std::map<int, int> counters;
    
public:
    MisraGries(int k) : k(k) {}
    
    void process(int item) {
        if (counters.count(item)) {
            counters[item]++;
        } else if ((int)counters.size() < k - 1) {
            counters[item] = 1;
        } else {
            // Decrement all, remove zeros
            std::vector<int> toRemove;
            for (auto& [key, val] : counters) {
                val--;
                if (val <= 0) toRemove.push_back(key);
            }
            for (int key : toRemove) counters.erase(key);
        }
    }
    
    std::vector<std::pair<int,int>> getFrequent() {
        std::vector<std::pair<int,int>> result;
        for (auto& [key, val] : counters)
            result.push_back({key, val});
        return result;
    }
};

int main() {
    MisraGries mg(3); // Find elements with freq > n/3
    std::vector<int> stream = {1,1,1,2,2,3,1,2,3,1,2,1};
    for (int x : stream) mg.process(x);
    
    auto freq = mg.getFrequent();
    std::cout << "Heavy hitters (approx):\n";
    for (auto& [val, count] : freq)
        std::cout << "  " << val << ": ~" << count << "\n";
    return 0;
}
```

---

## 147.3 Reservoir Sampling

Sample k items uniformly from a stream of unknown size.

```cpp
#include <iostream>
#include <vector>
#include <random>

std::vector<int> reservoirSample(const std::vector<int>& stream, int k) {
    std::mt19937 rng(42);
    std::vector<int> reservoir(stream.begin(), stream.begin() + k);
    
    for (int i = k; i < (int)stream.size(); i++) {
        std::uniform_int_distribution<int> dist(0, i);
        int j = dist(rng);
        if (j < k) reservoir[j] = stream[i];
    }
    return reservoir;
}

int main() {
    std::vector<int> stream(1000);
    for (int i = 0; i < 1000; i++) stream[i] = i;
    
    auto sample = reservoirSample(stream, 5);
    std::cout << "Sample: ";
    for (int x : sample) std::cout << x << " ";
    std::cout << "\n";
    return 0;
}
```

---

## 147.4 Frequency Moments

F_k = Σ f_i^k where f_i is frequency of element i.

| Moment | Meaning | Algorithm |
|---|---|---|
| F_0 | Distinct count | HyperLogLog |
| F_1 | Total count | Counter |
| F_2 | Surprise | AMS sketch |

---

## Summary

| Problem | Space | Error | Algorithm |
|---|---|---|---|
| Heavy Hitters | O(k) | Approximate | Misra-Gries |
| Distinct Count | O(log n) | ~2% | HyperLogLog |
| Reservoir Sample | O(k) | Exact | Vitter's |
| Frequency Moments | O(polylog) | Approximate | AMS sketch |
