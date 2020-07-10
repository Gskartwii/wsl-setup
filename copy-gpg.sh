#!/bin/bash
set -euo pipefail

gpg --armor --export `git config --global --get user.signingkey` | clip.exe
