# 团队协作指南

> 本指南定义多角色团队协作的标准流程和职责分工

---

## 📋 目录

1. [团队角色](#-团队角色)
2. [开发流程](#-开发流程)
3. [沟通机制](#-沟通机制)
4. [文档规范](#-文档规范)
5. [工具使用](#-工具使用)

---

## 👥 团队角色

### 角色定义

| 角色 | 职责 | 关键产出 |
|------|------|----------|
| **mobile-architect** | 架构设计、技术选型、代码审查 | 架构文档、数据模型、API 设计 |
| **platform-specialist** | 平台开发 (iOS/Android/Harmony) | Models、ViewModels、Views/Composables |
| **mobile-qa** | 测试用例、覆盖率验证 | 测试代码、测试报告、覆盖率分析 |

### 职责详情

#### mobile-architect
- 负责系统架构设计和技术选型
- 定义数据模型和 API 接口
- 主导代码审查，确保代码质量
- 解决技术难题和性能瓶颈

#### platform-specialist
- 负责各平台 (iOS/Android/Harmony) 的代码实现
- 遵循架构设计规范
- 编写单元测试
- 参与代码审查

#### mobile-qa
- 编写测试用例和自动化测试
- 验证测试覆盖率 (≥80%)
- 输出测试报告
- 跟踪 Bug 修复

---

## 🔄 开发流程

### 阶段总览

```
需求输入 → 架构设计 → 并行开发 → 测试验证 → 代码审查 → 合并发布
   ↓          ↓          ↓          ↓          ↓          ↓
 PRD+Design  Gate 1    Code+Test  Gate 2     Gate 3     Release
```

### 各阶段说明

| 阶段 | 负责人 | 参与人 | 产出物 |
|------|--------|--------|--------|
| 需求输入 | PM | 全员 | PRD、Design |
| 架构设计 | Architect | 全员 | 架构文档、数据模型、API 设计 |
| 并行开发 | Specialist | QA | 代码 + 测试用例 |
| 测试验证 | QA | Specialist | 测试报告、覆盖率报告 |
| 代码审查 | Architect | 全员 | 审查报告 |
| 合并发布 | Team Lead | 全员 | Release、Changelog |

### 质量门禁

**Gate 1 - 架构评审**
- 架构文档完整
- 数据模型清晰
- API 设计合理

**Gate 2 - 测试验证**
- 所有测试通过
- 覆盖率 ≥ 80%

**Gate 3 - 代码审查**
- 审查问题解决
- Architect 批准

---

## 💬 沟通机制

### 日常沟通

| 场景 | 方式 | 说明 |
|------|------|------|
| 需求确认 | 会议/文档评论 | PRD/Design 评审 |
| 技术讨论 | 代码评论/会议 | 架构评审、技术难点 |
| 进度同步 | 任务评论 | 任务状态更新 |
| Bug 反馈 | Issue/Bug 系统 | 描述复现步骤 |

### 会议规范

| 会议类型 | 频率 | 参与人 | 时长 |
|----------|------|--------|------|
| 需求评审 | 按需 | 全员 | 30-60min |
| 架构评审 | 按需 | 全员 | 30-60min |
| 每日站会 | 每日 | 全员 | 15min |
| 迭代回顾 | 迭代结束 | 全员 | 60min |

---

## 📄 文档规范

### 文档分类

| 类型 | 目录 | 命名规范 |
|------|------|----------|
| 产品需求 | `PRD/` | `YYYYMMDD-{产品}-{功能}-PRD.md` |
| 设计稿 | `Design/` | `YYYYMMDD-{产品}-{功能}-Design.png` |
| 架构文档 | `Architect/` | `ArchitectureDesign.md`, `DataModels.md`, `APIDesign.md` |
| SOP 流程 | `Docs/SOP/` | `01-roles.md`, `02-flow.md`, `03-review.md` 等 |
| 团队指南 | `Docs/Guides/` | `team-collaboration.md` |

### Commit 规范

采用 [Conventional Commits](https://www.conventionalcommits.org/)：

```
<type>: <description>
```

**Types:** `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `ci`

**示例:**
```
feat(course): 添加课程列表页面
fix(auth): 修复登录 token 过期问题
refactor(utils): 抽取公共工具函数
```

---

## 🛠️ 工具使用

### 开发工具

| 工具 | 用途 | 说明 |
|------|------|------|
| DevEco Studio | HarmonyOS 开发 | 官方 IDE |
| Xcode | iOS 开发 | Apple 官方 IDE |
| Android Studio | Android 开发 | Google 官方 IDE |

### 协作工具

| 工具 | 用途 | 说明 |
|------|------|------|
| Git | 版本控制 | 代码管理 |
| Claude Code | AI 辅助开发 | 代码生成、审查 |
| Superpowers | 工作流管理 | 开发流程自动化 |

### Superpowers 使用

```bash
# 新功能开发
/superpowers

# 代码审查
/superpowers review

# 测试生成
/superpowers test
```

---

## 📊 任务跟踪

### 任务状态

| 状态 | 说明 |
|------|------|
| `pending` | 待处理 |
| `in_progress` | 进行中 |
| `blocked` | 已阻塞 (需注明阻塞原因) |
| `completed` | 已完成 |

### 任务分解

架构设计完成后，任务按以下方式分解：

| 任务类型 | 内容 | 负责人 |
|----------|------|--------|
| Models | 数据模型实现 | 各平台 Specialist |
| ViewModels | 业务逻辑实现 | 各平台 Specialist |
| Views | UI 组件实现 | 各平台 Specialist |
| Tests | 测试用例编写 | QA + Specialist |

---

**版本**: 2.0
**更新日期**: 2026-04-02
**适用范围**: 跨平台移动开发团队
