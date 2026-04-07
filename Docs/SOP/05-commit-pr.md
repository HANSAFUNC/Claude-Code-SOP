# Commit 与 PR 规范

> 通用的 Commit 信息格式和 Pull Request 流程

**版本**: 3.0
**发布日期**: 2026-04-07

---

## 1. Commit 格式

### 1.1 基本格式

```text
<type>: <description>

[optional body]

[optional footer]
```

### 1.2 格式示例

```text
feat: add course exchange functionality

Implement course exchange feature with validation rules.

Closes #123
```

---

## 2. Type 类型

| Type | 说明 | 使用场景 | 示例 |
|------|------|----------|------|
| `feat` | 新功能 | 新增功能、页面、组件 | `feat: add course search` |
| `fix` | Bug 修复 | 修复功能缺陷、崩溃 | `fix: fix progress calculation` |
| `refactor` | 重构 | 代码重构，不影响功能 | `refactor: extract validation logic` |
| `docs` | 文档 | 文档更新、注释更新 | `docs: update README` |
| `test` | 测试 | 新增/修改测试用例 | `test: add unit tests for ViewModel` |
| `chore` | 构建/工具 | 依赖升级、配置修改 | `chore: update dependencies` |
| `perf` | 性能 | 性能优化 | `perf: improve list rendering` |
| `ci` | CI/CD | CI/CD配置变更 | `ci: add GitHub Actions workflow` |
| `style` | 格式 | 代码格式调整 (不影响逻辑) | `style: format code` |
| `build` | 构建 | 构建系统或外部依赖变更 | `build: upgrade Xcode version` |

---

## 3. Description 规范

### 3.1 基本要求

- 使用祈使句现在时 ("add" not "added" or "adds")
- 首字母小写
- 结尾不加句号
- 长度不超过 50 字符

### 3.2 正确示例

```text
feat: add course search functionality
fix: resolve memory leak in image loading
refactor: simplify course filter logic
docs: update API documentation
test: add edge case tests for payment
```

### 3.3 错误示例

```text
# 时态错误
feat: Added course search functionality
fix: Fixed the bug in user module

# 描述不清
fix: A fix for the thing that does stuff
chore: some changes

# 太长
feat: Fixed the bug in the user module when the server is down and also fixed some styling issues and updated the tests

# 首字母大写
Feat: Add Course Search
```

---

## 4. Body 规范

### 4.1 何时使用 Body

以下情况需要添加 Body：
- Commit 涉及复杂变更
- 需要说明变更动机
- 有多个相关变更点
- 有 Breaking Change

### 4.2 Body 内容

- 详细说明变更原因和动机
- 对比变更前后行为
- 说明任何不明显的决策
- 列出所有变更点

### 4.3 Body 示例

```text
feat: add batch course exchange

Add support for exchanging multiple courses at once.
Users can now select up to 5 courses for batch exchange.

Changes:
- Add BulkExchangeView
- Add exchange validation rules
- Update API endpoint to accept course array
- Add transaction rollback on partial failure

Reason:
Manual one-by-one exchange is time-consuming for users
with multiple courses. This feature reduces the number
of API calls and improves user experience.
```

---

## 5. Footer 规范

### 5.1 引用 Issue

```text
Closes #123
Fixes #456, #789
Refs #101
```

### 5.2 Breaking Change

如果有破坏性变更，必须在 Footer 中说明：

```text
BREAKING CHANGE: API endpoint changed from /v1/courses to /v2/courses

Migration:
- Update all API clients to use /v2/courses
- Update request body format (see APIDesign.md)
```

### 5.3 联合作者

```text
Co-authored-by: Name <name@example.com>
```

---

## 6. 完整示例

### 6.1 简单 Commit

```text
feat: add course search

Add search functionality to course list page.
Supports searching by course name and instructor.

Closes #45
```

### 6.2 复杂 Commit

```text
feat: add batch course exchange

Add support for exchanging multiple courses at once.
Users can now select up to 5 courses for batch exchange.

Changes:
- Add BulkExchangeView component
- Add exchange validation rules
- Update CourseService API
- Add transaction rollback mechanism

Reason:
Manual one-by-one exchange is time-consuming.
This reduces API calls and improves UX.

BREAKING CHANGE: None

Closes #123
Co-authored-by: Jane Doe <jane@example.com>
```

### 6.3 Bug Fix Commit

```text
fix: resolve course progress calculation error

Fix incorrect progress calculation when course has
completed lessons but no quiz scores.

The bug was caused by dividing by zero when quiz
count was zero. Added guard clause to handle this case.

Fixes #789
```

### 6.4 Refactor Commit

```text
refactor: extract course validation logic

Extract validation logic from CourseService to
dedicated CourseValidator class.

This improves:
- Testability: Validator can be tested in isolation
- Reusability: Validator can be used by other services
- Readability: Smaller, focused methods

No functional changes.
```

---

## 7. Pull Request 流程

### 7.1 PR 创建前检查

**创建 PR 前必须确认:**

- [ ] 代码编译通过
- [ ] 所有测试通过
- [ ] 测试覆盖率 ≥ 80%
- [ ] 代码已格式化
- [ ] Commit 信息规范
- [ ] 自测完成

### 7.2 PR 标题规范

PR 标题遵循 Commit 格式：

```text
<type>: <description>
```

示例：
```text
feat: add course exchange functionality
fix: resolve login timeout issue
refactor: simplify payment flow
```

### 7.3 PR 描述模板

```markdown
## Summary
{简要描述 PR 的目的和变更内容}

## Changes
- {变更点 1}
- {变更点 2}
- {变更点 3}

## Type of Change
- [ ] 🚀 Feature (新功能)
- [ ] 🐛 Bug Fix (Bug 修复)
- [ ] ♻️ Refactor (重构)
- [ ] 📝 Documentation (文档)
- [ ] ✅ Test (测试)
- [ ] ⚙️ Chore (构建/工具)
- [ ] 🚨 Breaking Change (破坏性变更)

## Testing
{描述测试情况}

- 单元测试：X 个用例，通过率 Y%
- UI 测试：X 个用例，通过率 Y%
- 手动测试：{描述手动测试场景}

## Screenshots (if applicable)
{UI 变更附带截图}

## Checklist
- [ ] 代码编译通过
- [ ] 所有测试通过
- [ ] 测试覆盖率 ≥ 80%
- [ ] 代码已格式化
- [ ] Commit 信息规范
- [ ] 文档已更新 (如需要)
- [ ] 无 Breaking Change (或有说明)

## Related Issues
- Closes #{issue_number}
- Related to #{issue_number}

## Notes for Reviewers
{需要审查人特别注意的地方}
```

---

## 8. PR 审查流程

### 8.1 审查流程

```text
1. 创建 PR
       │
       ↓
2. 自动检查 (CI/CD)
       │
       ↓
3. 初审 (Senior Specialist)
       │
       ↓
4. 复审 (Architect)
       │
       ↓
5. 问题修复 (如需要)
       │
       ↓
6. 批准合并
```

### 8.2 审查响应时间

| 优先级 | 响应时间 | 说明 |
|--------|----------|------|
| P0 (阻塞) | 2 小时 | 紧急修复、线上问题 |
| P1 (高) | 24 小时 | 正常功能 PR |
| P2 (中) | 48 小时 | 常规 PR |
| P3 (低) | 1 周 | 优化、重构 PR |

### 8.3 审查状态

| 状态 | 说明 | 后续操作 |
|------|------|----------|
| ✅ Approved | 审查通过 | 可以合并 |
| ⚠️ Changes Requested | 需要修改 | 修复后重新审查 |
| ℹ️ Comment | 仅评论 | 无需操作，可选修改 |

---

## 9. 合并策略

### 9.1 合并方式

| 方式 | 说明 | 使用场景 |
|------|------|----------|
| Squash and Merge | 压缩为单个 Commit | 功能分支有多个工作 Commit |
| Merge Commit | 保留所有 Commit | 需要保留完整历史 |
| Rebase and Merge | 变基后合并 | 需要线性历史 |

### 9.2 合并检查

合并前自动检查：
- [ ] CI/CD 全部通过
- [ ] 审查批准
- [ ] 无冲突
- [ ] 分支是最新的

### 9.3 合并后

- 删除源分支
- 验证主分支构建
- 通知相关人员

---

## 10. Git 分支规范

### 10.1 分支命名

```text
{type}/{description}

# 示例
feat/course-exchange
fix/login-timeout
refactor/payment-flow
hotfix/critical-bug
```

### 10.2 工作流

```text
main (受保护)
  │
  ├── develop (开发分支)
  │     │
  │     ├── feat/* (功能分支)
  │     ├── fix/* (修复分支)
  │     └── refactor/* (重构分支)
  │
  └── release/* (发布分支)
```

### 10.3 Commit 频率

- 小步提交，频繁 Commit
- 每个 Commit 完成一个原子变更
- 不要在 Commit 之间夹杂无关变更

---

## 11. 检查清单

### 11.1 Commit 前

- [ ] 代码已格式化
- [ ] 本地测试通过
- [ ] Commit 信息符合规范
- [ ] 关联 Issue (如适用)

### 11.2 提交 PR 前

- [ ] 代码编译通过
- [ ] 所有测试通过
- [ ] 测试覆盖率 ≥ 80%
- [ ] Commit 信息规范
- [ ] 自测完成

### 11.3 审查 PR

- [ ] 代码符合规范
- [ ] 功能实现正确
- [ ] 测试覆盖完整
- [ ] 无安全漏洞
- [ ] 无明显性能问题

### 11.4 合并前

- [ ] CI/CD 全部通过
- [ ] 审查批准
- [ ] 无冲突
- [ ] 分支是最新的

---

**变更历史:**

| 版本 | 日期 | 变更说明 |
|------|------|----------|
| 1.0 | 2026-03-20 | 初始版本 |
| 2.0 | 2026-04-02 | 统一 Commit 格式 |
| 3.0 | 2026-04-07 | 新增 PR 流程规范、移除平台特定内容 |
