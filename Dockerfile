# 使用 mcr.microsoft.com/playwright/python:v1.50.0-jammy 作为基础镜像
FROM mcr.microsoft.com/playwright/python:v1.50.0-jammy

# 安装 pocketbase
WORKDIR /app
RUN apt-get update && apt-get install -y wget unzip && \
    wget https://github.com/pocketbase/pocketbase/releases/download/v0.23.4/pocketbase_0.23.4_linux_amd64.zip && \
    unzip pocketbase_0.23.4_linux_amd64.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/pocketbase && \
    rm pocketbase_0.23.4_linux_amd64.zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 创建必要的目录
RUN mkdir -p /pb/pb_data /pb/pb_migrations /pb_public /pb_hooks /app/core /app/work_dir

# 复制 core 目录内容
COPY ./core /app/core

# 安装 Python 依赖
WORKDIR /app/core
RUN pip install -r requirements.txt

# 复制启动脚本
COPY ./start.sh /app/
RUN chmod +x /app/start.sh

# 设置环境变量
ENV PB_API_BASE=http://localhost:8090
ENV PROJECT_DIR=/app/work_dir

# 暴露 pocketbase 端口
EXPOSE 8090

# 启动服务
CMD ["/app/start.sh"] 