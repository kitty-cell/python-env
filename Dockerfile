FROM --platform=linux/arm64 python:3.9.10-slim
WORKDIR /app
COPY . .
ENV TZ=Asia/Shanghai
CMD ["python"]
