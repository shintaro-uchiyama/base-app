# 概要
言葉を用いた連想ゲーム  

# 環境構築

```zsh
gsutil cp gs://ucwork-secrets/.env.local ./frontend/.env
docker-compose up -d
```

# 実行方法
```zsh
$ bazel run //:gazelle
$ bazel run //bff/cmd/hello:hello_test
INFO: Analyzed target //bff/cmd/hello:hello_test (1 packages loaded, 4 targets configured).
INFO: Found 1 target...
Target //bff/cmd/hello:hello_test up-to-date:
  bazel-bin/bff/cmd/hello/hello_test_/hello_test
INFO: Elapsed time: 0.677s, Critical Path: 0.49s
INFO: 8 processes: 3 internal, 5 darwin-sandbox.
INFO: Build completed successfully, 8 total actions
INFO: Build completed successfully, 8 total actions
exec ${PAGER:-/usr/bin/less} "$0" || exit 1
Executing tests from //bff/cmd/hello:hello_test
-----------------------------------------------------------------------------
===
aaa
PASS
```

# 外部パッケージの取り込み
```zsh
$ bazel run //:gazelle -- update-repos -from_file=bff/go.mod -to_macro=bff/repositories.bzl%go_repositories -prune
$ bazel run //:gazelle
$ bazel test //bff/cmd/hello:hello_test
INFO: Analyzed target //bff/cmd/hello:hello_test (0 packages loaded, 0 targets configured).
INFO: Found 1 test target...
Target //bff/cmd/hello:hello_test up-to-date:
  bazel-bin/bff/cmd/hello/hello_test_/hello_test
INFO: Elapsed time: 1.493s, Critical Path: 1.30s
INFO: 7 processes: 1 internal, 6 darwin-sandbox.
INFO: Build completed successfully, 7 total actions
//bff/cmd/hello:hello_test                                               PASSED in 0.4s

Executed 1 out of 1 test: 1 test passes.
INFO: Build completed successfully, 7 total actions
```

# ゲーム内容
2チームに分かれて行うゲーム  
1チームは最低2名。上限はなし。

5 x 5 = 25枚のカードを場に正方形の形にして展開  
各カードにはそれぞれ以下意味がある
1. 先行チーム：9枚
2. 後攻チーム：8枚
3. どちらのチームにも属さないカード：7枚
4. 選んだ瞬間敗北カード：1枚

別で用意されたMapping tableに、各カードがどれに属するか記載されている  

各チームから代表1名を選出し  
代表は**ヒント**と**選択できる数**の2つを宣言する  
ただし、ヒントは単語であり、英語での言い換えなどはNGとする

代表以外のメンバーはヒントから推測し自身のチームに属するカードを選択する  
１ターンで選択できるのは**代表者が宣言した数+1枚**まで

# 実装内容
1. 未ログインページ
    1. ゲームの紹介ページ
1. 会員登録  
   1. Googleアカウントで登録  
      1. ３アカウントの種類が存在
         1. フリーアカウント  
            1. 無料で利用できるアカウント  
         1. スタンダートアカウント  
            1. 200円/月かかるアカウント  
1. ログイン  
1. ログアウト  
1. ゲーム画面  
   1. 初期表示
      1. フリーアカウント  
         1. おんなじ言葉の組み合わせなら無料
      1. スタンダートアカウント
         1. 何回でも組み合わせ変えてやれまっせ
      1. 1クリック100円でシャッフルできるのだ
   1. ゲーム自体の実装
      1. ゲーム開始時
         1. 代表
            1. 色付きのカード配置
         1. プレイヤー
            1. 色のついていないカード配置
      1. ヒント考えるターン
         1. 代表
            1. 単語と数を入力できる
         1. プレイヤー
            1. thinking画面
      1. 回答ターン
         1. 代表
            1. 色付きのカード配置
         1. プレイヤー
            1. 色のついていないカード配置
            1. カード選択可能
            1. 決定ボタン
      1. 結果表示
         
      