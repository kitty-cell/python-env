# # 基于python的基础镜像
# FROM registry.cn-beijing.aliyuncs.com/dkzx_test/tensorflow_gpu_env:2.16.2
# # FROM registry.cn-beijing.aliyuncs.com/dkzx_test/python:python:3.9_load_pre
# # FROM python:3.9-slim
# # 工作目录
# WORKDIR /app
# # 复制所有应用程序文件到工作目录
# COPY . .

# #安装依赖
# RUN pip install --no-cache-dir --default-timeout=100  -r requirements.txt
FROM python:3.10.18-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

COPY requirements_evaluation.txt /app/requirements.txt

RUN python -m pip install \
        --no-cache-dir \
        -i https://pypi.tuna.tsinghua.edu.cn/simple \
        -r /app/requirements.txt \
    && rm -f /app/requirements.txt

COPY . /app


