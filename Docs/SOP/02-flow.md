# 开发流程

**版本:** 2.1
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
│  /brainstorming         ↓                    ↓                            │
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
/superpowers              # 主入口，自动加载 brainstorming skill
/brainstorming            # 直接触发 brainstorming
/superpowers:brainstorm   # 完整限定名

触发时机:
─────────────────────────────────────────
- 开始任何创造性工作
- 创建新功能、构建组件、添加功能
- 修改现有行为
- "帮我设计"、"规划这个功能"

备选命令 (Gemini CLI):
─────────────────────────────────────────
activate_skill({ skill: "superpowers:brainstorming" })
```

### 2.3 命令执行流程

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Phase 1: /superpowers 命令执行流程                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  用户: /superpowers                                                          │
│       ↓                                                                     │
│  Step 1: using-superpowers 自动加载 (Meta-Skill)                             │
│       ↓                                                                     │
│  Step 2: 1% Rule 检查 → 检测到设计任务                                       │
│       ↓                                                                     │
│  Step 3: 自动调用 brainstorming skill                                        │
│       ↓                                                                     │
│  Step 4: TodoWrite 创建 7 步 Checklist                                       │
│       ↓                                                                     │
│  Step 5-11: 执行 Checklist 各步骤                                            │
│       ↓                                                                     │
│  Step 12: Self-Review (完整性/一致性/YAGNI)                                  │
│       ↓                                                                     │
│  Step 13: 输出设计规格文档                                                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2.4 命令与步骤对应

| 步骤 | 命令行为 | 人工配合 |
|------|----------|----------|
| **Step 1** | 自动: 探索项目上下文 | 等待完成，可补充重要文件路径 |
| **Step 2** | 自动: 提供 UI/UX 视觉辅助 | 查看、确认或提出修改 |
| **Step 3** | 自动: 逐一提出澄清问题 | **逐一回答，每问题单独回复** |
| **Step 4** | 自动: 提出 2-3 个方案 | 选择推荐方案或提出修改意见 |
| **Step 5** | 自动: 分段呈现设计内容 | 每段确认或提出修改 |
| **Step 6** | 自动: 写设计文档 | 检查文档是否符合 No Placeholders |
| **Step 7** | 自动: Spec Review Loop | 等待审查完成 |

### 2.5 输出

```
docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md
```

### 2.6 HARD-GATE 1

```
⚠️ HARD-GATE: 禁止在未批准设计前实施

未通过此门禁 → 禁止进入 Phase 2
禁止调用 /writing-plans 命令
```

### 2.7 强制 Checklist (通过 TodoWrite 跟踪)

```text
Phase 1 Checklist (TodoWrite 自动创建):
─────────────────────────────────────────
☐ 探索项目上下文 (文件、文档、最近提交)
☐ 提供 UI/UX 视觉辅助 (如适用)
☐ 逐一提出澄清问题
☐ 提出 2-3 个方案并说明取舍
☐ 分段呈现设计内容请求批准
☐ 写设计文档到 docs/superpowers/specs/
☐ 规格审查循环 (subagent 或 self-review)
```

### 2.8 Self-Review 检查项

| 检查项 | 标准 | 检查方式 |
|--------|------|----------|
| **完整性** | 无 TBD | grep "TBD" docs/superpowers/specs/*.md |
| **一致性** | 无矛盾 | 人工对照各章节 |
| **YAGNI** | 无过度设计 | 检查是否有未使用的抽象 |

### 2.9 审查签字命令

```text
人工批准签字:
─────────────────────────────────────────
在文档末尾添加:

---
**审查人:** @architect
**审查日期:** 2026-04-14
**审查结论:** ✅ 批准
**HARD-GATE 1:** ✅ 通过

签字后可触发 Phase 2 命令
```

---

## 3. Phase 2: Planning (writing-plans)

### 3.1 目标

将设计规格分解为可执行的实施计划。

### 3.2 触发命令

```text
主命令:
─────────────────────────────────────────
/writing-plans            # 直接触发
/superpowers:writing-plans # 完整限定名

触发时机:
─────────────────────────────────────────
- Phase 1 HARD-GATE 1 通过后
- "创建实施计划"、"基于设计规格制定计划"
- 设计文档已批准签字

备选命令 (Gemini CLI):
─────────────────────────────────────────
activate_skill({ skill: "superpowers:writing-plans" })
```

### 3.3 命令执行流程

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Phase 2: /writing-plans 命令执行流程                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  用户: /writing-plans                                                        │
│       ↓                                                                     │
│  Step 1: 加载已批准设计规格                                                   │
│       ↓                                                                     │
│  Step 2: TodoWrite 创建任务跟踪                                              │
│       ↓                                                                     │
│  Step 3: 文件结构映射 (新增/修改文件列表)                                      │
│       ↓                                                                     │
│  Step 4: 任务分解 (每任务 2-5 分钟)                                           │
│       ↓                                                                     │
│  Step 5: RED-GREEN-REFACTOR 循环定义                                         │
│       ↓                                                                     │
│  Step 6: No Placeholders 自动检查                                            │
│       ↓                                                                     │
│  Step 7: Self-Review (可构建性/规格对齐)                                      │
│       ↓                                                                     │
│  Step 8: 输出实施计划文档                                                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3.4 命令与步骤对应

| 步骤 | 命令行为 | 人工配合 |
|------|----------|----------|
| **Step 1** | 自动: 加载设计规格 | 确认文档路径 |
| **Step 2** | 自动: 文件结构映射 | 检查文件列表是否完整 |
| **Step 3** | 自动: 任务分解 | **检查每任务是否 2-5 分钟** |
| **Step 4** | 自动: RED-GREEN-REFACTOR 定义 | 确认测试步骤完整 |
| **Step 5** | 自动: No Placeholders 检查 | 人工再次检查 TBD/占位符 |
| **Step 6** | 自动: Self-Review | 等待审查完成 |

### 3.5 输入

```
docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md (已批准)
```

### 3.6 输出

```
docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md
```

### 3.7 HARD-GATE 2

```
⚠️ HARD-GATE: 计划必须可构建

未通过此门禁 → 禁止进入 Phase 3
禁止调用 /subagent-driven-development 命令
```

### 3.8 No Placeholders 规则 (自动 + 人工检查)

```text
⚠️ 计划失败条件 (必须重新规划):

❌ TBD 字样
自动检查: grep "TBD" docs/superpowers/plans/*.md
人工确认: 无任何 TBD 内容

❌ 模糊描述
自动检查: grep "待" docs/superpowers/plans/*.md
人工确认: 无 "待确认"、"待定"

❌ 未定义引用
自动检查: grep "类似" docs/superpowers/plans/*.md
人工确认: 无 "类似 Task N" 简写

❌ 占位符
自动检查: grep "... existing" docs/superpowers/plans/*.md
人工确认: 无 "// ... existing code ..."
```

### 3.9 强制要求

| 要求 | 标准 | 检查方式 |
|------|------|----------|
| **文件结构映射** | 在定义任务前完成 | 检查文件列表完整 |
| **任务粒度** | 2-5 分钟/任务 | 检查时间标注 |
| **RED-GREEN-REFACTOR** | 包含完整循环 | 检查测试步骤 |
| **No Placeholders** | 无 TBD/占位符 | grep 检查 |

### 3.10 审查签字命令

```text
人工批准签字:
─────────────────────────────────────────
在文档末尾添加:

---
**审查人:** @architect
**审查日期:** 2026-04-14
**审查结论:** ✅ 批准
**HARD-GATE 2:** ✅ 通过
- No Placeholders: ✅
- 可构建性: ✅
- 规格对齐: ✅
- 任务粒度: ✅

签字后可触发 Phase 3 命令
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
/executing-plans             # 备选执行 (Gemini CLI)
/tdd                         # TDD 循环
/debug                       # 调试 (如遇问题)
/verify                      # 完成前验证

触发时机:
─────────────────────────────────────────
- Phase 2 HARD-GATE 2 通过后
- 开始实施代码
- 遇到 Bug 或问题时 /debug

备选命令 (Gemini CLI):
─────────────────────────────────────────
activate_skill({ skill: "superpowers:subagent-driven-development" })
activate_skill({ skill: "superpowers:executing-plans" })
```

### 4.3 命令执行流程

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Phase 3: 多命令协同执行流程                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  用户: 继续 Phase 3 实施                                                      │
│       ↓                                                                     │
│  Step 1: /using-git-worktrees (自动触发)                                     │
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
│  Step 3: (如遇问题) /systematic-debugging                                    │
│          4阶段调试流程                                                        │
│       ↓                                                                     │
│  Step 4: /verification-before-completion                                    │
│          完成前验证                                                          │
│       ↓                                                                     │
│  Step 5: ExitWorktree({ action: "keep" })                                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4.4 Git Worktree 隔离命令

```text
自动触发命令:
─────────────────────────────────────────
/using-git-worktrees       # 自动调用 EnterWorktree 工具

工具调用 (自动):
─────────────────────────────────────────
EnterWorktree({ name: "feature-001" })
# 创建隔离目录: .claude/worktrees/feature-001/

人工命令 (可选):
─────────────────────────────────────────
git worktree list          # 查看所有 worktree
git worktree add .claude/worktrees/feature-001 -b feature-001

退出命令:
─────────────────────────────────────────
ExitWorktree({ action: "keep" })     # 保留 worktree
ExitWorktree({ action: "remove" })   # 删除 worktree
```

### 4.5 TDD 循环命令详解

```text
触发命令:
─────────────────────────────────────────
/tdd                       # 直接触发
/test-driven-development   # 完整名
/superpowers:tdd           # 限定名

触发时机:
─────────────────────────────────────────
- 开始写代码时自动触发
- 每个任务执行时

RED-GREEN-REFACTOR 命令序列:
─────────────────────────────────────────

[RED] Phase:
─────────────────────────────────────────
Step 1: 自动创建测试文件
        示例: Tests/CourseTests.ets
Step 2: 运行测试命令
        npm test / xcodebuild test
Step 3: 确认失败
        结果: ❌ 失败 (符合预期)

[GREEN] Phase:
─────────────────────────────────────────
Step 4: 自动创建实现文件
        示例: Models/Course.ets
Step 5: 运行测试命令
        npm test / xcodebuild test
Step 6: 确认通过
        结果: ✅ 通过

[REFACTOR] Phase:
─────────────────────────────────────────
Step 7: 人工检查代码质量
        - 命名清晰?
        - 无冗余代码?
        - 注释必要?
Step 8: 运行测试确认
        npm test
        结果: ✅ 保持通过

[COMMIT] Phase:
─────────────────────────────────────────
Step 9: 提交代码
        git add Models/Course.ets Tests/CourseTests.ets
        git commit -m "feat: add Course model"
```

### 4.6 调试命令详解

```text
触发命令:
─────────────────────────────────────────
/debug                     # 直接触发
/systematic-debugging      # 完整名
/superpowers:debug         # 限定名

触发时机:
─────────────────────────────────────────
- 遇到 Bug 或问题时
- 测试失败无法通过时
- "帮我调试"、"debug this"

触发关键词:
─────────────────────────────────────────
"调试", "debug", "问题", "bug", "不工作", "失败"

4阶段调试命令流程:
─────────────────────────────────────────

Phase 1: /debug Define
─────────────────────────────────────────
自动: 收集问题描述
人工: 描述现象、提供复现步骤

Phase 2: /debug Gather
─────────────────────────────────────────
自动: 查看错误日志、检查网络请求
人工: 提供日志、确认数据状态

Phase 3: /debug Analyze
─────────────────────────────────────────
自动: 逐层排查、缩小范围、定位根因
人工: 确认分析结论

Phase 4: /debug Fix
─────────────────────────────────────────
自动: 制定修复方案、实现修复、运行测试
人工: 确认修复方案、验证修复结果

修复后自动恢复 /tdd 流程
```

### 4.7 验证命令详解

```text
触发命令:
─────────────────────────────────────────
/verify                    # 直接触发
/verification-before-completion  # 完整名
/superpowers:verify        # 限定名

触发时机:
─────────────────────────────────────────
- 任务完成前自动触发
- 声明"任务完成"时
- "验证一下"

Verification Checklist:
─────────────────────────────────────────
☐ 运行测试: npm test / xcodebuild test
☐ 检查覆盖率: npm run coverage (≥80%)
☐ 功能验证: 启动应用手动测试
☐ 无编译错误/警告
☐ 无明显性能问题
☐ 代码已提交

人工确认回复:
─────────────────────────────────────────
"验证通过，任务完成"
或
"覆盖率 75%，需补充测试"
```

### 4.8 输入

```
docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md (已批准)
```

### 4.9 HARD-GATE 3

```
⚠️ HARD-GATE: 规格合规 + 代码质量

未通过此门禁 → 禁止合并到主分支
禁止调用 git merge / git push
```

### 4.10 审查签字命令

```text
人工批准签字 (审查报告):
─────────────────────────────────────────
在 docs/superpowers/reviews/YYYY-MM-DD-*-review.md 添加:

---
**审查人:** @architect
**审查日期:** 2026-04-14
**审查结论:** ✅ 批准合并
**HARD-GATE 3:** ✅ 通过
- Spec Compliance: ✅
- Code Quality: ✅
- 测试覆盖率: 82% ✅
- 无 CRITICAL/HIGH 问题: ✅

签字后可执行合并命令
```

---

## 5. 合并发布命令

### 5.1 合并命令

```text
HARD-GATE 3 通过后执行:
─────────────────────────────────────────

Step 1: 切换主分支
─────────────────────────────────────────
git checkout main

Step 2: 合并功能分支
─────────────────────────────────────────
git merge feature/course-list --no-ff

Step 3: 推送到远程
─────────────────────────────────────────
git push origin main

Step 4: 创建 Release
─────────────────────────────────────────
git tag -a v1.2.0 -m "Release v1.2.0: 课程列表功能"
git push origin v1.2.0
```

### 5.2 更新模块记录

```text
更新命令:
─────────────────────────────────────────
更新 Docs/Records/{module}/overview.md
更新 Docs/Records/{module}/harmony.md (或 ios.md/android.md)
更新 Docs/Records/README.md 索引
```

---

## 6. 命令速查表

### 6.1 各阶段命令

| 阶段 | 命令 | 说明 |
|------|------|------|
| **Phase 1** | `/superpowers` | 主入口 |
| | `/brainstorming` | 设计 skill |
| **Phase 2** | `/writing-plans` | 规划 skill |
| **Phase 3** | `/subagent-driven-development` | SDD 执行 |
| | `/using-git-worktrees` | 隔离环境 |
| | `/tdd` | TDD 循环 |
| | `/debug` | 系统化调试 |
| | `/verify` | 完成验证 |
| **并行执行** | `/parallel` | 并行 Agent |

### 6.2 命令简写

```text
/superpowers    → /sp (可配置别名)
/brainstorming  → /bs
/writing-plans  → /wp
/tdd            → /tdd
/debug          → /dbg
/verify         → /vfy
/parallel       → /par
```

### 6.3 完整限定名

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

## 7. 异常处理命令

### 7.1 HARD-GATE 未通过

```text
处理命令流程:
─────────────────────────────────────────

HARD-GATE 1 未通过:
─────────────────────────────────────────
用户: "设计审查失败，见问题列表"
Claude: 修复问题...
用户: "问题已修复，请重新审查"
Claude: /brainstorming (重新审查)

HARD-GATE 2 未通过:
─────────────────────────────────────────
用户: "计划包含 TBD，驳回"
Claude: 修复 TBD 问题...
用户: "修复完成，重新审查"
Claude: /writing-plans (重新审查)

HARD-GATE 3 未通过:
─────────────────────────────────────────
用户: "测试覆盖率 65%，不足 80%"
Claude: 补充测试用例...
用户: "覆盖率 82%，重新审查"
Claude: /verify (重新验证)
```

### 7.2 任务执行失败

```text
失败处理命令:
─────────────────────────────────────────

Step 1: 查看失败原因
─────────────────────────────────────────
Claude 自动输出失败详情

Step 2: 选择处理方式
─────────────────────────────────────────
方式 A: /debug 调试修复
方式 B: ExitWorktree({ action: "remove" }) 丢弃重来

Step 3: 修复后继续
─────────────────────────────────────────
/debug → 修复 → /tdd → 继续
```

---

## 8. 命令触发关键词

| Skill | 触发关键词 |
|-------|-----------|
| **brainstorming** | "设计", "规划", "新功能", "创建", "构建", "添加" |
| **writing-plans** | "计划", "实施方案", "任务分解", "实施步骤" |
| **using-git-worktrees** | "隔离", "worktree", "独立环境" |
| **subagent-driven-development** | "执行", "实施", "开始编码" |
| **test-driven-development** | "实现", "编码", "写代码", "写功能" |
| **systematic-debugging** | "调试", "debug", "问题", "bug", "不工作", "失败" |
| **verification-before-completion** | "完成", "验证", "确认", "检查" |
| **dispatching-parallel-agents** | "并行", "同时", "多平台" |

---

## 9. 检查清单汇总

### Phase 1 Checklist

```text
☐ 探索项目上下文
☐ 提供 UI/UX 视觉辅助
☐ 逐一提出澄清问题
☐ 提出 2-3 个方案
☐ 分段呈现设计
☐ 写设计文档
☐ 规格审查循环
☐ HARD-GATE 1 签字
```

### Phase 2 Checklist

```text
☐ 文件结构映射
☐ 任务粒度 2-5 分钟
☐ RED-GREEN-REFACTOR 循环
☐ No Placeholders 检查
☐ 可构建性验证
☐ 规格对齐验证
☐ HARD-GATE 2 签字
```

### Phase 3 Checklist

```text
☐ Git Worktree 隔离
☐ Subagent 分发执行
☐ /tdd RED-GREEN-REFACTOR
☐ (如遇问题) /debug
☐ /verify 完成验证
☐ Spec Compliance 检查
☐ Code Quality 检查
☐ HARD-GATE 3 签字
☐ 合并发布
```

---

## 10. 流程对比

| 维度 | 旧流程 (v1.0) | 新流程 (v2.1) |
|------|---------------|---------------|
| 阶段数量 | 6 阶段 | 3 Phase |
| 门禁类型 | 软门禁 | **硬门禁** |
| 命令驱动 | 无 | **Superpowers 命令** |
| 设计阶段 | 架构师输出 | **/superpowers brainstorming** |
| 规划阶段 | 无 | **/writing-plans** |
| 实施阶段 | 直接开发 | **/tdd /debug /verify** |
| 调试方式 | 凭直觉 | **/systematic-debugging 4阶段** |

---

## 11. 相关文档

| 文档 | 路径 | 说明 |
|------|------|------|
| Superpowers 命令完整参考 | `Docs/SOP/09-superpowers-commands.md` | 所有命令详细说明 |
| 人工操作步骤指南 | `Docs/SOP/08-manual-operations.md` | 人工配合操作 |
| Git Worktree 规范 | `Docs/SOP/07-worktree.md` | Worktree 详细说明 |
| 质量门禁 | `Docs/SOP/06-gates.md` | 硬门禁定义 |

---

**版本**: 2.1
**更新日期**: 2026-04-14
**适用范围**: 跨平台移动开发团队
**来源**: Superpowers Pipeline v6.1