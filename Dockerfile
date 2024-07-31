# 使用Alpine作为基础镜像
FROM alpine:latest

# 设置时区环境变量
ENV TZ=Asia/Shanghai

# 安装必要的软件包，包括ca证书、时区数据、curl、jq和unzip
RUN apk --no-cache --no-progress add \
    ca-certificates \
    tzdata \
    curl \
    jq \
    unzip

# 设置系统时区
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 设置工作目录
WORKDIR /agent

# 下载Nezha Agent最新版本的URL并下载二进制文件
RUN LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/nezhahq/agent/releases/latest | jq -r '.assets[] | select(.name | test("nezha-agent_linux_amd64.zip")) | .browser_download_url') && \
    echo $LATEST_RELEASE_URL && \
    curl -L $LATEST_RELEASE_URL -o nezha-agent.zip && \
    unzip nezha-agent.zip && \
    chmod +x nezha-agent && \
    rm nezha-agent.zip

# 创建入口点脚本
RUN echo '#!/bin/sh' > entrypoint.sh && \
    echo 'CMD="/agent/nezha-agent"' >> entrypoint.sh && \
    echo 'if [ -n "$SKIP_PROCS" ]; then CMD="$CMD --skip-procs"; fi' >> entrypoint.sh && \
    echo 'if [ -n "$DISABLE_COMMAND_EXECUTE" ]; then CMD="$CMD --disable-command-execute"; fi' >> entrypoint.sh && \
    echo 'if [ -n "$REPORT_DELAY" ]; then CMD="$CMD --report-delay $REPORT_DELAY"; fi' >> entrypoint.sh && \
    echo 'if [ -n "$TLS" ]; then CMD="$CMD --tls"; fi' >> entrypoint.sh && \
    echo 'if [ -n "$SKIP_CONN" ]; then CMD="$CMD --skip-conn"; fi' >> entrypoint.sh && \
    echo 'if [ -n "$DISABLE_AUTO_UPDATE" ]; then CMD="$CMD --disable-auto-update"; fi' >> entrypoint.sh && \
    echo 'if [ -n "$DISABLE_FORCE_UPDATE" ]; then CMD="$CMD --disable-force-update"; fi' >> entrypoint.sh && \
    echo 'if [ -n "$USE_IPV6_COUNTRYCODE" ]; then CMD="$CMD --use-ipv6-countrycode"; fi' >> entrypoint.sh && \
    echo 'if [ -n "$GPU" ]; then CMD="$CMD --gpu"; fi' >> entrypoint.sh && \
    echo 'if [ -n "$TEMPERATURE" ]; then CMD="$CMD --temperature"; fi' >> entrypoint.sh && \
    echo 'if [ -n "$DEBUG" ]; then CMD="$CMD -d"; fi' >> entrypoint.sh && \
    echo 'if [ -n "$IP_REPORT_PERIOD" ]; then CMD="$CMD --ip-report-period $IP_REPORT_PERIOD"; fi' >> entrypoint.sh && \
    echo 'if [ -n "$INSECURE" ]; then CMD="$CMD -k"; fi' >> entrypoint.sh && \
    echo 'if [ -n "$NZ_GRPC_URL" ]; then CMD="$CMD -s $NZ_GRPC_URL"; fi' >> entrypoint.sh && \
    echo 'if [ -n "$NZ_CLIENT_SECRET" ]; then CMD="$CMD -p $NZ_CLIENT_SECRET"; fi' >> entrypoint.sh && \
    echo 'exec $CMD' >> entrypoint.sh && \
    chmod +x entrypoint.sh

# 设置容器启动时执行的命令
ENTRYPOINT ["/agent/entrypoint.sh"]
