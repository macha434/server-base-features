#!/usr/bin/env bash
# server_base の docker-compose labels 規約を教えるClaude Codeスキルを、
# コンテナのリモートユーザーのホーム配下 (~/.claude/skills/) に配置する。
#
# devcontainer Featureのinstall.shはコンテナビルド中にroot権限で実行される。
# `_REMOTE_USER_HOME` はdevcontainer CLIが実際のリモートユーザーのホームを
# 教えてくれる変数なので、これを使う(rootの $HOME ではなく)。
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_HOME="${_REMOTE_USER_HOME:-$HOME}"
SKILL_DIR="$TARGET_HOME/.claude/skills/server-base-app-compose"

mkdir -p "$SKILL_DIR"
cp -r "$SCRIPT_DIR/skill/." "$SKILL_DIR/"

if [ -n "${_REMOTE_USER:-}" ]; then
    chown -R "$_REMOTE_USER" "$TARGET_HOME/.claude"
fi

echo "server-base-app-compose skill installed to $SKILL_DIR"
