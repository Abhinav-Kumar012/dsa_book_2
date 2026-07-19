# Chapter 162: Algorithmic Game Theory

## Prerequisites
- Game theory basics, graph algorithms

## Interview Frequency: ★★

---

## 162.1 Stable Matching (Gale-Shapley)

Find a stable matching between two sets. O(n²) time.

```cpp
#include <iostream>
#include <vector>
#include <queue>

// Gale-Shapley algorithm: proposers get their best stable match
std::vector<int> galeShapley(const std::vector<std::vector<int>>& proposerPrefs,
                              const std::vector<std::vector<int>>& acceptorPrefs) {
    int n = proposerPrefs.size();
    std::vector<int> match(n, -1); // acceptor -> proposer
    std::vector<int> proposerMatch(n, -1); // proposer -> acceptor
    std::vector<int> nextProposal(n, 0); // next acceptor to propose to
    std::vector<std::vector<int>> acceptorRank(n, std::vector<int>(n));
    
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            acceptorRank[i][acceptorPrefs[i][j]] = j;
    
    std::queue<int> freeProposers;
    for (int i = 0; i < n; i++) freeProposers.push(i);
    
    while (!freeProposers.empty()) {
        int p = freeProposers.front(); freeProposers.pop();
        int a = proposerPrefs[p][nextProposal[p]++];
        
        if (match[a] == -1) {
            match[a] = p;
            proposerMatch[p] = a;
        } else if (acceptorRank[a][p] < acceptorRank[a][match[a]]) {
            int oldP = match[a];
            proposerMatch[oldP] = -1;
            freeProposers.push(oldP);
            match[a] = p;
            proposerMatch[p] = a;
        } else {
            freeProposers.push(p);
        }
    }
    
    return proposerMatch;
}

int main() {
    // Proposer preferences (0,1,2 = acceptors)
    std::vector<std::vector<int>> propPref = {{0,1,2},{1,0,2},{0,1,2}};
    std::vector<std::vector<int>> accPref = {{0,1,2},{1,0,2},{0,2,1}};
    
    auto match = galeShapley(propPref, accPref);
    std::cout << "Stable matching:\n";
    for (int i = 0; i < 3; i++)
        std::cout << "  Proposer " << i << " -> Acceptor " << match[i] << "\n";
    return 0;
}
```

---

## 162.2 Nash Equilibrium

A strategy profile where no player can improve their payoff by unilaterally changing their strategy.

**Pure Nash**: Deterministic strategies. May not exist.
**Mixed Nash**: Randomized strategies. Always exists (Nash's theorem, 1950).

**Computing Nash**: PPAD-complete for 2+ players. For 2-player zero-sum games, reduces to LP.

**Example**: Rock-Paper-Scissors has unique mixed Nash: each action with probability 1/3.

---

## 162.3 Mechanism Design

Design games/rules so that self-interested behavior leads to desired outcomes. "Reverse game theory."

**Key properties**:
- **Incentive compatibility**: Truth-telling is optimal
- **Individual rationality**: Participation is beneficial
- **Budget balance**: No external subsidies needed

**Applications**: Auction design (Vickrey auction), voting systems, kidney exchange, spectrum allocation.

---

## Summary

| Concept | Definition |
|---|---|
| Stable Matching | No blocking pair exists |
| Nash Equilibrium | No unilateral deviation helps |
| Mechanism Design | Reverse game theory |
