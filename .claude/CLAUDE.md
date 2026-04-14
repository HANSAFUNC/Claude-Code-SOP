# CLAUDE.md - 项目开发规范模板

> 使用 Superpowers Pipeline v6.1 驱动开发流程，强制执行三阶段硬门禁。
> **此模板可移植到任何项目，项目接入时请根据现有代码风格进行调整。**

---

## 🚀 核心指令

### 新功能开发

**每次开发新功能时，必须调用 Superpowers：**

```bash
/superpowers
```

Superpowers 将强制执行三阶段硬门禁流程：**Design → Planning → Implementation**

---

## 📚 文档索引

### 产品需求 (项目接入时创建)

| 文档 | 路径 | 说明 |
|------|------|------|
| PRD 目录 | `PRD/README.md` | 产品需求文档 |
| 设计稿目录 | `Design/README.md` | UI 设计稿 |

### 架构设计 (项目接入时创建)

| 文档 | 路径 | 说明 |
|------|------|------|
| 架构设计 | `Architect/ArchitectureDesign.md` | 整体架构设计 |
| API 设计 | `Architect/APIDesign.md` | API 接口设计 |

> **注意:** 架构设计文档需在 Phase 0 规范探索阶段从现有代码提取并创建。

### Superpowers Pipeline

| 文档 | 路径 | 说明 |
|------|------|------|
| 设计规格目录 | `docs/superpowers/specs/README.md` | 设计规格模板 |
| 设计规格文档 | `docs/superpowers/specs/YYYY-MM-DD-*-design.md` | 各功能设计规格 |
| 实施计划目录 | `docs/superpowers/plans/README.md` | 实施计划模板 |
| 实施计划文档 | `docs/superpowers/plans/YYYY-MM-DD-*.md` | 各功能实施计划 |
| 审查报告目录 | `docs/superpowers/reviews/README.md` | 审查报告模板 |
| 审查报告文档 | `docs/superpowers/reviews/YYYY-MM-DD-*-review.md` | 各功能审查报告 |

### 团队规范 (SOP)

| 文档 | 路径 | 说明 |
|------|------|------|
| SOP 总览 | `Docs/SOP/README.md` | 流程总览 |
| 团队角色 | `Docs/SOP/01-roles.md` | 角色职责定义 |
| 开发流程 (v3.5) | `Docs/SOP/02-flow.md` | 三阶段流程 + 其他场景 |
| 质量门禁 + 审查 | `Docs/SOP/03-gates.md` | HARD-GATE 定义 |
| 测试 + Commit 规范 | `Docs/SOP/04-standards.md` | 开发规范 |
| Git Worktree 规范 | `Docs/SOP/05-worktree.md` | 隔离环境使用 |
| 人工操作指南 | `Docs/SOP/06-operations.md` | 详细操作步骤 |

---

## 📋 开发流程 (v3.5)

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

## ✅ 硬门禁检查清单

### HARD-GATE 0': 规范确认 (旧项目接入)

```text
☐ 目录结构分析完成
☐ 命名约定提取完成
☐ 设计模式提取完成
☐ 平台约定提取完成
☐ API 风格定义完成
☐ 数据模型风格定义完成
☐ 兼容规范文档产出
☐ 渐进迁移策略定义
☐ 全员逐项确认签字
```

### HARD-GATE 1: Design Approved

```text
☐ 完整性: 无 TBD 或占位符
☐ 一致性: 无内部矛盾
☐ YAGNI: 无过度设计
☐ 需求覆盖: 覆盖 PRD 所有需求
☐ 技术可行: 技术可实现
☐ Architect 批准签字
```

### HARD-GATE 2: Plan Buildable

```text
☐ No Placeholders: 无 TBD/模糊描述/占位符
☐ 可构建性: 工程师可无阻塞执行
☐ 规格对齐: 覆盖设计规格所有需求
☐ 任务粒度: 每任务 2-5 分钟
☐ RED-GREEN-REFACTOR: 包含完整测试循环
☐ Architect 批准签字
```

### HARD-GATE 3: Spec Compliance + Code Quality

**Stage 1: Spec Compliance**

```text
☐ 满足设计规格所有需求
☐ 数据模型一致
☐ API 接口一致
☐ UI/UX 实现一致
```

**Stage 2: Code Quality**

```text
☐ 代码规范通过
☐ 测试覆盖率 ≥80%
☐ 无 CRITICAL/HIGH 安全漏洞
☐ 性能无回归
```

---

## 📝 Commit 规范

采用 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

```text
<type>: <description>
```

**Types:**

| Type | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat: add course list page` |
| `fix` | Bug 修复 | `fix: resolve login token issue` |
| `refactor` | 重构 | `refactor: extract utility functions` |
| `docs` | 文档更新 | `docs: update README` |
| `test` | 测试相关 | `test: add unit tests` |
| `chore` | 构建/工具 | `chore: update dependencies` |
| `perf` | 性能优化 | `perf: improve rendering` |
| `ci` | CI/CD | `ci: add GitHub Actions` |

---

## 🧪 测试要求

| 要求项 | 标准 |
|--------|------|
| **最低覆盖率** | 80% |
| **测试类型** | 单元测试 + UI 测试 |
| **测试框架** | 平台对应框架 (XCTest/JUnit/Hypium) |
| **CI 验证** | 所有测试必须通过 |

---

## 📁 目录规范

```text
项目根目录/
├── .claude/                    # Claude 配置
│   ├── agents/                 # 项目专用 agents (可选)
│   ├── rules/                  # 项目规则 (可选)
│   ├── teams/                  # 团队配置 (可选)
│   └── CLAUDE.md               # 本文件
├── docs/                       # 文档目录
│   └── superpowers/            # Superpowers Pipeline 文档
│       ├── specs/              # 设计规格 (Phase 1 产出)
│       ├── plans/              # 实施计划 (Phase 2 产出)
│       └── reviews/            # 审查报告 (Phase 3 产出)
├── PRD/                        # 产品需求文档 (项目接入时创建)
├── Design/                     # UI 设计稿 (项目接入时创建)
├── Architect/                  # 架构设计文档 (Phase 0 产出)
├── Docs/                       # 团队规范文档 (SOP 模板)
│   ├── SOP/                    # 标准操作流程
│   ├── Guides/                 # 团队指南 (可选)
│   └── Records/                # 模块变更记录 (可选)
└── [应用源码目录]               # 应用代码 (项目特定)
```

---

## 🔀 异常处理

### HARD-GATE 未通过

```text
门禁失败 → 阅读驳回原因 → 修复 → 重新提交审查 → 通过后继续
```

### 任务执行失败

```text
任务失败 → /debug 调试修复 → 或 ExitWorktree 丢弃重来 → 继续执行
```

---

## 🔄 渐进式规范化策略

| 优先级 | 适用范围 | 要求 |
|--------|----------|------|
| **优先级 1** | 新代码 | ✅ 强制遵循新规范 |
| **优先级 2** | 改版代码 | ⚠️ 逐步迁移到新规范 |
| **优先级 3** | 旧代码 | 🔄 保持原风格，不强制重构 |

---

**版本**: 3.5
**更新日期**: 2026-04-14
**来源**: Superpowers Pipeline v6.1
**说明**: 通用可移植模板 - 项目接入时根据现有代码风格调整