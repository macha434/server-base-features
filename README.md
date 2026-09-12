# server-base-features

[server_base](https://github.com/macha434/server_base) にアプリを追加する際の
docker-compose の書き方（`site.port` / `site.subdomain` labels の規約）を、
アプリ側リポジトリで一切設定せずに使えるようにするための
[devcontainer Feature](https://containers.dev/implementors/features/) 集。

## 提供している Feature

### `app-compose-skill`

ユーザーレベルの Claude Code スキル（`~/.claude/skills/server-base-app-compose/`）を
コンテナに配置する。個々のアプリリポジトリに何も追加しなくても、devcontainer を開いた
Claude Code がこの規約を知った状態になる。

## 使い方

VS Code のユーザー設定に一度だけ以下を追加する（`dev.containers.defaultFeatures` は
すべての devcontainer に自動適用される、プロジェクト非依存のグローバル設定）:

```json
{
  "dev.containers.defaultFeatures": {
    "ghcr.io/macha434/server-base-features/app-compose-skill:1": {}
  }
}
```

以降、どのアプリのdevcontainerを開いても、Claude Codeがこの規約に沿った
`labels`(`site.port`/`site.subdomain`)付きの docker-compose を書けるようになる。
アプリ側リポジトリの改変は不要。

規約の詳細は [server_baseリポジトリのspec](https://github.com/macha434/server_base/blob/main/docs/superpowers/specs/2026-09-12-app-compose-convention-design.md)
と、このリポジトリ内の [`src/app-compose-skill/skill/SKILL.md`](src/app-compose-skill/skill/SKILL.md) を参照。

## リリース

`main` への push (`src/**` 配下の変更) をトリガに、GitHub Actions
(`.github/workflows/release.yml`, [devcontainers/action](https://github.com/devcontainers/action) 使用)が
`ghcr.io/macha434/server-base-features/app-compose-skill` に自動公開する。

## 開発

このリポジトリ自体は devcontainer を持たない。開発・検証は
[server_base](https://github.com/macha434/server_base) の devcontainer
（`/workspace/server-base/features` に自動cloneされる）から行う。
