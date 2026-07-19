# Chapter 78: KD Trees and Spatial Data Structures

## Prerequisites

- Binary search trees
- Recursion

## Interview Frequency: ★★

KD Trees handle k-dimensional queries efficiently. They appear in **Google** interviews for nearest neighbor and range search problems.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| KD Tree construction | ★★ | Medium | Alternating dimensions |
| Nearest neighbor | ★★★ | Medium | Pruning with bounds |
| Range search | ★★ | Medium | Query rectangular regions |

---

## 78.1 Structure

A KD Tree is a binary tree that partitions k-dimensional space:
- At each level, split on a different dimension
- Left child: points with smaller coordinate in split dimension
- Right child: points with larger coordinate

---

## 78.2 Implementation

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <cmath>
#include <float.h>

struct Point {
    std::vector<double> coords;
    int id;
};

struct KDNode {
    Point point;
    KDNode *left, *right;
    int splitDim;
};

class KDTree {
    KDNode* root;
    int k;
    
    KDNode* build(std::vector<Point>& points, int depth) {
        if (points.empty()) return nullptr;
        
        int dim = depth % k;
        int mid = points.size() / 2;
        
        std::nth_element(points.begin(), points.begin() + mid, points.end(),
            [dim](const Point& a, const Point& b) {
                return a.coords[dim] < b.coords[dim];
            });
        
        KDNode* node = new KDNode();
        node->point = points[mid];
        node->splitDim = dim;
        
        std::vector<Point> leftPoints(points.begin(), points.begin() + mid);
        std::vector<Point> rightPoints(points.begin() + mid + 1, points.end());
        
        node->left = build(leftPoints, depth + 1);
        node->right = build(rightPoints, depth + 1);
        
        return node;
    }
    
    double dist(const Point& a, const Point& b) {
        double d = 0;
        for (int i = 0; i < k; i++)
            d += (a.coords[i] - b.coords[i]) * (a.coords[i] - b.coords[i]);
        return std::sqrt(d);
    }
    
    void nearestNeighbor(KDNode* node, const Point& target, 
                         KDNode*& best, double& bestDist) {
        if (!node) return;
        
        double d = dist(node->point, target);
        if (d < bestDist) {
            bestDist = d;
            best = node;
        }
        
        int dim = node->splitDim;
        double diff = target.coords[dim] - node->point.coords[dim];
        
        KDNode* first = diff < 0 ? node->left : node->right;
        KDNode* second = diff < 0 ? node->right : node->left;
        
        nearestNeighbor(first, target, best, bestDist);
        
        if (std::abs(diff) < bestDist) {
            nearestNeighbor(second, target, best, bestDist);
        }
    }
    
public:
    KDTree(const std::vector<Point>& points, int dimensions) 
        : k(dimensions) {
        std::vector<Point> pts = points;
        root = build(pts, 0);
    }
    
    Point nearestNeighbor(const Point& target) {
        KDNode* best = nullptr;
        double bestDist = DBL_MAX;
        nearestNeighbor(root, target, best, bestDist);
        return best->point;
    }
};

int main() {
    std::vector<Point> points = {
        {{2, 3}, 0}, {{5, 4}, 1}, {{9, 6}, 2}, {{4, 7}, 3},
        {{8, 1}, 4}, {{7, 2}, 5}, {{6, 8}, 6}, {{1, 9}, 7}
    };
    
    KDTree tree(points, 2);
    
    Point query = {{5, 5}, -1};
    Point nearest = tree.nearestNeighbor(query);
    
    std::cout << "Nearest to (5,5): (" << nearest.coords[0] << "," 
              << nearest.coords[1] << ") id=" << nearest.id << "\n";
    
    return 0;
}
```

---

## 78.3 Complexity

| Operation | Average | Worst |
|---|---|---|
| Build | O(n log n) | O(n²) |
| Nearest neighbor | O(log n) | O(n) |
| Range search | O(n^(1-1/k) + m) | O(n) |

---

## Summary

| Aspect | Value |
|---|---|
| Dimensions | k (typically 2 or 3) |
| Build | O(n log n) |
| Nearest neighbor | O(log n) average |
| Best for | Spatial queries, nearest neighbor |
