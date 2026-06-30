# MkDocs 文档模板分发与使用指南

本项目提供三种分发方式，满足不同团队/项目的需求。

---

## 方式一：作为 Git 子模块引入（推荐团队统一规范）

适用场景：组织内多个项目，需强制统一文档规范，模板更新可同步下发。

### 1. 在模板仓库发布 Release（打 Tag）
```bash
git tag -a v1.0.0 -m "发布 v1.0.0 文档模板"
git push origin v1.0.0
```

### 2. 目标项目添加为子模块
```bash
cd /path/to/target-project
git submodule add -b main https://github.com/your-org/mkdocs-template.git .docs-template
git commit -m "chore: 引入 MkDocs 文档模板子模块"
```

### 3. 目标项目添加初始化脚本
```bash
#!/bin/bash
# 放在目标项目根目录，提交到版本控制
set -euo pipefail

TEMPLATE_DIR=".docs-template"
TARGET_DIR="."

# 1. 同步最新模板
git submodule update --remote --merge "$TEMPLATE_DIR"

# 2. 运行模板初始化脚本
"$TEMPLATE_DIR/init-docs.sh" "$TARGET_DIR" --site-name "My Project" --author "Team"

# 3. 提交生成的文档骨架
git add docs/ mkdocs.yml CLAUDE.md requirements.txt .gitignore
git commit -m "docs: 初始化 MkDocs 文档骨架"
```

### 4. 后续升级模板
```bash
cd /path/to/target-project
git submodule update --remote --merge .docs-template
./init-docs.sh . --force  # 重新生成（会覆盖 docs/，慎用）
# 或手动对比 mkdocs.yml / CLAUDE.md 差异后手动合并
```

---

## 方式二：作为 Cookiecutter 模板（推荐新项目快速起步）

适用场景：新建项目时一次性生成完整文档骨架，后续不再同步模板更新。

### 1. 将本项目发布为 Cookiecutter 模板
```bash
# 目录结构调整为 cookiecutter 格式
mkdir -p cookiecutter-mkdocs-docs/{{cookiecutter.project_slug}}
cp -r docs mkdocs.yml init-docs.sh CLAUDE.md requirements.txt cookiecutter-mkdocs-docs/{{cookiecutter.project_slug}}/
# 编辑 cookiecutter.json 定义变量
cat > cookiecutter-mkdocs-docs/cookiecutter.json << 'EOF'
{
  "project_slug": "my-project",
  "project_name": "My Project",
  "project_description": "My Project 文档",
  "author": "zerophix"
}
EOF
# 将 mkdocs.yml / docs/index.md 中的占位符改为 {{cookiecutter.project_name}} 等
```

### 2. 使用者一键生成
```bash
pip install cookiecutter
cookiecutter gh:your-org/cookiecutter-mkdocs-docs
# 交互式输入 project_name, author 等
cd my-project
pip install -r requirements.txt
mkdocs serve
```

---

## 方式三：直接复制脚本文件（最轻量，适合零依赖）

适用场景：不想引入子模块、不想安装 Cookiecutter，仅需一个脚本即可初始化。

### 1. 将 `init-docs.sh` 发布为 Gist 或 Raw 文件
```bash
# 使用者直接在项目根目录运行：
bash <(curl -fsSL https://raw.githubusercontent.com/your-org/mkdocs-template/main/init-docs.sh) . --site-name "My Project" --author "Me"

# 或下载后运行：
curl -fsSL -o init-docs.sh https://raw.githubusercontent.com/your-org/mkdocs-template/main/init-docs.sh
chmod +x init-docs.sh
./init-docs.sh . --site-name "My Project" --author "Me"
```

### 2. 脚本会自动完成
- 创建 `docs/{architecture,guides,reference,changelog,notes}/index.md`
- 生成 `mkdocs.yml`（已替换占位符）
- 生成 `requirements.txt`
- 更新 `.gitignore`（追加 `site/`）
- 复制 `CLAUDE.md`（AI 文档规范）

---

## 自动渲染部署方案对比

| 方案 | 适用平台 | 优点 | 缺点 |
|------|----------|------|------|
| **GitHub Actions + GitHub Pages** | GitHub | 免费、零配置域名、原生集成、支持自定义域名 | 仅限 GitHub 仓库 |
| **GitLab CI + GitLab Pages** | GitLab | 免费、内置 Pages、支持私有仓库 | 仅限 GitLab |
| **Netlify / Vercel / Cloudflare Pages** | 任意 Git | 连接任意 Git 仓库、自动 HTTPS、CDN 全球加速、预览部署 | 需要额外账号配置 |
| **Read the Docs** | 任意 Git | 专业文档托管、版本管理、PDF/EPUB 导出、搜索优索优化 | 免费版有广告、配置稍复杂 |
| **自建服务器 (Nginx + Cron)** | 任意 | 完全可控、内网可用 | 需维护服务器、SSL、域名 |

---

## 推荐：GitHub Actions + GitHub Pages（零成本、最通用）

### 1. 目标项目启用 GitHub Pages
- Settings → Pages → Source: **GitHub Actions**

### 2. 复制工作流文件
将 `.github/workflows/docs.yml` 复制到目标项目同级目录。

### 3. 推送触发部署
```bash
git add .github/workflows/docs.yml
git commit -m "ci: 添加文档自动部署工作流"
git push origin main
```
- 首次部署需在 Actions 页面点击 "Run workflow" 或等待下次 push
- 部署成功后访问：`https://<username>.github.io/<repo-name>/`

### 4. 自定义域名（可选）
- 仓库根目录添加 `CNAME` 文件：`docs.example.com`
- DNS 添加 CNAME 指向 `<username>.github.io`
- GitHub Pages 设置中勾选 "Enforce HTTPS"

---

## 推荐：Netlify（连接任意 Git 仓库、预览部署、免费）

### 1. 登录 Netlify → Add new site → Import from Git
### 2. 选择仓库（GitHub/GitLab/Bitbucket/Azure DevOps）
### 3. 构建设置：
```
Build command: mkdocs build --strict
Publish directory: site
```
### 4. 环境变量（可选）：
```
PYTHON_VERSION: 3.11
```
### 5. 优势
- **PR 预览部署**：每个 PR 自动生成唯一预览链接
- **分支部署**：`main` → 生产环境，`dev` → 预览环境
- **表单/函数/边缘网络** 等增值功能免费额度大

---

## 完整使用示例：新项目从零开始

```bash
# 1. 创建新项目
mkdir my-awesome-api && cd my-awesome-api
git init

# 2. 一键初始化文档（方式三：远程脚本）
bash <(curl -fsSL https://raw.githubusercontent.com/your-org/mkdocs-template/main/init-docs.sh) . \
  --site-name "My Awesome API" \
  --author "Zhang San"

# 3. 安装依赖并本地预览
pip install -r requirements.txt
mkdocs serve  # http://127.0.0.1:8000

# 4. 推送到 GitHub
git add .
git commit -m "feat: 初始化项目文档"
git branch -M main
git remote add origin git@github.com:your-org/my-awesome-api.git
git push -u origin main

# 5. 启用 GitHub Pages（Settings → Pages → GitHub Actions）
# 6. 复制工作流文件
mkdir -p .github/workflows
curl -fsSL -o .github/workflows/docs.yml \
  https://raw.githubusercontent.com/your-org/mkdocs-template/main/.github/workflows/docs.yml
git add .github/workflows/docs.yml
git commit -m "ci: 添加文档自动部署"
git push

# 7. 访问线上文档
# https://your-org.github.io/my-awesome-api/
```

---

## 维护建议

1. **模板版本化**：模板仓库打 Tag（v1.0.0, v1.1.0），目标项目通过子模块或重新运行脚本升级
2. **文档规范强制**：CI 中加入 `markdownlint` / `vale` 检查，PR 必须通过才能合并
3. **多语言扩展**：`mkdocs.yml` 中 `plugins.search.lang: [zh, en]`，目录结构复制为 `docs/en/` `docs/zh/`
4. **版本化文档**：使用 `mike` 或 `mkdocs-versioning` 插件，配合 Git Tag 发布多版本文档

---

## 目录结构速览（分发包含的文件）

```
mkdocs-template/
├── init-docs.sh              # 核心初始化脚本（分发核心）
├── mkdocs.yml                # 模板配置（含占位符）
├── requirements.txt          # Python 依赖
├── CLAUDE.md                 # AI 文档规范（复制到目标项目）
├── .github/workflows/docs.yml  # GitHub Actions 部署工作流
├── .gitlab-ci.yml            # GitLab CI 部署配置
├── DISTRIBUTION.md           # 本文件
└── docs/                     # 文档骨架
    ├── DOC-GUIDE.md          # 完整文档规范
    ├── index.md              # 首页模板
    ├── architecture/index.md
    ├── guides/index.md
    ├── reference/index.md
    ├── changelog/index.md
    └── notes/index.md
```

将整个 `mkdocs-template` 仓库作为**模板仓库**在 GitHub/GitLab 创建，新项目点击 "Use this template" 即可一键拥有完整文档体系 + 自动部署。