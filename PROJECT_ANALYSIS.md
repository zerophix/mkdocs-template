# MkDocs 模板项目分析记录

## 项目概览
这是一个 **MkDocs 文档模板项目**，使用 Material for MkDocs 主题，包含完整的中文文档结构。

## 目录结构
```
mkdocs-template/
├── mkdocs.yml              # MkDocs 配置文件
├── requirements.txt        # Python 依赖 (新增)
├── init-docs.sh           # 初始化脚本
├── .github/workflows/
│   └── docs.yml           # GitHub Actions 部署工作流
└── docs/                  # 文档内容目录
    ├── index.md           # 首页
    ├── DOC-GUIDE.md       # 文档编写指南
    ├── architecture/      # 架构设计
    │   └── index.md
    ├── guides/            # 开发指南
    │   └── index.md
    ├── reference/         # 参考文档
    │   └── index.md
    ├── changelog/         # 变更日志
    │   └── index.md
    └── notes/             # 笔记
        └── index.md
```

## 核心配置 (mkdocs.yml)
- **主题**: Material for MkDocs (Indigo 主色调)
- **语言**: 中文 (zh)
- **插件**:
  - `search` - 全文搜索 (中文分词支持)
  - `git-revision-date-localized` - Git 最后更新时间显示
  - `minify` - HTML/CSS/JS 压缩
- **扩展**: 代码高亮、脚注、表格、任务列表、数学公式、Mermaid 图表等
- **导航结构**: 6 大板块 (首页、架构设计、开发指南、参考文档、变更日志、笔记)

## GitHub Pages 部署
- **部署地址**: https://zerophix.github.io/mkdocs-template/
- **部署分支**: `gh-pages` (由 mkdocs gh-deploy 自动维护)
- **触发条件**: 推送到 `main` 分支
- **工作流**: `.github/workflows/docs.yml`

## 修复记录 (2026-06-30)
**问题**: GitHub Actions 部署失败 - `ERROR: Could not open requirements file: [Errno 2] No such file or directory: 'requirements.txt'`

**解决**: 创建 `requirements.txt` 包含必要依赖：
```
mkdocs==1.6.1
mkdocs-material==9.7.6
mkdocs-git-revision-date-localized-plugin==1.5.3
mkdocs-minify-plugin==0.8.0
```

**验证**: 部署成功，站点返回 HTTP 200

## 待配置占位符
`mkdocs.yml` 中需根据实际项目替换：
- `{PROJECT_NAME}` - 项目名称
- `{PROJECT_DESC}` - 项目描述
- `{AUTHOR}` - 作者
- `{USER}/{REPO}` - GitHub 仓库路径
- 版权信息、社交链接等

## 使用建议
1. 复制此模板作为新项目起点
2. 替换上述占位符
3. 根据需要调整导航结构
4. 推送到 GitHub 即可自动部署文档站点