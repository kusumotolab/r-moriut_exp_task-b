# ベースイメージを指定
FROM ubuntu

# 作業ディレクトリを指定
WORKDIR /app

# 必要なパッケージのインストール
RUN apt-get update \
    && apt-get install -y \
    build-essential \
    git \
    musl-dev \
    python3 \
    python3-dev \
    python3-venv \
    nodejs

# 仮想環境を作成し，pipを最新バージョンにアップグレード
RUN python3 -m venv /venv
    && /venv/bin/pip install --upgrade pip

# Pythonパッケージ一覧とソースコード・データセット等をコンテナにコピー
COPY . .

# 必要なPythonパッケージをインストール
RUN /venv/bin/pip install --no-cache-dir -r requirements.txt

# Jupyterの設定ファイルを生成し，ログイン用のトークンを設定
ENV TOKEN="hoge"
RUN /venv/bin/jupyter notebook --generate-config \
    && echo "c.NotebookApp.token = '${TOKEN}'" > /root/.jupyter/jupyter_notebook_config.py

# GitHubからサンプルコードをclone
RUN mkdir sample \
    && cd sample \
    && git clone https://github.com/fchollet/deep-learning-with-python-notebooks.git

# ポートの指定
EXPOSE 8888

# Jupyter Notebookの起動
CMD ["/venv/bin/jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]