# AWSでの環境構築手順

1. AMIからインスタンスを起動
   * リージョンを「バージニア北部」等へ変更
   * AMIカタログ画面で「GPU」で検索して任意のAMIを選択
     例：Deep Learning AMI GPU PyTorch 2.0.1 (Ubuntu 20.04) 20230613
   * 「AMIでインスタンスを起動」を押下  
   ◆各種設定  
   * キーペア  
     なければ新規で作る  
     名前は何でも良い  
     タイプ：RSA　ファイル形式はOpenSSHなら.pem、PuTTYなら.ppk  
   * ネットワーク設定→編集  
     VPC：デフォルト  
     サブネット：us-east1-[a~d]のどれか  
     パブリックIPの自動割当：有効化（インスタンスのIPが起動の度に変わる？）  
     ファイアウォール(セキュリティグループ)：  
       インバウンドセキュリティグループのルール：  
         タイプ：すべてのトラフィック　に変更  
         ソースタイプ：任意の場所、もしくは自分のIP  
   * ストレージ  
     300GiBに変更  

   すべて設定したら最下部のインスタンスを起動をクリック  
  
2.SSH接続  
  * SSHクライアントでインスタンスに接続する  
    起動状態のインスタンスの「接続 → SSHクライアント」の例をコピペしてくる  
    例：ssh -i "test02.pem" ubuntu@ec2-44-203-24-38.compute-1.amazonaws.com　←ココ  

    * 今回はteratermでやる  
    * ご使用のインスタンスの パブリック DNS を使用してインスタンスに接続: ec2-44-203-24-38.compute-1.amazonaws.com　←ココをコピペ  
    * teraterm起動時の〇〇のとこにパブリックDNSをペースト  
    * ユーザー名は ubuntu  
    * パスワードは無し  
      これで繋がるはず  
  
3. Docker install  
   以下でDockerをインストール  
   [Docker install 手順](https://sid-fm.com/support/vm/guide/install-docker-ubuntu.html#repository)  
  
4.githubの設定  
  * ssh-keyの生成  
    ```  
    ssh-keygen -t rsa  
    ```  
  * githubへ公開鍵を登録　下のコマンドでクリックボードに登録される  
    ```
    cat ~/.ssh/id_rsa.pub
    ```
  * git clone  
    ```
    git clone git@github.com:KotaOkamoto/for-learning.git
    ```
  * クローンしたディレクトリに移動  
    ```
    cd for-learning
    ```
  * docker-composeする  
    docker-compose.ymlがあるディレクトリで  
    ```
    docker-compose up -d
    ```
  * コンテナへ入る  
    ```
    docker exec -it pytorch-container bash  
    ```
  * コンテナ内でjupyterlabを実行する  
    ```
    jupyter-lab --ip="0.0.0.0" --allow_root
    ```

  * http://[ec2のホスト]:8888 へアクセス  
    ※アクセスできない場合はセキュリティグループでタイプが「すべてのタイプ」になってるか確認  

  * データのダウンロード  
    ```
    wget -P ${APP_DIR}/data -i luna_file_path.txt
    ```

  * データの解凍は標準のunzipではできないので7zipをインストール
    ```
    apt install p7zip-full
    ```

  * 解凍
    ```
    7z x '*.zip'
    ```
    ディレクトリ作りたかったら -o の後にスペースを入れずにディレクトリ名を入力  
    ディレクトリがなければ作成される
    ```
    7z x -odir_name '*.zip'
    ```




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
