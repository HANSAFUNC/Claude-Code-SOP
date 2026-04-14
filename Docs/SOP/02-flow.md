# 开发流程

**版本:** 3.1
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

### 2.4 各步骤角色分工

#### Step 1: 探索项目上下文

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 阅读 PRD/Design 文件，理解业务需求 | **主产出**: 需求理解 |
| **Architect** | 查看最近 git log，了解技术现状 | **主产出**: 技术背景 |
| **Architect** | 检查现有架构文档 Architect/*.md | **主产出**: 架构依赖分析 |
| **Platform Spec** | 查看现有代码实现，了解平台差异 | 辅助: 平台现状说明 |
| **QA** | 查看现有测试覆盖率，了解测试现状 | 辅助: 测试现状说明 |

#### Step 2: 提供 UI/UX 视觉辅助

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 展示 Design 设计稿截图或 mockup | **主产出**: UI 参考图 |
| **Architect** | 说明 UI 组件层级和交互流程 | **主产出**: UI 流程图 |
| **Platform Spec** | 提出平台特定 UI 规范建议 | 辅助: 平台 UI 建议 |

#### Step 3: 逐一提出澄清问题

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 提出技术可行性问题 | **主产出**: 问题清单 |
| **Architect** | 提出架构扩展性问题 | **主产出**: 问题清单 |
| **Platform Spec** | 提出平台兼容性问题 | 辅助: 补充问题 |
| **QA** | 提出测试覆盖边界问题 | 辅助: 补充问题 |

#### Step 4: 提出 2-3 个方案

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 设计 2-3 个技术方案 | **主产出**: 方案对比表 |
| **Architect** | 分析各方案优劣和取舍 | **主产出**: 方案分析 |
| **Platform Spec** | 补充平台实现差异说明 | 辅助: 平台差异备注 |
| **QA** | 补充测试难度评估 | 辅助: 测试难度说明 |

#### Step 5: 分段呈现设计内容

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 分段展示设计规格内容 | **主产出**: 设计段落 |
| **Architect** | 等待人工确认或修改 | **主产出**: 确认记录 |
| **Platform Spec** | 提出平台实现细节补充 | 辅助: 补充内容 |
| **QA** | 提出测试策略补充 | 辅助: 补充内容 |

#### Step 6: 写设计文档

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 撰写设计规格文档 | **主产出**: specs/*.md |
| **Architect** | 定义数据模型和 API | **主产出**: Models/API 定义 |
| **Platform Spec** | 补充平台特定实现说明 | 辅助: 平台说明章节 |
| **QA** | 补充测试策略章节 | 辅助: 测试策略章节 |

#### Step 7: Self-Review

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 检查完整性 (无 TBD) | **主产出**: 完整性确认 |
| **Architect** | 检查一致性 (无矛盾) | **主产出**: 一致性确认 |
| **Architect** | 检查 YAGNI (无过度设计) | **主产出**: YAGNI 确认 |
| **Platform Spec** | 检查平台可行性 | 辅助: 平台可行性确认 |
| **QA** | 检查测试可覆盖性 | 辅助: 测试覆盖确认 |

#### Step 8: 输出设计规格文档

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 最终文档输出并签字批准 | **主产出**: specs/*.md + HARD-GATE 1 通过签字 |
| **全员** | 确认文档内容无异议 | 辅助: 确认记录 |

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

### 2.7 Checklist

```text
Phase 1 Checklist:
─────────────────────────────────────────
☐ 探索项目上下文 (Architect + Platform Spec + QA)
☐ 提供 UI/UX 视觉辅助 (Architect)
☐ 逐一提出澄清问题 (全员)
☐ 提出 2-3 个方案 (Architect + Platform Spec + QA)
☐ 分段呈现设计 (Architect)
☐ 写设计文档 (Architect)
☐ 规格审查循环 (全员)
☐ HARD-GATE 1 签字 (Architect)
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

### 3.4 各步骤角色分工

#### Step 1: 加载已批准设计规格

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 加载 specs/*.md 文档 | **主产出**: 设计规格加载 |
| **Architect** | 向全员介绍设计重点 | **主产出**: 设计要点说明 |
| **Platform Spec** | 确认平台实现范围 | 辅助: 范围确认 |
| **QA** | 确认测试范围 | 辅助: 范围确认 |

#### Step 2: 文件结构映射

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 规划整体文件结构 | **主产出**: 文件结构列表 |
| **Architect** | 定义新增/修改文件 | **主产出**: 文件变更清单 |
| **iOS-Spec** | 规划 iOS 文件结构 | 辅助: iOS 文件建议 |
| **Android-Spec** | 规划 Android 文件结构 | 辅助: Android 文件建议 |
| **Harmony-Spec** | 规划 Harmony 文件结构 | 辅助: Harmony 文件建议 |
| **QA** | 规划测试文件结构 | 辅助: 测试文件建议 |

#### Step 3: 任务分解

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 分解整体任务为 2-5 分钟粒度 | **主产出**: 任务清单 |
| **Architect** | 定义任务依赖关系 | **主产出**: 依赖图 |
| **iOS-Spec** | 分解 iOS 平台任务 | 辅助: iOS 任务建议 |
| **Android-Spec** | 分解 Android 平台任务 | 辅助: Android 任务建议 |
| **Harmony-Spec** | 分解 Harmony 平台任务 | 辅助: Harmony 任务建议 |
| **QA** | 分解测试编写任务 | 辅助: 测试任务建议 |

#### Step 4: RED-GREEN-REFACTOR 定义

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 定义 TDD 循环步骤 | **主产出**: TDD 步骤定义 |
| **Platform Spec** | 定义平台特定测试策略 | 辅助: 平台测试建议 |
| **QA** | 定义测试验收标准 | 辅助: 验收标准建议 |

#### Step 5: No Placeholders 检查

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 自动检查 TBD/模糊描述 | **主产出**: 检查结果 |
| **Architect** | 人工确认无占位符 | **主产出**: 确认签字 |
| **全员** | 确认任务描述明确可执行 | 辅助: 确认记录 |

#### Step 6: Self-Review

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 检查可构建性 | **主产出**: 可构建性确认 |
| **Architect** | 检查规格对齐 | **主产出**: 规格对齐确认 |
| **Platform Spec** | 检查任务粒度合理性 | 辅助: 粒度确认 |
| **QA** | 检查测试覆盖完整性 | 辅助: 测试覆盖确认 |

#### Step 7: 输出实施计划文档

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 最终计划文档输出并签字批准 | **主产出**: plans/*.md + 批准签字 |
| **全员** | 确认计划可执行无异议 | 辅助: 确认记录 |

### 3.5 输入/输出

```text
输入: docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md (已批准)
输出: docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md
```

### 3.6 HARD-GATE 2

```
⚠️ HARD-GATE: 计划必须可构建

未通过此门禁 → 禁止进入 Phase 3
禁止调用 /subagent-driven-development 命令
```

### 3.7 No Placeholders 规则

```text
计划失败条件 (必须重新规划):
─────────────────────────────────────────
❌ TBD 字样
❌ 模糊描述 ("待确认"、"待定")
❌ 未定义引用 ("类似 Task N")
❌ 占位符 ("// ... existing code ...")
```

### 3.8 Checklist

```text
Phase 2 Checklist:
─────────────────────────────────────────
☐ 加载设计规格 (Architect)
☐ 文件结构映射 (Architect + Platform Spec + QA)
☐ 任务分解 2-5 分钟 (各角色分工)
☐ RED-GREEN-REFACTOR 定义 (Architect + QA)
☐ No Placeholders 检查 (Architect)
☐ 可构建性验证 (Architect + Platform Spec)
☐ 规格对齐验证 (Architect)
☐ HARD-GATE 2 签字 (Architect)
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
│  iOS-Spec  Android-Spec Harmony-Spec QA                                     │
│  执行任务   执行任务       执行任务     编写测试                                │
│  RED-GREEN-REFACTOR                                                     │
│       ↓                                                                     │
│  Step 3: (如遇问题) /debug                                                   │
│          4阶段调试流程                                                        │
│       ↓                                                                     │
│  Step 4: /verify 完成前验证                                                  │
│       ↓                                                                     │
│  Step 5: ExitWorktree                                                       │
│       ↓                                                                     │
│  Step 6: 双阶段审查                                                          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4.4 各步骤角色分工

#### Step 1: Git Worktree 隔离

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 创建 Worktree 隔离环境 | **主产出**: Worktree 目录 |
| **Architect** | 分配任务给各平台专家 | **主产出**: 任务分配表 |
| **iOS-Spec** | 进入 iOS worktree 目录 | 辅助: iOS 工作环境准备 |
| **Android-Spec** | 进入 Android worktree 目录 | 辅助: Android 工作环境准备 |
| **Harmony-Spec** | 进入 Harmony worktree 目录 | 辅助: Harmony 工作环境准备 |

#### Step 2: /subagent-driven-development 执行

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 监控任务执行进度 | 辅助: 进度监控 |
| **Architect** | 协调跨平台依赖 | 辅助: 协调记录 |
| **iOS-Spec** | 执行 iOS 任务: Models → ViewModel → View | **主产出**: iOS 源代码 |
| **Android-Spec** | 执行 Android 任务: Models → ViewModel → View | **主产出**: Android 源代码 |
| **Harmony-Spec** | 执行 Harmony 任务: Models → ViewModel → View | **主产出**: Harmony 源代码 |
| **QA** | 执行测试任务: 编写测试用例 | **主产出**: 测试源代码 |

#### Step 3: RED-GREEN-REFACTOR 循环 (每个任务)

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Platform Spec** | [RED] 写测试文件，运行确认失败 | **主产出**: 测试文件 |
| **Platform Spec** | [GREEN] 写实现代码，运行确认通过 | **主产出**: 实现文件 |
| **Platform Spec** | [REFACTOR] 优化代码质量 | **主产出**: 优化代码 |
| **QA** | 验证测试覆盖率和质量 | 辅助: 覆盖率确认 |
| **Platform Spec** | [COMMIT] git commit 提交代码 | **主产出**: 提交记录 |

#### Step 4: /debug 调试 (如遇问题)

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Platform Spec** | 描述问题现象 | **主产出**: 问题描述 |
| **Platform Spec** | 查看错误日志和堆栈 | **主产出**: 错误日志分析 |
| **Architect** | 协助分析根因 | 辅助: 根因分析建议 |
| **Platform Spec** | 制定修复方案并实施 | **主产出**: 修复代码 |
| **QA** | 验证修复后测试通过 | 辅助: 验证确认 |

#### Step 5: /verify 完成前验证

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **QA** | 运行所有测试 | **主产出**: 测试报告 |
| **QA** | 检查覆盖率 ≥80% | **主产出**: 覆盖率报告 |
| **Platform Spec** | 启动应用手动测试 | 辅助: 手测确认 |
| **Platform Spec** | 确认无编译错误/警告 | 辅助: 编译确认 |
| **Architect** | 确认所有任务已完成 | 辅助: 完成确认 |

#### Step 6: 双阶段审查

**Stage 1: Spec Compliance (Architect 主导)**

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | 对照设计规格检查需求满足 | **主产出**: Spec 合规确认 |
| **Architect** | 检查数据模型一致性 | **主产出**: 数据模型确认 |
| **Architect** | 检查 API 接口一致性 | **主产出**: API 确认 |
| **Architect** | 检查 UI/UX 实现一致性 | **主产出**: UI 确认 |

**Stage 2: Code Quality (QA + Architect)**

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **QA** | 检查代码规范 | **主产出**: 规范确认 |
| **QA** | 验证测试覆盖率 | **主产出**: 覆盖率确认 |
| **Architect** | 检查安全漏洞 | **主产出**: 安全确认 |
| **QA** | 检查性能无回归 | **主产出**: 性能确认 |
| **Architect** | 最终批准签字 | **主产出**: HARD-GATE 3 通过签字 |

### 4.5 HARD-GATE 3

```
⚠️ HARD-GATE: 规格合规 + 代码质量

未通过此门禁 → 禁止合并到主分支
禁止调用 git merge / git push
```

### 4.6 Checklist

```text
Phase 3 Checklist:
─────────────────────────────────────────
☐ Git Worktree 隔离 (Architect)
☐ 任务分配 (Architect → Platform Spec + QA)
☐ /tdd RED-GREEN-REFACTOR (Platform Spec)
☐ (如遇问题) /debug (Platform Spec + Architect)
☐ /verify 完成验证 (QA + Platform Spec + Architect)
☐ Spec Compliance 检查 (Architect)
☐ Code Quality 检查 (QA + Architect)
☐ HARD-GATE 3 签字 (Architect + QA)
☐ 合并发布 (Architect)
```

---

## 5. 合并发布

### 5.1 各角色操作

| 角色 | 操作 | 主产出/辅助 |
|------|------|-------------|
| **Architect** | git checkout main + merge | **主产出**: 合并记录 |
| **Architect** | git push + 创建 tag | **主产出**: 发布记录 |
| **Architect** | 更新 CHANGELOG.md | **主产出**: Changelog |
| **Platform Spec** | 更新模块记录 overview.md | 辅助: 模块记录更新 |
| **QA** | 更新测试报告归档 | 辅助: 测试归档 |

---

## 6. 命令速查表

| 阶段 | 命令 | 主导角色 |
|------|------|----------|
| **Phase 1** | `/superpowers`, `/brainstorming` | Architect |
| **Phase 2** | `/writing-plans` | Architect |
| **Phase 3** | `/subagent-driven-development` | Platform Spec |
| | `/tdd` | Platform Spec |
| | `/debug` | Platform Spec |
| | `/verify` | QA + Architect |

---

## 7. 相关文档

| 文档 | 路径 | 说明 |
|------|------|------|
| 团队角色 | [01-roles.md](./01-roles.md) | 角色职责定义 |
| 门禁详细定义 | [03-gates.md](./03-gates.md) | HARD-GATE 检查清单 |
| 开发规范 | [04-standards.md](./04-standards.md) | 测试 + Commit 规范 |
| Worktree 规范 | [05-worktree.md](./05-worktree.md) | 隔离环境使用 |
| 人工操作指南 | [06-operations.md](./06-operations.md) | 详细操作步骤 |

---

**版本**: 3.1
**更新日期**: 2026-04-14
**适用范围**: 跨平台移动开发团队
**来源**: Superpowers Pipeline v6.1