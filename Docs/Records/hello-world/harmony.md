# Hello World - HarmonyOS 平台实现

## 页面结构

```
entry/src/main/ets/pages/hello/
└── Index.ets          # @Entry 页面组件
```

## 核心代码

### Index.ets

```typescript
@Entry
@Component
struct HelloPage {
  build() {
    Column() {
      Text('Hello World')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor('#000000')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
```

## 技术决策

1. **声明式 UI** - 使用 `@Entry` + `@Component` + `build()` 方法，官方推荐写法
2. **Column 布局** - 垂直居中布局
3. **独立页面** - 不影响现有应用功能

## 运行方式

在 DevEco Studio 中：
1. 选择 Entry 作为启动目标
2. 点击运行按钮
3. 在模拟器或真机上查看

## 变更历史

| 版本 | 日期 | 变更类型 | 变更描述 | 关联 Commit | PR |
|------|------|----------|----------|-------------|-----|
| v1.0 | 2026-04-02 | feat | 初始版本 | - | - |
