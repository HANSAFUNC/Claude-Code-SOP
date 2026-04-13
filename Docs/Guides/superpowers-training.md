# Superpowers Pipeline 培训指南

**版本:** 1.0
**日期:** 2026-04-13
**对象:** 全员 (Architect, Specialist, QA)

---

## 1. 培训目标

通过本培训，团队成员将掌握：

| 目标 | 说明 |
|------|------|
| **理解流程** | 三阶段硬门禁开发流程 |
| **掌握工具** | Superpowers skills 使用方法 |
| **遵循规范** | No Placeholders、任务粒度要求 |
| **执行审查** | 双阶段审查标准 |

---

## 2. 培训大纲

### 2.1 培训时长

| 模块 | 时长 | 形式 |
|------|------|------|
| **模块 1: 流程概览** | 30 分钟 | 讲授 |
| **模块 2: Phase 1 实操** | 45 分钟 | 演示 + 练习 |
| **模块 3: Phase 2 实操** | 45 分钟 | 演示 + 练习 |
| **模块 4: Phase 3 实操** | 60 分钟 | 演示 + 练习 |
| **模块 5: 审查流程** | 30 分钟 | 讲授 + 讨论 |
| **模块 6: 综合演练** | 60 分钟 | 实战项目 |
| **总计** | 4.5 小时 | |

---

## 3. 模块 1: 流程概览 (30分钟)

### 3.1 内容

1. **v1.0 vs v2.0 对比**
   - 6 阶段 → 3 Phase
   - 软门禁 → 硬门禁
   - 并行开发 → SDD

2. **三阶段流程**
   ```
   Design → HARD-GATE 1 → Planning → HARD-GATE 2 → Implementation → HARD-GATE 3
   ```

3. **核心概念**
   - 硬门禁定义
   - No Placeholders 规则
   - RED-GREEN-REFACTOR
   - Git Worktree 隔离

### 3.2 讲授要点

| 要点 | 强调程度 |
|------|----------|
| 硬门禁 = 阻塞 | ⚠️⚠️⚠️ 高 |
| No Placeholders = 禁止 | ⚠️⚠️⚠️ 高 |
| 任务粒度 2-5 分钟 | ⚠️⚠️ 中 |
| SDD 防止上下文污染 | ⚠️⚠️ 中 |

### 3.3 讨论问题

1. 为什么硬门禁比软门禁更有效？
2. No Placeholders 规则能解决什么问题？
3. 任务粒度为什么需要控制在 2-5 分钟？

---

## 4. 模块 2: Phase 1 实操 (45分钟)

### 4.1 内容

1. **brainstorming skill 触发**

```bash
/superpowers
```

2. **交互式设计流程**

```
探索上下文 → 提澄清问题 → 提方案选项 → 分段呈现 → 写规格文档 → 规格审查
```

3. **设计规格文档结构**

| 章节 | 必填 | 内容 |
|------|------|------|
| 背景 | ✅ | 业务价值 |
| 目标 | ✅ | 目标列表 |
| 方案选项 | ✅ | 2-3 个方案 + 推荐 |
| 详细设计 | ✅ | 数据模型、API、UI |
| 风险评估 | ✅ | 风险 + 缓解措施 |

### 4.2 演示案例

**案例: 课程列表功能**

```markdown
# 课程列表 - 设计规格

## 1. 背景
用户需要浏览和筛选保险培训课程。

## 2. 目标
- 支持课程列表展示
- 支持分类筛选
- 支持关键词搜索

## 3. 方案选项

### 方案 A: 纯本地缓存
优点: 快速响应
缺点: 数据不及时

### 方案 B: 远程 API + 本地缓存
优点: 数据及时 + 离线可用
缺点: 实现复杂

### 推荐方案: 方案 B
理由: 业务需要实时数据更新

## 4. 详细设计
[数据模型、API、UI...]
```

### 4.3 练习任务

**任务: 设计"用户登录"功能规格**

```text
时间: 15 分钟
要求:
1. 写出背景和目标
2. 提出至少 2 个方案
3. 给出推荐方案和理由
4. 符合 No Placeholders 规则
```

---

## 5. 模块 3: Phase 2 实操 (45分钟)

### 5.1 内容

1. **writing-plans skill**

```
输入: 已批准设计规格
输出: 实施计划文档
```

2. **No Placeholders 规则**

| 问题类型 | 示例 | 为什么禁止 |
|----------|------|------------|
| TBD | "TBD: 待确认" | 不明确，无法执行 |
| 未定义引用 | "类似 Task N" | 依赖外部，可能误解 |
| 占位符 | "// ... existing code ..." | 代码不完整 |

3. **任务粒度要求**

```
每个任务: 2-5 分钟
遵循: RED-GREEN-REFACTOR 循环
```

4. **RED-GREEN-REFACTOR 模式**

```text
[RED]   写测试 → 运行测试 → 预期失败
[GREEN] 实现功能 → 运行测试 → 预期通过
[REFACTOR] 清理代码 → 运行测试 → 保持通过
[COMMIT] 提交代码 → 标记完成
```

### 5.2 演示案例

**案例: 课程列表计划**

```markdown
# 课程列表 - 实施计划

## 文件结构映射

### 新增文件
| 文件路径 | 类型 | 说明 |
|----------|------|------|
| `Models/Course.ets` | Model | 课程数据模型 |
| `ViewModels/CourseListViewModel.ets` | ViewModel | 列表视图模型 |
| `Views/CourseListPage.ets` | Page | 课程列表页面 |

## 任务列表

### Task 1: 创建 Course 数据模型
时间: 3 分钟

[RED] 写测试: 创建 `Tests/CourseTests.ets`，测试 id, title 属性
[RED] 运行测试: 预期失败 (Course 类不存在)
[GREEN] 实现: 在 `Models/Course.ets` 中定义 Course 类
[GREEN] 运行测试: 预期通过
[REFACTOR] 添加注释
[COMMIT] `feat: add Course model`
```

### 5.3 练习任务

**任务: 编写"用户登录"实施计划**

```text
时间: 20 分钟
要求:
1. 文件结构映射
2. 3-5 个任务，每个 2-5 分钟
3. 无 TBD/占位符
4. 包含 RED-GREEN-REFACTOR 循环
```

---

## 6. 模块 4: Phase 3 实操 (60分钟)

### 6.1 内容

1. **Subagent-Driven Development (SDD)**

```
Controller Agent → 分发任务 → Subagent 在 Worktree 执行 → 返回结果
```

2. **Git Worktree 使用**

```typescript
// 创建隔离环境
EnterWorktree({ name: "course-list-001" })

// 执行任务
// ...

// 完成后退出
ExitWorktree({ action: "keep" })
```

3. **实施执行流程**

```text
1. EnterWorktree 创建隔离环境
2. 按 RED-GREEN-REFACTOR 执行每个任务
3. 运行测试验证
4. ExitWorktree 退出隔离环境
5. 继续下一个任务
```

### 6.2 演示案例

**案例: 执行课程列表实施计划**

```bash
# Controller Agent 分发

# Task 1: Course Model
EnterWorktree({ name: "course-model-001" })
# [RED] 创建测试
# [GREEN] 实现模型
# [REFACTOR] 清理代码
ExitWorktree({ action: "keep" })

# Task 2: CourseListViewModel
EnterWorktree({ name: "course-vm-002" })
# [RED] 创建测试
# [GREEN] 实现 ViewModel
# [REFACTOR] 清理代码
ExitWorktree({ action: "keep" })

# Task 3: CourseListPage
EnterWorktree({ name: "course-page-003" })
# [RED] 创建 UI 测试
# [GREEN] 实现页面
# [REFACTOR] 清理代码
ExitWorktree({ action: "keep" })
```

### 6.3 练习任务

**任务: 执行"用户登录"实施计划**

```text
时间: 30 分钟
要求:
1. 使用 EnterWorktree 创建隔离环境
2. 按 RED-GREEN-REFACTOR 执行至少 2 个任务
3. 使用 ExitWorktree 正确退出
4. 运行测试验证
```

---

## 7. 模块 5: 审查流程 (30分钟)

### 7.1 内容

1. **HARD-GATE 审查**

| 门禁 | 检查项 |
|------|--------|
| HARD-GATE 1 | 完整性、一致性、YAGNI |
| HARD-GATE 2 | No Placeholders、可构建性、规格对齐 |
| HARD-GATE 3 | Spec Compliance、Code Quality |

2. **双阶段审查 (HARD-GATE 3)**

```text
Stage 1: Spec Compliance
- 需求满足
- 数据模型一致
- API 接口一致
- UI/UX 实现一致

Stage 2: Code Quality
- 代码规范
- 测试覆盖率 ≥80%
- 无安全漏洞
- 性能无回归
```

3. **问题分级**

| 优先级 | 说明 | 阻塞合并 |
|--------|------|----------|
| CRITICAL | 必须修复 | ✅ 阻塞 |
| HIGH | 应该修复 | ✅ 阻塞 |
| MEDIUM | 建议修复 | ❌ 不阻塞 |
| LOW | 可选修复 | ❌ 不阻塞 |

### 7.2 讨论问题

1. 为什么需要双阶段审查？
2. CRITICAL 和 HIGH 问题如何区分？
3. 审查报告如何写？

---

## 8. 模块 6: 综合演练 (60分钟)

### 8.1 演练项目

**项目: 实现"学分记录"功能**

```
需求: 用户可以查看自己的学分获取记录

要求:
1. 完成完整的三阶段流程
2. 产出所有文档
3. 通过所有 HARD-GATE
```

### 8.2 演练步骤

| 步骤 | 时间 | 产出 |
|------|------|------|
| Step 1: 设计规格 | 15 分钟 | `specs/YYYY-MM-DD-credit-records-design.md` |
| Step 2: 实施计划 | 15 分钟 | `plans/YYYY-MM-DD-credit-records.md` |
| Step 3: 实施 | 20 分钟 | 代码 + 测试 |
| Step 4: 审查 | 10 分钟 | `reviews/YYYY-MM-DD-credit-records-review.md` |

### 8.3 验收标准

```text
☐ 设计规格无 TBD
☐ 实施计划无 Placeholders
☐ 任务粒度符合 2-5 分钟
☐ 测试覆盖率 ≥80%
☐ 审查报告完整
```

---

## 9. 培训材料

### 9.1 必读文档

| 文档 | 路径 | 重点 |
|------|------|------|
| 开发流程 | `Docs/SOP/02-flow.md` | 三阶段流程 |
| 质量门禁 | `Docs/SOP/06-gates.md` | 硬门禁定义 |
| Git Worktree | `Docs/SOP/07-worktree.md` | 隔离执行 |
| Commit 规范 | `Docs/SOP/05-commit.md` | 提交格式 |
| 测试要求 | `Docs/SOP/04-testing.md` | 覆盖率要求 |

### 9.2 模板文件

| 模板 | 路径 |
|------|------|
| 设计规格模板 | `docs/superpowers/specs/README.md` |
| 实施计划模板 | `docs/superpowers/plans/README.md` |
| 审查报告模板 | `docs/superpowers/reviews/README.md` |

---

## 10. 培训考核

### 10.1 考核方式

| 考核项 | 分值 | 说明 |
|--------|------|------|
| 流程理解 | 20% | 笔试问答 |
| Phase 1 实操 | 20% | 设计规格质量 |
| Phase 2 实操 | 20% | 实施计划质量 |
| Phase 3 实操 | 20% | 实施完成度 |
| 综合演练 | 20% | 项目验收通过 |

### 10.2 通过标准

```
总分 ≥80 分 = 通过
总分 <80 分 = 需补充培训
```

---

## 11. 常见问题 FAQ

### Q1: 硬门禁和软门禁的区别？

```
硬门禁: 不通过 = 禁止进入下一阶段
软门禁: 不通过 = 警告但可继续
```

### Q2: No Placeholders 规则为什么重要？

```
原因:
1. TBD 表示不明确，无法执行
2. 占位符导致实施时需要猜测
3. 未定义引用可能产生误解

结果: 计划不可构建，实施会失败
```

### Q3: 任务粒度为什么需要 2-5 分钟？

```
原因:
1. 太长: 无法准确预估，容易失败
2. 太短: 过度碎片化，效率降低
3. 2-5 分钟: 可控、可验证、可回滚
```

### Q4: Git Worktree 有什么好处？

```
好处:
1. 防止上下文污染
2. 失败任务可独立回滚
3. 多任务可并行执行
4. 不影响主仓库
```

### Q5: SDD 和传统开发有什么区别？

```
传统开发:
- 同一 session 执行所有任务
- 上下文可能污染
- 失败需要整体回滚

SDD:
- 每个 subagent 独立执行
- 在隔离 worktree 中工作
- 失败只需重试单个任务
```

---

## 12. 培训后续支持

### 12.1 在线答疑

```
渠道: 团队 IM 群
时间: 工作日 10:00-18:00
响应: 24 小时内回复
```

### 12.2 文档更新

```
反馈渠道: Docs/SOP/ 文档评论
更新周期: 每月回顾
版本管理: CLAUDE.md 版本号
```

### 12.3 持续改进

```
每月培训回顾:
- 收集培训反馈
- 更新培训材料
- 优化流程文档
```

---

**版本**: 1.0
**更新日期**: 2026-04-13
**培训负责人**: Architect
**适用范围**: 全员