#!/bin/sh

# Purpose: check typos in pre-commit hook and CI
# Usage: sh path/to/check-typos.sh
# Dependencies: typos
# Date: 2025-07-01
# Author: Yusong

typos --hidden --exclude .git --format brief
