# CLAUDE.md - 项目配置与开发规范索引

> 本项目使用 Superpowers 插件 + Agent Team 驱动开发流程，所有新功能开发必须启动 Agent Team 协作。

---

## 🚀 核心指令

### Agent Team 模式（强制）

**每次开发新功能时，必须启动 Agent Team 团队协作模式：**

```bash
# 1. 创建团队
/teams create {module-name}-team

# 2. 创建团队成员（按角色）- 使用 Agent 工具
- Architect（架构师）- 负责架构设计和评审
- Harmony 专家 - 负责 HarmonyOS 平台实现
- iOS 专家 - 负责 iOS 平台实现（如适用）
- Android 专家 - 负责 Android 平台实现（如适用）
- QA 工程师 - 负责测试验证和覆盖率
- Code Reviewer - 负责代码审查
```

**重要**：
- 必须使用 `Agent` 工具创建团队成员，指定 `team_name` 和 `prompt` 参数
- 团队创建后，由 Team Lead 协调以下流程
- 不创建团队直接开发 = 违反流程

**团队工作流程**：

1. **需求分析** - 全员参与
2. **架构设计** - Architect 主导
3. **任务分配** - Team Lead 使用 `SendMessage` 工具分派给各角色
4. **并行开发** - 各平台专家独立开发
5. **测试验证** - QA 工程师负责
6. **代码审查** - Code Reviewer 负责
7. **合并发布** - Team Lead 负责

### Superpowers 技能

配合 Agent Team 使用，所有开发流程必须调用 Superpowers：

```bash
/superpowers
```

Superpowers 将协调：需求分析 → 架构设计 → 测试先行 → 并行实现 → 验证审查

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
| 数据模型 | `Architect/DataModels.md` |
| API 设计 | `Architect/APIDesign.md` |

### 团队规范 (SOP)
| 文档 | 路径 |
|------|------|
| SOP 总览 | `Docs/SOP/README.md` |
| 团队角色 | `Docs/SOP/01-roles.md` |
| 开发流程 | `Docs/SOP/02-flow.md` |
| 代码审查 | `Docs/SOP/03-review.md` |
| 测试要求 | `Docs/SOP/04-testing.md` |
| Commit 规范 | `Docs/SOP/05-commit.md` |
| 质量门禁 | `Docs/SOP/06-gates.md` |

### 团队协作
| 文档 | 路径 |
|------|------|
| 团队协作指南 | `Docs/Guides/team-collaboration.md` |

### 模块记录
| 文档 | 路径 |
|------|------|
| 记录总览 | `Docs/Records/README.md` |

---

## 📋 开发流程

### 完整流程图

```
┌────────────────────────────────────────────────────────────────────────────┐
│                           团队协作开发流程                                  │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐            │
│  │ 需求输入 │ →  │ 架构设计 │ →  │ 并行开发 │ →  │ 测试验证 │            │
│  │ PRD+Design│   │ Gate 1   │    │Code+Test │    │ Gate 2   │            │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘            │
│       ↓               ↓               ↓               ↓                   │
│   文档完整        评审通过        自测通过        覆盖率≥80%               │
│                                                    ↓                       │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐                           │
│  │ 合并发布 │ ←  │ 代码审查 │ ←  │ 模块记录 │                           │
│  │ Release  │    │ Gate 3   │    │ Gate 4   │                           │
│  └──────────┘    └──────────┘    └──────────┘                           │
│       ↓               ↓               ↓                                   │
│   发布成功       审查通过        记录已更新                               │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

### 阶段详解

| 阶段 | 负责人 | 参与人 | 准入条件 | 准出条件 | 产出物 |
|------|--------|--------|----------|----------|--------|
| **1. 需求输入** | PM | 全员 | PRD/Design 已上传 | 需求理解一致 | PRD、Design 文档 |
| **2. 架构设计** | Architect | 全员 | 需求明确 | 评审通过 | 架构文档、数据模型、API 设计 |
| **3. 并行开发** | Specialist | QA | 架构评审通过 | 自测通过 | 代码 + 测试用例 |
| **4. 测试验证** | QA | Specialist | 代码完成 | 覆盖率≥80% | 测试报告、覆盖率报告 |
| **5. 代码审查** | Architect | 全员 | 测试通过 | 问题解决 | 审查报告 |
| **6. 合并发布** | Team Lead | 全员 | 审查通过 | 发布成功 | Release、Changelog |
| **7. 模块记录** | Specialist | 全员 | 代码已合并 | 记录已更新 | `Docs/Records/{module}/` |

---

## 🎯 并行开发模式

```
                         Architect
                    (架构设计 + 评审)
                          │
                          ↓
        ┌─────────────────┼─────────────────┐
        ↓                 ↓                 ↓
   iOS 专家          Android 专家        Harmony 专家
   Models            Models              Models
   ViewModels        ViewModels          ViewModels
   Views             Composables         ArkUI
        │                 │                 │
        └─────────────────┼─────────────────┘
                          ↓
                    QA 工程师
              (整合测试 + 覆盖率验证)
```

---

## ✅ 质量门禁 (Quality Gates)

### Gate 1: 架构评审
- [ ] 架构文档完整
- [ ] 数据模型定义清晰
- [ ] API 接口设计合理
- [ ] 全员评审通过

### Gate 2: 测试验证
- [ ] 所有测试用例通过
- [ ] 测试覆盖率 ≥ 80%
- [ ] 无阻塞性 Bug

### Gate 3: 代码审查
- [ ] 代码符合规范
- [ ] 无安全漏洞
- [ ] 性能无回归
- [ ] 审查问题全部解决

### Gate 4: 模块记录
- [ ] `Docs/Records/{module}/overview.md` 已创建/更新
- [ ] 平台记录文件已创建/更新 (`ios.md` / `android.md` / `harmony.md`)
- [ ] 变更历史已登记（版本、日期、Commit、PR）
- [ ] 技术决策已记录（如适用）
- [ ] `Docs/Records/README.md` 索引已更新

---

## 📝 Commit 规范

采用 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

```
<type>: <description>

<optional body>
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

### 需求变更
```
变更请求 → 影响评估 → 架构调整 → 任务重分配 → 继续开发
```

### 技术阻塞
```
发现问题 → 团队讨论 → Architect 决策 → 方案调整 → 继续开发
```

### 质量不达标
```
测试失败/覆盖率不足 → 分析原因 → 修复 → 重新验证
```

---

## 📁 目录规范

```
项目根目录/
├── .claude/                    # Claude 配置
│   ├── agents/                 # 项目专用 agents
│   ├── rules/                  # 项目规则
│   ├── teams/                  # 团队配置
│   └── CLAUDE.md               # 本文件
├── PRD/                        # 产品需求文档
├── Design/                     # UI 设计稿
├── Architect/                  # 架构设计文档
├── Docs/                       # 团队规范文档
│   ├── SOP/                    # 标准操作流程 (01-06)
│   ├── Guides/                 # 团队指南
│   ├── Records/                # 模块变更记录
│   │   ├── README.md           # 记录索引
│   │   └── {module}/           # 模块记录目录
│   │       ├── overview.md     # 跨平台概述
│   │       ├── ios.md          # iOS 记录
│   │       ├── android.md      # Android 记录
│   │       └── harmony.md      # Harmony 记录
│   ├── Agents/                 # Agent 文档
│   └── Tests/                  # 测试计划
└── [应用源码目录]               # 应用代码
```

---

## 📝 模块记录规范

### 何时创建模块记录

**每次开发新功能时**，必须创建或更新模块记录：

| 场景 | 操作 |
|------|------|
| 全新功能模块 | 创建 `Docs/Records/{module}/` 目录及所有文件 |
| 现有模块变更 | 更新对应平台的记录文件（如 `harmony.md`） |
| 跨平台同步 | 更新 `overview.md` 和各平台记录 |

### 记录文件结构

| 文件 | 必填 | 内容 |
|------|------|------|
| `overview.md` | ✅ | 模块概述、跨平台变更总览、团队成员 |
| `ios.md` | 条件 | iOS 平台实现（仅当有 iOS 代码时） |
| `android.md` | 条件 | Android 平台实现（仅当有 Android 代码时） |
| `harmony.md` | ✅ | HarmonyOS 平台实现 |

### 变更历史格式

```markdown
| 版本 | 日期 | 变更类型 | 变更描述 | 关联 Commit | PR |
|------|------|----------|----------|-------------|-----|
| v1.0 | 2026-04-02 | feat | 初始版本 | abc1234 | #123 |
```

**变更类型**：`feat` / `fix` / `refactor` / `docs` / `test`

### 完成开发后检查

- [ ] 代码已提交到 git
- [ ] `Docs/Records/{module}/overview.md` 已创建/更新
- [ ] 平台记录文件已更新（`harmony.md` / `ios.md` / `android.md`）
- [ ] `Docs/Records/README.md` 索引已更新
- [ ] 变更历史已登记（Commit、PR）

---

**版本**: 2.1
**更新日期**: 2026-04-02
**说明**: 通用模板 - 适用于跨平台移动项目 (iOS/Android/Harmony)
