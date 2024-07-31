# nezha-agent-docker-auto
nezha-agent-docker-auto

## Nezha Agent Docker部署指南

Nezha Agent 是一个开源的服务器监控工具，可以通过Docker进行部署，以实现对服务器的状态监控和管理。本文档提供了如何使用Docker Compose和Docker Run命令来部署Nezha Agent的详细步骤。

### 1. Docker Compose 配置示例

Docker Compose 是一个用于定义和运行多容器Docker应用程序的工具。使用以下YAML文件，您可以轻松地配置和启动Nezha Agent容器。

```yaml
version: '3.8'

services:
  nezha-agent:
    image: vpsss/nezha-agent:latest
    container_name: nezha-agent
    environment:
      - NZ_GRPC_URL=https://your-grpc-url.example.com
      - NZ_CLIENT_SECRET=your_client_secret
      - REPORT_DELAY=3
      - SKIP_PROCS=true
      - DISABLE_COMMAND_EXECUTE=true
      - TLS=true
      - GPU=false
      - TEMPERATURE=false
      - DEBUG=false
      - INSECURE=false
      - USE_IPV6_COUNTRYCODE=false
      - IP_REPORT_PERIOD=1800
```

配置参数详解
+ NZ_GRPC_URL: gRPC服务器的URL。
+ NZ_CLIENT_SECRET: 客户端密钥。
+ REPORT_DELAY: 上报数据的时间间隔（秒）。
+ SKIP_PROCS: 是否忽略进程监控。
+ DISABLE_COMMAND_EXECUTE: 是否禁用命令执行功能。
+ TLS: 是否开启TLS加密传输。
+ GPU: 是否监控GPU使用情况。
+ TEMPERATURE: 是否监控硬件温度。
+ DEBUG: 是否启用调试模式。
+ INSECURE: 是否禁用安全证书检查。
+ USE_IPV6_COUNTRYCODE: 是否使用IPv6地址来查询国家代码。
+ IP_REPORT_PERIOD: IP地址信息的更新周期（秒）。

### 2.使用 Docker Run 启动
如果您更倾向于不使用Docker Compose，以下是一个docker run命令的示例，用于启动Nezha Agent容器。

```
docker run -d --name nezha-agent \
  -e NZ_GRPC_URL=https://your-grpc-url.example.com \
  -e NZ_CLIENT_SECRET=your_client_secret \
  -e REPORT_DELAY=3 \
  -e SKIP_PROCS=true \
  -e DISABLE_COMMAND_EXECUTE=true \
  -e TLS=true \
  -e GPU=false \
  -e TEMPERATURE=false \
  -e DEBUG=false \
  -e INSECURE=false \
  -e USE_IPV6_COUNTRYCODE=false \
  -e IP_REPORT_PERIOD=1800 \
  vpsss/nezha-agent:latest
```

无论您是选择使用Docker Compose还是直接通过Docker命令行部署，Nezha Agent 都能为您提供灵活而强大的服务器监控解决方案。根据您的具体需求调整环境变量，以确保最佳的监控效果。


