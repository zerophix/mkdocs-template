# 项目文档规范

本项目使用 MkDocs 管理文档。**AI 在创建或修改文档时必须遵守本规范。**

---

## 目录结构

```
docs/
├── index.md              # 项目仪表盘（入口，先读）
├── DOC-GUIDE.md         # 完整文档规范（新项目必读一次）
├── architecture/         # 系统长什么样
├── guides/               # 怎么开发/使用
├── reference/            # 具体接口/配置
├── changelog/            # 发生了什么变化
└── notes/                # 为什么这么决定
```

## AI 行为规则

### 读
1. 操作文档前先读 `docs/index.md` 了解项目概况
2. 新项目先通读一次 `docs/DOC-GUIDE.md` 了解规范全貌

### 写
3. 新文档必须放入上述 5 个目录之一，禁止在 `docs/` 根创建独立文件
4. 已有相关文档时优先更新而非新建
5. 一次操作最多新建 3 个文档，避免碎片
6. 文件命名 `kebab-case`，禁止中文文件名（如 `data-model.md`）

### 格式
7. 每个文档必须有 Front Matter
   ```yaml
   ---
   title: "文档标题"
   status: draft   # draft | review | stable | archive
   ---
   ```
8. 不确定的内容标注 `<!-- TODO: 待确认 -->`
9. 代码块必须标注语言（如 ` ```python `）
10. 链接使用相对路径（如 `[架构概览](../architecture/index.md)`）

### 同步（极易遗漏！）
11. 新增/删除 `.md` 后必须同步更新 `mkdocs.yml` 的 `nav` 节
12. 新增/删除 `.md` 后必须同步更新所在目录的 `index.md`
13. 修改文档内容后必须在 `changelog/index.md` 追加记录

## 文档模板

```markdown
---
title: "文档标题"
status: draft
---

# 文档标题

> 一句话摘要

---

## 正文

...
```

## 目录职责速查

| 目录 | 回答的问题 | 典型内容 |
|------|-----------|---------|
| `architecture/` | 系统长什么样 | 架构图、数据模型、技术选型、部署方案 |
| `guides/` | 怎么开发/使用 | 环境搭建、编码规范、操作教程 |
| `reference/` | 具体参数是什么 | API 签名、配置项列表、错误码 |
| `changelog/` | 发生了什么变化 | 按时间倒序的版本变更 |
| `notes/` | 为什么这么决定 | 调研笔记、ADR、踩坑记录 |

## 变更日志格式

遵循 [Keep a Changelog](https://keepachangelog.com/)，按时间倒序：

```markdown
## YYYY-MM-DD

### 新增
- 功能描述 (`path/to/file.md`)

### 变更
- 修改描述

### 修复
- 修复描述
```

## 操作检查清单

每次文档操作后对照：

- [ ] 内容放对了目录（不要越界）
- [ ] 文件 `kebab-case` 命名
- [ ] Front Matter 完整（title + status）
- [ ] `mkdocs.yml` 的 `nav` 已同步
- [ ] 所在目录的 `index.md` 已更新
- [ ] `changelog/index.md` 已追加
- [ ] 不确定内容标注了 `<!-- TODO -->`
