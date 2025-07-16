# Terminal Multiplexers: `screen` vs `tmux` Command Cheat Sheet

This document provides a quick comparison and usage reference for two popular terminal multiplexers: `screen` and `tmux`.

---

## Installation

```bash
# Install screen
sudo apt install screen

# Install tmux
sudo apt install tmux
```

---

## Basic Commands

| **Action**          | **screen** Command                   | **tmux** Command               |
| ------------------- | ------------------------------------ | ------------------------------ |
| Start new session   | `screen` or `screen -S <name>`       | `tmux` or `tmux new -s <name>` |
| List sessions       | `screen -ls`                         | `tmux ls`                      |
| Reattach to session | `screen -r <name or id>`             | `tmux attach -t <name>`        |
| Detach from session | `Ctrl + A`, then `D`                 | `Ctrl + B`, then `D`           |
| Kill session        | `exit` or `screen -X -S <name> quit` | `tmux kill-session -t <name>`  |

---

## Window & Pane Management

| **Action**              | **screen** Command                        | **tmux** Command                     |
| ----------------------- | ----------------------------------------- | ------------------------------------ |
| Create new window       | `Ctrl + A`, then `C`                      | `Ctrl + B`, then `C`                 |
| Switch windows          | `Ctrl + A`, then `N` (next) or `P` (prev) | `Ctrl + B`, then `N` or `P`          |
| Rename session          | ❌ Use session name when creating          | `Ctrl + B`, then `,`                 |
| Split pane horizontally | ❌ Not supported                           | `Ctrl + B`, then `%`                 |
| Split pane vertically   | ❌ Not supported                           | `Ctrl + B`, then `"`                 |
| Switch between panes    | ❌ Not supported                           | `Ctrl + B`, then Arrow keys          |
| Resize panes            | ❌ Not supported                           | `Ctrl + B`, then `Ctrl` + Arrow keys |

---

## Scrolling & Copy Mode

| **Action**             | **screen** Command              | **tmux** Command                        |
| ---------------------- | ------------------------------- | --------------------------------------- |
| Enter scroll/copy mode | `Ctrl + A`, then `Esc`          | `Ctrl + B`, then `[`                    |
| Scroll up/down         | Arrow keys or `PageUp/PageDown` | Arrow keys or `PageUp/PageDown`         |
| Exit scroll mode       | Press `Esc` or `q`              | Press `q` or `Esc`                      |
| Enable mouse support   | ❌ Not supported natively        | Add `set -g mouse on` to `~/.tmux.conf` |

---

## Sample `.tmux.conf`

```bash
# ~/.tmux.conf
set -g mouse on              # Enable mouse for scroll and click
unbind C-b
set -g prefix C-a            # Use Ctrl + A as prefix like screen
bind C-a send-prefix
```

---

## ✅ When to Use

| Use Case                                 | Recommended Tool |
| ---------------------------------------- | ---------------- |
| Lightweight background job               | `screen`         |
| Persistent and interactive sessions      | `tmux`           |
| Need multiple panes, mouse, or scripting | `tmux`           |

---
