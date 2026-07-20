# Scripts

Utility scripts for the DSA book project.

| Script | Description |
|---|---|
| `push.sh` | One-shot push of current branch to origin |
| `auto-push-daemon.sh` | Background daemon, pushes every N minutes |
| `find-thin-pages.sh` | Find markdown files in a line range (default 150-200) |

## Usage

```bash
# Push now
bash .openclaw/scripts/push.sh

# Start auto-push daemon (every 10 min)
nohup bash .openclaw/scripts/auto-push-daemon.sh 600 &

# Find thin pages to expand
bash .openclaw/scripts/find-thin-pages.sh        # 150-200 lines
bash .openclaw/scripts/find-thin-pages.sh 100 150 # custom range
```
