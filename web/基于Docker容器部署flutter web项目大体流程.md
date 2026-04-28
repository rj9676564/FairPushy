## 基于 Docker 与 GitHub Actions 部署 Flutter Web

这份文档不再介绍“手工在服务器里装 Flutter 和 Nginx 再编译”的老流程，而是改成：

1. 用 GitHub Actions 自动构建 `web` 镜像
2. 用多阶段 Dockerfile 完成 Flutter Web 编译和 Nginx 静态托管
3. 部署环境只负责拉镜像并启动容器

### 一、产物说明

仓库内已经补齐以下文件：

- `web/Dockerfile`
- `web/nginx/default.conf`
- `docker-compose.yml`
- `.github/workflows/docker-images.yml`

其中：

- `web/Dockerfile` 负责 Flutter Web 编译和 Nginx 运行时镜像制作
- `web/nginx/default.conf` 提供静态站点和单页路由回退配置
- `docker-compose.yml` 负责本地一键拉起 Server + Web，数据库使用外部 MySQL
- `docker-images.yml` 负责在 GitHub Actions 中构建并推送镜像

### 二、镜像构建方式

`web/Dockerfile` 使用多阶段构建：

1. 构建阶段使用 Flutter 镜像执行 `flutter pub get` 和 `flutter build web`
2. 运行阶段使用 `nginx:alpine` 承载 `build/web` 产物

这样做的好处：

- 部署环境不需要安装 Flutter
- 最终镜像体积更小
- 发布链路和本地开发链路分离更清晰

### 三、GitHub Actions 触发方式

工作流文件：`.github/workflows/docker-images.yml`

默认触发条件：

- push 到 `main`
- push tag，格式如 `v1.0.0`
- 手动触发 `workflow_dispatch`

工作流会自动：

1. 检出代码
2. 构建 `web` 镜像
3. 登录 `ghcr.io`
4. 推送镜像到 `ghcr.io/<owner>/fairpushy-web`

默认标签策略：

- 分支名标签
- Git tag 标签
- `sha-<commit>`
- 默认分支上的 `latest`

### 四、本地构建验证

本地可以先直接验证镜像：

```bash
docker build -f web/Dockerfile -t fairpushy-web:local web
docker run --rm -p 8081:80 fairpushy-web:local
```

浏览器访问：

```text
http://127.0.0.1:8081
```

健康检查地址：

```text
http://127.0.0.1:8081/healthz
```

### 五、部署环境使用方式

部署机只需要拉镜像并启动：

```bash
docker pull ghcr.io/<owner>/fairpushy-web:latest

docker run -d \
  --name fairpushy-web \
  -p 80:80 \
  ghcr.io/<owner>/fairpushy-web:latest
```

### 六、推荐发布流程

推荐用下面这个流程：

1. 合并代码到 `main`
2. 打 `vX.Y.Z` tag
3. GitHub Actions 自动产出 `web` 镜像
4. 部署环境执行 `docker pull` + `docker run`

这样发布链路会比旧方案简单很多：

- 不再需要在服务器里手工安装 Flutter
- 不再需要手工编译 `build/web`
- 不再需要手工复制静态资源到 Nginx 目录

### 七、补充说明

如果后续 `web` 需要：

- 自定义域名
- HTTPS 证书
- 反向代理到 `server`
- 缓存策略或 gzip/brotli

建议继续在 `web/nginx/default.conf` 上扩展，而不是把这些逻辑重新写回部署文档里。

### 八、本地一键启动

如果要直接验证整套容器链路，可以在仓库根目录执行：

```bash
docker compose up --build
```

默认端口：

- `web`：`http://127.0.0.1:8081`
- `server`：`http://127.0.0.1:8080`

注意：

- `web` 当前接口地址仍然是 `127.0.0.1:8080`
- `server` 依赖外部 MySQL，启动前需要注入 `MYSQL_*` 环境变量
- 所以浏览器从宿主机访问 `http://127.0.0.1:8081` 时，请求会打到宿主机映射出来的 `server:8080`
