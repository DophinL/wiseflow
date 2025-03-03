#!/bin/bash

# 启动 pocketbase 在后台
/usr/local/bin/pocketbase serve --http=0.0.0.0:8090 --dir=/pb/pb_data --publicDir=/pb_public --hooksDir=/pb_hooks --migrationsDir=/pb/pb_migrations &

# 等待 pocketbase 启动
sleep 5

# 如果设置了 PB_SUPERUSER_EMAIL 和 PB_SUPERUSER_PASSWORD，创建超级用户
if [ ! -z "$PB_SUPERUSER_EMAIL" ] && [ ! -z "$PB_SUPERUSER_PASSWORD" ]; then
    /usr/local/bin/pocketbase superuser upsert $PB_SUPERUSER_EMAIL $PB_SUPERUSER_PASSWORD --dir=/pb/pb_data
fi

# 设置 PB_API_AUTH 环境变量（如果未设置）
if [ -z "$PB_API_AUTH" ] && [ ! -z "$PB_SUPERUSER_EMAIL" ] && [ ! -z "$PB_SUPERUSER_PASSWORD" ]; then
    export PB_API_AUTH="${PB_SUPERUSER_EMAIL}|${PB_SUPERUSER_PASSWORD}"
fi

# 启动 core 服务
cd /app/core
python run_task.py 