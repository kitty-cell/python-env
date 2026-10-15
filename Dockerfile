FROM --platform=linux/amd64 python:3.9.10-slim
WORKDIR /app

COPY . .

# 添加时区环境变量，亚洲，上海
ENV TimeZone=Asia/Shanghai
# 使用软连接，并且将时区配置覆盖/etc/timezone
RUN ln -snf /usr/share/zoneinfo/$TimeZone /etc/localtime && echo $TimeZone > /etc/timezone

COPY ./config.ini /app/config.ini
CMD ["python"]