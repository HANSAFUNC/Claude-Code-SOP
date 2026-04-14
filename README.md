# SOP 开发规范模板

> 基于 Superpowers Pipeline v6.1 的通用开发规范模板
> **可一键复制到任何项目，实现标准化开发流程**

---

## 📋 目录

- [快速开始](#快速开始)
- [一键复制到新项目](#一键复制到新项目)
- [项目结构](#项目结构)
- [开发流程](#开发流程)
- [常用命令](#常用命令)
- [文档索引](#文档索引)

---

## 🚀 快速开始

### 前提条件

| 工具 | 用途 |
|------|------|
| Claude Code | AI 辅助开发 |
| Superpowers 插件 | 三阶段硬门禁流程 |

### 环境配置

```bash
# 安装 Claude Code
npm install -g @anthropics/claude-code

# 配置 API Key
export ANTHROPIC_API_KEY=your_api_key
```

---

## 📦 一键复制到新项目

### 使用方法

```bash
# 从本项目复制 SOP 模板到目标项目
./scripts/copy-sop-template.sh <目标项目路径>

# 示例
./scripts/copy-sop-template.sh ~/projects/my-app
./scripts/copysop-template.sh /path/to/another-project
```

### 复制内容

脚本会复制以下文件和目录：

| 目录 | 文件数 | 内容 |
|------|--------|------|
| `CLAUDE.md` | 1 | 开发规范模板 (v3.5) |
| `.claude/CLAUDE.md` | 1 | Claude 配置 |
| `Architect/` | 1 | 架构模板指引 |
| `PRD/` | 1 | 产品需求模板 |
| `Design/` | 1 | UI 设计稿模板 |
| `Docs/SOP/` | 7 | 标准操作流程 |
| `Docs/Guides/` | 2 | 培训文档 + 团队协作 |
| `Docs/Records/` | 1 | 模块变更记录模板 |
| `Docs/superpowers/` | 3 | specs/plans/reviews 模板 |

**总计：18 个 .md 文件**

### 复制后的目录结构

模板会复制到目标项目的 `sop-template/` 独立目录，与应用源码分离：

```
<目标项目>/
├── sop-template/                  # SOP 模板目录 (独立)
│   ├── CLAUDE.md                  # 开发规范模板 (v3.5)
│   ├── .claude/
│   │   └── CLAUDE.md              # Claude 配置
│   ├── Architect/
│   │   └── README.md              # 架构模板指引
│   ├── PRD/
│   │   └── README.md              # 产品需求模板
│   ├── Design/
│   │   └── README.md              # UI 设计稿模板
│   └── Docs/
│       ├── SOP/                   # 标准操作流程
│       │   ├── README.md
│       │   ├── 01-roles.md        # 团队角色与职责
│       │   ├── 02-flow.md         # 开发流程 (v3.5)
│       │   ├── 03-gates.md        # 质量门禁 + 审查
│       │   ├── 04-standards.md    # 测试/Commit/代码规范
│       │   ├── 05-worktree.md     # Git Worktree 规范
│       │   └── 06-operations.md   # 人工操作指南
│       ├── Guides/                # 团队指南
│       │   ├── superpowers-training.md
│       │   └── team-collaboration.md
│       ├── Records/               # 模块变更记录
│       │   └── README.md
│       └── superpowers/           # Pipeline 目录
│           ├── specs/README.md    # 设计规格模板
│           ├── plans/README.md    # 实施计划模板
│           └── reviews/README.md  # 审查报告模板
│
└── [应用源码目录]/                 # 项目实际源码 (上一级)
    ├── src/
    ├── ios/                       # iOS 原生代码
    ├── android/                   # Android 原生代码
    └── ...
```

### 复制后操作

1. **检查已复制的文件是否正确**

2. **在 sop-template/ 目录下运行 Claude Code**
   ```bash
   cd sop-template
   claude
   ```

3. **根据项目现有代码风格调整规范 (Phase 0 规范探索)**
   - 分析上一级目录的应用源码结构
   - 提取命名约定
   - 提取设计模式
   - 提取平台约定
   - 全员确认签字 (HARD-GATE 0')

4. **在 Architect/ 目录创建架构设计文档**
   - `ArchitectureDesign.md`
   - `APIDesign.md` (如需要)

5. **运行 `/superpowers` 开始新功能开发**

---

## 📁 项目结构

```
.
├── .claude/                    # Claude Code 配置
│   ├── agents/                 # Agent 角色定义
│   ├── rules/                  # 项目规则
│   ├── settings.json           # 设置
│   ├── teams/                  # 团队配置
│   └── CLAUDE.md               # 项目指令
├── Architect/                  # 架构设计文档
├── Design/                     # UI 设计稿
├── Docs/                       # 团队规范文档
│   ├── SOP/                    # 标准操作流程 (6 文档)
│   ├── Guides/                 # 协作指南
│   ├── Records/                # 模块变更记录
│   ├── Tests/                  # 测试计划
│   └── superpowers/            # Pipeline 目录
│       ├── specs/              # 设计规格
│       ├── plans/              # 实施计划
│       └── reviews/            # 审查报告
├── PRD/                        # 产品需求文档
├── scripts/                    # 工具脚本
│   └── copy-sop-template.sh    # 一键复制脚本
├── CLAUDE.md                   # 核心指令 (v3.5)
└── README.md                   # 本文件
```

---

## 🔄 开发流程

### 三阶段硬门禁流程

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Superpowers 三阶段硬门禁开发流程                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Phase 1: Design      HARD-GATE 1      Phase 2: Planning                   │
│  /superpowers     ─────────────────→   /writing-plans                      │
│       ↓            "禁止未批准实施"          实施计划文档                     │
│  设计规格文档                              ↓                               │
│                                        HARD-GATE 2                         │
│                                    "计划必须可构建"                          │
│                                             ↓                               │
│  Phase 3: Implement  ─────────────→   HARD-GATE 3                          │
│  /tdd /debug /verify     ↓             "规格合规 + 代码质量"                 │
│       ↓             Git Worktree                                            │
│  双阶段审查           隔离机制                                               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 场景选择决策树

```
是否是新功能? ──── 是 → 完整三阶段流程 (Phase 1-3)
    │
    否
    │
是否是 Bug? ──── 是 → Bug 修复流程 (/debug + /verify)
    │
    否
    │
改动范围 >10%? ──── 是 → 改版流程 (Phase 1-3 简化版)
    │
    否
    │
小改动流程 (直接执行)
```

### 旧项目接入流程 (Phase 0)

```
Phase 0: 规范探索      HARD-GATE 0'     后续开发
    │                      ↓                  │
    ↓                 人工确认签字             ↓
分析现有代码  ─────────────────→   按确认规范继续
提取约定
定义兼容规范
    │
    ↓
产出规范文档
```

---

## 🛠️ 常用命令

### 启动开发流程

```bash
# 新功能开发
/superpowers

# Bug 修复
/debug

# 验证功能
/verify
```

### Git 操作

```bash
# 查看状态
git status

# 提交更改
git add .
git commit -m "feat: 描述更改"

# 推送远程
git push origin main
```

### Commit 规范

采用 Conventional Commits:

| Type | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat: 添加用户管理` |
| `fix` | Bug 修复 | `fix: 修复认证问题` |
| `refactor` | 重构 | `refactor: 抽取工具函数` |
| `docs` | 文档更新 | `docs: 更新说明` |
| `test` | 测试 | `test: 添加单元测试` |
| `chore` | 构建/依赖 | `chore: 升级依赖` |

---

## 📚 文档索引

### 产品文档

| 文档 | 路径 |
|------|------|
| PRD 目录 | `PRD/README.md` |
| 设计稿 | `Design/README.md` |

### 架构文档

| 文档 | 路径 |
|------|------|
| 架构模板指引 | `Architect/README.md` |

### 团队规范 (SOP)

| 文档 | 路径 | 说明 |
|------|------|------|
| SOP 总览 | `Docs/SOP/README.md` | 流程总览 |
| 团队角色 | `Docs/SOP/01-roles.md` | 角色职责定义 |
| 开发流程 | `Docs/SOP/02-flow.md` | 三阶段流程 (v3.5) |
| 质量门禁 | `Docs/SOP/03-gates.md` | HARD-GATE 定义 |
| 开发规范 | `Docs/SOP/04-standards.md` | 测试/Commit/代码 |
| Worktree | `Docs/SOP/05-worktree.md` | Git 隔离环境 |
| 操作指南 | `Docs/SOP/06-operations.md` | 人工操作步骤 |

### Superpowers Pipeline

| 文档 | 路径 | 说明 |
|------|------|------|
| 设计规格模板 | `Docs/superpowers/specs/README.md` | Phase 1 产出 |
| 实施计划模板 | `Docs/superpowers/plans/README.md` | Phase 2 产出 |
| 审查报告模板 | `Docs/superpowers/reviews/README.md` | Phase 3 产出 |

---

## ⚠️ 硬门禁定义

| 门禁 | 阻塞条件 | 说明 |
|------|----------|------|
| **HARD-GATE 0'** | 规范必须人工确认 | 旧项目接入时，提取的规范需全员签字 |
| **HARD-GATE 1** | 禁止未批准实施 | 设计未通过 = 禁止进入 Planning |
| **HARD-GATE 2** | 计划必须可构建 | 计划未通过 = 禁止进入 Implementation |
| **HARD-GATE 3** | 规格合规 + 代码质量 | 审查未通过 = 禁止合并 |

---

## 🔴 No Placeholders 规则

**禁止以下内容 (必须重新规划):**

| 问题类型 | 示例 | 说明 |
|----------|------|------|
| TBD/模糊 | "TBD: 待确认" | 必须明确定义 |
| 未定义引用 | "类似 Task N" | 必须完整描述 |
| 占位符 | "// ... existing code ..." | 必须写出具体代码 |

---

## 👥 团队角色

| 角色 | 职责 |
|------|------|
| **PM** | 需求定义、PRD 编写 |
| **Architect** | 架构设计、技术评审、代码审查 |
| **Platform Specialist** | 平台特定代码实现、单元测试 |
| **QA** | 测试验证、覆盖率检查 |

---

## 🔗 相关资源

- [Claude Code 官方文档](https://docs.anthropic.com/claude-code)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Superpowers 插件](https://github.com/anthropics/superpowers)

---

**版本**: 2.0  
**更新日期**: 2026-04-14  
**来源**: Superpowers Pipeline v6.1