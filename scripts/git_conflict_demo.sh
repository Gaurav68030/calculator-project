#!/bin/bash
# Q1 - Reproduces the full Git workflow with an intentional merge conflict.
# Usage:  bash git_conflict_demo.sh [REMOTE_URL]
#   REMOTE_URL = your empty GitHub repo, e.g. https://github.com/<user>/simple-calculator.git
# Requires: git config --global user.name / user.email already set.
set -x
REMOTE="$1"
rm -rf demo-repo && mkdir demo-repo && cd demo-repo
git init -b main

cat > calculator.py <<'PY'
"""Simple command-line calculator."""

def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a * b

def divide(a, b):
    if b == 0:
        raise ValueError("Division by zero is not allowed")
    return a / b

def main():
    print("Simple Calculator")
    a = float(input("First number: "))
    op = input("Operation (+, -, *, /): ")
    b = float(input("Second number: "))
    ops = {"+": add, "-": subtract, "*": multiply, "/": divide}
    print("Result:", ops[op](a, b))

if __name__ == "__main__":
    main()
PY
printf '# Simple Calculator\n\nA small Python command-line calculator.\n\nUsage: python calculator.py\n' > README.md
git add . && git commit -m "Initial commit: calculator with four operations and README"
if [ -n "$REMOTE" ]; then git remote add origin "$REMOTE" && git push -u origin main; fi

# ---- Branch 1: feature-power (edits the SAME lines as branch 2) ----
git checkout -b feature-power
python3 - <<'PY'
s = open("calculator.py").read()
s = s.replace('def main():', 'def power(a, b):\n    return a ** b\n\ndef main():')
s = s.replace('Operation (+, -, *, /): ', 'Operation (+, -, *, /, ^): ')
s = s.replace('"/": divide}', '"/": divide, "^": power}')
open("calculator.py", "w").write(s)
PY
sed -i 's|^Usage: python calculator.py.*|Usage: python calculator.py  (supports + - * / and ^ power)|' README.md
git add . && git commit -m "feature-power: add power operation and update README usage line"

# ---- Branch 2: feature-modulo (edits the SAME lines differently) ----
git checkout main
git checkout -b feature-modulo
python3 - <<'PY'
s = open("calculator.py").read()
s = s.replace('def main():', 'def modulo(a, b):\n    if b == 0:\n        raise ValueError("Modulo by zero is not allowed")\n    return a % b\n\ndef main():')
s = s.replace('Operation (+, -, *, /): ', 'Operation (+, -, *, /, %): ')
s = s.replace('"/": divide}', '"/": divide, "%": modulo}')
open("calculator.py", "w").write(s)
PY
sed -i 's|^Usage: python calculator.py.*|Usage: python calculator.py  (supports + - * / and % modulo)|' README.md
git add . && git commit -m "feature-modulo: add modulo operation and update README usage line"

# ---- Merge: first merge is clean, second one CONFLICTS ----
git checkout main
git merge feature-power -m "Merge feature-power into main"
git merge feature-modulo -m "Merge feature-modulo into main"   # <-- CONFLICT happens here
git status
git diff

echo ""
echo ">>> The conflict is now live. Open calculator.py and README.md in your editor,"
echo ">>> keep BOTH power and modulo, delete the <<<<<<< ======= >>>>>>> markers, then run:"
echo "    git add calculator.py README.md"
echo "    git commit -m 'Resolve merge conflict: keep both power and modulo operations'"
echo "    git push -u origin main      # (if you did not pass REMOTE_URL: git remote add origin <url> first)"
echo ">>> Screenshots to take: git status (conflict), git diff (markers), resolved file, git log --oneline --graph --all"
