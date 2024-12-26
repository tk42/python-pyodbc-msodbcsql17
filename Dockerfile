FROM --platform=linux/amd64 python:3.13-bookworm

# システムのパッケージを更新と必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    gnupg2 \
    curl \
    wget \
    unixodbc \
    unixodbc-dev \
    tdsodbc \
    apt-utils \
    && apt-get clean -y

# Microsoft SQL Server の依存関係をインストール（修正版）
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/keyrings/microsoft.gpg \
    && chmod go+r /etc/apt/keyrings/microsoft.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
    > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update

# MSODBCドライバーのインストール
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18

# odbcinst.iniの設定
ADD odbcinst.ini /etc/odbcinst.ini

# pip3のアップグレードとpyodbcのインストール
RUN pip3 install --upgrade pip && pip install pyodbc

# 作業ディレクトリを設定
WORKDIR /app

CMD ["bash"]
