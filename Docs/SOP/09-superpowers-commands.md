# Superpowers 命令完整参考手册

**版本:** 1.0
**日期:** 2026-04-14
**来源:** Superpowers Pipeline v6.1 (obra/superpowers)

---

## 1. 命令概览

Superpowers 系统包含 **10 个核心 Skills**，每个 Skill 对应特定的开发场景。

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      Superpowers Skills 工作流顺序                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ① using-superpowers (Meta-Skill - 会话启动时自动加载)                       │
│         ↓                                                                   │
│  ② brainstorming (Phase 1: Design)                                          │
│         ↓                                                                   │
│  ③ using-git-worktrees (创建隔离环境)                                        │
│         ↓                                                                   │
│  ④ writing-plans (Phase 2: Planning)                                        │
│         ↓                                                                   │
│  ⑤ subagent-driven-development OR executing-plans (Phase 3: Execution)      │
│         ↓                                                                   │
│  ⑥ test-driven-development (RED-GREEN-REFACTOR)                             │
│         ↓                                                                   │
│  ⑦ systematic-debugging (如遇问题)                                          │
│         ↓                                                                   │
│  ⑧ verification-before-completion (完成前验证)                               │
│         ↓                                                                   │
│  ⑨ dispatching-parallel-agents (并行任务)                                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. 命令触发方式

### 2.1 各平台调用方式

| 平台 | 调用命令 | 说明 |
|------|----------|------|
| **Claude Code** | `/skill-name` 或 `Skill` 工具 | 推荐：直接输入斜杠命令 |
| **Gemini CLI** | `activate_skill` 工具 | 需使用工具调用 |
| **Cursor** | `/skill-name` | 与 Claude Code 相同 |
| **Codex** | 自动发现 `~/.agents/skills/` | 无需显式调用 |

### 2.2 触发规则 (1% Rule)

```
⚠️ 核心规则: 1% Rule

"如果某个 skill 有 1% 的概率适用当前任务，
Agent 必须在执行任何响应或操作之前调用该 skill"

触发顺序:
1. 用户消息到达
2. 检查: "是否有 skill 适用？(即使是 1% 概率)"
3. 如果是 → 立即调用 Skill 工具
4. 宣布: "正在使用 [skill] 来 [目的]"
5. 如果 skill 有 checklist → 使用 TodoWrite 创建任务
6. 完全遵循 skill 指令执行
```

---

## 3. 核心 Skills 详细说明

### 3.1 using-superpowers (Meta-Skill)

**功能:** 元技能，建立 skill 发现协议

| 属性 | 说明 |
|------|------|
| **触发时机** | 会话启动时自动加载 (通过 hooks 注入) |
| **触发条件** | "Use when starting any conversation" |
| **主要作用** | 建立 1% Rule，强制 skill 检查 |
| **执行位置** | 无需显式调用，系统自动注入 |

**命令语法:**

```text
# 自动加载，无需手动触发
# 系统在会话开始时自动注入 using-superpowers skill
```

**执行流程:**

```text
会话启动:
─────────────────────────────────────────
Step 1: 系统通过 hooks 注入 using-superpowers
Step 2: skill 内容加载到会话上下文
Step 3: Agent 收到任何用户消息时
Step 4: 自动检查是否有其他 skill 适用
Step 5: 如有 1% 概率适用 → 强制调用相关 skill
```

**人工配合要点:**

| 场景 | 人工操作 |
|------|----------|
| Claude 提示 "我需要先调用 skill" | 等待 skill 加载完成 |
| Claude 创建 TodoWrite 任务列表 | 逐一配合完成检查项 |

---

### 3.2 brainstorming (Phase 1: Design)

**功能:** 交互式设计，Socratic 方法逐步细化

| 属性 | 说明 |
|------|------|
| **触发时机** | Phase 1: Design 阶段 |
| **触发条件** | "starting any creative work—creating features, building components, adding functionality, or modifying behavior" |
| **主要作用** | 交互式设计规格产出 |
| **输出文档** | `docs/superpowers/specs/YYYY-MM-DD-*.md` |

**命令语法:**

```text
# Claude Code
/superpowers          # 主入口，自动加载 brainstorming
/brainstorming        # 直接调用 (如果已配置)
/superpowers:brainstorm  # 使用完整限定名

# Gemini CLI
activate_skill({ skill: "brainstorming" })
```

**人工触发示例:**

```text
用户输入:
─────────────────────────────────────────
/superpowers

或

我需要设计一个课程列表功能，帮我做 brainstorming

或

帮我规划这个新功能

Claude 响应:
─────────────────────────────────────────
正在使用 brainstorming skill 进行设计...

我需要先了解项目上下文，让我探索一下...
[读取文件...]

基于我的探索，我有以下澄清问题：
1. 这个功能的目标用户是谁？
2. 是否需要支持离线模式？

请逐一回答，我会根据你的反馈设计方案。
```

**强制 Checklist (TodoWrite):**

```text
brainstorming Checklist:
─────────────────────────────────────────
☐ 探索项目上下文 (文件、文档、最近提交)
☐ 提供 UI/UX 视觉辅助 (如适用)
☐ 逐一提出澄清问题
☐ 提出 2-3 个方案并说明取舍
☐ 分段呈现设计内容请求批准
☐ 写设计文档到 docs/superpowers/specs/
☐ 规格审查循环 (subagent 或 self-review)
```

**Self-Review 检查项:**

| 检查项 | 标准 | 说明 |
|--------|------|------|
| **完整性** | 无 TBD | 无占位符或待确认内容 |
| **一致性** | 无矛盾 | 数据模型、API、UI 无矛盾 |
| **YAGNI** | 无过度设计 | 无未使用的抽象 |

**人工配合操作:**

| Claude 行为 | 人工操作 | 示例回复 |
|-------------|----------|----------|
| 探索项目上下文 | 等待完成 | 无需回复，等待下一步 |
| 提出澄清问题 | 逐一回答 | "目标用户是保险业务员，需要支持离线" |
| 提出方案选项 | 选择或修改 | "选择方案 B，同意推荐理由" |
| 分段呈现设计 | 每段确认 | "设计部分 1 通过，继续下一部分" |
| 写设计文档 | 检查文档 | "文档检查通过，无 TBD" |

---

### 3.3 using-git-worktrees

**功能:** 创建隔离开发环境

| 属性 | 说明 |
|------|------|
| **触发时机** | Phase 1 完成后，Phase 2/3 前 |
| **触发条件** | "For isolated development branches" |
| **主要作用** | 创建独立的 git worktree 工作目录 |
| **隔离目的** | 防止上下文污染，任务可独立回滚 |

**命令语法:**

```text
# Claude Code (自动调用 EnterWorktree 工具)
# 无需显式调用 skill，工具自动执行

# 人工触发 (可选)
/using-git-worktrees

# Gemini CLI
activate_skill({ skill: "superpowers:using-git-worktrees" })
```

**关联工具调用:**

| 工具 | 功能 | 参数 |
|------|------|------|
| `EnterWorktree` | 创建隔离 worktree | `{ name: "feature-001" }` |
| `ExitWorktree` | 退出 worktree | `{ action: "keep" }` 或 `{ action: "remove" }` |

**人工操作步骤:**

```text
Step 1: Claude 调用 EnterWorktree
─────────────────────────────────────────
Claude: 正在创建隔离工作树 EnterWorktree({ name: "course-001" })

系统响应: 已切换到 .claude/worktrees/course-001/

Step 2: 人工确认
─────────────────────────────────────────
检查: 当前工作目录是否已切换
命令: pwd (应显示 worktree 路径)

Step 3: 任务执行
─────────────────────────────────────────
在 worktree 中完成所有任务

Step 4: 退出 worktree
─────────────────────────────────────────
Claude: 任务完成，正在退出 worktree
ExitWorktree({ action: "keep" })

人工确认: 已返回主仓库目录
```

**Action 选择指南:**

| Action | 使用场景 | 后续操作 |
|--------|----------|----------|
| **keep** | 任务成功，后续可能继续 | worktree 和分支保留 |
| **remove** | 任务失败或实验结束 | worktree 和分支删除 |

---

### 3.4 writing-plans (Phase 2: Planning)

**功能:** 创建可执行的实施计划

| 属性 | 说明 |
|------|------|
| **触发时机** | Phase 2: Planning 阶段 |
| **触发条件** | "When planning implementation" |
| **主要作用** | 将设计规格分解为可执行任务 |
| **输出文档** | `docs/superpowers/plans/YYYY-MM-DD-*.md` |

**命令语法:**

```text
# Claude Code
/writing-plans
/superpowers:writing-plans

# Gemini CLI
activate_skill({ skill: "superpowers:writing-plans" })
```

**人工触发示例:**

```text
用户输入:
─────────────────────────────────────────
继续 Phase 2 规划

或

基于设计规格创建实施计划

Claude 响应:
─────────────────────────────────────────
正在使用 writing-plans skill 制定实施计划...

基于已批准的设计规格，我将创建实施计划。
首先进行文件结构映射...

新增文件:
| 文件路径 | 类型 | 说明 |
| Models/Course.ets | Model | 课程模型 |
...
```

**强制要求:**

| 要求 | 标准 | 检查方式 |
|------|------|----------|
| **文件结构映射** | 在定义任务前完成 | 检查文件列表完整 |
| **任务粒度** | 2-5 分钟/任务 | 检查时间标注 |
| **RED-GREEN-REFACTOR** | 包含完整循环 | 检查测试步骤 |
| **No Placeholders** | 无 TBD/占位符 | grep 检查 |

**No Placeholders 规则详解:**

```text
⚠️ 计划失败条件 (必须重新规划):

❌ TBD 字样
grep -n "TBD" docs/superpowers/plans/*.md
示例: "TBD: 需要确认字段名称" → 驳回

❌ 模糊描述
grep -n "待" docs/superpowers/plans/*.md
示例: "待确认" → 驳回

❌ 未定义引用
grep -n "类似" docs/superpowers/plans/*.md
示例: "类似 Task N" → 驳回

❌ 占位符
grep -n "... existing" docs/superpowers/plans/*.md
示例: "// ... existing code ..." → 驳回
```

**Self-Review 检查项:**

| 检查项 | 标准 | 说明 |
|--------|------|------|
| **可构建性** | 无阻塞点 | 工程师能否无阻塞执行 |
| **规格对齐** | 覆盖所有需求 | 是否遗漏设计规格功能 |
| **类型一致性** | 类型定义完整 | 所有类型已定义 |

---

### 3.5 subagent-driven-development (Phase 3: Execution)

**功能:** 通过 Subagent 分发并行执行任务

| 属性 | 说明 |
|------|------|
| **触发时机** | Phase 3: Implementation 阶段 |
| **触发条件** | "For complex multi-task execution" |
| **主要作用** | 使用 Task 工具分发任务给 Subagent |
| **适用平台** | Claude Code (支持 Task 工具) |

**命令语法:**

```text
# Claude Code (自动使用 Task 工具)
/subagent-driven-development
/superpowers:subagent-driven-development

# Gemini CLI (不支持 Task 工具)
# 使用 executing-plans 替代
```

**执行流程:**

```text
Controller Agent
─────────────────────────────────────────
    │
    ↓ Task 工具分发
─────────────────────────────────────────
┌───┴───┬───────┬───────┬───────┐
│       │       │       │       │
↓       ↓       ↓       ↓       ↓
Task 1  Task 2  Task 3  Task 4  Task N
(新     (新     (新     (新     (新
subagent) subagent) subagent) subagent) subagent)
│       │       │       │       │
↓       ↓       ↓       ↓       ↓
Worktree Worktree Worktree Worktree Worktree
隔离执行  隔离执行  隔离执行  隔离执行  隔离执行
```

**人工配合操作:**

```text
Step 1: 确认任务分发
─────────────────────────────────────────
Claude: 正在分发 Task 1 给 Subagent...

人工确认: TodoWrite 任务状态更新为 in_progress

Step 2: 监控任务执行
─────────────────────────────────────────
Claude 通知: Task 1 完成
人工确认: 检查测试是否通过

Step 3: 继续下一任务
─────────────────────────────────────────
Claude 自动分发 Task 2

Step 4: 全部任务完成
─────────────────────────────────────────
Claude: 所有任务已完成，准备进入审查阶段
```

---

### 3.6 executing-plans (Fallback)

**功能:** 单 session 执行计划 (无 Subagent 支持时的备选)

| 属性 | 说明 |
|------|------|
| **触发时机** | Phase 3: Implementation (备用) |
| **触发条件** | "Fallback for platforms lacking subagent support" |
| **适用平台** | Gemini CLI (无 Task 工具) |
| **执行方式** | 同 session 批量执行 + 人工检查点 |

**命令语法:**

```text
# Gemini CLI
activate_skill({ skill: "superpowers:executing-plans" })
```

**执行流程:**

```text
Executing Plans (Gemini CLI)
─────────────────────────────────────────
    │
    ↓ 同 session 执行
─────────────────────────────────────────
Task 1 → 人工检查点 → Task 2 → 人工检查点 → Task N
    │              │              │
    ↓              ↓              ↓
RED-GREEN-REFACTOR RED-GREEN-REFACTOR RED-GREEN-REFACTOR
```

**人工检查点操作:**

```text
每完成一个任务后:
─────────────────────────────────────────
Step 1: Claude 提示任务完成
Step 2: 人工验证测试通过
Step 3: 人工确认继续下一任务
回复: "Task 1 通过，继续 Task 2"
```

---

### 3.7 test-driven-development

**功能:** 强制执行 RED-GREEN-REFACTOR 循环

| 属性 | 说明 |
|------|------|
| **触发时机** | 任务执行过程中 |
| **触发条件** | "When implementing code" |
| **主要作用** | 确保测试先行 |
| **执行模式** | RED → GREEN → REFACTOR |

**命令语法:**

```text
# Claude Code
/test-driven-development
/tdd
/superpowers:tdd

# Gemini CLI
activate_skill({ skill: "superpowers:test-driven-development" })
```

**RED-GREEN-REFACTOR 循环详解:**

```text
[RED] Step 1: 写测试
─────────────────────────────────────────
操作: 创建测试文件
示例: Tests/CourseTests.ets

内容:
test("Course should have id property", () => {
  const course = new Course();
  expect(course.id).toBeDefined();
});

执行: 运行测试
命令: npm test 或 xcodebuild test
结果: ❌ 失败 (Course 类不存在)

[RED] Step 2: 确认失败
─────────────────────────────────────────
人工确认: 测试报错信息合理
Claude 确认: "测试失败，Course 类不存在，符合预期"

[GREEN] Step 3: 实现功能
─────────────────────────────────────────
操作: 创建实现文件
示例: Models/Course.ets

内容:
export class Course {
  id: string = "";
  title: string = "";
}

执行: 运行测试
结果: ✅ 通过

[GREEN] Step 4: 确认通过
─────────────────────────────────────────
人工确认: 所有测试通过，无警告

[REFACTOR] Step 5: 优化代码
─────────────────────────────────────────
操作: 检查代码质量
检查项:
- 命名清晰
- 无冗余代码
- 注释必要

执行: 再次运行测试确认通过

[COMMIT] Step 6: 提交代码
─────────────────────────────────────────
命令:
git add Models/Course.ets Tests/CourseTests.ets
git commit -m "feat: add Course model"
```

**人工配合要点:**

| 步骤 | 人工操作 |
|------|----------|
| RED 写测试 | 等待 Claude 完成，确认测试文件创建 |
| RED 运行测试 | 确认测试失败信息合理 |
| GREEN 实现 | 等待 Claude 完成实现 |
| GREEN 运行测试 | 确认测试通过 |
| REFACTOR | 检查代码质量，提出改进建议 |
| COMMIT | 确认提交成功 |

---

### 3.8 systematic-debugging

**功能:** 4阶段系统化调试流程

| 属性 | 说明 |
|------|------|
| **触发时机** | 遇到 Bug 或问题时 |
| **触发条件** | "Let's debug this issue" |
| **主要作用** | 替代直觉猜测，系统化诊断 |
| **流程阶段** | 4 Phase |

**命令语法:**

```text
# Claude Code
/systematic-debugging
/debug
/superpowers:systematic-debugging

# Gemini CLI
activate_skill({ skill: "superpowers:systematic-debugging" })
```

**人工触发示例:**

```text
用户输入:
─────────────────────────────────────────
课程列表加载不出来，帮我调试一下

或

/debug

或

Let's debug this issue

Claude 响应:
─────────────────────────────────────────
正在使用 systematic-debugging skill...

Phase 1: 定义问题
─────────────────────────────────────────
问题描述: 课程列表加载失败
影响范围: CourseListPage
复现步骤: [请提供]
```

**4阶段调试流程:**

```text
Phase 1: 定义问题 (Define)
─────────────────────────────────────────
检查项:
☐ 问题现象描述
☐ 影响范围确定
☐ 复现步骤确认
☐ 预期行为定义

Phase 2: 收集信息 (Gather)
─────────────────────────────────────────
操作:
☐ 查看错误日志
☐ 检查网络请求
☐ 检查数据状态
☐ 检查代码逻辑

Phase 3: 分析原因 (Analyze)
─────────────────────────────────────────
方法:
☐ 逐层排查
☐ 缩小范围
☐ 定位根因

Phase 4: 修复验证 (Fix & Verify)
─────────────────────────────────────────
步骤:
☐ 制定修复方案
☐ 实现修复
☐ 运行测试
☐ 验证问题解决
☐ 回归测试
```

**人工配合操作:**

| Phase | 人工操作 |
|-------|----------|
| Phase 1 | 描述问题现象、提供复现步骤 |
| Phase 2 | 提供日志、确认数据状态 |
| Phase 3 | 认 Claude 的分析结论 |
| Phase 4 | 确认修复方案、验证修复结果 |

---

### 3.9 verification-before-completion

**功能:** 任务完成前强制验证

| 属性 | 说明 |
|------|------|
| **触发时机** | 任务完成前 |
| **触发条件** | "Before declaring task complete" |
| **主要作用** | 要求证据验证，而非仅声明 |
| **验证标准** | 测试通过 + 功能验证 |

**命令语法:**

```text
# Claude Code
/verification-before-completion
/verify
/superpowers:verification-before-completion

# Gemini CLI
activate_skill({ skill: "superpowers:verification-before-completion" })
```

**验证 Checklist:**

```text
Verification Checklist:
─────────────────────────────────────────
☐ 所有测试通过 (运行测试命令)
☐ 测试覆盖率达标 (≥80%)
☐ 功能可正常使用 (人工验证)
☐ 无编译错误/警告
☐ 无明显性能问题
☐ 代码已提交
```

**人工验证操作:**

```text
Step 1: 运行测试
─────────────────────────────────────────
命令: npm test
确认: 所有测试通过

Step 2: 检查覆盖率
─────────────────────────────────────────
命令: npm run coverage
确认: ≥80%

Step 3: 功能验证
─────────────────────────────────────────
操作: 启动应用，手动测试功能
确认: 功能正常工作

Step 4: 确认完成
─────────────────────────────────────────
回复: "验证通过，任务完成"
```

---

### 3.10 dispatching-parallel-agents

**功能:** 并行分发多个 Agent

| 属性 | 说明 |
|------|------|
| **触发时机** | 需要并行执行多个独立任务 |
| **触发条件** | "For parallel work execution" |
| **主要作用** | 同时启动多个 Agent 处理不同任务 |
| **适用平台** | Codex (需 `multi_agent = true`) |

**命令语法:**

```text
# Claude Code
/dispatching-parallel-agents
/parallel
/superpowers:dispatching-parallel-agents

# Codex (自动发现)
# 需在配置中设置 multi_agent = true
```

**并行执行示例:**

```text
用户输入:
─────────────────────────────────────────
同时开发 iOS、Android、Harmony 三个平台的课程列表

Claude 响应:
─────────────────────────────────────────
正在使用 dispatching-parallel-agents skill...

启动 3 个并行 Agent:
─────────────────────────────────────────
Agent 1: iOS Specialist → CourseListPage.swift
Agent 2: Android Specialist → CourseListPage.kt
Agent 3: Harmony Specialist → CourseListPage.ets

各 Agent 在独立 worktree 中执行...
```

**人工配合操作:**

```text
Step 1: 确认并行任务列表
─────────────────────────────────────────
检查: 各任务是否独立可并行

Step 2: 监控各 Agent 进度
─────────────────────────────────────────
系统通知: Agent 1 完成
系统通知: Agent 2 完成
系统通知: Agent 3 完成

Step 3: 整合结果
─────────────────────────────────────────
Claude: 所有 Agent 完成，准备整合审查
```

---

## 4. Skills 按场景分类

### 4.1 按开发阶段分类

| 阶段 | 适用 Skills |
|------|--------------|
| **需求分析** | brainstorming |
| **设计阶段** | brainstorming |
| **规划阶段** | writing-plans |
| **实施阶段** | using-git-worktrees → subagent-driven-development → test-driven-development |
| **调试阶段** | systematic-debugging |
| **完成验证** | verification-before-completion |

### 4.2 按问题类型分类

| 问题类型 | 适用 Skills |
|----------|--------------|
| **新功能开发** | brainstorming → writing-plans → subagent-driven-development → tdd |
| **Bug 修复** | systematic-debugging → tdd → verification-before-completion |
| **重构** | brainstorming → writing-plans → subagent-driven-development |
| **性能优化** | systematic-debugging → brainstorming |
| **多平台并行** | dispatching-parallel-agents |

### 4.3 按角色分类

| 角色 | 常用 Skills |
|------|--------------|
| **Architect** | brainstorming, writing-plans, verification-before-completion |
| **Specialist** | using-git-worktrees, test-driven-development, systematic-debugging |
| **QA** | verification-before-completion, systematic-debugging |

---

## 5. 命令速查表

### 5.1 主入口命令

```text
/superpowers              # 主入口，启动完整工作流
```

### 5.2 各阶段命令

```text
# Phase 1: Design
/brainstorming            # 交互式设计

# Phase 2: Planning  
/writing-plans            # 实施计划

# Phase 3: Implementation
/using-git-worktrees      # 创建隔离环境
/subagent-driven-development  # SDD 执行
/executing-plans          # 备选执行方式
/test-driven-development  # TDD 循环
/tdd                      # TDD 简写

# 问题处理
/systematic-debugging     # 系统化调试
/debug                    # 调试简写

# 完成验证
/verification-before-completion  # 完成前验证
/verify                   # 验证简写

# 并行执行
/dispatching-parallel-agents  # 并行 Agent
/parallel                 # 并行简写
```

### 5.3 完整限定名

```text
/superpowers:brainstorm
/superpowers:writing-plans
/superpowers:using-git-worktrees
/superpowers:subagent-driven-development
/superpowers:executing-plans
/superpowers:test-driven-development
/superpowers:systematic-debugging
/superpowers:verification-before-completion
/superpowers:dispatching-parallel-agents
```

---

## 6. 工具配合命令

### 6.1 Git Worktree 工具

```text
# Claude Code 工具调用 (自动)
EnterWorktree({ name: "feature-001" })
ExitWorktree({ action: "keep" })
ExitWorktree({ action: "remove", discard_changes: true })

# 人工 Git 命令
git worktree list               # 查看所有 worktree
git worktree add .claude/worktrees/feature-001 -b feature-001
git worktree remove .claude/worktrees/feature-001
git worktree prune              # 清理过期 worktree
```

### 6.2 Task 工具 (Subagent)

```text
# Claude Code 工具调用 (自动)
Task({ task_id: "task-001", subagent_type: "general-purpose" })

# 人工无直接调用，由 skill 自动执行
```

### 6.3 TodoWrite 工具

```text
# Claude Code 工具调用 (自动)
TodoWrite({ todos: [
  { content: "探索项目上下文", status: "pending", activeForm: "探索中" },
  { content: "提出澄清问题", status: "pending", activeForm: "提问中" }
] })

# 人工查看进度
# 系统自动显示 TodoWrite 状态
```

---

## 7. 完整工作流命令序列

### 7.1 标准开发流程

```text
# Step 1: 启动流程
用户: /superpowers
─────────────────────────────────────────
Claude: using-superpowers 已加载
       正在使用 brainstorming skill...

# Step 2: Phase 1 Design
Claude: 探索项目上下文... ✓
       提出澄清问题:
       1. 目标用户是谁？
用户: 目标用户是保险业务员
─────────────────────────────────────────
Claude: 收到回答，继续下一个问题...

# Step 3: Phase 1 完成
Claude: 设计文档已创建
       docs/superpowers/specs/2026-04-14-course-design.md
       请审查文档

用户: 文档审查通过，进入 Phase 2
─────────────────────────────────────────

# Step 4: Phase 2 Planning
Claude: 正在使用 writing-plans skill...
       文件结构映射... ✓
       任务定义...

用户: 计划审查通过，进入 Phase 3
─────────────────────────────────────────

# Step 5: Phase 3 Implementation
Claude: 正在使用 using-git-worktrees skill...
       EnterWorktree({ name: "course-001" })
       
       正在使用 test-driven-development skill...
       Task 1: RED → GREEN → REFACTOR → COMMIT
       
       ExitWorktree({ action: "keep" })

# Step 6: Verification
Claude: 正在使用 verification-before-completion skill...
       Verification Checklist... ✓

用户: 验证通过，任务完成
─────────────────────────────────────────
```

### 7.2 调试流程

```text
# Step 1: 触发调试
用户: 课程列表加载不出来，帮我调试
─────────────────────────────────────────
Claude: 正在使用 systematic-debugging skill...

# Step 2: Phase 1 Define
Claude: 问题定义:
       现象: 课程列表加载失败
       影响: CourseListPage
       复现步骤: [请提供]

用户: 打开课程列表页面，等待 30 秒无响应
─────────────────────────────────────────

# Step 3: Phase 2 Gather
Claude: 收集信息:
       检查网络请求... 发现超时
       检查 API 配置... 发现超时设置过短

# Step 4: Phase 3 Analyze
Claude: 分析结论:
       根因: API 超时设置 10 秒，数据量大时不够

# Step 5: Phase 4 Fix
Claude: 修复方案:
       将超时设置调整为 30 秒
       
       正在使用 test-driven-development skill...
       RED → GREEN → REFACTOR → COMMIT

# Step 6: Verify
Claude: 正在使用 verification-before-completion skill...
       ✓ 问题解决
```

---

## 8. 命令触发条件速查

| Skill | 触发关键词 |
|-------|-----------|
| **brainstorming** | "设计", "规划", "新功能", "创建", "构建" |
| **writing-plans** | "计划", "实施方案", "任务分解" |
| **using-git-worktrees** | "隔离", "worktree", "独立环境" |
| **subagent-driven-development** | "并行执行", "多个任务", "分发" |
| **test-driven-development** | "实现", "编码", "写代码" |
| **systematic-debugging** | "调试", "debug", "问题", "bug", "不工作" |
| **verification-before-completion** | "完成", "验证", "确认" |
| **dispatching-parallel-agents** | "并行", "同时", "多平台" |

---

## 9. 注意事项

### 9.1 强制执行规则

```text
⚠️ 1% Rule 强制执行:
─────────────────────────────────────────
- skill 检查必须在任何响应之前
- 即使只有 1% 概率适用，也要调用
- 不能跳过 skill 检查
- 不能用 "让我先探索一下" 等借口跳过
```

### 9.2 Skill 优先级

```text
Skill 调用优先级:
─────────────────────────────────────────
1. Process Skills (brainstorming, systematic-debugging)
   → 优先级最高，决定 HOW to approach

2. Implementation Skills (writing-plans, tdd)
   → 优先级次高，指导执行

3. Meta Skills (using-superpowers)
   → 自动加载，无需显式调用
```

### 9.3 Checklist 执行

```text
TodoWrite Checklist 执行规则:
─────────────────────────────────────────
1. skill 加载后如有 checklist
2. Claude 自动使用 TodoWrite 创建任务
3. 每完成一个任务立即更新状态
4. 人工配合逐一完成检查项
```

---

**版本:** 1.0
**更新日期:** 2026-04-14
**来源:** Superpowers Pipeline v6.1 (https://deepwiki.com/obra/superpowers)