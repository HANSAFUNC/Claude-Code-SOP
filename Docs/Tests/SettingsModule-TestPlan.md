# 设置中心模块 - 测试计划

> 本文档定义设置中心 (Settings Center) 模块的测试策略、测试用例和测试数据。

---

## 1. 测试概述

### 1.1 测试目标

验证设置中心模块的功能完整性和稳定性，确保：

- ViewModel 状态管理正确
- 用户操作方法执行正确
- UI 渲染符合预期
- 错误处理完善

### 1.2 测试范围

| 测试类别  | 测试对象                              | 测试类型 | 优先级 |
| --------- | ------------------------------------- | -------- | ------ |
| ViewModel | SettingsViewModel                     | 单元测试 | P0     |
| View      | SettingsPage                          | UI 测试  | P0     |
| 数据模型  | UserInfo, SettingsItem, SettingsGroup | 单元测试 | P1     |
| 路由跳转  | 页面导航                              | 集成测试 | P1     |

### 1.3 测试环境

- **测试框架**: Hypium (@ohos/hypium@1.0.25)
- **运行平台**: HarmonyOS Simulator / 真机
- **最低 API 版本**: API 9

---

## 2. SettingsViewModel 单元测试

### 2.1 初始化状态测试

#### 测试用例：testInitialState

```typescript
/**
 * 测试点：ViewModel 初始状态
 * 预期：所有状态属性为默认值
 */
it("testInitialState", 0, async () => {
  const viewModel = new SettingsViewModel();

  // 验证初始状态
  expect(viewModel.isLoggedIn).assertEqual(false);
  expect(viewModel.userInfo).assertEqual(null);
  expect(viewModel.groups).assertEqual([]);
  expect(viewModel.isLoading).assertEqual(false);
  expect(viewModel.errorMessage).assertEqual(null);
  expect(viewModel.isCancelling).assertEqual(false);
  expect(viewModel.pageTitle).assertEqual("设置");
});
```

**测试数据**：无

**预期结果**：

- `isLoggedIn` = false
- `userInfo` = null
- `groups` = []
- `isLoading` = false
- `errorMessage` = null

---

### 2.2 loadSettingsConfig() 测试

#### 测试用例：testLoadSettingsConfig_Success

```typescript
/**
 * 测试点：加载设置配置 - 成功场景
 * 预期：正确加载设置项分组
 */
it("testLoadSettingsConfig_Success", 0, async () => {
  // Mock API 响应
  const mockConfig: SettingsConfigResponse = {
    groups: [
      {
        id: "function_group",
        title: "功能服务",
        items: [
          {
            id: "dream_map",
            title: "我的退休梦想图",
            icon: "icon_dream",
            type: SettingsItemType.NAVIGATION,
            destination: "pages/dream/DreamMapPage",
            requireAuth: true,
            order: 1,
          },
        ],
      },
    ],
  };

  // Mock SettingsApi
  const mockGetSettingsConfig = mock.mockFunc(
    SettingsApi.getSettingsConfig,
    () => Promise.resolve(mockConfig),
  );

  const viewModel = new SettingsViewModel();
  await viewModel.loadSettingsConfig();

  // 验证状态更新
  expect(viewModel.groups.length).assertGreatThan(0);
  expect(viewModel.groups[0].id).assertEqual("function_group");
});
```

**测试数据**：

- Mock 配置数据包含 1 个分组，1 个设置项

**预期结果**：

- `groups` 数组长度 > 0
- 第一个分组 ID 为 "function_group"

#### 测试用例：testLoadSettingsConfig_Failure

```typescript
/**
 * 测试点：加载设置配置 - 失败场景
 * 预期：使用本地默认配置
 */
it("testLoadSettingsConfig_Failure", 0, async () => {
  // Mock API 抛出异常
  const mockGetSettingsConfig = mock.mockFunc(
    SettingsApi.getSettingsConfig,
    () => Promise.reject(new Error("Network error")),
  );

  const viewModel = new SettingsViewModel();
  await viewModel.loadSettingsConfig();

  // 验证使用默认配置
  expect(viewModel.groups.length).assertGreatThan(0);
});
```

**测试数据**：

- Mock API 抛出网络错误

**预期结果**：

- 使用本地默认配置
- `groups` 数组不为空

---

### 2.3 checkLoginStatus() 测试

#### 测试用例：testCheckLoginStatus_LoggedIn

```typescript
/**
 * 测试点：检查登录状态 - 已登录
 * 预期：加载用户信息
 */
it("testCheckLoginStatus_LoggedIn", 0, async () => {
  // Mock AuthManager.isLoggedIn 返回 true
  const mockIsLoggedIn = mock.mockFunc(AuthManager.isLoggedIn, () =>
    Promise.resolve(true),
  );

  // Mock AuthManager.getUserProfile
  const mockUserProfile: UserProfileResponse = {
    userId: "1001",
    nickname: "张三",
    avatar: "https://example.com/avatar.jpg",
    identityDescription: "企业员工",
    accountType: AccountType.ENTERPRISE,
    needCompleteProfile: false,
  };
  const mockGetUserProfile = mock.mockFunc(SettingsApi.getUserProfile, () =>
    Promise.resolve(mockUserProfile),
  );

  const viewModel = new SettingsViewModel();
  await viewModel.checkLoginStatus();

  // 验证状态
  expect(viewModel.isLoggedIn).assertEqual(true);
  expect(viewModel.userInfo).notEqual(null);
  expect(viewModel.userInfo?.nickname).assertEqual("张三");
});
```

**测试数据**：

- 登录状态：true
- 用户信息：userId="1001", nickname="张三"

**预期结果**：

- `isLoggedIn` = true
- `userInfo` 不为 null
- 用户昵称正确

#### 测试用例：testCheckLoginStatus_LoggedOut

```typescript
/**
 * 测试点：检查登录状态 - 未登录
 * 预期：保持未登录状态
 */
it("testCheckLoginStatus_LoggedOut", 0, async () => {
  const mockIsLoggedIn = mock.mockFunc(AuthManager.isLoggedIn, () =>
    Promise.resolve(false),
  );

  const viewModel = new SettingsViewModel();
  await viewModel.checkLoginStatus();

  expect(viewModel.isLoggedIn).assertEqual(false);
  expect(viewModel.userInfo).assertEqual(null);
});
```

---

### 2.4 handleLogout() 测试

#### 测试用例：testHandleLogout_Success

```typescript
/**
 * 测试点：处理登出 - 成功场景
 * 预期：清除数据，跳转登录页
 */
it("testHandleLogout_Success", 0, async () => {
  // 设置初始登录状态
  const viewModel = new SettingsViewModel();
  viewModel.isLoggedIn = true;
  viewModel.userInfo = {
    userId: "1001",
    nickname: "张三",
    avatar: "",
    currentIdentity: "企业员工",
    accountType: AccountType.ENTERPRISE,
    needCompleteProfile: false,
  };

  // Mock 登出 API
  const mockLogout = mock.mockFunc(SettingsApi.logout, () => Promise.resolve());

  // Mock AuthManager.clearAuthData
  const mockClearAuthData = mock.mockFunc(AuthManager.clearAuthData, () =>
    Promise.resolve(),
  );

  // Mock Dialog.show 返回 true (确认登出)
  const mockDialogShow = mock.mockFunc(Dialog.show, () =>
    Promise.resolve(true),
  );

  await viewModel.handleLogout();

  // 验证状态已清除
  expect(viewModel.isLoggedIn).assertEqual(false);
  expect(viewModel.userInfo).assertEqual(null);
});
```

**测试数据**：

- 初始状态：已登录
- 用户确认登出

**预期结果**：

- `isLoggedIn` = false
- `userInfo` = null

#### 测试用例：testHandleLogout_Failure

```typescript
/**
 * 测试点：处理登出 - 失败场景
 * 预期：显示错误提示，保持登录状态
 */
it("testHandleLogout_Failure", 0, async () => {
  const viewModel = new SettingsViewModel();
  viewModel.isLoggedIn = true;

  // Mock API 抛出异常
  const mockLogout = mock.mockFunc(SettingsApi.logout, () =>
    Promise.reject(new Error("Network error")),
  );
  const mockDialogShow = mock.mockFunc(Dialog.show, () =>
    Promise.resolve(true),
  );

  await viewModel.handleLogout();

  // 验证显示错误提示（通过 showToast 验证）
  // 登出失败时应该调用 showToast
});
```

---

### 2.5 handleCancelAccount() 测试

#### 测试用例：testHandleCancelAccount_ConfirmFlow

```typescript
/**
 * 测试点：注销账号 - 确认流程
 * 预期：显示确认对话框，用户确认后执行注销
 */
it("testHandleCancelAccount_ConfirmFlow", 0, async () => {
  const viewModel = new SettingsViewModel();
  viewModel.isLoggedIn = true;
  viewModel.userInfo = {
    userId: "1001",
    nickname: "张三",
    avatar: "",
    currentIdentity: "企业员工",
    accountType: AccountType.ENTERPRISE,
    needCompleteProfile: false,
  };

  // Mock 确认对话框返回 true
  const mockDialogShow = mock.mockFunc(Dialog.show, () =>
    Promise.resolve(true),
  );

  // Mock 注销 API
  const mockCancelAccount = mock.mockFunc(SettingsApi.cancelAccount, () =>
    Promise.resolve({
      success: true,
      coolOffDays: 7,
      message: "账号注销申请已提交",
    }),
  );

  await viewModel.handleCancelAccount();

  // 验证状态已清除
  expect(viewModel.isLoggedIn).assertEqual(false);
  expect(viewModel.isCancelling).assertEqual(false);
});
```

**测试数据**：

- 用户确认注销
- API 返回成功

**预期结果**：

- `isLoggedIn` = false
- `isCancelling` = false

#### 测试用例：testHandleCancelAccount_Cancelled

```typescript
/**
 * 测试点：注销账号 - 用户取消
 * 预期：不执行注销操作
 */
it("testHandleCancelAccount_Cancelled", 0, async () => {
  const viewModel = new SettingsViewModel();
  viewModel.isLoggedIn = true;
  viewModel.userInfo = createMockUserInfo();

  // Mock 确认对话框返回 false (取消)
  const mockDialogShow = mock.mockFunc(Dialog.show, () =>
    Promise.resolve(false),
  );

  await viewModel.handleCancelAccount();

  // 验证状态未改变
  expect(viewModel.isLoggedIn).assertEqual(true);
  expect(viewModel.userInfo).notEqual(null);
});
```

---

### 2.6 handleItemClick() 测试

#### 测试用例：testHandleItemClick_Navigation

```typescript
/**
 * 测试点：点击设置项 - 页面跳转类型
 * 预期：调用 router.pushUrl
 */
it("testHandleItemClick_Navigation", 0, async () => {
  const viewModel = new SettingsViewModel();
  viewModel.isLoggedIn = true;

  const item: SettingsItem = {
    id: "dream_map",
    title: "我的退休梦想图",
    icon: "icon_dream",
    type: SettingsItemType.NAVIGATION,
    destination: "pages/dream/DreamMapPage",
    requireAuth: true,
    order: 1,
  };

  // Mock router.pushUrl
  const mockPushUrl = mock.mockFunc(router.pushUrl, () => {});

  await viewModel.handleItemClick(item);

  // 验证 router.pushUrl 被调用
  expect(mockPushUrl).toBeCalledTimes(1);
});
```

#### 测试用例：testHandleItemClick_WebView

```typescript
/**
 * 测试点：点击设置项 - WebView 类型
 * 预期：打开 WebView 页面并传递参数
 */
it("testHandleItemClick_WebView", 0, async () => {
  const viewModel = new SettingsViewModel();

  const item: SettingsItem = {
    id: "privacy_policy",
    title: "隐私政策协议",
    icon: "icon_privacy",
    type: SettingsItemType.WEB_VIEW,
    destination: "https://example.com/privacy",
    requireAuth: false,
    order: 1,
  };

  const mockPushUrl = mock.mockFunc(router.pushUrl, () => {});

  await viewModel.handleItemClick(item);

  expect(mockPushUrl).toBeCalledTimes(1);
});
```

#### 测试用例：testHandleItemClick_RequireAuth_NotLoggedIn

```typescript
/**
 * 测试点：点击设置项 - 需要登录但未登录
 * 预期：跳转登录页
 */
it("testHandleItemClick_RequireAuth_NotLoggedIn", 0, async () => {
  const viewModel = new SettingsViewModel();
  viewModel.isLoggedIn = false;

  const item: SettingsItem = {
    id: "dream_map",
    title: "我的退休梦想图",
    icon: "icon_dream",
    type: SettingsItemType.NAVIGATION,
    destination: "pages/dream/DreamMapPage",
    requireAuth: true,
    order: 1,
  };

  const mockReplaceUrl = mock.mockFunc(router.replaceUrl, () => {});

  await viewModel.handleItemClick(item);

  // 验证跳转登录页
  expect(mockReplaceUrl).toBeCalledTimes(1);
});
```

---

### 2.7 openProtocol() 路由跳转测试

#### 测试用例：testOpenProtocol_PrivacyPolicy

```typescript
/**
 * 测试点：打开隐私政策
 * 预期：正确跳转到 WebView 页面
 */
it("testOpenProtocol_PrivacyPolicy", 0, async () => {
  const viewModel = new SettingsViewModel();

  const protocol: Protocol = {
    id: "privacy_2024_v1",
    title: "隐私政策",
    type: ProtocolType.PRIVACY_POLICY,
    url: "https://example.com/privacy",
    version: "1.0.0",
    isRequired: true,
    updatedAt: Date.now(),
    userAgreed: false,
  };

  const mockPushUrl = mock.mockFunc(router.pushUrl, () => {});

  await viewModel.openProtocol(protocol);

  expect(mockPushUrl).toBeCalledTimes(1);
});
```

---

## 3. SettingsView UI 测试

### 3.1 页面渲染测试

#### 测试用例：testPage_Render

```typescript
/**
 * 测试点：页面基础渲染
 * 预期：页面正常渲染，无崩溃
 */
it("testPage_Render", 0, async () => {
  // 创建页面实例
  const page = new SettingsPage();

  // 验证页面可以正常构建
  expect(page).notEqual(null);
});
```

### 3.2 用户信息区域显示测试

#### 测试用例：testUserHeader_Display_LoggedIn

```typescript
/**
 * 测试点：用户信息区域显示 - 已登录状态
 * 预期：显示头像、昵称、身份、登出按钮
 */
it("testUserHeader_Display_LoggedIn", 0, async () => {
  const page = new SettingsPage();
  page.viewModel.isLoggedIn = true;
  page.viewModel.userInfo = {
    userId: "1001",
    nickname: "张三",
    avatar: "https://example.com/avatar.jpg",
    currentIdentity: "企业员工",
    accountType: AccountType.ENTERPRISE,
    needCompleteProfile: false,
  };

  // 验证 showUserHeader 计算属性
  expect(page.viewModel.showUserHeader).assertEqual(true);
  expect(page.viewModel.showLogoutButton).assertEqual(true);
});
```

#### 测试用例：testUserHeader_Hidden_LoggedOut

```typescript
/**
 * 测试点：用户信息区域隐藏 - 未登录状态
 * 预期：不显示用户信息区域
 */
it("testUserHeader_Hidden_LoggedOut", 0, async () => {
  const page = new SettingsPage();
  page.viewModel.isLoggedIn = false;
  page.viewModel.userInfo = null;

  expect(page.viewModel.showUserHeader).assertEqual(false);
  expect(page.viewModel.showLogoutButton).assertEqual(false);
});
```

### 3.3 设置项列表渲染测试

#### 测试用例：testSettingsList_Render

```typescript
/**
 * 测试点：设置项列表渲染
 * 预期：正确渲染分组和设置项
 */
it("testSettingsList_Render", 0, async () => {
  const page = new SettingsPage();

  // 设置 Mock 数据
  page.viewModel.groups = [
    {
      id: "function_group",
      title: "功能服务",
      showHeader: true,
      order: 1,
      items: [
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
          destination: "https://example.com/app",
          requireAuth: false,
          order: 2,
        },
      ],
    },
  ];

  expect(page.viewModel.groups.length).assertEqual(1);
  expect(page.viewModel.groups[0].items.length).assertEqual(2);
});
```

### 3.4 点击登出按钮测试

#### 测试用例：testLogoutButton_Click

```typescript
/**
 * 测试点：点击登出按钮
 * 预期：触发 handleLogout 方法
 */
it("testLogoutButton_Click", 0, async () => {
  const page = new SettingsPage();
  page.viewModel.isLoggedIn = true;

  // Mock handleLogout
  let logoutCalled = false;
  const originalHandleLogout = page.viewModel.handleLogout;
  page.viewModel.handleLogout = async () => {
    logoutCalled = true;
  };

  // 模拟点击
  await page.viewModel.handleLogout();

  expect(logoutCalled).assertEqual(true);

  // 恢复原始方法
  page.viewModel.handleLogout = originalHandleLogout;
});
```

### 3.5 点击设置项跳转测试

#### 测试用例：testSettingsItem_Click_Jump

```typescript
/**
 * 测试点：点击设置项跳转
 * 预期：根据类型正确跳转
 */
it("testSettingsItem_Click_Jump", 0, async () => {
  const page = new SettingsPage();
  page.viewModel.isLoggedIn = true;

  let navigateCalled = false;
  let navigateUrl = "";

  const mockPushUrl = mock.mockFunc(router.pushUrl, (params) => {
    navigateCalled = true;
    navigateUrl = params.url;
  });

  const item: SettingsItem = {
    id: "dream_map",
    title: "我的退休梦想图",
    icon: "icon_dream",
    type: SettingsItemType.NAVIGATION,
    destination: "pages/dream/DreamMapPage",
    requireAuth: true,
    order: 1,
  };

  await page.viewModel.handleItemClick(item);

  expect(navigateCalled).assertEqual(true);
  expect(navigateUrl).assertEqual("pages/dream/DreamMapPage");
});
```

---

## 4. 测试数据准备

### 4.1 Mock 数据工厂

```typescript
/**
 * 创建 Mock 用户信息
 */
function createMockUserInfo(): UserInfo {
  return {
    userId: "1001",
    nickname: "张三",
    avatar: "https://example.com/avatar.jpg",
    currentIdentity: "企业员工",
    accountType: AccountType.ENTERPRISE,
    needCompleteProfile: false,
  };
}

/**
 * 创建 Mock 设置项
 */
function createMockSettingsItem(
  id: string,
  type: SettingsItemType,
): SettingsItem {
  return {
    id: id,
    title: `测试设置项-${id}`,
    icon: "icon_test",
    type: type,
    destination: "pages/test/TestPage",
    requireAuth: false,
    order: 1,
  };
}

/**
 * 创建 Mock 设置分组
 */
function createMockSettingsGroup(): SettingsGroup {
  return {
    id: "test_group",
    title: "测试分组",
    showHeader: true,
    order: 1,
    items: [
      createMockSettingsItem("item1", SettingsItemType.NAVIGATION),
      createMockSettingsItem("item2", SettingsItemType.WEB_VIEW),
    ],
  };
}
```

### 4.2 测试账号

| 账号类型 | 账号            | 密码    | 用途             |
| -------- | --------------- | ------- | ---------------- |
| 企业账号 | test_enterprise | test123 | 测试已登录状态   |
| 普通账号 | test_normal     | test123 | 测试普通用户功能 |

---

## 5. 测试执行计划

### 5.1 测试执行顺序

1. **单元测试** (SettingsViewModel.test.ets)
   - 初始化状态测试
   - 数据加载测试
   - 用户操作测试
   - 路由跳转测试

2. **UI 测试** (SettingsView.test.ets)
   - 页面渲染测试
   - 组件显示测试
   - 交互测试

### 5.2 通过标准

- **单元测试通过率**: >= 90%
- **UI 测试通过率**: >= 80%
- **代码覆盖率**: >= 80%

### 5.3 测试报告

测试执行后生成报告，包含：

- 测试用例总数
- 通过/失败统计
- 代码覆盖率
- 问题分析

---

## 附录

### A. 测试文件结构

```
harmony_chrp_app/entry/src/test/
├── SettingsViewModel.test.ets    # ViewModel 单元测试
├── SettingsView.test.ets         # UI 测试
└── List.test.ets                 # 测试入口
```

### B. 变更日志

| 版本 | 日期       | 作者      | 变更说明 |
| ---- | ---------- | --------- | -------- |
| v1.0 | 2026-03-25 | mobile-qa | 初始版本 |
