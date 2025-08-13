#!/bin/sh

# Purpose: check if there the current worktree is dirty.
# Usage: sh path/to/git-status.sh
# Dependencies: git
# Date: 2025-07-12
# Author: Yusong

if [ "$(git status -s)" ]; then
  echo "local changes detected:"
  git status -s
  exit 1
fi
