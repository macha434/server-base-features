---
name: server-base-app-compose
description: Use when writing or editing a docker-compose file (often under deploy/) intended for deployment behind server_base (an nginx/dnsmasq composition-root host). Ensures the compose file carries the labels server_base's new-app.sh needs to auto-detect the app without any other repo-side configuration.
---

# server_base 用 docker-compose の書き方

## 目的

このリポジトリは [server_base](https://github.com/macha434/server_base) というホスト基盤の配下にデプロイされる。server_base 側の `scripts/new-app.sh <このリポジトリのURL>` だけでアプリを追加できるようにするため、このリポジトリの docker-compose ファイルには以下の規約に沿った `labels` を付与する。**server_base 自体はこのリポジトリを一切改変しない**ので、この規約を満たす labels を書くのはアプリ側（＝あなたが今作業しているこのリポジトリ）の責務になる。

## 規約

デプロイ対象サービス（外部に公開したいサービス。通常は1個）に以下の labels を付与する:

```yaml
services:
  web:                          # サービス名は何でも良い(server_base側が自動検出する)
    labels:
      site.port: "3000"         # 必須: このコンテナがリッスンしているポート番号
      site.subdomain: "myapp"   # 任意: 省略するとリポジトリ名がそのままサブドメインになる
```

- `site.port` は**必須**。無いと server_base 側の `new-app.sh` がエラーで案内して止まる。
- `site.subdomain` は任意。省略時はリポジトリ名がそのまま使われる（`https://<リポジトリ名>.ubuntu.local/` になる）。短いサブドメインにしたい場合や、リポジトリ名がURLとして使いにくい場合に指定する。
- サービスが複数ある場合、公開対象がどれか一意に決まらないため、`new-app.sh` 実行時に `--service <サービス名>` を明示する必要がある（このSKILL自体はlabelsの付与だけをカバーする）。

## compose ファイルの場所

`new-app.sh` は以下の順で自動探索する。可能なら `deploy/docker-compose.yaml` に置く(このリポジトリで初めて用意する場合の推奨パス)。

1. `deploy/docker-compose.yaml`
2. `docker-compose.yaml`
3. `docker-compose.yml`

## このスキルの役割

このスキルが提供する情報はここまで。実際に `new-app.sh` を実行して `stacks/<app名>/docker-compose.yml`（server_base側のoverride）を生成する作業は server_base リポジトリ側で行うものであり、このリポジトリ側の作業ではない。ここでは「将来 new-app.sh に読ませるための labels を、このリポジトリの compose ファイルに正しく書く」ことだけを行う。

## やること(このスキルが要求された時の動作)

1. このリポジトリ内で実際にデプロイに使う docker-compose ファイルを探す（無ければ `deploy/docker-compose.yaml` を新規作成する）。
2. 外部公開したいサービスに `site.port` label を追加する（値はそのサービスが実際にリッスンしているポート番号。Dockerfile の `EXPOSE` やアプリの設定から判断する）。
3. サブドメインをリポジトリ名と変えたい場合のみ `site.subdomain` label も追加する。
4. 他に変更は加えない（server_base 側が `include:` でこのファイルを取り込み、ネットワーク・ポート公開設定は server_base 側の override で上書きするため、ここでは labels 以外を気にする必要はない）。
