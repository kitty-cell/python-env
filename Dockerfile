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
# FROM --platform=linux/amd64 python:3.12.7-slim-bullseye

# ENV PYTHONDONTWRITEBYTECODE=1 \
#     PYTHONUNBUFFERED=1 \
#     PIP_DISABLE_PIP_VERSION_CHECK=1 \
#     PIP_NO_CACHE_DIR=1

# WORKDIR /app

# COPY requirements.txt /app/requirements.txt

# RUN python -m pip install \
#         --no-cache-dir \
#         --default-timeout=100 \
#         -i https://pypi.tuna.tsinghua.edu.cn/simple \
#         -r /app/requirements.txt \
#     && rm -f /app/requirements.txt

# COPY . /app
FROM --platform=linux/amd64 python:3.12.7-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

COPY requirements.txt /tmp/requirements.txt

RUN python -m pip install --no-compile \
        --index-url https://download.pytorch.org/whl/cu128 \
        torch==2.11.0 \
    && python -m pip install --no-compile \
        -r /tmp/requirements.txt \
        tabpfn==8.5.0 \
        xgboost-cu12==3.4.1 \
    && python -m pip check \
    && rm -f /tmp/requirements.txt

CMD ["python"]
