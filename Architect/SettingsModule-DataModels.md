# 设置中心模块 - 数据结构定义

> 本文档定义设置中心 (Settings Center) 相关的所有数据结构，包括设置项模型、用户信息扩展、协议模型等。

---

## 1. 功能概述

设置中心模块包含以下功能区域：

| 功能区域     | 说明                 | 包含项                                                       |
| ------------ | -------------------- | ------------------------------------------------------------ |
| 用户信息区域 | 展示当前登录用户信息 | 头像、昵称、当前身份、登出按钮                               |
| 功能列表区   | 设置相关功能入口     | 我的退休梦想图、IDA 高研院 APP、隐私政策、用户协议、注销账号 |
| 底部信息区   | 应用版本和备案信息   | 版本号、ICP 备案号                                           |

### 1.1 页面结构

```
┌─────────────────────────────────┐
│      用户信息区域 (Header)       │
│  ┌───┐                          │
│  │头像│  昵称                    │
│  └───┘  当前登录身份    [登出]   │
├─────────────────────────────────┤
│  [我的退休梦想图]         >     │
│  [IDA 高研院 APP]         >     │
│  [隐私政策协议]           >     │
│  [用户协议]               >     │
│  [注销账号]               >     │
├─────────────────────────────────┤
│     退休规划师 v2.3.4           │
│     京 ICP 备 XXXXXXXX 号          │
└─────────────────────────────────┘
```

---

## 2. 数据模型

### 2.1 设置项模型 (SettingsItem)

```typescript
/**
 * 设置项类型枚举
 */
enum SettingsItemType {
  /** 跳转页面 */
  NAVIGATION = 1,
  /** WebView 打开协议 */
  WEB_VIEW = 2,
  /** 外部链接 */
  EXTERNAL_LINK = 3,
  /** 触发确认对话框 */
  CONFIRM_ACTION = 4,
  /** 开关切换 */
  TOGGLE = 5,
}

/**
 * 设置项数据模型
 * 描述：设置页面列表项的数据结构
 */
@Observed
class SettingsItem {
  /** 设置项唯一标识 */
  id: string = "";

  /** 设置项标题 */
  title: string = "";

  /** 设置项副标题/描述 (可选) */
  subtitle?: string = undefined;

  /** 图标资源名称或 URL */
  icon: string = "";

  /** 设置项类型 */
  type: SettingsItemType = SettingsItemType.NAVIGATION;

  /** 跳转路由地址 (页面路径或 URL) */
  destination: string = "";

  /** 是否需要登录 */
  requireAuth: boolean = true;

  /** 是否需要确认对话框 */
  needConfirm: boolean = false;

  /** 确认对话框标题 */
  confirmTitle?: string = undefined;

  /** 确认对话框内容 */
  confirmMessage?: string = undefined;

  /** 确认按钮文字 */
  confirmButtonText?: string = undefined;

  /** 是否显示红点提示 */
  showBadge: boolean = false;

  /** 红点提示文字 */
  badgeText?: string = undefined;

  /** 是否启用 */
  enabled: boolean = true;

  /** 排序值 (数字越小越靠前) */
  order: number = 999;
}
```

### 2.2 设置项分组 (SettingsGroup)

```typescript
/**
 * 设置项分组
 * 描述：用于将设置项按组展示
 */
@Observed
class SettingsGroup {
  /** 分组唯一标识 */
  id: string = "";

  /** 分组标题 */
  title: string = "";

  /** 分组副标题 */
  subtitle?: string = undefined;

  /** 设置项列表 */
  items: SettingsItem[] = [];

  /** 是否显示分组标题 */
  showHeader: boolean = true;

  /** 排序值 */
  order: number = 999;
}
```

### 2.3 用户信息扩展 (UserInfo)

```typescript
/**
 * 用户信息展示模型
 * 描述：用于设置页面头部展示的用户信息
 */
@Observed
class UserInfo {
  /** 用户 ID */
  userId: string = "";

  /** 用户昵称 */
  nickname: string = "";

  /** 头像 URL */
  avatar: string = "";

  /** 当前登录身份描述 */
  currentIdentity: string = "";

  /** 账号类型 */
  accountType: AccountType = AccountType.NORMAL;

  /** 是否需要完善信息 */
  needCompleteProfile: boolean = false;
}
```

### 2.4 应用版本信息 (AppVersionInfo)

```typescript
/**
 * 应用版本信息
 * 描述：用于设置页面底部展示的版本信息
 */
@Observed
class AppVersionInfo {
  /** 应用名称 */
  appName: string = "退休规划师";

  /** 版本号 (如：2.3.4) */
  versionName: string = "";

  /** 版本号 (如：100) */
  versionCode: number = 0;

  /** 完整版本描述 (如：v2.3.4) */
  get fullVersion(): string {
    return `${this.versionName}`;
  }

  /** ICP 备案号 */
  icpLicense: string = "";

  /** ICP 备案跳转 URL */
  icpLicenseUrl: string = "https://beian.miit.gov.cn/";
}
```

### 2.5 协议模型 (Protocol)

```typescript
/**
 * 协议类型枚举
 */
enum ProtocolType {
  /** 隐私政策 */
  PRIVACY_POLICY = 1,
  /** 用户协议 */
  USER_AGREEMENT = 2,
  /** 第三方 SDK 目录 */
  SDK_DIRECTORY = 3,
  /** 儿童保护政策 */
  CHILD_PROTECTION = 4,
}

/**
 * 协议信息
 * 描述：用于 WebView 展示的协议内容
 */
@Observed
class Protocol {
  /** 协议唯一标识 */
  id: string = "";

  /** 协议标题 */
  title: string = "";

  /** 协议类型 */
  type: ProtocolType = ProtocolType.PRIVACY_POLICY;

  /** 协议 URL */
  url: string = "";

  /** 协议版本号 */
  version: string = "";

  /** 是否必须同意 */
  isRequired: boolean = true;

  /** 最后更新时间戳 */
  updatedAt: number = 0;

  /** 用户是否已同意 */
  userAgreed: boolean = false;

  /** 用户同意时间戳 */
  userAgreedAt?: number = undefined;
}
```

### 2.6 设置页面配置 (SettingsPageConfig)

```typescript
/**
 * 设置页面配置
 * 描述：设置页面的整体配置数据
 */
@Observed
class SettingsPageConfig {
  /** 用户信息 */
  userInfo: UserInfo | null = null;

  /** 设置项分组列表 */
  groups: SettingsGroup[] = [];

  /** 应用版本信息 */
  appVersion: AppVersionInfo = new AppVersionInfo();

  /** 是否已登录 */
  isLoggedIn: boolean = false;

  /** 登出按钮文字 */
  logoutButtonText: string = "退出登录";

  /** 页面标题 */
  pageTitle: string = "设置";

  /** 是否显示导航栏 */
  showNavBar: boolean = true;
}
```

---

## 3. API 请求/响应模型

### 3.1 获取设置配置请求

```typescript
/**
 * 获取设置配置请求参数
 */
class SettingsConfigRequest {
  /** 应用版本号 */
  appVersion: string = "";

  /** 平台标识 */
  platform: string = "harmonyos";

  /** 语言环境 */
  locale: string = "zh-CN";
}
```

### 3.2 获取设置配置响应

```typescript
/**
 * 获取设置配置响应数据
 */
class SettingsConfigResponse {
  /** 设置项分组列表 */
  groups: SettingsGroup[] = [];

  /** 协议列表 */
  protocols: Protocol[] = [];

  /** 外部链接配置 */
  externalLinks: Record<string, string> = {};

  /** 功能开关配置 */
  featureFlags: Record<string, boolean> = {};
}
```

### 3.3 退出登录请求

```typescript
/**
 * 退出登录请求参数
 */
class LogoutRequest {
  /** 设备 ID */
  deviceId: string = "";

  /** 退出原因 (可选) */
  reason?: string = undefined;
}
```

### 3.4 注销账号请求

```typescript
/**
 * 注销账号请求参数
 */
class CancelAccountRequest {
  /** 用户 ID */
  userId: string = "";

  /** 注销原因 */
  reason: string = "";

  /** 验证码 (如果需要) */
  verificationCode?: string = undefined;

  /** 确认标记 */
  confirmed: boolean = true;
}
```

### 3.5 注销账号响应

```typescript
/**
 * 注销账号响应数据
 */
class CancelAccountResponse {
  /** 是否成功 */
  success: boolean = false;

  /** 注销冷却期 (天) */
  coolOffDays: number = 0;

  /** 可恢复截止时间戳 */
  recoverableUntil?: number = undefined;

  /** 提示信息 */
  message: string = "";
}
```

---

## 4. 本地存储模型

### 4.1 设置存储 (SettingsStorage)

```typescript
/**
 * 设置本地存储模型
 * 描述：存储在 Preferences 中的设置数据
 */
@Observed
class SettingsStorage {
  /** 是否首次启动 */
  isFirstLaunch: boolean = true;

  /** 已同意的隐私政策版本 */
  agreedPrivacyVersion: string = "";

  /** 已同意的用户协议版本 */
  agreedUserAgreementVersion: string = "";

  /** 协议同意时间 */
  agreementsAgreedAt: number = 0;

  /** 是否显示过新手引导 */
  hasShownOnboarding: boolean = false;

  /** 上次检查版本时间 */
  lastVersionCheckAt: number = 0;

  /** 用户自定义设置 */
  userPreferences: UserPreferences = new UserPreferences();
}
```

### 4.2 用户偏好设置 (UserPreferences)

```typescript
/**
 * 用户偏好设置
 */
@Observed
class UserPreferences {
  /** 通知开关 */
  notificationEnabled: boolean = true;

  /** 自动播放视频 */
  autoPlayVideo: boolean = true;

  /** WiFi 下自动下载 */
  downloadOnlyOnWifi: boolean = true;

  /** 字体大小 */
  fontSize: FontSize = FontSize.NORMAL;

  /** 主题模式 */
  themeMode: ThemeMode = ThemeMode.SYSTEM;

  /** 退出时是否清除缓存 */
  clearCacheOnExit: boolean = false;
}
```

---

## 5. 枚举类型汇总

### 5.1 SettingsItemType

| 值  | 名称           | 说明         |
| --- | -------------- | ------------ |
| 1   | NAVIGATION     | 跳转页面     |
| 2   | WEB_VIEW       | WebView 打开 |
| 3   | EXTERNAL_LINK  | 外部链接     |
| 4   | CONFIRM_ACTION | 确认动作     |
| 5   | TOGGLE         | 开关切换     |

### 5.2 ProtocolType

| 值  | 名称             | 说明            |
| --- | ---------------- | --------------- |
| 1   | PRIVACY_POLICY   | 隐私政策        |
| 2   | USER_AGREEMENT   | 用户协议        |
| 3   | SDK_DIRECTORY    | 第三方 SDK 目录 |
| 4   | CHILD_PROTECTION | 儿童保护政策    |

### 5.3 FontSize

| 值  | 名称        | 说明 |
| --- | ----------- | ---- |
| 0   | SMALL       | 小   |
| 1   | NORMAL      | 正常 |
| 2   | LARGE       | 大   |
| 3   | EXTRA_LARGE | 特大 |

### 5.4 ThemeMode

| 值  | 名称   | 说明     |
| --- | ------ | -------- |
| 0   | SYSTEM | 跟随系统 |
| 1   | LIGHT  | 浅色模式 |
| 2   | DARK   | 深色模式 |

---

## 附录

### A. 默认设置项配置

```typescript
// 默认设置项列表配置
const DEFAULT_SETTINGS_ITEMS: SettingsItem[] = [
  {
    id: "dream_map",
    title: "我的退休梦想图",
    icon: "icon_dream",
    type: SettingsItemType.NAVIGATION,
    destination: "pages/dream/DreamMapPage",
    requireAuth: true,
    order: 1,
  },
  {
    id: "ida_app",
    title: "IDA 高研院 APP",
    icon: "icon_app",
    type: SettingsItemType.EXTERNAL_LINK,
    destination: "https://app.ida1998.com/download",
    requireAuth: false,
    order: 2,
  },
  {
    id: "privacy_policy",
    title: "隐私政策协议",
    icon: "icon_privacy",
    type: SettingsItemType.WEB_VIEW,
    destination: "https://crm.ida1998.com/privacy",
    requireAuth: false,
    order: 3,
  },
  {
    id: "user_agreement",
    title: "用户协议",
    icon: "icon_agreement",
    type: SettingsItemType.WEB_VIEW,
    destination: "https://crm.ida1998.com/terms",
    requireAuth: false,
    order: 4,
  },
  {
    id: "cancel_account",
    title: "注销账号",
    icon: "icon_delete",
    type: SettingsItemType.CONFIRM_ACTION,
    destination: "/api/v1/auth/cancel",
    requireAuth: true,
    needConfirm: true,
    confirmTitle: "确认注销账号？",
    confirmMessage: "注销后您的账号信息将被永久删除，且无法恢复。请谨慎操作！",
    confirmButtonText: "确认注销",
    order: 5,
  },
];
```

### B. 变更日志

| 版本 | 日期       | 作者             | 变更说明 |
| ---- | ---------- | ---------------- | -------- |
| v1.0 | 2026-03-25 | mobile-architect | 初始版本 |
