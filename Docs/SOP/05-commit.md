# Commit 规范

**版本:** 1.0
**日期:** 2026-03-20

---

## 1. Commit 格式

```
<type>: <description>

[optional body]

[optional footer]
```

### 示例

```
feat: add course exchange functionality

Implement course exchange feature with validation rules.

Closes #123
```

---

## 2. Type 类型

| Type | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat: add course search` |
| `fix` | Bug 修复 | `fix: fix progress calculation` |
| `refactor` | 重构 | `refactor: extract validation logic` |
| `docs` | 文档更新 | `docs: update README` |
| `test` | 测试相关 | `test: add unit tests for ViewModel` |
| `chore` | 构建/工具/配置 | `chore: update dependencies` |
| `perf` | 性能优化 | `perf: improve list rendering` |
| `ci` | CI/CD 配置 | `ci: add GitHub Actions workflow` |

---

## 3. Description 规范

- 使用祈使句现在时 ("add" not "added" or "adds")
- 首字母小写
- 结尾不加句号
- 长度不超过 50 字符

### 正确示例
```
feat: add course search functionality
fix: resolve memory leak in image loading
```

### 错误示例
```
feat: Added course search functionality  # 时态错误
feat: A fix for the thing that does stuff  # 描述不清
feat: Fixed the bug in the user module when the server is down and also fixed some styling issues  # 太长
```

---

## 4. Body 规范

- 详细说明变更原因和动机
- 对比变更前后行为
- 说明任何不明显的决策

---

## 5. Footer 规范

### 引用 Issue
```
Closes #123
Fixes #456, #789
```

### 破坏性变更
```
BREAKING CHANGE: API endpoint changed from /v1/courses to /v2/courses
```

---

## 6. 完整示例

```
feat: add batch course exchange

Add support for exchanging multiple courses at once.
Users can now select up to 5 courses for batch exchange.

Changes:
- Add BulkExchangeView
- Add exchange validation rules
- Update API endpoint

Closes #123

BREAKING CHANGE: None
```
