# 设置中心模块 - API 接口设计

> 本文档定义设置中心 (Settings Center) 相关的所有 API 接口，包括退出登录、注销账号、获取用户信息、获取协议列表等接口。

---

## 1. 接口概述

设置中心模块共包含 5 个核心 API 接口：

| 接口         | 方法 | 路径                         | 说明                     | 认证 |
| ------------ | ---- | ---------------------------- | ------------------------ | ---- |
| 获取用户信息 | GET  | `/api/v1/user/profile`       | 获取当前用户详细信息     | 是   |
| 退出登录     | POST | `/api/v1/auth/logout`        | 退出当前登录状态         | 是   |
| 注销账号     | POST | `/api/v1/auth/cancel`        | 申请注销用户账号         | 是   |
| 获取协议列表 | GET  | `/api/v1/settings/protocols` | 获取隐私政策、用户协议等 | 否   |
| 获取设置配置 | GET  | `/api/v1/settings/config`    | 获取设置页面配置数据     | 否   |

---

## 2. API 接口详情

### 2.1 获取用户信息

#### 接口说明

获取当前登录用户的详细信息，用于设置页面头部展示。

#### 请求定义

```typescript
// 请求
GET /api/v1/user/profile
Authorization: Bearer {token}

// 请求头
{
  "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "X-Device-Id": "xxx-xxx-xxx",
  "X-App-Version": "2.3.4",
  "X-Platform": "harmonyos"
}

// 无请求参数
```

#### 响应定义

```typescript
// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "userId": "1001",
    "username": "zhangsan",
    "nickname": "张三",
    "avatar": "https://crm.ida1998.com/uploads/avatar/1001.jpg",
    "phone": "138****0000",
    "email": "zhangsan@example.com",
    "department": "培训部",
    "position": "培训专员",
    "employeeId": "EMP20240001",
    "accountType": 1,
    "identityDescription": "企业微信内部员工",
    "needCompleteProfile": false,
    "createdAt": 1704067200000,
    "lastLoginAt": 1711353600000
  },
  "timestamp": 1711353600000,
  "traceId": "abc123xyz456"
}
```

#### 数据模型

```typescript
interface UserProfileResponse {
  /** 用户 ID */
  userId: string;
  /** 用户名 */
  username: string;
  /** 昵称 */
  nickname: string;
  /** 头像 URL */
  avatar: string;
  /** 手机号 (脱敏) */
  phone: string;
  /** 邮箱 */
  email: string;
  /** 部门 */
  department: string;
  /** 职位 */
  position: string;
  /** 工号 */
  employeeId: string;
  /** 账号类型 */
  accountType: number;
  /** 身份描述 */
  identityDescription: string;
  /** 是否需要完善信息 */
  needCompleteProfile: boolean;
  /** 创建时间 */
  createdAt: number;
  /** 最后登录时间 */
  lastLoginAt: number;
}
```

#### 错误码

| 错误码 | 说明                | 处理建议                   |
| ------ | ------------------- | -------------------------- |
| B00000 | 成功                | -                          |
| B00002 | 未授权 (Token 失效) | 清除本地 Token，跳转登录页 |
| B00004 | 用户不存在          | 清除本地数据，跳转登录页   |

---

### 2.2 退出登录

#### 接口说明

退出当前登录状态，使 Token 失效。客户端需清除本地存储的 Token 和用户数据。

#### 请求定义

```typescript
// 请求
POST /api/v1/auth/logout
Authorization: Bearer {token}
Content-Type: application/json

// 请求头
{
  "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "Content-Type": "application/json; charset=UTF-8"
}

// 请求体
{
  "deviceId": "xxx-xxx-xxx",
  "reason": "user_logout"
}
```

#### 请求参数

```typescript
interface LogoutRequest {
  /** 设备 ID */
  deviceId: string;
  /** 退出原因 (可选) */
  reason?:
    | "user_logout"
    | "token_expired"
    | "switch_account"
    | "security_reason";
}
```

#### 响应定义

```typescript
// 响应
{
  "code": "B00000",
  "message": "退出成功",
  "data": null,
  "timestamp": 1711353600000,
  "traceId": "abc123xyz456"
}
```

#### 客户端处理逻辑

```typescript
// 退出登录成功后的客户端处理
async function handleLogoutSuccess(): Promise<void> {
  // 1. 清除本地 Token
  await Preferences.clearToken();

  // 2. 清除用户数据缓存
  await Cache.clearUserCache();

  // 3. 清除学习进度缓存
  await Cache.clearLearningProgress();

  // 4. 跳转登录页
  router.replaceUrl({ url: "pages/login/Login" });

  // 5. 提示用户
  showToast("已退出登录");
}
```

#### 错误码

| 错误码 | 说明       | 处理建议                                 |
| ------ | ---------- | ---------------------------------------- |
| B00000 | 成功       | 清除本地数据，跳转登录页                 |
| B00002 | 未授权     | Token 已失效，直接清除本地数据跳转登录页 |
| B00050 | 服务器错误 | 本地清除数据后跳转登录页                 |

---

### 2.3 注销账号

#### 接口说明

申请注销用户账号。根据业务规则，可能需要经过冷却期后才能永久删除。

#### 请求定义

```typescript
// 请求
POST /api/v1/auth/cancel
Authorization: Bearer {token}
Content-Type: application/json

// 请求体
{
  "userId": "1001",
  "reason": "个人原因，不再使用",
  "verificationCode": "123456",
  "confirmed": true
}
```

#### 请求参数

```typescript
interface CancelAccountRequest {
  /** 用户 ID */
  userId: string;
  /** 注销原因 */
  reason: string;
  /** 验证码 (短信验证码，根据业务规则可能需要) */
  verificationCode?: string;
  /** 用户确认标记 */
  confirmed: boolean;
}
```

#### 响应定义

```typescript
// 响应
{
  "code": "B00000",
  "message": "账号注销申请已提交",
  "data": {
    "success": true,
    "coolOffDays": 7,
    "recoverableUntil": 1711958400000,
    "message": "您的账号将在 7 天后永久删除，在此期间登录可随时取消注销"
  },
  "timestamp": 1711353600000,
  "traceId": "abc123xyz456"
}
```

#### 数据模型

```typescript
interface CancelAccountResponse {
  /** 是否成功 */
  success: boolean;
  /** 冷却期天数 */
  coolOffDays: number;
  /** 可恢复截止时间戳 */
  recoverableUntil?: number;
  /** 提示信息 */
  message: string;
}
```

#### 客户端处理逻辑

```typescript
// 注销账号成功后的客户端处理
async function handleCancelAccountSuccess(
  response: CancelAccountResponse,
): Promise<void> {
  // 1. 显示提示信息
  showDialog({
    title: "注销申请已提交",
    message: response.message,
    confirmButtonText: "知道了",
  });

  // 2. 清除本地数据
  await Preferences.clearToken();
  await Preferences.clearUserData();

  // 3. 跳转登录页
  router.replaceUrl({ url: "pages/login/Login" });
}
```

#### 错误码

| 错误码 | 说明                  | 处理建议                     |
| ------ | --------------------- | ---------------------------- |
| B00000 | 成功                  | 提示用户注销申请已提交       |
| B00002 | 未授权                | Token 失效，跳转登录页       |
| B00020 | 账号已在注销流程中    | 提示用户账号已在注销中       |
| B00021 | 账号有未完成订单      | 提示用户完成所有订单后再注销 |
| B00010 | 参数错误 (验证码错误) | 提示用户重新输入验证码       |

---

### 2.4 获取协议列表

#### 接口说明

获取隐私政策、用户协议等协议信息，用于 WebView 展示。

#### 请求定义

```typescript
// 请求
GET /api/v1/settings/protocols
Content-Type: application/json

// Query 参数 (可选)
?platform=harmonyos&appVersion=2.3.4&locale=zh-CN

// 无需认证头
```

#### 响应定义

```typescript
// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": [
    {
      "id": "privacy_2024_v1",
      "title": "隐私政策",
      "type": 1,
      "url": "https://crm.ida1998.com/protocols/privacy_v1.html",
      "version": "1.0.0",
      "isRequired": true,
      "updatedAt": 1704067200000,
      "userAgreed": false,
      "userAgreedAt": null
    },
    {
      "id": "terms_2024_v1",
      "title": "用户协议",
      "type": 2,
      "url": "https://crm.ida1998.com/protocols/terms_v1.html",
      "version": "1.0.0",
      "isRequired": true,
      "updatedAt": 1704067200000,
      "userAgreed": false,
      "userAgreedAt": null
    },
    {
      "id": "sdk_2024_v1",
      "title": "第三方 SDK 目录",
      "type": 3,
      "url": "https://crm.ida1998.com/protocols/sdk_v1.html",
      "version": "1.0.0",
      "isRequired": false,
      "updatedAt": 1704067200000,
      "userAgreed": false,
      "userAgreedAt": null
    }
  ],
  "timestamp": 1711353600000,
  "traceId": "abc123xyz456"
}
```

#### 数据模型

```typescript
interface ProtocolListResponse {
  protocols: ProtocolInfo[];
}

interface ProtocolInfo {
  /** 协议 ID */
  id: string;
  /** 协议标题 */
  title: string;
  /** 协议类型 */
  type: number;
  /** 协议 URL */
  url: string;
  /** 协议版本 */
  version: string;
  /** 是否必须同意 */
  isRequired: boolean;
  /** 更新时间 */
  updatedAt: number;
  /** 用户是否已同意 */
  userAgreed: boolean;
  /** 用户同意时间 */
  userAgreedAt?: number;
}
```

#### 错误码

| 错误码 | 说明       | 处理建议               |
| ------ | ---------- | ---------------------- |
| B00000 | 成功       | -                      |
| B00001 | 通用错误   | 提示用户稍后重试       |
| B00050 | 服务器错误 | 使用本地缓存的协议内容 |

---

### 2.5 获取设置配置

#### 接口说明

获取设置页面的整体配置数据，包括设置项列表、外部链接配置、功能开关等。

#### 请求定义

```typescript
// 请求
GET /api/v1/settings/config
Content-Type: application/json

// Query 参数
?platform=harmonyos&appVersion=2.3.4&locale=zh-CN&userId=1001
```

#### 请求参数

```typescript
interface SettingsConfigRequest {
  /** 平台标识 */
  platform: string;
  /** App 版本号 */
  appVersion: string;
  /** 语言环境 */
  locale: string;
  /** 用户 ID (可选，登录后传入) */
  userId?: string;
}
```

#### 响应定义

```typescript
// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "groups": [
      {
        "id": "function_group",
        "title": "功能服务",
        "subtitle": "",
        "showHeader": true,
        "order": 1,
        "items": [
          {
            "id": "dream_map",
            "title": "我的退休梦想图",
            "subtitle": "规划您的退休生活",
            "icon": "icon_dream",
            "type": 1,
            "destination": "pages/dream/DreamMapPage",
            "requireAuth": true,
            "needConfirm": false,
            "showBadge": false,
            "enabled": true,
            "order": 1
          },
          {
            "id": "ida_app",
            "title": "IDA 高研院 APP",
            "subtitle": "下载移动端应用",
            "icon": "icon_app",
            "type": 3,
            "destination": "https://app.ida1998.com/download",
            "requireAuth": false,
            "needConfirm": false,
            "showBadge": false,
            "enabled": true,
            "order": 2
          }
        ]
      },
      {
        "id": "agreement_group",
        "title": "协议与条款",
        "subtitle": "",
        "showHeader": true,
        "order": 2,
        "items": [
          {
            "id": "privacy_policy",
            "title": "隐私政策协议",
            "subtitle": "",
            "icon": "icon_privacy",
            "type": 2,
            "destination": "https://crm.ida1998.com/protocols/privacy.html",
            "requireAuth": false,
            "needConfirm": false,
            "showBadge": false,
            "enabled": true,
            "order": 1
          },
          {
            "id": "user_agreement",
            "title": "用户协议",
            "subtitle": "",
            "icon": "icon_agreement",
            "type": 2,
            "destination": "https://crm.ida1998.com/protocols/terms.html",
            "requireAuth": false,
            "needConfirm": false,
            "showBadge": false,
            "enabled": true,
            "order": 2
          }
        ]
      },
      {
        "id": "account_group",
        "title": "账号安全",
        "subtitle": "",
        "showHeader": true,
        "order": 3,
        "items": [
          {
            "id": "cancel_account",
            "title": "注销账号",
            "subtitle": "",
            "icon": "icon_delete",
            "type": 4,
            "destination": "/api/v1/auth/cancel",
            "requireAuth": true,
            "needConfirm": true,
            "confirmTitle": "确认注销账号？",
            "confirmMessage": "注销后您的账号信息将被永久删除，且无法恢复。请谨慎操作！",
            "confirmButtonText": "确认注销",
            "showBadge": false,
            "enabled": true,
            "order": 1
          }
        ]
      }
    ],
    "protocols": [...],
    "externalLinks": {
      "ida_app_download": "https://app.ida1998.com/download",
      "icp_license": "https://beian.miit.gov.cn/"
    },
    "featureFlags": {
      "dream_map_enabled": true,
      "ida_app_entry_enabled": true,
      "cancel_account_enabled": true
    }
  },
  "timestamp": 1711353600000,
  "traceId": "abc123xyz456"
}
```

#### 数据模型

```typescript
interface SettingsConfigResponse {
  /** 设置项分组列表 */
  groups: SettingsGroupResponse[];
  /** 协议列表 */
  protocols: ProtocolInfo[];
  /** 外部链接配置 */
  externalLinks: Record<string, string>;
  /** 功能开关配置 */
  featureFlags: Record<string, boolean>;
}

interface SettingsGroupResponse {
  /** 分组 ID */
  id: string;
  /** 分组标题 */
  title: string;
  /** 分组副标题 */
  subtitle?: string;
  /** 是否显示分组头 */
  showHeader: boolean;
  /** 排序值 */
  order: number;
  /** 设置项列表 */
  items: SettingsItemResponse[];
}

interface SettingsItemResponse {
  /** 设置项 ID */
  id: string;
  /** 设置项标题 */
  title: string;
  /** 设置项副标题 */
  subtitle?: string;
  /** 图标 */
  icon: string;
  /** 类型 */
  type: number;
  /** 跳转地址 */
  destination: string;
  /** 是否需要登录 */
  requireAuth: boolean;
  /** 是否需要确认 */
  needConfirm: boolean;
  /** 确认对话框标题 */
  confirmTitle?: string;
  /** 确认对话框内容 */
  confirmMessage?: string;
  /** 确认按钮文字 */
  confirmButtonText?: string;
  /** 是否显示红点 */
  showBadge: boolean;
  /** 红点文字 */
  badgeText?: string;
  /** 是否启用 */
  enabled: boolean;
  /** 排序值 */
  order: number;
}
```

#### 错误码

| 错误码 | 说明       | 处理建议         |
| ------ | ---------- | ---------------- |
| B00000 | 成功       | -                |
| B00001 | 通用错误   | 使用本地默认配置 |
| B00050 | 服务器错误 | 使用本地默认配置 |

---

## 3. 客户端 API 调用封装

### 3.1 SettingsApi 服务类

```typescript
/**
 * 设置中心 API 服务
 */
class SettingsApi {
  /**
   * 获取用户信息
   */
  static async getUserProfile(): Promise<UserProfileResponse> {
    const response = await HttpClient.get<UserProfileResponse>(
      "/api/v1/user/profile",
      null,
      { needAuth: true },
    );
    return response.data;
  }

  /**
   * 退出登录
   */
  static async logout(deviceId: string, reason?: string): Promise<void> {
    await HttpClient.post<void>(
      "/api/v1/auth/logout",
      { deviceId, reason },
      { needAuth: true },
    );
  }

  /**
   * 注销账号
   */
  static async cancelAccount(
    userId: string,
    reason: string,
    verificationCode?: string,
  ): Promise<CancelAccountResponse> {
    const response = await HttpClient.post<CancelAccountResponse>(
      "/api/v1/auth/cancel",
      { userId, reason, verificationCode, confirmed: true },
      { needAuth: true },
    );
    return response.data;
  }

  /**
   * 获取协议列表
   */
  static async getProtocols(): Promise<ProtocolInfo[]> {
    const response = await HttpClient.get<ProtocolListResponse>(
      "/api/v1/settings/protocols",
      { platform: "harmonyos", appVersion: AppInfo.versionName },
    );
    return response.data.protocols;
  }

  /**
   * 获取设置配置
   */
  static async getSettingsConfig(
    userId?: string,
  ): Promise<SettingsConfigResponse> {
    const response = await HttpClient.get<SettingsConfigResponse>(
      "/api/v1/settings/config",
      {
        platform: "harmonyos",
        appVersion: AppInfo.versionName,
        locale: "zh-CN",
        userId: userId ?? "",
      },
    );
    return response.data;
  }
}
```

---

## 4. 错误处理

### 4.1 统一错误处理

```typescript
/**
 * 设置中心错误处理
 */
async function handleSettingsError(error: ApiError): Promise<void> {
  switch (error.code) {
    case "B00002": // 未授权
      await clearUserData();
      router.replaceUrl({ url: "pages/login/Login" });
      showToast("登录已过期，请重新登录");
      break;

    case "B00020": // 业务错误 (如账号已在注销中)
      showToast(error.message);
      break;

    case "B00050": // 服务器错误
      showToast("服务器繁忙，请稍后重试");
      break;

    default:
      showToast(error.message || "操作失败");
  }
}
```

### 4.2 错误码汇总

| 错误码 | 接口     | 说明       | 处理建议               |
| ------ | -------- | ---------- | ---------------------- |
| B00000 | 全部     | 成功       | -                      |
| B00002 | 全部     | 未授权     | 清除 Token，跳转登录页 |
| B00010 | 注销账号 | 参数错误   | 提示具体错误信息       |
| B00020 | 注销账号 | 业务错误   | 提示具体业务错误       |
| B00021 | 注销账号 | 重复操作   | 提示操作过于频繁       |
| B00050 | 全部     | 服务器错误 | 提示稍后重试           |

---

## 附录

### A. 接口调用时序图

```
用户点击退出登录
       │
       ▼
┌──────────────────────┐
│ SettingsViewModel    │
│ - handleLogout()     │
└──────────────────────┘
       │
       ▼
┌──────────────────────┐
│ SettingsApi          │
│ - logout()           │
└──────────────────────┘
       │
       ▼
┌──────────────────────┐
│ HttpClient           │
│ - POST /logout       │
└──────────────────────┘
       │
       ▼
┌──────────────────────┐
│ Server               │
│ - Invalidate Token   │
└──────────────────────┘
       │
       ▼
┌──────────────────────┐
│ SettingsViewModel    │
│ - Clear Local Data   │
│ - Navigate to Login  │
└──────────────────────┘
```

### B. 变更日志

| 版本 | 日期       | 作者             | 变更说明 |
| ---- | ---------- | ---------------- | -------- |
| v1.0 | 2026-03-25 | mobile-architect | 初始版本 |
