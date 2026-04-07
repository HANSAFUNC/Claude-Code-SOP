# 测试标准与规范

> 通用的跨平台移动应用测试标准

**版本**: 3.0
**发布日期**: 2026-04-07

---

## 1. 测试金字塔

```text
                        /\
                       /  \
                      / UI \      20%
                     /______\
                    /        \
                   /Integration\  30%
                  /____________\
                 /              \
                /    Unit Tests   \  50%
               /__________________\
```

### 测试类型分布

| 测试类型 | 占比 | 说明 | 执行频率 |
|----------|------|------|----------|
| 单元测试 | 50% | 测试单个函数/类/模块 | 每次提交 |
| 集成测试 | 30% | 测试模块间交互 | 每次构建 |
| UI 测试 | 20% | 测试用户界面和交互 | 每日/发布前 |

---

## 2. 测试类型与要求

### 2.1 单元测试 (Unit Tests)

**目标覆盖率:** 80%+

| 测试对象 | 覆盖率要求 | 说明 |
|----------|------------|------|
| Models | 100% | 数据模型、Entity、DTO |
| ViewModels | 80%+ | 业务逻辑、状态管理 |
| Services | 80%+ | 网络、数据库、文件系统 |
| Utils/Helpers | 80%+ | 工具函数、扩展方法 |

**测试框架:**
- iOS: XCTest
- Android: JUnit + Mockito
- Harmony: Hypium

**文件命名:**
- 测试文件：`{被测试类型}Tests.{ext}`
- 测试类：`{被测试类型}Tests`
- 测试方法：`test_{功能}_{场景}_{预期结果}`

**示例:**
```swift
// 文件：CourseListViewModelTests.swift
// 类：CourseListViewModelTests

class CourseListViewModelTests: XCTestCase {
    func testLoadCourses_success_populatesCourses() async { ... }
    func testLoadCourses_failure_setsErrorMessage() async { ... }
    func testSearchFilter_byTitle_returnsFilteredResults() { ... }
}
```

---

### 2.2 集成测试 (Integration Tests)

**目标覆盖率:** 核心集成点 100%

| 测试内容 | 说明 | 测试框架 |
|----------|------|----------|
| API 集成 | 验证 API 调用和响应解析 | XCTest/XCUITest |
| 数据库集成 | 验证持久化操作 | XCTest/Room |
| 模块集成 | 验证模块间通信 | 平台特定框架 |
| 第三方服务 | 验证 SDK 集成 | Mock + 真实 SDK |

**测试场景:**
- [ ] 正常流程：API 成功 → 数据持久化 → UI 更新
- [ ] 失败流程：API 失败 → 错误处理 → 用户提示
- [ ] 边界场景：大数据量、空数据、网络切换

---

### 2.3 UI 测试 (UI Tests)

**目标覆盖率:** 关键用户路径 100%

| 测试内容 | 说明 | 测试框架 |
|----------|------|----------|
| 页面加载 | 验证页面正常显示 | XCUITest/Espresso |
| 用户交互 | 验证按钮、输入等交互 | XCUITest/Espresso |
| 导航流程 | 验证页面间导航 | XCUITest/Espresso |
| 无障碍 | 验证辅助功能支持 | XCUITest/Accessibility |

**关键用户路径:**
- [ ] 启动应用 → 主页加载
- [ ] 登录流程
- [ ] 核心功能流程
- [ ] 设置/退出流程

**示例:**
```swift
// 文件：CourseListUITests.swift
// 类：CourseListUITests

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

## 3. 测试编写规范

### 3.1 AAA 模式

所有测试必须遵循 AAA (Arrange-Act-Assert) 模式：

```swift
func testExample() {
    // Arrange - 准备测试数据和环境
    let viewModel = CourseListViewModel()
    let mockService = MockCourseService()
    viewModel.service = mockService

    // Act - 执行被测试的操作
    await viewModel.loadCourses()

    // Assert - 验证结果
    XCTAssertFalse(viewModel.courses.isEmpty)
    XCTAssertTrue(mockService.fetchCourseListCalled)
}
```

### 3.2 测试数据工厂

使用工厂模式创建测试数据，避免硬编码：

```swift
// TestHelpers.swift

struct CourseFactory {
    static func create(
        id: String = UUID().uuidString,
        title: String = "Test Course",
        progress: Double = 0.0,
        duration: Int = 60
    ) -> Course {
        Course(
            id: id,
            title: title,
            progress: progress,
            duration: duration
        )
    }

    static func createList(_ count: Int) -> [Course] {
        (0..<count).map { create(id: "\($0)") }
    }
}

// 使用
let course = CourseFactory.create(progress: 0.5)
let courses = CourseFactory.createList(10)
```

### 3.3 Mock 对象

使用 Mock 隔离被测对象的外部依赖：

```swift
// MockCourseService.swift

class MockCourseService: CourseServiceProtocol {
    var fetchCourseListCalled = false
    var fetchCourseListCallCount = 0
    var mockCourses: [Course] = []
    var mockError: Error?

    func fetchCourseList() async throws -> [Course] {
        fetchCourseListCalled = true
        fetchCourseListCallCount += 1
        if let error = mockError {
            throw error
        }
        return mockCourses
    }

    func reset() {
        fetchCourseListCalled = false
        fetchCourseListCallCount = 0
        mockCourses = []
        mockError = nil
    }
}

// 使用
let mockService = MockCourseService()
mockService.mockCourses = CourseFactory.createList(5)
```

### 3.4 测试隔离

每个测试必须独立，不依赖其他测试的状态：

```swift
// 正确：每个测试独立
func testA() {
    let data = createTestData()
    // ...
}

func testB() {
    let data = createTestData()
    // ...
}

// 错误：测试之间有依赖
var sharedData: [String] = []  // ❌

func testA() {
    sharedData.append("item")
}

func testB() {
    XCTAssertEqual(sharedData.count, 1)  // 依赖 testA
}
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

### 4.2 覆盖率计算

```bash
# iOS - 运行测试并生成覆盖率报告
xcodebuild test \
  -project {Project}.xcodeproj \
  -scheme {Scheme} \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -enableCodeCoverage YES

# Android - 使用 Gradle 生成覆盖率报告
./gradlew jacocoTestReport

# Harmony - 使用 DevEco 覆盖率工具
```

### 4.3 覆盖率豁免

以下情况可申请覆盖率豁免：

| 豁免类型 | 说明 | 审批人 |
|----------|------|--------|
| 纯 UI 代码 | View 样式、纯展示组件 | Architect |
| 自动生成的代码 | 工具生成的代码 | - |
| 平台特定代码 | 条件编译的平台代码 | Architect |
| 遗留代码 | 无法测试的旧代码 | Architect |

---

## 5. 测试场景覆盖

### 5.1 正常场景

测试功能正常工作的主流程：

```swift
func testNormalCase_success() {
    // 测试正常流程
    let courses = CourseFactory.createList(5)
    mockService.mockCourses = courses

    await viewModel.loadCourses()

    XCTAssertEqual(viewModel.courses.count, 5)
    XCTAssertEqual(viewModel.state, .success)
}
```

### 5.2 边界场景

测试边界条件：

```swift
// 空列表
func testBoundaryCase_emptyList() {
    mockService.mockCourses = []

    await viewModel.loadCourses()

    XCTAssertEqual(viewModel.courses.isEmpty)
    XCTAssertEqual(viewModel.state, .empty)
}

// 单个项目
func testBoundaryCase_singleItem() {
    mockService.mockCourses = CourseFactory.createList(1)

    await viewModel.loadCourses()

    XCTAssertEqual(viewModel.courses.count, 1)
}

// 最大值
func testBoundaryCase_maximumValue() {
    let largeList = CourseFactory.createList(1000)
    mockService.mockCourses = largeList

    await viewModel.loadCourses()

    XCTAssertEqual(viewModel.courses.count, 1000)
}

// 零值、负值、极值等
```

### 5.3 异常场景

测试错误和异常情况：

```swift
// 网络失败
func testErrorCase_networkFailure() async {
    mockService.mockError = NetworkError.unavailable

    await viewModel.loadCourses()

    XCTAssertEqual(viewModel.state, .error)
    XCTAssertNotNil(viewModel.errorMessage)
}

// 无效数据
func testErrorCase_invalidData() {
    // 测试无效数据输入
}

// 超时
func testErrorCase_timeout() async {
    // 测试请求超时
}

// 权限拒绝
func testErrorCase_permissionDenied() {
    // 测试权限被拒绝
}
```

---

## 6. 测试执行

### 6.1 本地执行

```bash
# 运行所有测试
# iOS
xcodebuild test -project {Project}.xcodeproj -scheme {Scheme}

# Android
./gradlew test

# Harmony
npm run test

# 运行特定测试
# iOS
xcodebuild test \
  -project {Project}.xcodeproj \
  -scheme {Scheme} \
  -only-testing:{Target}/{TestClass}

# Android
./gradlew test --tests {TestClass}.{testMethod}
```

### 6.2 CI/CD 执行

```yaml
# .github/workflows/test.yml
name: Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3

      - name: Run Tests
        run: xcodebuild test -project {Project}.xcodeproj -scheme {Scheme}

      - name: Upload Coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./build/reports/jacoco/test/jacocoTestReport.xml
```

### 6.3 测试报告

```markdown
## 测试报告

**日期:** YYYY-MM-DD
**版本:** v{version}
**模块:** {module-name}

### 测试结果
| 类型 | 总数 | 通过 | 失败 | 跳过 | 通过率 |
|------|------|------|------|------|--------|
| 单元测试 | X | Y | Z | W | Y/X% |
| UI 测试 | X | Y | Z | W | Y/X% |
| 集成测试 | X | Y | Z | W | Y/X% |
| **总计** | **N** | **M** | **K** | **L** | **M/N%** |

### 覆盖率
| 模块 | 行覆盖率 | 分支覆盖率 |
|------|----------|------------|
| Models | XX% | XX% |
| ViewModels | XX% | XX% |
| Services | XX% | XX% |
| **综合** | **XX%** | **XX%** |

### 失败分析
| 测试名称 | 失败原因 | 负责人 | 状态 | 预计修复日期 |
|----------|----------|--------|------|--------------|
| testX | 描述 | @XXX | 修复中 | YYYY-MM-DD |

### 已知问题
- {问题描述}
- {影响范围}
- {临时方案}
```

---

## 7. 测试维护

### 7.1 测试更新时机

| 时机 | 操作 |
|------|------|
| 新功能开发 | 新增测试用例 (先写测试) |
| Bug 修复 | 新增回归测试 |
| 代码重构 | 验证现有测试 |
| 需求变更 | 更新相关测试 |
| 发现漏测 | 补充测试用例 |

### 7.2 测试代码审查

测试代码也需要审查：

- [ ] 测试命名清晰 (描述功能和预期)
- [ ] 遵循 AAA 模式
- [ ] 无断言缺失
- [ ] 无硬编码魔法值
- [ ] Mock 使用恰当
- [ ] 测试独立可并行
- [ ] 测试执行时间合理

### 7.3 技术债管理

使用标记管理测试技术债：

```swift
// FIXME: 测试用例需要改进 - 添加边界条件测试
func testSomething() { ... }

// TODO: 添加性能测试
func testPerformance() { ... }

// HACK: 临时测试方案，待改进
func testWithHack() { ... }

// DEBT: 这个测试有 Flaky 问题，需要修复
func testFlaky() { ... }
```

---

## 8. 测试检查清单

### 8.1 提交测试前

- [ ] 所有测试通过
- [ ] 覆盖率达标 (≥80%)
- [ ] 测试命名规范
- [ ] 遵循 AAA 模式
- [ ] 无 Flaky 测试
- [ ] Mock 使用正确
- [ ] 测试数据隔离
- [ ] 测试执行时间合理

### 8.2 审查测试用例

- [ ] 测试覆盖正常场景
- [ ] 测试覆盖边界场景
- [ ] 测试覆盖异常场景
- [ ] 测试独立可并行
- [ ] 测试可重复执行
- [ ] 断言完整
- [ ] 错误信息清晰

### 8.3 测试质量评估

| 检查项 | 优秀 | 良好 | 需改进 |
|--------|------|------|--------|
| 覆盖率 | >90% | 80-90% | <80% |
| 执行时间 | <5 分钟 | 5-10 分钟 | >10 分钟 |
| Flaky 测试 | 0 个 | 1-2 个 | >2 个 |
| 断言缺失 | 0 个 | 1-2 个 | >2 个 |

---

## 9. 持续改进

### 9.1 测试指标

| 指标 | 目标值 | 测量方式 |
|------|--------|----------|
| 测试覆盖率 | ≥80% | 覆盖率工具 |
| 测试通过率 | 100% | CI/CD 统计 |
| 测试执行时间 | <10 分钟 | CI/CD 统计 |
| Flaky 测试数 | 0 | CI/CD 统计 |
| Bug 逃逸率 | <5% | 生产环境统计 |

### 9.2 回顾改进

每个迭代回顾测试情况：
- 是否有漏测的 Bug
- 测试是否有效拦截问题
- 测试执行时间是否合理
- 如何改进测试质量

---

**变更历史:**

| 版本 | 日期 | 变更说明 |
|------|------|----------|
| 1.0 | 2026-03-20 | 初始版本 |
| 2.0 | 2026-04-02 | 统一测试标准 |
| 3.0 | 2026-04-07 | 移除平台特定内容、新增通用检查清单 |
