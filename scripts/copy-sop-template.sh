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
#   - 复制 Docs/SOP/ 标准操作流程文档
#   - 复制 docs/superpowers/ Pipeline 目录结构
#   - 复制 Architect/ 架构模板指引
#   - 自动创建必要的目录结构
#
# ============================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# 定义要复制的文件和目录
FILES_TO_COPY=(
    # CLAUDE.md 模板
    "CLAUDE.md"
    ".claude/CLAUDE.md"
    # Architect 模板指引
    "Architect/README.md"
    # SOP 文档
    "Docs/SOP/README.md"
    "Docs/SOP/01-roles.md"
    "Docs/SOP/02-flow.md"
    "Docs/SOP/03-gates.md"
    "Docs/SOP/04-standards.md"
    "Docs/SOP/05-worktree.md"
    "Docs/SOP/06-operations.md"
    # Superpowers 目录结构
    "docs/superpowers/specs/README.md"
    "docs/superpowers/plans/README.md"
    "docs/superpowers/reviews/README.md"
)

# 统计计数
COPIED_COUNT=0
SKIPPED_COUNT=0
CREATED_DIRS=0

echo -e "${YELLOW}开始复制...${NC}"
echo ""

for FILE in "${FILES_TO_COPY[@]}"; do
    SOURCE_FILE="$SOURCE_DIR/$FILE"
    TARGET_FILE="$TARGET_DIR/$FILE"

    # 检查源文件是否存在
    if [ ! -f "$SOURCE_FILE" ]; then
        echo -e "${RED}  ✗ 源文件不存在: $FILE${NC}"
        continue
    fi

    # 创建目标目录（如果不存在）
    TARGET_PARENT="$(dirname "$TARGET_FILE")"
    if [ ! -d "$TARGET_PARENT" ]; then
        mkdir -p "$TARGET_PARENT"
        CREATED_DIRS=$((CREATED_DIRS + 1))
    fi

    # 检查目标文件是否已存在
    if [ -f "$TARGET_FILE" ]; then
        echo -e "${YELLOW}  ⚠ 覆盖: $FILE${NC}"
    else
        echo -e "${GREEN}  ✓ 新建: $FILE${NC}"
    fi

    # 复制文件
    cp "$SOURCE_FILE" "$TARGET_FILE"
    COPIED_COUNT=$((COPIED_COUNT + 1))
done

echo ""
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}  复制完成！${NC}"
echo -e "${GREEN}============================================================${NC}"
echo ""
echo -e "复制文件: ${BLUE}$COPIED_COUNT${NC} 个"
echo -e "创建目录: ${BLUE}$CREATED_DIRS${NC} 个"
echo ""

# 显示目标目录结构
echo -e "${YELLOW}目标目录结构:${NC}"
echo ""
echo "  $TARGET_DIR/"
echo "  ├── CLAUDE.md                    # 开发规范模板"
echo "  ├── .claude/"
echo "  │   └── CLAUDE.md                # Claude 配置"
echo "  ├── Architect/"
echo "  │   └── README.md                # 架构模板指引"
echo "  ├── Docs/"
echo "  │   └── SOP/                     # 标准操作流程"
echo "  │       ├── README.md"
echo "  │       ├── 01-roles.md"
echo "  │       ├── 02-flow.md"
echo "  │       ├── 03-gates.md"
echo "  │       ├── 04-standards.md"
echo "  │       ├── 05-worktree.md"
echo "  │       └── 06-operations.md"
echo "  └── docs/"
echo "      └── superpowers/             # Pipeline 目录"
echo "          ├── specs/README.md"
echo "          ├── plans/README.md"
echo "          └── reviews/README.md"
echo ""

# 提示下一步操作
echo -e "${YELLOW}下一步操作:${NC}"
echo ""
echo "1. 检查已复制的文件是否正确"
echo "2. 根据项目现有代码风格调整规范:"
echo "   - 分析现有目录结构"
echo "   - 提取命名约定"
echo "   - 提取设计模式"
echo "   - 更新 Architect/README.md"
echo ""
echo "3. 在项目根目录创建以下目录 (如不存在):"
echo "   - PRD/      # 产品需求文档"
echo "   - Design/   # UI 设计稿"
echo ""
echo "4. 运行 /superpowers 开始新功能开发"
echo ""

echo -e "${GREEN}完成！${NC}"