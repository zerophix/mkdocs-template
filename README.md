# MkDocs Template - 项目文档模板

> **一个开箱即用的 MkDocs 文档站模板，专为项目文档管理设计，支持 GitHub Pages 自动部署。**

[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Deployed-blue?logo=github)](https://zerophix.github.io/mkdocs-template/)
[![MkDocs](https://img.shields.io/badge/MkDocs-1.6+-green?logo=mkdocs)](https://www.mkdocs.org/)
[![Material for MkDocs](https://img.shields.io/badge/Material_for_MkDocs-9.7+-blue?logo=material-design)](https://squidfunk.github.io/mkdocs-material/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

---

## 📖 项目简介

这是一个 **MkDocs 文档站模板**，提供了标准化的项目文档结构和规范，包含：

- 📁 **标准化目录结构** - 架构设计、开发指南、参考文档、变更日志、笔记五大板块
- 📝 **完整的文档规范** - 包含 AI 协作规则、文档生命周期、命名规范等
- 🎨 **Material for MkDocs 主题** - 现代化 UI、暗色模式、代码高亮、搜索增强
- 🚀 **GitHub Pages 一键部署** - 推送即部署，零配置
- 🔧 **实用插件集成** - Git 版本日期、HTML 压缩、中英文搜索

**在线预览**: https://zerophix.github.io/mkdocs-template/

---

## 🗂️ 目录结构

```
mkdocs-template/
├── mkdocs.yml              # MkDocs 配置文件
├── requirements.txt        # Python 依赖
├── init-docs.sh            # 初始化脚本（复制到新项目使用）
├── CLAUDE.md               # AI 协作规则（给 AI 看的）
├── README.md               # 本文件
├── docs/                   # 文档源文件
│   ├── index.md            # 项目仪表盘（首页）
│   ├── DOC-GUIDE.md        # 完整文档规范（必读）
│   ├── architecture/       # 架构设计 —— "系统是什么样的"
│   │   └── index.md
│   ├── guides/             # 开发指南 —— "怎么开发/使用"
│   │   └── index.md
│   ├── reference/          # 参考文档 —— "具体接口/配置是什么"
│   │   └── index.md
│   ├── changelog/          # 变更日志 —— "发生了什么变化"
│   │   └── index.md
│   └── notes/              # 笔记 —— "为什么这么决定"
│       └── index.md
└── site/                   # 构建输出（自动生成，勿提交）
```

### 五大板块职责速查

| 目录 | 回答的问题 | 典型内容 |
|------|-----------|---------|
| `architecture/` | 系统长什么样 | 架构图、数据模型、技术选型、部署方案 |
| `guides/` | 怎么开发/使用 | 环境搭建、编码规范、操作教程 |
| `reference/` | 具体参数是什么 | API 签名、配置项列表、错误码 |
| `changelog/` | 发生了什么变化 | 按时间倒序的版本变更记录 |
| `notes/` | 为什么这么决定 | 调研笔记、ADR、踩坑记录 |

---

## 🚀 快速开始

### 方式一：作为模板创建新项目（推荐）

```bash
# 1. 克隆或下载此模板
git clone https://github.com/zerophix/mkdocs-template.git my-project-docs
cd my-project-docs

# 2. 运行初始化脚本（自动替换项目名、作者等占位符）
./init-docs.sh . --site-name "我的项目" --author "你的名字"

# 3. 安装依赖
pip install -r requirements.txt

# 4. 本地预览
mkdocs serve
# 打开 http://127.0.0.1:8000
```

### 方式二：直接在现有项目中使用

```bash
# 复制 docs/ 目录结构和配置到现有项目
cp -r mkdocs-template/docs/ your-project/
cp mkdocs-template/mkdocs.yml your-project/
cp mkdocs-template/requirements.txt your-project/
cp mkdocs-template/CLAUDE.md your-project/

# 修改 mkdocs.yml 中的 site_name、site_url、repo_url 等配置
# 然后安装依赖并预览
cd your-project
pip install -r requirements.txt
mkdocs serve
```

---

## 🛠️ 本地开发

### 安装依赖

```bash
# 推荐使用虚拟环境
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

### 常用命令

```bash
mkdocs serve          # 本地预览（热重载）
mkdocs build          # 构建静态站点到 site/
mkdocs gh-deploy      # 部署到 GitHub Pages
mkdocs --help         # 查看所有命令
```

---

## 📦 部署到 GitHub Pages

### 自动部署（推荐）

本模板已配置 `mkdocs gh-deploy`，一键部署：

```bash
mkdocs gh-deploy --force
```

这会：
1. 构建静态站点到 `site/`
2. 推送到 `gh-pages` 分支
3. GitHub Pages 自动发布

**访问地址**：`https://<你的用户名>.github.io/<仓库名>/`

> ⚠️ 首次部署前需在 GitHub 仓库 Settings → Pages 中将 Source 设为 "Deploy from a branch"，选择 `gh-pages` 分支。

### 手动部署（CI/CD）

也可配置 GitHub Actions 自动部署，参考 `.github/workflows/docs.yml`（需自行创建）。

---

## ⚙️ 配置说明

### 核心配置 (`mkdocs.yml`)

```yaml
site_name: "{PROJECT_NAME}"           # 站点名称
site_description: "{PROJECT_DESC}"    # 站点描述（SEO）
site_author: "{AUTHOR}"               # 作者
site_url: "https://zerophix.github.io" # 站点 URL（GitHub Pages 必填）
repo_url: "https://github.com/zerophix/mkdocs-template"  # 仓库地址
repo_name: "zerophix/mkdocs-template" # 显示的仓库名
```

### 主题配置

- **主题**: Material for MkDocs
- **语言**: 中文 (zh)
- **配色**: Indigo 主色调，支持亮/暗模式切换
- **字体**: Noto Sans SC (中文) + JetBrains Mono (代码)

### 插件

| 插件 | 作用 |
|------|------|
| `search` | 中英文全文搜索 |
| `git-revision-date-localized` | 显示页面最后更新时间（基于 Git） |
| `minify` | 压缩 HTML/CSS/JS，减小体积 |

### Markdown 扩展

支持：代码高亮、行号、标签页、表情、折叠块、目录、键位、下标/上标、任务列表、表格等。

---

## 🤖 AI 协作规范

本项目包含 `CLAUDE.md` 和 `docs/DOC-GUIDE.md`，定义了 AI 在文档操作时的行为规则：

- **先读后写** - 操作前必须阅读规范和首页
- **目录归属** - 文档必须放入五大目录之一
- **nav 同步** - 新增/删除文档后同步更新 `mkdocs.yml` 和对应目录的 `index.md`
- **Front Matter** - 每个文档必须包含 `title` 和 `status`
- **生命周期** - Draft → Review → Stable → Archive

详见：[CLAUDE.md](CLAUDE.md) | [docs/DOC-GUIDE.md](docs/DOC-GUIDE.md)

---

## 📝 文档编写指南

### 文档模板

```markdown
---
title: "文档标题"
status: draft   # draft | review | stable | archive
---

# 文档标题

> 一句话摘要

---

## 正文内容

...
```

### 命名规范

- 文件名：`kebab-case`（如 `data-model.md`、`api-convention.md`）
- 禁止中文文件名
- 目录下的 `index.md` 作为概览页

### 链接规范

- 内部链接使用相对路径：`[架构概览](../architecture/index.md)`
- 外部链接使用完整 URL

---

## 🔗 相关链接

- **在线文档**: https://zerophix.github.io/mkdocs-template/
- **GitHub 仓库**: https://github.com/zerophix/mkdocs-template
- **MkDocs 官网**: https://www.mkdocs.org/
- **Material for MkDocs**: https://squidfunk.github.io/mkdocs-material/
- **文档规范参考**: https://keepachangelog.com/

---

## 📄 许可证

MIT License - 可自由使用、修改、分发。

---

## 🙏 致谢

- [MkDocs](https://www.mkdocs.org/) - 静态站点生成器
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) - 优秀的主题
- [mkdocs-git-revision-date-localized-plugin](https://github.com/timvink/mkdocs-git-revision-date-localized-plugin) - Git 日期插件
- [mkdocs-minify-plugin](https://github.com/mnessie/mkdocs-minify-plugin) - 压缩插件