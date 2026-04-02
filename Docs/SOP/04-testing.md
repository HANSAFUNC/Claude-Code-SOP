# 测试标准

**版本:** 1.0
**日期:** 2026-03-20

---

## 1. 测试层级

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

---

## 2. 测试类型与要求

### 2.1 单元测试 (Unit Tests)

**目标覆盖率:** 80%+

| 测试对象 | 覆盖率要求 | 测试框架 |
|----------|------------|----------|
| Models | 100% | XCTest |
| ViewModels | 80%+ | XCTest |
| Services | 80%+ | XCTest + Mock |
| Utils/Helpers | 80%+ | XCTest |

**测试内容:**
```swift
// 测试文件命名：{被测试类型}Tests.swift
// 测试类命名：{被测试类型}Tests
// 测试方法命名：test_{功能}_{场景}_{预期结果}

// 示例
class CourseListViewModelTests: XCTestCase {
    func testLoadCourses_success_populatesCourses() async { ... }
    func testLoadCourses_failure_setsErrorMessage() async { ... }
    func testSearchFilter_byTitle_returnsFilteredResults() { ... }
}
```

---

### 2.2 UI 测试 (UI Tests)

**目标覆盖率:** 关键路径 100%

| 测试内容 | 说明 | 测试框架 |
|----------|------|----------|
| 页面加载 | 验证页面正常显示 | XCUITest |
| 用户交互 | 验证按钮、输入等交互 | XCUITest |
| 导航流程 | 验证页面间导航 | XCUITest |
| 无障碍 | 验证 VoiceOver 支持 | XCUITest |

**测试内容:**
```swift
// UI 测试文件命名：{功能}UITests.swift
// 测试类命名：{功能}UITests

class CourseListUITests: XCTestCase {
    var app: XCUIApplication!

    func testCourseList_displaysCourses() {
        app.launch()
        XCTAssertTrue(app.tables["courseList"].exists)
    }

    func testCourseCard_showsAllFields() {
        // 验证课程卡片显示所有必填字段
    }
}
```

---

### 2.3 集成测试 (Integration Tests)

**目标覆盖率:** 核心集成点 100%

| 测试内容 | 说明 |
|----------|------|
| API 集成 | 验证 API 调用和响应解析 |
| 数据库集成 | 验证 CoreData 持久化 |
| 模块集成 | 验证模块间通信 |

---

## 3. 测试编写规范

### 3.1 AAA 模式

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

### 3.2 测试数据工厂

```swift
// TestHelpers.swift

struct CourseFactory {
    static func create(
        id: String = UUID().uuidString,
        title: String = "Test Course",
        progress: Double = 0.0
    ) -> Course {
        Course(
            id: id,
            title: title,
            // ...
        )
    }
}

// 使用
let course = CourseFactory.create(progress: 0.5)
```

### 3.3 Mock 对象

```swift
// MockService.swift

class MockCourseService: CourseServiceProtocol {
    var fetchCourseListCalled = false
    var mockCourses: [Course] = []

    func fetchCourseList() async throws -> [Course] {
        fetchCourseListCalled = true
        return mockCourses
    }
}

// 使用
let mockService = MockCourseService()
mockService.mockCourses = [CourseFactory.create()]
```

---

## 4. 测试覆盖率

### 4.1 覆盖率要求

| 模块 | 最低覆盖率 | 目标覆盖率 |
|------|------------|------------|
| Models | 100% | 100% |
| ViewModels | 80% | 90% |
| Services | 80% | 90% |
| Views | 70% | 80% |
| **综合** | **80%** | **90%** |

### 4.2 覆盖率检查

```bash
# 运行测试并生成覆盖率报告
xcodebuild test \
  -project MobileApp.xcodeproj \
  -scheme MobileApp \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -enableCodeCoverage YES

# 查看覆盖率报告
open build/Logs/Test/*.xcresult
```

### 4.3 覆盖率豁免

以下情况可申请覆盖率豁免:
- 纯 UI 代码 (View 样式)
- 自动生成的代码
- 平台特定代码 (conditional compilation)
- 无法测试的遗留代码

---

## 5. 测试场景覆盖

### 5.1 正常场景

```swift
func testNormalCase_success() {
    // 测试正常流程
}
```

### 5.2 边界场景

```swift
func testBoundaryCase_emptyList() {
    // 测试空列表
}

func testBoundaryCase_singleItem() {
    // 测试单项
}

func testBoundaryCase_maximumValue() {
    // 测试最大值
}
```

### 5.3 异常场景

```swift
func testErrorCase_networkFailure() async {
    // 测试网络失败
}

func testErrorCase_invalidData() {
    // 测试无效数据
}

func testErrorCase_timeout() async {
    // 测试超时
}
```

---

## 6. 测试执行

### 6.1 本地执行

```bash
# 运行所有测试
xcodebuild test -project MobileApp.xcodeproj -scheme MobileApp

# 运行特定测试
xcodebuild test \
  -project MobileApp.xcodeproj \
  -scheme MobileApp \
  -only-testing:MobileAppTests/CourseListViewModelTests
```

### 6.2 CI/CD 执行

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Tests
        run: xcodebuild test -project MobileApp.xcodeproj -scheme MobileApp
```

### 6.3 测试报告

```markdown
## 测试报告

**日期:** YYYY-MM-DD
**版本:** v1.0.0

### 测试结果
- 通过：X 个
- 失败：Y 个
- 跳过：Z 个
- 总计：N 个
- 通过率：XX%

### 覆盖率
- 代码覆盖率：XX%
- 分支覆盖率：XX%

### 失败分析
| 测试 | 失败原因 | 负责人 | 状态 |
|------|----------|--------|------|
| testX | 描述 | @XXX | 修复中 |
```

---

## 7. 测试维护

### 7.1 测试更新时机

| 时机 | 操作 |
|------|------|
| 新功能开发 | 新增测试用例 |
| Bug 修复 | 新增回归测试 |
| 代码重构 | 验证现有测试 |
| 需求变更 | 更新相关测试 |

### 7.2 测试代码审查

测试代码也需要审查:
- [ ] 测试命名清晰
- [ ] 遵循 AAA 模式
- [ ] 无断言缺失
- [ ] 无硬编码魔法值
- [ ] Mock 使用恰当

### 7.3 技术债管理

```swift
// FIXME: 测试用例需要改进
// TODO: 添加边界条件测试
// HACK: 临时测试方案，待改进
```

---

## 8. 测试检查清单

### 提交测试前

```
☐ 所有测试通过
☐ 覆盖率达标 (≥80%)
☐ 测试命名规范
☐ 遵循 AAA 模式
☐ 无 flaky 测试
☐ Mock 使用正确
☐ 测试数据隔离
```

### 审查测试用例

```
☐ 测试覆盖正常场景
☐ 测试覆盖边界条件
☐ 测试覆盖异常情况
☐ 测试独立可并行
☐ 测试可重复执行
☐ 测试执行时间合理
```
