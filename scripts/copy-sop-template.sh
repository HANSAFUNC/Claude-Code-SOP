#!/bin/bash

# ============================================================
# SOP Template Copy Script
# 一键复制 Superpowers Pipeline 模板到任何项目
# ============================================================
#
# 使用方法:
#   ./copy-sop-template.sh <目标项目路径>
#
# 示例:
#   ./copy-sop-template.sh ~/projects/my-app
#   ./copy-sop-template.sh /path/to/another-project
#
# 功能:
#   - 复制 CLAUDE.md 开发规范模板
#   - 复制 .claude/CLAUDE.md Claude 配置
#   - 复制 Architect/ 架构模板指引
#   - 复制 Design/ 设计稿目录模板
#   - 复制 PRD/ 产品需求目录模板
#   - 复制 Docs/ 全部文档 (SOP/Guides/Records/superpowers)
#   - 自动创建必要的目录结构
#
# ============================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 获取脚本所在目录（模板源目录）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$(dirname "$SCRIPT_DIR")"

# 检查参数
if [ -z "$1" ]; then
    echo -e "${RED}错误: 未指定目标项目路径${NC}"
    echo ""
    echo "使用方法:"
    echo "  $0 <目标项目路径>"
    echo ""
    echo "示例:"
    echo "  $0 ~/projects/my-app"
    echo "  $0 /path/to/another-project"
    exit 1
fi

TARGET_DIR="$1"

# 检查目标目录是否存在
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}错误: 目标目录不存在: $TARGET_DIR${NC}"
    exit 1
fi

# 转换为绝对路径
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  SOP Template Copy Script${NC}"
echo -e "${BLUE}  Superpowers Pipeline v6.1${NC}"
echo -e "${BLUE}============================================================${NC}"
echo ""
echo -e "源目录: ${GREEN}$SOURCE_DIR${NC}"
echo -e "目标目录: ${GREEN}$TARGET_DIR${NC}"
echo ""

# 统计计数
COPIED_FILES=0
COPIED_DIRS=0

# 复制单个文件的函数
copy_file() {
    local SRC="$1"
    local DST="$2"
    local DESC="$3"

    if [ ! -f "$SRC" ]; then
        echo -e "${RED}  ✗ 源文件不存在: $SRC${NC}"
        return 1
    fi

    # 创建目标目录
    local DST_DIR="$(dirname "$DST")"
    if [ ! -d "$DST_DIR" ]; then
        mkdir -p "$DST_DIR"
        COPIED_DIRS=$((COPIED_DIRS + 1))
    fi

    # 如果目标文件已存在，先删除
    if [ -f "$DST" ]; then
        rm -f "$DST"
        echo -e "${YELLOW}  ⚠ 覆盖: $DESC${NC}"
    else
        echo -e "${GREEN}  ✓ 新建: $DESC${NC}"
    fi
    cp "$SRC" "$DST"
    COPIED_FILES=$((COPIED_FILES + 1))
}

# 复制目录的函数 (先删除目标目录，再复制所有 .md 文件)
copy_dir() {
    local SRC_DIR="$1"
    local DST_DIR="$2"
    local DESC="$3"

    if [ ! -d "$SRC_DIR" ]; then
        echo -e "${RED}  ✗ 源目录不存在: $SRC_DIR${NC}"
        return 1
    fi

    # 统计该目录下的 .md 文件数
    local MD_COUNT=$(find "$SRC_DIR" -name "*.md" -type f | wc -l | tr -d ' ')

    # 如果目标目录已存在，先删除所有 .md 文件
    if [ -d "$DST_DIR" ]; then
        find "$DST_DIR" -name "*.md" -type f -delete 2>/dev/null || true
        # 删除空目录
        find "$DST_DIR" -type d -empty -delete 2>/dev/null || true
        echo -e "${YELLOW}  ⚠ 覆盖: $DESC ($MD_COUNT 个 .md 文件)${NC}"
    else
        mkdir -p "$DST_DIR"
        COPIED_DIRS=$((COPIED_DIRS + 1))
        echo -e "${GREEN}  ✓ 新建: $DESC ($MD_COUNT 个 .md 文件)${NC}"
    fi

    # 确保目标目录存在
    mkdir -p "$DST_DIR"

    # 复制所有 .md 文件，保持目录结构
    find "$SRC_DIR" -name "*.md" -type f | while read MD_FILE; do
        local REL_PATH="${MD_FILE#$SRC_DIR/}"
        local TARGET_FILE="$DST_DIR/$REL_PATH"
        local TARGET_PARENT="$(dirname "$TARGET_FILE")"

        if [ ! -d "$TARGET_PARENT" ]; then
            mkdir -p "$TARGET_PARENT"
        fi

        cp "$MD_FILE" "$TARGET_FILE"
    done

    COPIED_FILES=$((COPIED_FILES + MD_COUNT))
}

echo -e "${YELLOW}开始复制...${NC}"
echo ""

echo -e "${CYAN}[核心配置文件]${NC}"
copy_file "$SOURCE_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md" "CLAUDE.md (开发规范模板)"
copy_file "$SOURCE_DIR/.claude/CLAUDE.md" "$TARGET_DIR/.claude/CLAUDE.md" ".claude/CLAUDE.md"

echo ""
echo -e "${CYAN}[架构模板]${NC}"
copy_dir "$SOURCE_DIR/Architect" "$TARGET_DIR/Architect" "Architect/ (架构模板指引)"

echo ""
echo -e "${CYAN}[产品需求目录]${NC}"
copy_dir "$SOURCE_DIR/PRD" "$TARGET_DIR/PRD" "PRD/ (产品需求模板)"

echo ""
echo -e "${CYAN}[设计稿目录]${NC}"
copy_dir "$SOURCE_DIR/Design" "$TARGET_DIR/Design" "Design/ (UI 设计稿模板)"

echo ""
echo -e "${CYAN}[文档目录 Docs/]${NC}"
copy_dir "$SOURCE_DIR/Docs" "$TARGET_DIR/Docs" "Docs/ (完整文档目录)"

echo ""
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}  复制完成！${NC}"
echo -e "${GREEN}============================================================${NC}"
echo ""
echo -e "复制文件: ${BLUE}$COPIED_FILES${NC} 个 .md 文件"
echo -e "创建目录: ${BLUE}$COPIED_DIRS${NC} 个新目录"
echo ""

# 显示目标目录结构
echo -e "${YELLOW}目标目录结构:${NC}"
echo ""
cat << 'STRUCTURE'
  <目标项目>/
  ├── CLAUDE.md                     # 开发规范模板 (v3.5)
  ├── .claude/
  │   └── CLAUDE.md                 # Claude 配置
  ├── Architect/
  │   └── README.md                 # 架构模板指引
  ├── PRD/
  │   └── README.md                 # 产品需求模板
  ├── Design/
  │   └── README.md                 # UI 设计稿模板
  └── Docs/
      ├── SOP/                      # 标准操作流程
      │   ├── README.md
      │   ├── 01-roles.md           # 团队角色与职责
      │   ├── 02-flow.md            # 开发流程 (v3.5)
      │   ├── 03-gates.md           # 质量门禁 + 审查
      │   ├── 04-standards.md       # 测试/Commit/代码规范
      │   ├── 05-worktree.md        # Git Worktree 规范
      │   └── 06-operations.md      # 人工操作指南
      ├── Guides/                   # 团队指南
      │   ├── superpowers-training.md
      │   └── team-collaboration.md
      ├── Records/                  # 模块变更记录
      │   └── README.md
      ├── Tests/                    # 测试相关 (空目录)
      └── superpowers/              # Pipeline 目录
          ├── specs/README.md       # 设计规格模板
          ├── plans/README.md       # 实施计划模板
          └── reviews/README.md     # 审查报告模板
STRUCTURE
echo ""

# 提示下一步操作
echo -e "${YELLOW}下一步操作:${NC}"
echo ""
echo "1. 检查已复制的文件是否正确"
echo "2. 根据项目现有代码风格调整规范 (Phase 0 规范探索):"
echo "   - 分析现有目录结构"
echo "   - 提取命名约定"
echo "   - 提取设计模式"
echo "   - 提取平台约定"
echo "   - 全员确认签字 (HARD-GATE 0')"
echo ""
echo "3. 在 Architect/ 目录创建架构设计文档:"
echo "   - ArchitectureDesign.md"
echo "   - APIDesign.md (如需要)"
echo ""
echo "4. 运行 /superpowers 开始新功能开发"
echo ""
echo -e "${GREEN}完成！${NC}"