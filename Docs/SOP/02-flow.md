# 开发流程

**版本:** 3.0
**日期:** 2026-04-14
**来源:** Superpowers Pipeline v6.1

---

## 1. 流程概览

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
│  /subagent-driven       ↓             "规格合规 + 代码质量"                 │
│  /tdd /debug /verify  Git Worktree                                        │
│       ↓             隔离机制                                               │
│  双阶段审查                                                                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 核心原则

| 原则 | 说明 |
|------|------|
| **硬门禁** | 门禁不通过 = 禁止进入下一阶段 |
| **No Placeholders** | 禁止 TBD、模糊描述、占位符 |
| **RED-GREEN-REFACTOR** | 先写测试 → 运行失败 → 实现 → 通过 → 重构 |
| **任务粒度** | 每个任务 2-5 分钟 |
| **隔离执行** | Git Worktree 隔离 + Subagent 分发 |
| **1% Rule** | 有 1% 概率适用某 skill → 强制调用 |

---

## 2. Phase 1: Design (brainstorming)

### 2.1 目标

交互式设计，产出完整的设计规格文档。

### 2.2 触发命令

```text
主命令:
─────────────────────────────────────────
/superpowers              # 主入口，自动加载 brainstorming
/brainstorming            # 直接触发设计 skill

触发时机:
─────────────────────────────────────────
- 开始任何创造性工作
- 创建新功能、构建组件、添加功能
- "帮我设计"、"规划这个功能"
```

### 2.3 执行流程

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Phase 1: /superpowers 命令执行流程                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  用户: /superpowers                                                          │
│       ↓                                                                     │
│  Step 1: 探索项目上下文 (文件、文档、最近提交)                                 │
│       ↓                                                                     │
│  Step 2: 提供 UI/UX 视觉辅助 (如适用)                                        │
│       ↓                                                                     │
│  Step 3: 逐一提出澄清问题                                                    │
│       ↓                                                                     │
│  Step 4: 提出 2-3 个方案并说明取舍                                            │
│       ↓                                                                     │
│  Step 5: 分段呈现设计内容请求批准                                             │
│       ↓                                                                     │
│  Step 6: 写设计文档到 docs/superpowers/specs/                                │
│       ↓                                                                     │
│  Step 7: Self-Review (完整性/一致性/YAGNI)                                   │
│       ↓                                                                     │
│  Step 8: 输出设计规格文档                                                    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2.4 输出

```
docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md
```

### 2.5 HARD-GATE 1

```
⚠️ HARD-GATE: 禁止在未批准设计前实施

未通过此门禁 → 禁止进入 Phase 2
禁止调用 /writing-plans 命令
```

### 2.6 Checklist

```text
Phase 1 Checklist:
─────────────────────────────────────────
☐ 探索项目上下文
☐ 提供 UI/UX 视觉辅助
☐ 逐一提出澄清问题
☐ 提出 2-3 个方案
☐ 分段呈现设计
☐ 写设计文档
☐ 规格审查循环
```

---

## 3. Phase 2: Planning (writing-plans)

### 3.1 目标

将设计规格分解为可执行的实施计划。

### 3.2 触发命令

```text
主命令:
─────────────────────────────────────────
/writing-plans            # 直接触发规划 skill

触发时机:
─────────────────────────────────────────
- Phase 1 HARD-GATE 1 通过后
- 设计文档已批准签字
```

### 3.3 执行流程

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Phase 2: /writing-plans 命令执行流程                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  用户: /writing-plans                                                        │
│       ↓                                                                     │
│  Step 1: 加载已批准设计规格                                                   │
│       ↓                                                                     │
│  Step 2: 文件结构映射 (新增/修改文件列表)                                      │
│       ↓                                                                     │
│  Step 3: 任务分解 (每任务 2-5 分钟)                                           │
│       ↓                                                                     │
│  Step 4: RED-GREEN-REFACTOR 循环定义                                         │
│       ↓                                                                     │
│  Step 5: No Placeholders 自动检查                                            │
│       ↓                                                                     │
│  Step 6: Self-Review (可构建性/规格对齐)                                      │
│       ↓                                                                     │
│  Step 7: 输出实施计划文档                                                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3.4 输入/输出

```text
输入: docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md (已批准)
输出: docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md
```

### 3.5 HARD-GATE 2

```
⚠️ HARD-GATE: 计划必须可构建

未通过此门禁 → 禁止进入 Phase 3
禁止调用 /subagent-driven-development 命令
```

### 3.6 No Placeholders 规则

```text
计划失败条件 (必须重新规划):
─────────────────────────────────────────
❌ TBD 字样
❌ 模糊描述 ("待确认"、"待定")
❌ 未定义引用 ("类似 Task N")
❌ 占位符 ("// ... existing code ...")
```

### 3.7 Checklist

```text
Phase 2 Checklist:
─────────────────────────────────────────
☐ 文件结构映射
☐ 任务粒度 2-5 分钟
☐ RED-GREEN-REFACTOR 循环
☐ No Placeholders 检查
☐ 可构建性验证
☐ 规格对齐验证
```

---

## 4. Phase 3: Implementation (SDD)

### 4.1 目标

在隔离环境中执行实施计划。

### 4.2 触发命令

```text
主命令:
─────────────────────────────────────────
/subagent-driven-development  # SDD 执行 (推荐)
/tdd                         # TDD 循环
/debug                       # 调试 (如遇问题)
/verify                      # 完成前验证

触发时机:
─────────────────────────────────────────
- Phase 2 HARD-GATE 2 通过后
- 开始实施代码
```

### 4.3 执行流程

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Phase 3: 多命令协同执行流程                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  用户: 继续 Phase 3 实施                                                      │
│       ↓                                                                     │
│  Step 1: Git Worktree 隔离                                                   │
│          EnterWorktree({ name: "feature-001" })                             │
│       ↓                                                                     │
│  Step 2: /subagent-driven-development                                       │
│          Controller Agent 分发任务                                           │
│       ↓                                                                     │
│  ┌────┴────┬────────────┬────────────┐                                     │
│  │         │            │            │                                      │
│  ↓         ↓            ↓            ↓                                      │
│  /tdd      /tdd         /tdd         /tdd                                   │
│  Task 1    Task 2       Task 3       Task N                                 │
│  RED-GREEN-REFACTOR                                                     │
│       ↓                                                                     │
│  Step 3: (如遇问题) /debug                                                   │
│          4阶段调试流程                                                        │
│       ↓                                                                     │
│  Step 4: /verify 完成前验证                                                  │
│       ↓                                                                     │
│  Step 5: ExitWorktree                                                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4.3 输入

```
docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md (已批准)
```

### 4.4 HARD-GATE 3

```
⚠️ HARD-GATE: 规格合规 + 代码质量

未通过此门禁 → 禁止合并到主分支
禁止调用 git merge / git push
```

### 4.5 Checklist

```text
Phase 3 Checklist:
─────────────────────────────────────────
☐ Git Worktree 隔离
☐ Subagent 分发执行
☐ /tdd RED-GREEN-REFACTOR
☐ (如遇问题) /debug
☐ /verify 完成验证
☐ Spec Compliance 检查
☐ Code Quality 检查
```

---

## 5. 命令速查表

### 5.1 各阶段命令

| 阶段 | 命令 | 说明 |
|------|------|------|
| **Phase 1** | `/superpowers` | 主入口 |
| | `/brainstorming` | 设计 skill |
| **Phase 2** | `/writing-plans` | 规划 skill |
| **Phase 3** | `/subagent-driven-development` | SDD 执行 |
| | `/tdd` | TDD 循环 |
| | `/debug` | 系统化调试 |
| | `/verify` | 完成验证 |

### 5.2 完整限定名

```text
/superpowers:brainstorm
/superpowers:writing-plans
/superpowers:subagent-driven-development
/superpowers:test-driven-development
/superpowers:systematic-debugging
/superpowers:verification-before-completion
```

### 5.3 命令触发关键词

| Skill | 触发关键词 |
|-------|-----------|
| **brainstorming** | "设计", "规划", "新功能", "创建" |
| **writing-plans** | "计划", "实施方案", "任务分解" |
| **subagent-driven-development** | "执行", "实施", "开始编码" |
| **test-driven-development** | "实现", "编码", "写代码" |
| **systematic-debugging** | "调试", "debug", "问题", "bug" |
| **verification-before-completion** | "完成", "验证", "确认" |

---

## 6. 合并发布

### 6.1 HARD-GATE 3 通过后

```text
Step 1: git checkout main
Step 2: git merge feature-xxx --no-ff
Step 3: git push origin main
Step 4: git tag -a v1.x.0 -m "Release message"
Step 5: git push origin v1.x.0
```

### 6.2 更新记录

```text
更新 Docs/Records/{module}/overview.md
更新 Docs/Records/{module}/harmony.md (或 ios.md/android.md)
更新 Docs/Records/README.md 索引
```

---

## 7. 异常处理

### 7.1 HARD-GATE 未通过

```text
处理流程:
─────────────────────────────────────────
门禁失败 → 阅读驳回原因 → 修复问题 → 重新提交审查 → 通过后继续
```

### 7.2 任务执行失败

```text
处理流程:
─────────────────────────────────────────
任务失败 → /debug 调试修复 → 或 ExitWorktree 丢弃重来 → 继续执行
```

---

## 8. 相关文档

| 文档 | 路径 | 说明 |
|------|------|------|
| 门禁详细定义 | [03-gates.md](./03-gates.md) | HARD-GATE 检查清单 |
| 开发规范 | [04-standards.md](./04-standards.md) | 测试 + Commit 规范 |
| Worktree 规范 | [05-worktree.md](./05-worktree.md) | 隔离环境使用 |
| 人工操作指南 | [06-operations.md](./06-operations.md) | 详细操作步骤 |

---

**版本**: 3.0
**更新日期**: 2026-04-14
**适用范围**: 跨平台移动开发团队
**来源**: Superpowers Pipeline v6.1