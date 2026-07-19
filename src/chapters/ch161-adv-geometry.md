# Chapter 161: Advanced Computational Geometry

## Prerequisites
- Convex hull, sweep line basics

## Interview Frequency: ★

---

## 161.1 Voronoi Diagrams

Given n points (sites), partition the plane into n regions where each region contains all points closest to one site.

**Properties**: O(n) vertices, edges, faces. Dual to Delaunay triangulation.

```cpp
#include <iostream>
#include <vector>
#include <cmath>
#include <algorithm>

// Simple Voronoi: find which site is closest to a query point
struct Point { double x, y; };

int nearestSite(const Point& q, const std::vector<Point>& sites) {
    int best = 0;
    double bestDist = 1e18;
    for (int i = 0; i < (int)sites.size(); i++) {
        double dx = q.x - sites[i].x, dy = q.y - sites[i].y;
        double d = dx*dx + dy*dy;
        if (d < bestDist) { bestDist = d; best = i; }
    }
    return best;
}

int main() {
    std::vector<Point> sites = {{0,0}, {4,0}, {0,4}, {4,4}};
    std::vector<Point> queries = {{1,1}, {3,3}, {2,2}, {0,5}};
    
    for (auto& q : queries) {
        int site = nearestSite(q, sites);
        std::cout << "(" << q.x << "," << q.y << ") -> site " << site << "\n";
    }
    
    return 0;
}
```

---

## 161.2 Delaunay Triangulation

Triangulation where no point is inside the circumcircle of any triangle. Dual of Voronoi diagram.

**Properties**: Maximizes minimum angle. O(n log n) construction.

---

## 161.3 Half-Plane Intersection

Find intersection of n half-planes (convex polygon). O(n log n) using divide and conquer.

---

## 161.4 Range Trees

2D range reporting: O(log² n + k) query time, O(n log n) space.

**Construction**: Build BST on x-coordinates. Each node stores a sorted array of y-coordinates.

---

## 161.5 BSP Trees

Binary Space Partition: recursively split space with lines/planes. Used in computer graphics (rendering), robotics (collision detection).

---

## Summary

| Structure | Build | Query | Space | Application |
|---|---|---|---|---|
| Voronoi | O(n log n) | O(log n) | O(n) | Nearest neighbor |
| Delaunay | O(n log n) | — | O(n) | Mesh generation |
| Half-plane intersection | O(n log n) | — | O(n) | Linear programming |
| Range Tree | O(n log n) | O(log² n + k) | O(n log n) | Range reporting |
| BSP Tree | O(n log n) | O(log n) | O(n) | Rendering |
