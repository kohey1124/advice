---
name: multi-review
description: 成果物をGeminiとGPTに独立レビューさせ、突き合わせて修正する
---

対象は $ARGUMENTS（未指定なら直前に作成した成果物）。

## Step 1: レビュー依頼文を1つ作る

scratchpad/rv-prompt.md に以下を書き出す。
両モデルに完全に同一の入力を渡すため、必ずファイル経由にすること。

---
あなたはレビュアーです。以下の文書の問題点のみを列挙してください。
良い点は書かないでください。

観点:
(1) 事実誤り・根拠が示されていない記述
(2) 論理の飛躍
(3) 抜けている論点
(4) 読み手に突っ込まれる箇所

形式: 番号 / 該当箇所の引用 / 問題 / 修正案 / 重要度(高中低)
---
【文書】
（対象ファイルの中身をここに展開）
---

## Step 2: 並列実行

以下を1つのbashコマンドとして実行する。

mkdir -p scratchpad
GEMINI_API_KEY="$GEMINI_API_KEY" \
  gemini --skip-trust -p "$(cat scratchpad/rv-prompt.md)" \
  > scratchpad/rv-gemini.md 2>&1 &
PID_G=$!
codex exec --skip-git-repo-check --sandbox read-only \
  "$(cat scratchpad/rv-prompt.md)" \
  < /dev/null > scratchpad/rv-gpt.md 2>&1 &
PID_P=$!
wait $PID_G; RC_G=$?
wait $PID_P; RC_P=$?
echo "gemini=$RC_G gpt=$RC_P"

両方が 0 の場合のみ Step 3 へ進む。
片方でも 0 以外なら、該当ファイルの中身をエラーとして報告し停止する。
両方失敗した場合は認証状態を確認するよう伝える。

## Step 3: 突き合わせ

両ファイルを読み、3群に分類して提示する。

【A】両方が指摘した箇所
【B】片方のみが指摘した箇所（出所を [G] [P] で明記）
【C】見解が対立する箇所
     （一方が問題とし他方が問題としない／修正案が矛盾する）

## Step 4: 仕分けと修正

- 【A】は原則すべて採用し、修正版に反映する
- 【B】は採用/却下を判断し、却下は理由を明記する
- 【C】は修正せず、論点として提示し判断を仰ぐ
- Claude自身が両者と異なる見解を持つ場合は、それも明記する
