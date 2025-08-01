# Basic Shortcuts for `vi` Editor in Ubuntu

The `vi` (or `vim`) editor is a widely used text editor in Unix/Linux environments. It has two main modes: **Command mode** and **Insert mode**.

---

## Modes in `vi`

* **Command Mode**: For navigating and performing operations.
* **Insert Mode**: For editing and inserting text.

---

## Opening and Closing `vi`

* `vi filename` – Open or create a file
* `:w` – Save the file (write)
* `:q` – Quit
* `:wq` or `ZZ` – Save and quit
* `:q!` – Quit without saving

---

## Switching Between Modes

* `i` – Insert at cursor (before)
* `I` – Insert at beginning of line
* `a` – Append after cursor
* `A` – Append at end of line
* `Esc` – Return to Command mode

---

## Navigating in Command Mode

* `h` – Move left
* `l` – Move right
* `j` – Move down
* `k` – Move up
* `0` – Move to beginning of line
* `$` – Move to end of line
* `w` – Next word
* `b` – Previous word
* `G` – Go to end of file
* `gg` – Go to beginning of file
* `:n` – Go to line number `n`

---

## Editing Text

* `x` – Delete character
* `dd` – Delete current line
* `dw` – Delete word
* `D` – Delete from cursor to end of line
* `u` – Undo last change
* `Ctrl + r` – Redo
* `yy` – Yank (copy) line
* `p` – Paste below
* `P` – Paste above

---

## Searching

* `/word` – Search forward for "word"
* `?word` – Search backward for "word"
* `n` – Repeat search in same direction
* `N` – Repeat search in opposite direction

---

## Visual Mode (for selection)

* `v` – Start visual mode (character-wise)
* `V` – Visual line mode
* `Ctrl + v` – Visual block mode
* `d`, `y`, `>` – Cut, copy, indent selection

---

## Save & Exit (Quick Reference)

* `:wq` – Save and exit
* `:x` – Save and exit (same as `:wq`)
* `ZZ` – Save and exit
* `:q!` – Exit without saving

---

These shortcuts are essential for beginners to navigate and edit files efficiently in `vi`. Practice them regularly to build fluency.

---

**Tip**: You can install `vim` (an enhanced version of `vi`) using:

```bash
sudo apt install vim
```
