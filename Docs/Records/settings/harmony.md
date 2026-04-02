# 设置模块 (Settings) - Harmony 记录

**平台**: HarmonyOS (ArkTS/ArkUI)  
**开发负责人**: @harmony-specialist  
**状态**: ⏳ 规划中

---

## 1. 平台概述

HarmonyOS 端使用 ArkTS 和 ArkUI 声明式框架实现，采用 MVVM 架构模式。

### 技术栈
- **开发语言**: ArkTS
- **UI 框架**: ArkUI (声明式 UI)
- **架构模式**: MVVM + Repository
- **状态管理**: @State, @Prop, @Link, AppStorage
- **本地存储**: Preferences / MMKV

---

## 2. 变更历史

| 版本 | 日期 | 变更类型 | 变更描述 | 关联 Commit | PR |
|------|------|----------|----------|-------------|-----|
| - | - | - | 待实现 | - | - |

---

## 3. 技术决策

暂无

---

## 4. 文件清单

```
harmony_chrp_app/entry/src/main/ets/settings/
├── pages/
│   ├── AccountSettingsPage.ets
│   ├── GeneralSettingsPage.ets
│   ├── NotificationSettingsPage.ets
│   ├── PrivacySettingsPage.ets
│   └── HelpFeedbackPage.ets
├── viewmodels/
│   ├── AccountSettingsViewModel.ets
│   ├── GeneralSettingsViewModel.ets
│   └── ...
└── components/
    ├── SettingsItem.ets
    └── SettingsHeader.ets
```

---

## 5. 已知问题

暂无

---

## 6. 测试覆盖

| 测试类型 | 覆盖率 | 测试文件 |
|----------|--------|----------|
| 单元测试 | - | - |
| UI 测试 | - | - |

---

**最后更新**: 2026-04-02
