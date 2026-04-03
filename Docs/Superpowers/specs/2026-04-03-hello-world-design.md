# Hello World 布局演示 - 设计规范

**创建日期**: 2026-04-03  
**产品负责人**: @pm  
**技术负责人**: @architect  
**状态**: 设计已批准

---

## 1. 模块概述

Hello World 布局演示是一个**教学演示模块**，旨在向零基础初学者展示 HarmonyOS ArkUI 的核心布局能力。

### 设计目标

| 目标 | 说明 |
|------|------|
| **受众** | 完全零基础的初学者（无声明式 UI 经验） |
| **重点** | ArkUI 布局能力：Column、Row、Stack、Flex、Grid |
| **优先级** | 代码可读性 > 视觉效果 |
| **主题** | 经典 Hello World 文字 + 按钮交互 |

---

## 2. 页面架构

### 2.1 整体布局

```
┌────────────────────────────────────────┐
│  Navigation Title: "Hello World"       │
├────────────────────────────────────────┤
│  Scroll (可滚动内容区)                  │
│  ┌──────────────────────────────────┐  │
│  │ Card - Column 布局示例           │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │ Card - Row 布局示例              │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │ Card - Stack 布局示例            │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │ Card - Flex 布局示例             │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │ Card - Grid 布局示例             │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
```

### 2.2 设计要点

- 每个 Card 是一个独立的自定义组件 (`@Component`)
- 每个示例包含：说明文字 + 视觉演示 + 交互按钮
- 使用 `@State` 实现简单的交互切换效果

---

## 3. 布局示例详解

### 3.1 Column 布局示例

**演示内容**:
- 标题："Column 垂直布局"
- 说明：Column 容器将子元素沿垂直方向排列
- 演示：3 个 Text 元素垂直排列
- 交互：按钮切换主轴方向（vertical ↔ horizontal）

**关键 API**:
```ets
Column() {
  Text('Hello')
  Text('World')
}
.width('100%')
.space(10) // 子元素间距
```

---

### 3.2 Row 布局示例

**演示内容**:
- 标题："Row 水平布局"
- 说明：Row 容器将子元素沿水平方向排列
- 演示：3 个 Text 元素水平排列
- 交互：按钮切换交叉轴对齐方式（start ↔ center ↔ end）

**关键 API**:
```ets
Row() {
  Text('Hello')
  Text('World')
}
.width('100%')
.justifyContent(FlexAlign.Start)
.crossAxisAlignment(ItemAlign.Center)
```

---

### 3.3 Stack 布局示例

**演示内容**:
- 标题："Stack 叠加布局"
- 说明：Stack 容器将子元素按顺序叠加在一起
- 演示：底层卡片 + 顶层标签叠加效果
- 交互：按钮切换显示/隐藏顶层元素

**关键 API**:
```ets
Stack() {
  Text('底层背景')
  Text('顶层标签').position({ x: 10, y: 10 })
}
.width(200)
.height(100)
```

---

### 3.4 Flex 布局示例

**演示内容**:
- 标题："Flex 弹性布局"
- 说明：Flex 容器提供灵活的弹性布局能力
- 演示：多个子元素在不同方向下的排列
- 交互：按钮切换换行模式（nowrap ↔ wrap）

**关键 API**:
```ets
Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
  Text('Item 1')
  Text('Item 2')
  Text('Item 3')
}
.width('100%')
```

---

### 3.5 Grid 布局示例

**演示内容**:
- 标题："Grid 网格布局"
- 说明：Grid 容器将子元素按网格形式排列
- 演示：网格项按行列排列
- 交互：按钮切换列数（2 列 ↔ 3 列）

**关键 API**:
```ets
Grid() {
  GridItem() { Text('A') }
  GridItem() { Text('B') }
  GridItem() { Text('C') }
}
.columnsTemplate('1fr 1fr')
```

---

## 4. 代码结构

```
entry/src/main/ets/pages/hello-world/
├── Index.ets                 # 主页面入口
├── components/
│   ├── ColumnLayoutDemo.ets  # Column 布局示例组件
│   ├── RowLayoutDemo.ets     # Row 布局示例组件
│   ├── StackLayoutDemo.ets   # Stack 布局示例组件
│   ├── FlexLayoutDemo.ets    # Flex 布局示例组件
│   └── GridLayoutDemo.ets    # Grid 布局示例组件
└── models/
    └── LayoutDemoData.ets    # 示例数据模型（可选）
```

### 4.1 文件规范

每个组件文件都包含：
- 详细的文件头注释（用途、作者、日期）
- 组件功能说明
- 逐行注释的关键代码
- 参数说明

---

## 5. 交互设计

| 示例卡片 | 状态变量 | 交互内容 |
|----------|----------|----------|
| Column | `isHorizontal: boolean` | 按钮切换主轴方向 |
| Row | `alignIndex: number` | 按钮切换对齐方式 (0=start, 1=center, 2=end) |
| Stack | `showTop: boolean` | 按钮切换顶层元素显示 |
| Flex | `isWrap: boolean` | 按钮切换换行模式 |
| Grid | `columnCount: number` | 按钮切换列数 (2 ↔ 3) |

---

## 6. 视觉风格

| 属性 | 值 |
|------|-----|
| **页面背景** | `#F5F5F5` |
| **Card 背景** | `#FFFFFF` |
| **主色调** | `#007DFF` (HarmonyOS Blue) |
| **主文字** | `#333333` |
| **次要文字** | `#666666` |
| **圆角** | `12vp` |
| **Card 间距** | `16vp` |
| **Card 内边距** | `12vp` |

---

## 7. Index.ets 主页面结构

```ets
// entry/src/main/ets/pages/hello-world/Index.ets
/**
 * Hello World 布局演示 - 主入口
 * 
 * 功能：展示 5 种 ArkUI 核心布局的示例卡片
 * 受众：零基础初学者
 * 
 * @author Harmony Team
 * @date 2026-04-03
 */

@Entry
@Component
struct HelloWorldPage {
  build() {
    Navigation() {
      Scroll() {
        Column() {
          // 5 个布局示例卡片垂直排列
          ColumnLayoutDemo()
          RowLayoutDemo()
          StackLayoutDemo()
          FlexLayoutDemo()
          GridLayoutDemo()
        }
        .width('100%')
        .padding(16) // Card 间距
      }
      .scrollable(ScrollDirection.Vertical)
    }
    .title('Hello World 布局演示')
  }
}
```

**职责说明**：
- `@Entry`: 页面入口标识
- `Navigation`: 提供顶部导航栏和页面标题
- `Scroll`: 提供垂直滚动能力
- `Column`: 垂直排列 5 个 Card 组件
- 每个 Card 组件独立管理自己的状态（`@State`）

---

## 8. 状态管理说明

### 8.1 各组件状态独立

每个布局示例组件都有自己独立的 `@State` 状态：

| 组件 | 状态变量 | 类型 | 初始值 | 是否持久化 |
|------|----------|------|--------|------------|
| ColumnLayoutDemo | `isHorizontal` | boolean | false | 否 |
| RowLayoutDemo | `alignIndex` | number | 0 | 否 |
| StackLayoutDemo | `showTop` | boolean | true | 否 |
| FlexLayoutDemo | `isWrap` | boolean | true | 否 |
| GridLayoutDemo | `columnCount` | number | 2 | 否 |

**说明**：
- 所有状态都是**临时状态**，不需要持久化
- 组件之间**没有共享状态**，不需要 `@Link` 或 `@Prop`
- 页面刷新后状态重置为初始值

### 8.2 状态装饰器说明（初学者术语）

| 装饰器 | 含义 | 本例中的用途 |
|--------|------|--------------|
| `@Entry` | 页面入口标识 | 标记 HelloWorldPage 为页面入口 |
| `@Component` | 自定义组件标识 | 标记 struct 为可复用的 UI 组件 |
| `@State` | 组件内部状态 | 管理每个示例的交互状态 |

---

## 9. 错误处理与降级方案

| 异常场景 | 处理方式 |
|----------|----------|
| 组件加载失败 | 显示占位 Card + 错误提示文字 |
| 状态异常（如 alignIndex 越界） | 重置为默认值 |
| 屏幕尺寸过小 | 使用 Scroll 容器，支持滚动浏览 |
| 深色模式 | 自动适配系统主题（颜色使用系统变量） |

---

## 10. 可访问性考虑

| 项目 | 标准 | 实现 |
|------|------|------|
| **颜色对比度** | WCAG AA (4.5:1) | `#333333` on `#F5F5F5` = 12.6:1 ✓ |
| **按钮最小尺寸** | ≥ 44vp | 按钮高度设置为 48vp ✓ |
| **无障碍标签** | 所有按钮有 description | 每个按钮设置 `.accessibility.description` |

---

## 11. 视觉验证标准

| 检查项 | 标准值 | 容差 |
|--------|--------|------|
| Card 圆角 | 12vp | ±1vp |
| Card 间距 | 16vp | ±2vp |
| Card 内边距 | 12vp | ±1vp |
| 主色调 | #007DFF | 必须精确 |
| 页面背景 | #F5F5F5 | 必须精确 |

---

## 12. 验收标准（量化版）

### 功能验收
- [ ] 5 种布局全部实现（Column、Row、Stack、Flex、Grid）
- [ ] 每个布局有 1 个交互按钮
- [ ] 每个布局的状态切换生效

### 代码质量验收
- [ ] 代码注释覆盖率 > 80%
- [ ] 无单字母变量名（`i`、`j` 等循环变量除外）
- [ ] 每个函数/组件有头部注释
- [ ] 关键 API 有内联注释说明

### 视觉验收
- [ ] Card 圆角一致（12vp）
- [ ] 间距符合设计值（16vp / 12vp）
- [ ] 颜色符合主题定义

### 体验验收
- [ ] 页面可正常滚动浏览
- [ ] 按钮点击响应灵敏
- [ ] 状态切换有视觉反馈

### 初学者友好验收
- [ ] 术语表已添加（解释 `@Component`、`@State`、`vp` 等）
- [ ] 每个文件有完整的功能说明
- [ ] 代码示例可直接运行

---

## 13. 术语表（面向零基础）

| 术语 | 解释 |
|------|------|
| `@Component` | 标记一个 struct 为可复用的 UI 组件 |
| `@Entry` | 标记页面的入口组件 |
| `@State` | 声明组件内部的状态变量，状态变化时 UI 自动更新 |
| `vp` | 虚拟像素单位，类似 CSS 的 dp，自动适配不同屏幕密度 |
| `FlexAlign` | 主轴对齐方式枚举（Start/Center/End/SpaceAround/SpaceEvenly） |
| `ItemAlign` | 交叉轴对齐方式枚举（Start/Center/End/Stretch） |
| `Column` | 垂直布局容器，子元素从上到下排列 |
| `Row` | 水平布局容器，子元素从左到右排列 |
| `Stack` | 叠加布局容器，子元素按顺序叠加 |
| `Flex` | 弹性布局容器，支持换行、对齐等灵活控制 |
| `Grid` | 网格布局容器，子元素按行列排列 |

---

## 14. 扩展阅读

- [ArkUI 官方文档 - 布局组件](https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/layout-overview-0000001501961869-V3)
- [ArkUI 官方文档 - 状态管理](https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/state-overview-0000001501871756-V3)
- [HarmonyOS 开发者指南](https://developer.harmonyos.com/cn/docs/)

---

## 15. 相关文件

| 类型 | 路径 |
|------|------|
| **实施计划** | `../plans/2026-04-03-hello-world-plan.md` |
| **模块记录** | `../../Records/hello-world/` |
| **测试计划** | `../../Tests/hello-world-TestPlan.md` |

---

**版本**: 1.1  
**审查状态**: 已回应审查意见  
**更新日期**: 2026-04-03
