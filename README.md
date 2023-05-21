# GCP VertexAI WorkBenchでの学習環境構築
## GCPアカウントの用意

1.gmailアカウントを新規作成
e.g.) gcp01.xxxxxx@gmail.com

2.GCPへログイン https://console.cloud.google.com/welcome

3.新規project作成

4.無料トライアルを始める

5.vertex ai workbench を有効にして利用を始める https://cloud.google.com/vertex-ai-workbench?hl=ja

無料トライアルではGPUが使えなかった、課金アカウントにするべきか

### Vertex AIの設定
ユーザー管理のノートブックの作成
* リージョンはアジア東京へ
* OS：ubuntu
* 環境：PyTorch1.13
* マシンタイプ：n1-standard-4
* GPU：Nvidia T4, GPUの数：1
* ディスク、bootディスク：100、Dataディスク：256
* バックアップ：バケットを作成
* ネットワーキング以降はすべて初期状態のまま

## GCPとgithubの連携
1. SSHキーを生成して登録する
```
# キーの生成
ssh-keygen -t rsa 

# キーの表示
cat ~/.ssh/id_rsa.pub
```

2. githubへ登録
* setting → SSH and GPG keys → New SSH keys
* 名前つけてキーを貼り付けて登録 ssh-rsa ~~ = jupyter@vm-~~ まで

## Git clone
今回はobata01から直接クローンする
```
# クローン
git clone -b pytorch git@github.com:obata01/for-learning.git luna

# ディレクトリ移動
cd luna

# ライブラリのインストール
pip install -r requirement.txt

# 必要なデータのダウンロード
export LUNA_HOME="/home/jupyter/luna"
wget -P ${LUNA_HOME}/data -i luna_file_path.txt

```
