# 设置模块 (Settings) - iOS 记录

**平台**: iOS (Swift/SwiftUI)  
**开发负责人**: @ios-specialist  
**状态**: ✅ 已完成

---

## 1. 平台概述

iOS 端使用 SwiftUI 实现，采用 MVVM 架构模式。

### 技术栈
- **UI 框架**: SwiftUI
- **架构模式**: MVVM + Repository
- **状态管理**: @State, @ObservedObject, @EnvironmentObject
- **本地存储**: UserDefaults

---

## 2. 变更历史

| 版本 | 日期 | 变更类型 | 变更描述 | 关联 Commit | PR |
|------|------|----------|----------|-------------|-----|
| v1.0 | 2026-03-25 | feat | 初始版本 - 设置页面框架 | c25e44c | #101 |
| v1.1 | 2026-03-26 | feat | 添加 5 个子模块页面 | 70732c3 | #102 |
| v1.2 | 2026-03-27 | fix | 修复 ProfileView 缩进问题 | 272c366 | #103 |
| v1.3 | 2026-04-01 | refactor | 重构项目文件结构 | b79dd1c | #104 |
| v1.4 | 2026-04-01 | docs | 恢复文档 | 86f8b9b | #105 |

---

## 3. 技术决策

### 决策 1: SettingsItem 组件化

- **日期**: 2026-03-25
- **背景**: 5 个设置页面有重复的列表项结构
- **选项**:
  - 每个页面独立实现
  - 抽取通用 SettingsItem 组件
- **决定**: 抽取 SettingsItem 组件
- **原因**:
  - 减少代码重复 (从 500 行降至 150 行)
  - 统一视觉风格
  - 便于后续维护

### 决策 2: ViewModel 层设计

- **日期**: 2026-03-25
- **背景**: 需要清晰的状态管理
- **选项**:
  - 使用 @State 直接在 View 中管理
  - 创建独立 ViewModel 类
- **决定**: 创建独立 ViewModel 类
- **原因**:
  - 便于单元测试
  - 逻辑与 UI 分离
  - 符合 MVVM 架构

---

## 4. 文件清单

### 主目录结构
```
Team Mode/MobileApp/iOS/settings/
├── AccountSettingsView.swift      # 账户设置页面
├── AccountSettingsViewModel.swift # 账户设置 VM
├── GeneralSettingsView.swift      # 通用设置页面
├── GeneralSettingsViewModel.swift # 通用设置 VM
├── NotificationSettingsView.swift # 通知设置页面
├── NotificationSettingsViewModel.swift
├── PrivacySettingsView.swift      # 隐私设置页面
├── PrivacySettingsViewModel.swift # 隐私设置 VM
├── HelpFeedbackView.swift         # 帮助与反馈页面
├── SettingsItem.swift             # 通用设置项组件
└── SettingsHeader.swift           # 设置页面头部组件
```

### 文件详情
| 文件 | 行数 | 说明 |
|------|------|------|
| `AccountSettingsView.swift` | 120 | 账户设置 UI |
| `AccountSettingsViewModel.swift` | 80 | 账户设置逻辑 |
| `SettingsItem.swift` | 60 | 通用列表项组件 |
| `SettingsHeader.swift` | 40 | 页面头部组件 |

---

## 5. 已知问题

| 问题描述 | 影响 | 临时方案 | 预计修复 |
|----------|------|----------|----------|
| 无 | - | - | - |

---

## 6. 测试覆盖

| 测试类型 | 覆盖率 | 测试文件 |
|----------|--------|----------|
| 单元测试 | 85% | `Tests/SettingsViewModelTests.swift` |
| UI 测试 | 70% | `Tests/SettingsViewTests.swift` |

---

## 7. 代码示例

### SettingsItem 组件

```swift
struct SettingsItem: View {
    let icon: String
    let title: String
    let value: String?
    let action: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
            Spacer()
            if let value = value {
                Text(value)
                    .foregroundColor(.gray)
            }
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .onTapGesture { action() }
    }
}
```

---

**最后更新**: 2026-04-02
