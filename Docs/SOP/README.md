# SOP - 标准操作流程

> 团队协作开发的标准操作流程文档 (v3.0 - Superpowers Pipeline 简化版)

---

## 📁 文档目录

| 文件 | 说明 | 版本 |
|------|------|------|
| [01-roles.md](./01-roles.md) | 团队角色与职责 | v1.0 |
| [02-flow.md](./02-flow.md) | 开发流程 (含旧项目接入规范) | **v3.4** |
| [03-gates.md](./03-gates.md) | 质量门禁 + 审查流程 | **v3.0** |
| [04-standards.md](./04-standards.md) | 测试标准 + Commit 规范 + 代码规范 | **v3.0** |
| [05-worktree.md](./05-worktree.md) | Git Worktree 使用规范 | v1.0 |
| [06-operations.md](./06-operations.md) | 人工操作指南 + 培训要点 | **v3.0** |

---

## 🔄 流程总览

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

---

## ⚠️ 硬门禁定义

| 门禁 | 阻塞条件 | 检查文档 |
|------|----------|----------|
| **HARD-GATE 1** | 禁止未批准实施 | [03-gates.md](./03-gates.md#2-hard-gate-1) |
| **HARD-GATE 2** | 计划必须可构建 | [03-gates.md](./03-gates.md#3-hard-gate-2) |
| **HARD-GATE 3** | 规格合规 + 代码质量 | [03-gates.md](./03-gates.md#4-hard-gate-3) |

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

```text
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
| 产品需求文档 | `PRD/README.md` |
| 架构设计文档 | `Architect/ArchitectureDesign.md` |

---

## 📊 版本历史

| 版本 | 日期 | 变更说明 |
|------|------|----------|
| **v3.0** | 2026-04-14 | 简化整合：10 文档 → 6 文档，精简重复内容 |
| v2.0 | 2026-04-13 | 引入 Superpowers Pipeline，三阶段硬门禁 |
| v1.0 | 2026-03-20 | 初始版本，六阶段软门禁 |

---

**版本**: 3.0
**更新日期**: 2026-04-14
**适用范围**: 跨平台移动开发团队