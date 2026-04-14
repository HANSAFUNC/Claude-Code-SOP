# CLAUDE.md - 项目配置与开发规范索引

> 本项目使用 Superpowers Pipeline v6.1 驱动开发流程，强制执行三阶段硬门禁。

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

### 产品需求

| 文档 | 路径 |
|------|------|
| PRD 目录 | `PRD/README.md` |
| 设计稿目录 | `Design/README.md` |

### 架构设计

| 文档 | 路径 |
|------|------|
| 架构设计 | `Architect/ArchitectureDesign.md` |
| API 设计 | `Architect/APIDesign.md` |

### Superpowers Pipeline (新增)

| 文档 | 路径 |
|------|------|
| 设计规格目录 | `docs/superpowers/specs/README.md` |
| 设计规格文档 | `docs/superpowers/specs/YYYY-MM-DD-*-design.md` |
| 实施计划目录 | `docs/superpowers/plans/README.md` |
| 实施计划文档 | `docs/superpowers/plans/YYYY-MM-DD-*.md` |
| 审查报告目录 | `docs/superpowers/reviews/README.md` |
| 审查报告文档 | `docs/superpowers/reviews/YYYY-MM-DD-*-review.md` |

### 团队规范 (SOP)

| 文档 | 路径 |
|------|------|
| SOP 总览 | `Docs/SOP/README.md` |
| 团队角色 | `Docs/SOP/01-roles.md` |
| 开发流程 (v2.0) | `Docs/SOP/02-flow.md` |
| 代码审查 | `Docs/SOP/03-review.md` |
| 测试要求 | `Docs/SOP/04-testing.md` |
| Commit 规范 | `Docs/SOP/05-commit.md` |
| 质量门禁 (v2.0) | `Docs/SOP/06-gates.md` |

### 团队协作

| 文档 | 路径 |
|------|------|
| 团队协作指南 | `Docs/Guides/team-collaboration.md` |

### 模块记录

| 文档 | 路径 |
|------|------|
| 记录总览 | `Docs/Records/README.md` |

---

## 📋 开发流程 (v2.0)

### 三阶段硬门禁流程

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Superpowers 三阶段硬门禁开发流程                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Phase 1: Design      HARD-GATE 1      Phase 2: Planning                   │
│  (brainstorming)   ─────────────────→   (writing-plans)                    │
│       ↓                  ↓                    ↓                            │
│  设计规格文档      "禁止未批准实施"          实施计划文档                     │
│       ↓                                       ↓                             │
│  specs/YYYY-MM-DD-*.md                  HARD-GATE 2                         │
│                                     "计划必须可构建"                         │
│                                              ↓                              │
│  Phase 3: Implement  ─────────────────→  HARD-GATE 3                        │
│  (SDD)                  ↓             "规格合规 + 代码质量"                  │
│       ↓             Git Worktree                                           │
│  双阶段审查           隔离机制                                             │
│       ↓                                                                     │
│  reviews/YYYY-MM-DD-*-review.md                                             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 阶段详解

| 阶段 | 输入 | 输出 | 门禁 | 核心要求 |
|------|------|------|------|----------|
| **Phase 1: Design** | PRD/Design | `specs/*.md` | HARD-GATE 1 | 无 TBD、交互式设计 |
| **Phase 2: Planning** | 设计规格 | `plans/*.md` | HARD-GATE 2 | No Placeholders、2-5分钟任务 |
| **Phase 3: Implementation** | 实施计划 | 代码 + 测试 | HARD-GATE 3 | SDD + Worktree 隔离 |

---

## ⚠️ 硬门禁定义

| 门禁 | 阻塞条件 | 说明 |
|------|----------|------|
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
| `feat` | 新功能 | `feat(course): 添加课程列表页面` |
| `fix` | Bug 修复 | `fix(auth): 修复登录 token 过期问题` |
| `refactor` | 重构 | `refactor(utils): 抽取公共工具函数` |
| `docs` | 文档更新 | `docs(README): 更新快速开始指南` |
| `test` | 测试相关 | `test(user): 添加用户服务单元测试` |
| `chore` | 构建/工具 | `chore(deps): 升级依赖版本` |
| `perf` | 性能优化 | `perf(render): 优化列表渲染性能` |
| `ci` | CI/CD | `ci(github): 添加自动化测试流程` |

---

## 🧪 测试要求

| 要求项 | 标准 |
|--------|------|
| **最低覆盖率** | 80% |
| **测试类型** | 单元测试 + UI 测试 |
| **测试框架** | 平台对应框架 (XCTest/JUnit/Hypium) |
| **CI 验证** | 所有测试必须通过 |

---

## 🔀 异常处理

### HARD-GATE 未通过

```text
门禁失败 → 诊断问题 → 修复 → 重新提交审查 → 通过后继续
```

### 任务执行失败

```text
任务失败 → 在 Worktree 中诊断 → 修复 → 重新执行 → 继续
```

---

## 📁 目录规范

```text
项目根目录/
├── .claude/                    # Claude 配置
│   ├── agents/                 # 项目专用 agents
│   ├── rules/                  # 项目规则
│   ├── teams/                  # 团队配置
│   └── CLAUDE.md               # 本文件
├── docs/                       # 文档目录 (新增)
│   └── superpowers/            # Superpowers Pipeline 文档
│       ├── specs/              # 设计规格
│       │   ├── README.md       # 规格目录
│       │   └── YYYY-MM-DD-*-design.md  # 规格文档
│       ├── plans/              # 实施计划
│       │   ├── README.md       # 计划目录
│       │   └── YYYY-MM-DD-*.md # 计划文档
│       └── reviews/            # 审查报告
│       │   ├── README.md       # 审查目录
│       │   └── YYYY-MM-DD-*-review.md  # 审查文档
├── PRD/                        # 产品需求文档
├── Design/                     # UI 设计稿
├── Architect/                  # 架构设计文档
├── Docs/                       # 团队规范文档
│   ├── SOP/                    # 标准操作流程 (01-06)
│   ├── Guides/                 # 团队指南
│   └── Records/                # 模块变更记录
└── [应用源码目录]               # 应用代码
```

---

## 📝 模块记录规范

### 何时创建模块记录

**每次开发新功能时**，必须创建或更新模块记录：

| 场景 | 操作 |
|------|------|
| 全新功能模块 | 创建 `Docs/Records/{module}/` 目录及所有文件 |
| 现有模块变更 | 更新对应平台的记录文件 |
| 跨平台同步 | 更新 `overview.md` 和各平台记录 |

### 完成开发后检查

- [ ] 代码已提交到 git
- [ ] `Docs/Records/{module}/overview.md` 已创建/更新
- [ ] 平台记录文件已更新
- [ ] `Docs/Records/README.md` 索引已更新
- [ ] 变更历史已登记 (Commit、PR)

---

## 🔄 流程对比

| 维度 | v1.0 (旧) | v2.0 (新) |
|------|-----------|-----------|
| 阶段数量 | 6 阶段 | 3 Phase |
| 门禁类型 | 软门禁 | **硬门禁** |
| 设计阶段 | 架构师输出 | **交互式 brainstorming** |
| 规划阶段 | 无 | **强制 writing-plans** |
| 任务粒度 | 模块级 | **2-5 分钟** |
| 实施机制 | 并行开发 | **SDD + Worktree** |
| 审查机制 | 双层审查 | **双阶段审查** |

---

**版本**: 2.2
**更新日期**: 2026-04-13
**来源**: Superpowers Pipeline v6.1
**说明**: 三阶段硬门禁流程 - 适用于跨平台移动项目