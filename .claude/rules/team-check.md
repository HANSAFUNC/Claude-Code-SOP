# Agent Team 检查规则

## 核心规则

**在开始任何开发任务前，必须检查 Agent Team 是否已创建。**

## 检查流程

```
1. 检查当前是否有活跃的 Team
2. 如果没有团队 → 询问用户是否创建
3. 用户确认后 → 创建团队和成员
4. 团队创建完成后 → 分配任务
```

## 如何检查团队状态

查看项目 `.claude/teams/` 目录下是否有团队配置：

```bash
ls .claude/teams/
```

## 询问用户模板

如果发现团队未创建，必须使用以下模板询问：

```
⚠️ 根据项目规范，开发新功能前必须先创建 Agent Team。

检测到当前没有活跃团队，是否现在创建？

建议团队名称：{module-name}-team
建议角色：Architect、Harmony 专家、QA 工程师、Code Reviewer

请选择：
A) 立即创建团队
B) 跳过团队创建（仅当任务不需要协作时）
```

## 创建团队流程

### Step 1: 创建团队

```typescript
TeamCreate({
  team_name: "{module-name}-team",
  description: "{模块名称}开发团队",
  agent_type: "team-lead"
})
```

### Step 2: 创建成员

使用 `Agent` 工具创建以下角色（必须指定 `team_name`）：

| 角色 | Agent 类型 | 职责 |
|------|-----------|------|
| Architect | `everything-claude-code:architect` | 架构设计和评审 |
| Harmony 专家 | `general-purpose` | HarmonyOS 平台实现 |
| QA 工程师 | `general-purpose` | 测试验证和覆盖率 |
| Code Reviewer | `everything-claude-code:code-reviewer` | 代码审查 |

### Step 3: 分配任务

使用 `SendMessage` 工具分派任务给各角色。

## 例外情况

只有在以下情况可以跳过团队创建：

- 简单的文件读取/查询任务
- 文档更新
- Git 操作
- 配置修改

**凡是涉及代码编写的任务，必须创建团队。**
