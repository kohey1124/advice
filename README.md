# advice

WordPress テーマ [albatros](https://open-cage.com/albatros/) のスタイルシート (`css`) を管理するリポジトリです。

## AI コーディング CLI のセットアップ

Claude Code と Codex CLI をまとめて導入するスクリプトを用意しています。

```bash
./scripts/setup-cli.sh
```

個別に入れる場合は次のとおりです。

```bash
# Claude Code
npm install -g @anthropic-ai/claude-code

# Codex CLI
npm install -g @openai/codex
```

### 必要なもの

- Node.js 18 以上 (`node -v` で確認)
- npm

### 動作確認

```bash
claude --version
codex --version
```

いずれも初回起動時にサインインを求められます。

```bash
claude
codex
```
