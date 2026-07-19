# Chapter 88: Palindromic Tree (Eertree)

## Prerequisites

- String basics
- Trie concepts

## Interview Frequency: ★★

Palindromic trees efficiently process palindromic substrings. Appears in **Google** competitive programming-style interviews.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Structure | ★★ | Hard | Two root nodes |
| Operations | ★★ | Medium | Add character, find palindromes |
| Applications | ★★ | Medium | Count distinct palindromes |

---

## 88.1 Structure

An **Eertree** (palindromic tree) stores all distinct palindromic substrings:
- Two root nodes: length -1 (odd root) and length 0 (even root)
- Each node represents a distinct palindrome
- Suffix links point to the longest proper palindromic suffix

---

## 88.2 Implementation

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <map>

class PalindromicTree {
    struct Node {
        int len;           // Length of palindrome
        int suffixLink;    // Link to longest proper palindromic suffix
        std::map<char, int> next; // Transitions
        int count;         // Number of occurrences
        Node(int l) : len(l), suffixLink(0), count(0) {}
    };
    
    std::vector<Node> tree;
    std::string s;
    int last; // Node representing longest suffix-palindrome
    
public:
    PalindromicTree() {
        // Root for odd-length (-1) and even-length (0)
        tree.push_back(Node(-1)); // 0: odd root
        tree.push_back(Node(0));  // 1: even root
        tree[0].suffixLink = 0;
        tree[1].suffixLink = 0;
        last = 1;
        s = "$"; // Sentinel
    }
    
    void addChar(char c) {
        s += c;
        int pos = s.size() - 1;
        int curr = last;
        
        // Find the longest palindromic suffix that can be extended
        while (true) {
            int curLen = tree[curr].len;
            if (pos - curLen - 1 >= 0 && s[pos - curLen - 1] == c)
                break;
            curr = tree[curr].suffixLink;
        }
        
        // Check if palindrome already exists
        if (tree[curr].next.count(c)) {
            last = tree[curr].next[c];
            tree[last].count++;
            return;
        }
        
        // Create new node
        int newNode = tree.size();
        tree.push_back(Node(tree[curr].len + 2));
        tree[curr].next[c] = newNode;
        
        // Set suffix link
        if (tree[newNode].len == 1) {
            tree[newNode].suffixLink = 1;
        } else {
            int link = tree[curr].suffixLink;
            while (true) {
                int linkLen = tree[link].len;
                if (pos - linkLen - 1 >= 0 && s[pos - linkLen - 1] == c)
                    break;
                link = tree[link].suffixLink;
            }
            tree[newNode].suffixLink = tree[link].next[c];
        }
        
        last = newNode;
        tree[last].count = 1;
    }
    
    int distinctPalindromes() {
        return tree.size() - 2; // Exclude two roots
    }
    
    int longestPalindromeLength() {
        return tree[last].len;
    }
};

int main() {
    PalindromicTree pt;
    std::string s = "abacaba";
    
    for (char c : s) pt.addChar(c);
    
    std::cout << "Distinct palindromes in \"" << s << "\": " 
              << pt.distinctPalindromes() << "\n";
    std::cout << "Longest palindrome length: " << pt.longestPalindromeLength() << "\n";
    
    return 0;
}
```

---

## Summary

| Operation | Time | Notes |
|---|---|---|
| Add character | O(1) amortized | Amortized over string |
| Count distinct palindromes | O(1) | After building |
| Longest palindrome | O(1) | After building |
| Total space | O(n) | At most n+2 nodes |
