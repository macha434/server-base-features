#!/usr/bin/env bash
# `devcontainer features test` から実行される自動テスト。
# https://containers.dev/implementors/features/#test-your-feature-optional
set -e

source dev-container-features-test-lib

check "skill file exists" bash -c "test -f \$HOME/.claude/skills/server-base-app-compose/SKILL.md"
check "skill mentions site.port" bash -c "grep -q 'site.port' \$HOME/.claude/skills/server-base-app-compose/SKILL.md"
check "skill mentions site.subdomain" bash -c "grep -q 'site.subdomain' \$HOME/.claude/skills/server-base-app-compose/SKILL.md"

reportResults
