# ベースイメージを指定
FROM ubuntu:24.04

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

# Pythonパッケージ一覧とオリジナル演習の題材をコンテナにコピー
COPY . .

# 仮想環境下で必要なPythonパッケージをインストール
RUN python3 -m venv /venv \
    && /venv/bin/pip install --upgrade pip \
    && /venv/bin/pip install --no-cache-dir -r requirements.txt

# Jupyterの設定ファイルを生成し，ログイン用のトークン（hoge）を設定
RUN /venv/bin/jupyter notebook --generate-config \
    && echo "c.NotebookApp.token = 'hoge'" > /root/.jupyter/jupyter_notebook_config.py

# GitHub上に公開されている演習の題材をclone
RUN git clone https://github.com/fchollet/deep-learning-with-python-notebooks.git subject-github

# ポートの指定
EXPOSE 8888

# Jupyter Notebookの起動
CMD ["/venv/bin/jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]