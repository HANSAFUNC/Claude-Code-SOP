# 功能模块变更记录

> 记录每个功能模块在各平台（iOS/Android/Harmony）的开发历史和变更轨迹

---

## 📋 使用说明

### 目录结构

```
Docs/Records/
├── README.md                      # 本文件（索引）
├── templates/                     # 记录模板
│   └── module-record.md           # 模块记录模板
└── {module-name}/                 # 每个模块一个目录
    ├── overview.md                # 模块概述和跨平台信息
    ├── ios.md                     # iOS 平台记录
    ├── android.md                 # Android 平台记录
    └── harmony.md                 # HarmonyOS 平台记录
```

### 文件命名

| 文件 | 用途 |
|------|------|
| `overview.md` | 模块概述、跨平台通用信息、API 契约 |
| `ios.md` | iOS 平台特有实现和变更 |
| `android.md` | Android 平台特有实现和变更 |
| `harmony.md` | HarmonyOS 平台特有实现和变更 |

---

## 📂 现有模块记录

| 模块 | 目录 | iOS | Android | Harmony |
|------|------|-----|---------|---------|
| 设置模块 | `settings/` | ✅ | ⏳ | ⏳ |

---

## 📝 记录模板

### overview.md 模板

```markdown
# {模块名称} - 概述

**创建日期**: YYYY-MM-DD  
**产品负责人**: @pm  
**技术负责人**: @architect  
**状态**: 规划中 / 开发中 / 已完成 / 已下线

---

## 1. 模块概述

简要描述模块的功能和用途。

---

## 2. 跨平台变更总览

| 日期 | 变更类型 | 变更描述 | iOS | Android | Harmony |
|------|----------|----------|-----|---------|---------|
| YYYY-MM-DD | feat | 初始版本 | ✅ | ✅ | ✅ |

---

## 3. 平台实现状态

| 平台 | 状态 | 负责人 | 开始日期 | 完成日期 |
|------|------|--------|----------|----------|
| iOS | 已完成 | @ios-specialist | | |
| Android | 开发中 | @android-specialist | | |
| Harmony | 规划中 | @harmony-specialist | | |

---

## 4. 相关文件

| 类型 | 路径 |
|------|------|
| 需求文档 | `../../PRD/YYYYMMDD-{module}-PRD.md` |
| 设计稿 | `../../Design/YYYYMMDD-{module}-Design.png` |
| 架构文档 | `../../Architect/{module}-*.md` |
| 测试计划 | `../../Docs/Tests/{module}-TestPlan.md` |

---

## 5. 接口依赖

### 上游依赖
- 依赖的模块或 API

### 下游依赖
- 被哪些模块依赖

---

## 6. 团队成员

| 角色 | 成员 | 职责 |
|------|------|------|
| 产品负责人 | | 需求定义 |
| 技术负责人 | | 架构设计 |
| iOS 开发 | | iOS 实现 |
| Android 开发 | | Android 实现 |
| Harmony 开发 | | Harmony 实现 |
| QA | | 测试验证 |
```

### 平台记录模板 ({platform}.md)

```markdown
# {模块名称} - {平台} 记录

**平台**: iOS / Android / HarmonyOS  
**开发负责人**: @developer  
**状态**: 规划中 / 开发中 / 已完成 / 已下线

---

## 1. 平台概述

平台特有的实现说明。

---

## 2. 变更历史

| 版本 | 日期 | 变更类型 | 变更描述 | 关联 Commit | PR |
|------|------|----------|----------|-------------|-----|
| v1.0 | YYYY-MM-DD | feat | 初始版本 | abc1234 | #123 |

---

## 3. 技术决策

### 决策 1: {决策名称}

- **日期**: YYYY-MM-DD
- **背景**: 为什么需要做这个决策
- **选项**: 考虑过的方案
- **决定**: 最终选择的方案
- **原因**: 选择该方案的理由

---

## 4. 文件清单

| 类型 | 文件路径 | 说明 |
|------|----------|------|
| View | `path/to/File.swift` | 页面视图 |
| ViewModel | `path/to/ViewModel.swift` | 视图模型 |
| Model | `path/to/Model.swift` | 数据模型 |

---

## 5. 已知问题

| 问题描述 | 影响 | 临时方案 | 预计修复 |
|----------|------|----------|----------|
| | | | |

---

## 6. 测试覆盖

| 测试类型 | 覆盖率 | 测试文件 |
|----------|--------|----------|
| 单元测试 | % | `path/to/Tests` |
| UI 测试 | % | `path/to/UITests` |
```

---

## 🔗 相关文档

- [SOP 流程](../SOP/README.md)
- [团队协作指南](../Guides/team-collaboration.md)
- [Commit 规范](../SOP/05-commit.md)

---

**版本**: 2.0
**更新日期**: 2026-04-02
