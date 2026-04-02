# Hello World 示例设计

**日期**: 2026-04-02
**类型**: 教学示例
**平台**: HarmonyOS (ArkTS/ArkUI)

---

## 目标

创建一个最简单的 HarmonyOS ArkTS 声明式 UI 示例，用于学习/演示 ArkTS 基础。

## 设计决策

| 决策 | 选择 | 理由 |
|------|------|------|
| 复杂度 | 最简单 | 只显示"Hello World"文本，无其他功能 |
| UI 写法 | 声明式 UI | 官方推荐，主流写法，类似 SwiftUI/Flutter |
| 页面位置 | 新建独立页面 | 不破坏现有应用功能，适合教学示例 |

## 架构

```
entry/src/main/ets/pages/hello/
└── Index.ets          # 主页面 - @Entry 组件，显示"Hello World"
```

## 代码结构

**文件**: `entry/src/main/ets/pages/hello/Index.ets`

**要求**:
- 使用 `@Entry` 和 `@Component` 装饰器
- `build()` 方法返回 ArkUI 声明式布局
- 使用 `Column` 垂直布局
- 使用 `Text` 组件显示"Hello World"
- 基础样式：居中、字体大小 30、颜色黑色
- 约 30-40 行代码

## 成功标准

- [ ] 代码符合 ArkTS 规范
- [ ] 页面可正常显示"Hello World"文本
- [ ] 代码简洁、可读性强
- [ ] 可作为教学示例

---

**下一步**: 调用 `writing-plans` 技能创建实施计划
