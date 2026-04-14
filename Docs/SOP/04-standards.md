# 开发规范

**版本:** 3.0
**日期:** 2026-04-14

---

## 1. 测试标准

### 1.1 测试层级

```
┌────────────────────────────────────────────────────────────────┐
│                        测试金字塔                              │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│                           /\                                   │
│                          /  \                                  │
│                         / UI \     20%                         │
│                        /______\                                │
│                       /        \                               │
│                      /Integration\  30%                        │
│                     /____________\                             │
│                    /              \                            │
│                   /    Unit Tests  \  50%                      │
│                  /__________________\                          │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### 1.2 覆盖率要求

**最低覆盖率: 80%**

| 测试对象 | 覆盖率要求 |
|----------|------------|
| Models | 100% |
| ViewModels | 80%+ |
| Services | 80%+ |
| Utils/Helpers | 80%+ |

### 1.3 测试类型

| 类型 | 目标 | 框架 |
|------|------|------|
| **单元测试** | 80%+ | XCTest / JUnit / Hypium |
| **UI 测试** | 关键路径 100% | XCUITest / UI Automator |
| **集成测试** | 核心集成点 100% | 平台对应框架 |

### 1.4 测试编写规范

**AAA 模式:**

```swift
func testExample() {
    // Arrange - 准备测试数据
    let viewModel = CourseListViewModel()

    // Act - 执行被测试的操作
    await viewModel.loadCourses()

    // Assert - 验证结果
    XCTAssertFalse(viewModel.courses.isEmpty)
}
```

**命名规范:**

```text
测试文件: {被测试类型}Tests.swift
测试方法: test_{功能}_{场景}_{预期结果}

示例:
- testLoadCourses_success_populatesCourses
- testLoadCourses_failure_setsErrorMessage
```

### 1.5 测试检查清单

```text
☐ 单元测试覆盖率 ≥80%
☐ 测试覆盖正常/边界/异常情况
☐ UI 测试覆盖关键路径
☐ 测试用例命名清晰
☐ 使用 Mock 隔离外部依赖
```

---

## 2. Commit 规范

### 2.1 格式

```text
<type>: <description>

[optional body]

[optional footer]
```

### 2.2 Type 类型

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

### 2.3 Description 规范

```text
- 使用祈使句现在时 ("add" not "added")
- 首字母小写
- 结尾不加句号
- 长度不超过 50 字符
```

**正确示例:**
```text
feat: add course search functionality
fix: resolve memory leak in image loading
```

**错误示例:**
```text
feat: Added course search functionality  # 时态错误
feat: A fix for the thing  # 描述不清
```

### 2.4 Body 与 Footer

**Body:** 详细说明变更原因和动机

**Footer:**
```text
Closes #123          # 引用 Issue
BREAKING CHANGE: ... # 破坏性变更说明
```

### 2.5 完整示例

```text
feat: add batch course exchange

Add support for exchanging multiple courses at once.
Users can now select up to 5 courses for batch exchange.

Changes:
- Add BulkExchangeView
- Add exchange validation rules
- Update API endpoint

Closes #123
```

---

## 3. 代码规范

### 3.1 通用规范

```text
☐ 命名符合规范 (驼峰式、语义化)
☐ 代码格式统一
☐ 注释清晰必要
☐ 函数长度 <50 行
☐ 文件大小 <800 行
☐ 无深度嵌套 (>4 层)
☐ 无硬编码值
```

### 3.2 平台特定规范

| 平台 | 特定规范 |
|------|----------|
| **iOS/Swift** | let 优先于 var、可选值处理、闭包捕获列表、访问控制 |
| **HarmonyOS/ArkTS** | 状态管理、组件复用、Builder 装饰器 |
| **Android/Kotlin** | 空安全、协程、Jetpack 组件 |

---

## 4. 相关文档

| 文档 | 说明 |
|------|------|
| [02-flow.md](./02-flow.md) | 开发流程 |
| [03-gates.md](./03-gates.md) | 质量门禁与审查 |

---

**版本**: 3.0
**更新日期**: 2026-04-14