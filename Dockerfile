FROM python:3.13-bookworm

# システムのパッケージを更新
RUN apt-get update

# PYODBC関連の依存パッケージをインストール
RUN apt-get install -y tdsodbc unixodbc-dev
RUN apt-get clean -y
ADD odbcinst.ini /etc/odbcinst.ini

# pip3をアップグレード
RUN pip3 install --upgrade pip

# Microsoft製品のリポジトリを追加するための準備
RUN apt-get install -y apt-transport-https gnupg2 curl wget

# Microsoftの署名キーを正しく追加（修正版）
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/microsoft-archive-keyring.gpg \
    && echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/debian/12/prod/ bookworm main" > /etc/apt/sources.list.d/microsoft-prod.list \
    && apt-get update

# SQL Server 2016向けのODBCドライバーをインストール（修正版）
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18

# SQL Server toolsのパスを環境変数に追加
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile 
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# pyodbcをインストール
RUN pip install pyodbc

# 作業ディレクトリを設定
WORKDIR /app

CMD ["bash"]