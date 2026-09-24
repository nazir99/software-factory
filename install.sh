#!/usr/bin/env bash
# Install or update every published factory skill into a skills folder.
# Usage: ./install.sh [skills-dir]   (default: ~/.claude/skills)
set -euo pipefail
DEST="${1:-$HOME/.claude/skills}"
SKILLS=(nsq netsuite-data-solutioning reader-walkthrough drawing-t-accounts)

mkdir -p "$DEST"
for s in "${SKILLS[@]}"; do
  if [ -d "$DEST/$s/.git" ]; then
    echo "updating $s"; git -C "$DEST/$s" pull -q --ff-only
  elif [ -e "$DEST/$s" ]; then
    echo "skipping $s: $DEST/$s exists and is not a git clone"
  else
    echo "installing $s"; git clone -q "https://github.com/nazir99/$s.git" "$DEST/$s"
  fi
done
echo "Done. Skills that ship a CLI (nsq) also need: cd $DEST/nsq && npm link"
