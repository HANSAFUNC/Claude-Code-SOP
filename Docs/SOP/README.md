# SOP - 标准操作流程

> 团队协作开发的标准操作流程文档 (v2.0 - Superpowers Pipeline)

---

## 📁 文档目录

| 文件 | 说明 | 版本 |
|------|------|------|
| [01-roles.md](./01-roles.md) | 团队角色与职责 | v1.0 |
| [02-flow.md](./02-flow.md) | 开发流程详解 (三阶段硬门禁) | **v2.0** |
| [03-review.md](./03-review.md) | 代码审查流程 | v1.0 |
| [04-testing.md](./04-testing.md) | 测试标准与规范 | v1.0 |
| [05-commit.md](./05-commit.md) | Commit 规范 | v1.0 |
| [06-gates.md](./06-gates.md) | 质量门禁定义 (硬门禁) | **v2.0** |
| [07-worktree.md](./07-worktree.md) | Git Worktree 使用规范 | **v1.0 新增** |
| [08-manual-operations.md](./08-manual-operations.md) | 人工操作步骤指南 | **v1.0 新增** |
| [version-history.md](./version-history.md) | 版本迭代记录 | **v1.0 新增** |

---

## 🔄 流程总览 (v2.0)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Superpowers 三阶段硬门禁开发流程                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Phase 1: Design      HARD-GATE 1      Phase 2: Planning                   │
│  (brainstorming)   ─────────────────→   (writing-plans)                    │
│       ↓                  ↓                    ↓                            │
│  设计规格文档      "禁止未批准实施"          实施计划文档                     │
│                                             ↓                               │
│                                        HARD-GATE 2                          │
│                                     "计划必须可构建"                         │
│                                             ↓                               │
│  Phase 3: Implement  ─────────────────→  HARD-GATE 3                        │
│  (SDD)                  ↓             "规格合规 + 代码质量"                  │
│       ↓             Git Worktree                                            │
│  双阶段审查           隔离机制                                               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 阶段说明

| 阶段 | 输入 | 输出 | 门禁 |
|------|------|------|------|
| **Phase 1: Design** | PRD/Design | `docs/superpowers/specs/*.md` | HARD-GATE 1 |
| **Phase 2: Planning** | 设计规格 | `docs/superpowers/plans/*.md` | HARD-GATE 2 |
| **Phase 3: Implementation** | 实施计划 | 代码 + 测试 | HARD-GATE 3 |

---

## ⚠️ 硬门禁定义

| 门禁 | 阻塞条件 | 检查文档 |
|------|----------|----------|
| **HARD-GATE 1** | 禁止未批准实施 | [06-gates.md](./06-gates.md#2-hard-gate-1-design-approved) |
| **HARD-GATE 2** | 计划必须可构建 | [06-gates.md](./06-gates.md#3-hard-gate-2-plan-buildable) |
| **HARD-GATE 3** | 规格合规 + 代码质量 | [06-gates.md](./06-gates.md#4-hard-gate-3-spec-compliance--code-quality) |

---

## 🔴 核心规则

### No Placeholders 规则

**禁止以下内容:**

| 问题类型 | 示例 | 说明 |
|----------|------|------|
| TBD/模糊 | "TBD: 待确认" | 必须明确定义 |
| 未定义引用 | "类似 Task N" | 必须完整描述 |
| 占位符 | "// ... existing code ..." | 必须写出具体代码 |

### 任务粒度要求

```
每个任务: 2-5 分钟
遵循: RED-GREEN-REFACTOR 循环
```

---

## 📚 相关文档

| 文档类型 | 路径 |
|----------|------|
| Superpowers 规格目录 | `docs/superpowers/specs/README.md` |
| Superpowers 计划目录 | `docs/superpowers/plans/README.md` |
| Superpowers 审查目录 | `docs/superpowers/reviews/README.md` |
| 团队协作指南 | `../Guides/team-collaboration.md` |
| Superpowers 培训指南 | `../Guides/superpowers-training.md` |
| 产品需求文档 | `../../PRD/README.md` |
| 架构设计文档 | `../../Architect/ArchitectureDesign.md` |

---

## 📊 版本历史

| 版本 | 日期 | 变更说明 | 详细比对 |
|------|------|----------|----------|
| v2.0 | 2026-04-13 | 引入 Superpowers Pipeline，三阶段硬门禁 | [查看详情](./version-history.md#v10--v20-版本对比) |
| v1.0 | 2026-03-20 | 初始版本，六阶段软门禁 | [查看详情](./version-history.md) |

**完整版本迭代记录:** [version-history.md](./version-history.md)

---

**版本**: 2.0
**更新日期**: 2026-04-13
**适用范围**: 跨平台移动开发团队
**来源**: Superpowers Pipeline v6.1