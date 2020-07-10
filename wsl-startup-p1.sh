#!/bin/bash
set -euo pipefail

printf "[network]\ngenerateResolvConf = false\n" | sudo tee -a /etc/wsl.conf
echo "Shutting down VM. Restart with \`wsl\` and run ./wsl-startup-p2.sh"
