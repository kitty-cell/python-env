# 基于python的基础镜像
FROM python:3.9.19-slim
# 工作目录
WORKDIR /app
# 复制所有应用程序文件到工作目录
COPY . .

#安装依赖
RUN pip install --no-cache-dir --default-timeout=100  -r requirements.txt
# RUN pip install --no-cache-dir --default-timeout=100 -i https://mirrors.aliyun.com/pypi/simple/ -r requirements.txt



