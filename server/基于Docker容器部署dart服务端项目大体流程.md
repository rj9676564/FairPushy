## 基于 Docker 与 GitHub Actions 部署 Dart Server

这份文档改成两件事：

1. `server` 镜像由 GitHub Actions 自动构建并推送到 `GHCR`
2. 数据库配置在**运行容器时**通过环境变量注入，不再把账号密码写死在镜像里

### 一、产物说明

仓库内已经补齐以下文件：

- `server/Dockerfile`
- `docker-compose.yml`
- `.github/workflows/docker-images.yml`

其中：

- `server/Dockerfile` 负责把 Dart Server 编译成可运行镜像
- `docker-compose.yml` 负责本地一键拉起 Server + Web，数据库使用外部 MySQL
- `docker-images.yml` 负责在 GitHub Actions 中构建并推送镜像

### 二、数据库环境变量

Server 启动时会优先读取以下环境变量，并在启动时生成 `settings.yaml`：

- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `MYSQL_HOST`
- `MYSQL_PORT`
- `MYSQL_DATABASE`

示例：

```bash
docker run -d \
  --name fairpushy-server \
  -p 8080:8080 \
  -e MYSQL_USER=fair_pushy \
  -e MYSQL_PASSWORD=replace_me \
  -e MYSQL_HOST=127.0.0.1 \
  -e MYSQL_PORT=3306 \
  -e MYSQL_DATABASE=fair_pushy \
  ghcr.io/<owner>/fairpushy-server:latest
```

### 三、GitHub Actions 触发方式

工作流文件：`.github/workflows/docker-images.yml`

默认触发条件：

- push 到 `main`
- push tag，格式如 `v1.0.0`
- 手动触发 `workflow_dispatch`

工作流会自动：

1. 检出代码
2. 构建 `server` 镜像
3. 登录 `ghcr.io`
4. 推送镜像到 `ghcr.io/<owner>/fairpushy-server`

默认标签策略：

- 分支名标签
- Git tag 标签
- `sha-<commit>`
- 默认分支上的 `latest`

### 四、镜像发布前准备

请先确认：

1. GitHub 仓库已开启 `Packages`
2. Actions 对仓库具备 `packages: write` 权限
3. 如果组织策略有限制，允许 `GITHUB_TOKEN` 推送 GHCR

一般情况下，当前 workflow 使用内置 `GITHUB_TOKEN` 就可以完成推送，不需要额外配置 Docker 用户名密码。

### 五、本地构建验证

如果要先在本地确认镜像可用，可以执行：

```bash
docker build -f server/Dockerfile -t fairpushy-server:local server
```

然后带上数据库环境变量启动：

```bash
docker run --rm \
  -p 8080:8080 \
  -e MYSQL_USER=fair_pushy \
  -e MYSQL_PASSWORD=replace_me \
  -e MYSQL_HOST=127.0.0.1 \
  -e MYSQL_PORT=3306 \
  -e MYSQL_DATABASE=fair_pushy \
  fairpushy-server:local
```

服务正常启动后，可以检查：

```bash
curl http://127.0.0.1:8080/app/patch
```

### 六、推荐发布流程

推荐用下面这个流程：

1. 合并代码到 `main`
2. 打 `vX.Y.Z` tag
3. GitHub Actions 自动产出镜像
4. 部署环境只负责 `docker pull` 和注入数据库环境变量

这样可以把“构建镜像”和“运行镜像”彻底拆开，部署侧不再需要手工编译 Dart 项目。

### 七、本地一键启动

如果你要在本地快速验证整套容器链路，可以直接在仓库根目录执行：

```bash
docker compose up --build
```

默认会启动：

- `server`：`8080`
- `web`：`8081`

访问地址：

```text
http://127.0.0.1:8081
```

注意：

- `docker-compose.yml` 只负责把基础环境拉起来
- `MYSQL_USER`、`MYSQL_PASSWORD`、`MYSQL_HOST`、`MYSQL_DATABASE` 需要在启动前注入
- 数据表仍然需要按 `server/README.md` 中的建表说明初始化
