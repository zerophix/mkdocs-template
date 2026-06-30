#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# MkDocs 项目文档骨架初始化脚本
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 用法：
#   ./init-docs.sh <目标项目路径> [options]
#
# 选项：
#   --site-name "项目名"   站点名称（默认使用目录名）
#   --author "作者"        作者名（默认 zerophix）
#   --force                覆盖已存在的 docs/ 目录
#   --no-claude            不生成 CLAUDE.md
#
# 示例：
#   ./init-docs.sh /path/to/my-project --site-name "My API" --author "zerophix"
#   ./init-docs.sh . --site-name "当前项目" --force
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

# ── 颜色 ──
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()  { printf "${BLUE}[INFO]${NC}  %s\n" "$*"; }
ok()    { printf "${GREEN}[OK]${NC}    %s\n" "$*"; }
warn()  { printf "${YELLOW}[WARN]${NC}  %s\n" "$*"; }
error() { printf "${RED}[ERROR]${NC} %s\n" "$*"; exit 1; }

# ── 默认值 ──
TEMPLATE_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR=""
SITE_NAME=""
AUTHOR="zerophix"
FORCE=false
NO_CLAUDE=false

# ── 解析参数 ──
while [[ $# -gt 0 ]]; do
  case $1 in
    --site-name) SITE_NAME="$2"; shift 2 ;;
    --author) AUTHOR="$2"; shift 2 ;;
    --force) FORCE=true; shift ;;
    --no-claude) NO_CLAUDE=true; shift ;;
    -*) error "未知选项: $1" ;;
    *) TARGET_DIR="$1"; shift ;;
  esac
done

# ── 校验 ──
[[ -z "$TARGET_DIR" ]] && error "用法: $0 <目标项目路径> [--site-name \"项目名\"] [--author \"作者\"]"
[[ -z "$SITE_NAME" ]] && SITE_NAME="$(basename "$TARGET_DIR")"

# ── Banner ──
echo ""
echo "━━━ MkDocs 文档骨架初始化 ━━━"
echo ""
echo "  目标项目: $TARGET_DIR"
echo "  站点名称: $SITE_NAME"
echo "  作者:     $AUTHOR"
echo "  强制覆盖: $FORCE"
echo ""

# ── 创建目标目录 ──
mkdir -p "$TARGET_DIR"

# ── 冲突检测 ──
if [[ -d "$TARGET_DIR/docs" ]]; then
  if $FORCE; then
    warn "docs/ 已存在，--force 覆盖中..."
    rm -rf "$TARGET_DIR/docs"
  else
    info "目标项目已有 docs/ 目录。"
    info "确认覆盖？(y/N) "
    read -r confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
      info "已取消。使用 --force 跳过确认。"
      exit 0
    fi
    rm -rf "$TARGET_DIR/docs"
  fi
fi

# ── 步骤 1：复制目录结构 ──
info "[1/5] 创建文档目录结构..."
mkdir -p "$TARGET_DIR/docs"/{architecture,guides,reference,changelog,notes}
cp -r "$TEMPLATE_DIR/docs/" "$TARGET_DIR/docs/"
ok "目录结构已创建"

# ── 步骤 2：生成 mkdocs.yml ──
info "[2/5] 生成 mkdocs.yml..."
cp "$TEMPLATE_DIR/mkdocs.yml" "$TARGET_DIR/mkdocs.yml"
if [[ "$(uname)" == "Darwin" ]]; then
  sed -i '' "s/{PROJECT_NAME}/$SITE_NAME/g" "$TARGET_DIR/mkdocs.yml"
  sed -i '' "s/{PROJECT_DESC}/$SITE_NAME 项目文档/g" "$TARGET_DIR/mkdocs.yml"
  sed -i '' "s/{AUTHOR}/$AUTHOR/g" "$TARGET_DIR/mkdocs.yml"
  sed -i '' "s/{PROJECT_NAME}/$SITE_NAME/g" "$TARGET_DIR/docs/index.md"
  sed -i '' "s/{PROJECT_DESC}/$SITE_NAME 项目文档/g" "$TARGET_DIR/docs/index.md"
else
  sed -i "s/{PROJECT_NAME}/$SITE_NAME/g" "$TARGET_DIR/mkdocs.yml"
  sed -i "s/{PROJECT_DESC}/$SITE_NAME 项目文档/g" "$TARGET_DIR/mkdocs.yml"
  sed -i "s/{AUTHOR}/$AUTHOR/g" "$TARGET_DIR/mkdocs.yml"
  sed -i "s/{PROJECT_NAME}/$SITE_NAME/g" "$TARGET_DIR/docs/index.md"
  sed -i "s/{PROJECT_DESC}/$SITE_NAME 项目文档/g" "$TARGET_DIR/docs/index.md"
fi
ok "mkdocs.yml 已生成"

# ── 步骤 3：复制 CLAUDE.md ──
if $NO_CLAUDE; then
  info "[3/5] 跳过 CLAUDE.md（--no-claude）"
else
  info "[3/5] 复制 AI 规则文件 (CLAUDE.md)..."
  if [[ -f "$TEMPLATE_DIR/CLAUDE.md" ]]; then
    cp "$TEMPLATE_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
    ok "CLAUDE.md 已创建"
  else
    warn "模板中无 CLAUDE.md，跳过"
  fi
fi

# ── 步骤 4：更新 .gitignore ──
info "[4/5] 更新 .gitignore..."
GITIGNORE="$TARGET_DIR/.gitignore"
if [[ -f "$GITIGNORE" ]]; then
  if ! grep -q "^site/" "$GITIGNORE" 2>/dev/null; then
    echo "" >> "$GITIGNORE"
    echo "# MkDocs 构建输出" >> "$GITIGNORE"
    echo "site/" >> "$GITIGNORE"
    ok ".gitignore 已追加 site/"
  else
    ok ".gitignore 已有 site/，跳过"
  fi
else
  cat > "$GITIGNORE" << 'EOF'
# MkDocs 构建输出
site/
EOF
  ok ".gitignore 已创建"
fi

# ── 步骤 5：requirements.txt ──
info "[5/5] 检查 requirements.txt..."
if [[ ! -f "$TARGET_DIR/requirements.txt" ]]; then
  cat > "$TARGET_DIR/requirements.txt" << 'EOF'
mkdocs>=1.6
mkdocs-material>=9.7
mkdocs-git-revision-date-localized-plugin
mkdocs-minify-plugin
EOF
  ok "requirements.txt 已创建"
else
  # 检查是否已有 mkdocs 依赖
  if grep -q "^mkdocs" "$TARGET_DIR/requirements.txt" 2>/dev/null; then
    ok "requirements.txt 已有 mkdocs 依赖，跳过"
  else
    warn "requirements.txt 已存在但缺少 mkdocs，请手动添加"
  fi
fi

# ── 完成 ──
echo ""
echo "━━━ 完成 ━━━"
echo ""
echo "后续步骤："
echo "  cd $TARGET_DIR"
echo "  pip install -r requirements.txt"
echo "  mkdocs serve"
echo ""
echo "CLAUDE.md 已包含核心文档规则，AI 工具会自动读取。"
echo "完整规范详见 docs/DOC-GUIDE.md。"
echo ""
