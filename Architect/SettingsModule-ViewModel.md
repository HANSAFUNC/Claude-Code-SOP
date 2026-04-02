# 设置中心模块 - ViewModel 设计

> 本文档定义设置中心 (Settings Center) 的 ViewModel 设计，包括状态管理、动作定义、页面逻辑等。

---

## 1. ViewModel 概述

设置中心模块采用 MVVM 架构模式，`SettingsViewModel` 负责页面的状态管理和业务逻辑。

### 1.1 职责划分

| 层级       | 职责                         | 文件                     |
| ---------- | ---------------------------- | ------------------------ |
| View       | 页面 UI 展示、用户交互       | `SettingsPage.ets`       |
| ViewModel  | 状态管理、业务逻辑、数据转换 | `SettingsViewModel.ets`  |
| Repository | 数据获取、API 调用           | `SettingsRepository.ets` |

### 1.2 架构图

```
┌─────────────────────────────────────────────────────────┐
│                    SettingsPage (View)                   │
│  ┌─────────────────────────────────────────────────┐    │
│  │  UserHeaderView  - 用户信息展示                   │    │
│  │  SettingsListView - 设置项列表                   │    │
│  │  FooterView        - 版本信息                    │    │
│  └─────────────────────────────────────────────────┘    │
│                         │ @Link                          │
│                         ▼                                │
│  ┌─────────────────────────────────────────────────┐    │
│  │              SettingsViewModel                   │    │
│  │  @State: userInfo, settingsItems, isLoading     │    │
│  │  @Action: load(), handleLogout(), handleJump()  │    │
│  └─────────────────────────────────────────────────┘    │
│                         │                                │
│                         ▼                                │
│  ┌─────────────────────────────────────────────────┐    │
│  │              SettingsRepository                  │    │
│  │  getUserProfile(), logout(), getProtocols()     │    │
│  └─────────────────────────────────────────────────┘    │
│                         │                                │
│                         ▼                                │
│  ┌─────────────────────────────────────────────────┐    │
│  │                   HttpClient                     │    │
│  └─────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

---

## 2. SettingsViewModel 设计

### 2.1 完整定义

```typescript
/**
 * 设置中心 ViewModel
 * 描述：管理设置页面的状态和业务逻辑
 */
@Observed
class SettingsViewModel {
  // ==================== 状态属性 (@State) ====================

  /** 是否已登录 */
  @State isLoggedIn: boolean = false;

  /** 用户信息 */
  @State userInfo: UserInfo | null = null;

  /** 设置项分组列表 */
  @State groups: SettingsGroup[] = [];

  /** 应用版本信息 */
  @State appVersion: AppVersionInfo = new AppVersionInfo();

  /** 是否正在加载 */
  @State isLoading: boolean = false;

  /** 错误信息 */
  @State errorMessage: string | null = null;

  /** 是否显示刷新动画 */
  @State isRefreshing: boolean = false;

  /** 注销账号处理中 */
  @State isCancelling: boolean = false;

  // ==================== 只读属性 ====================

  /** 页面标题 */
  readonly pageTitle: string = "设置";

  /** 是否显示用户信息区域 */
  get showUserHeader(): boolean {
    return this.isLoggedIn && this.userInfo !== null;
  }

  /** 是否显示登出按钮 */
  get showLogoutButton(): boolean {
    return this.isLoggedIn;
  }

  /** 版本号显示文本 */
  get versionDisplayText(): string {
    return `${this.appVersion.appName} v${this.appVersion.versionName}`;
  }

  // ==================== 生命周期方法 ====================

  /**
   * 初始化 ViewModel
   */
  async init(): Promise<void> {
    console.info("[SettingsViewModel] init");
    await this.loadSettingsConfig();
    await this.checkLoginStatus();
  }

  /**
   * 页面销毁时的清理工作
   */
  dispose(): void {
    console.info("[SettingsViewModel] dispose");
    // 清理订阅、定时器等
  }

  // ==================== 数据加载方法 ====================

  /**
   * 加载设置配置
   */
  async loadSettingsConfig(): Promise<void> {
    this.isLoading = true;
    this.errorMessage = null;

    try {
      // 从 API 获取配置，失败时使用本地默认配置
      const config = await SettingsApi.getSettingsConfig(this.userInfo?.userId);
      this.groups = config.groups;
      this.appVersion.externalLinks = config.externalLinks;
    } catch (error) {
      console.error("[SettingsViewModel] loadSettingsConfig error:", error);
      // 使用本地默认配置
      this.groups = this.getDefaultGroups();
    } finally {
      this.isLoading = false;
    }
  }

  /**
   * 检查登录状态
   */
  async checkLoginStatus(): Promise<void> {
    try {
      const isLoggedIn = await AuthManager.isLoggedIn();
      this.isLoggedIn = isLoggedIn;

      if (isLoggedIn) {
        await this.loadUserInfo();
      }
    } catch (error) {
      console.error("[SettingsViewModel] checkLoginStatus error:", error);
      this.isLoggedIn = false;
    }
  }

  /**
   * 加载用户信息
   */
  async loadUserInfo(): Promise<void> {
    try {
      const userProfile = await SettingsApi.getUserProfile();
      this.userInfo = {
        userId: userProfile.userId,
        nickname: userProfile.nickname,
        avatar: userProfile.avatar,
        currentIdentity: userProfile.identityDescription,
        accountType: userProfile.accountType,
        needCompleteProfile: userProfile.needCompleteProfile,
      };
    } catch (error) {
      console.error("[SettingsViewModel] loadUserInfo error:", error);
      // 加载失败时设置未登录状态
      this.isLoggedIn = false;
      this.userInfo = null;
    }
  }

  /**
   * 下拉刷新
   */
  async onRefresh(): Promise<void> {
    this.isRefreshing = true;
    try {
      await Promise.all([this.loadUserInfo(), this.loadSettingsConfig()]);
    } finally {
      this.isRefreshing = false;
    }
  }

  // ==================== 用户操作方法 ====================

  /**
   * 处理设置项点击
   * @param item 被点击的设置项
   */
  async handleItemClick(item: SettingsItem): Promise<void> {
    // 检查是否需要登录
    if (item.requireAuth && !this.isLoggedIn) {
      this.navigateToLogin();
      return;
    }

    // 检查是否启用
    if (!item.enabled) {
      showToast("该功能暂未开放");
      return;
    }

    // 根据类型处理
    switch (item.type) {
      case SettingsItemType.NAVIGATION:
        this.navigateToPage(item.destination);
        break;

      case SettingsItemType.WEB_VIEW:
        this.openWebView(item.title, item.destination);
        break;

      case SettingsItemType.EXTERNAL_LINK:
        this.openExternalLink(item.destination);
        break;

      case SettingsItemType.CONFIRM_ACTION:
        await this.showConfirmDialog(item);
        break;

      case SettingsItemType.TOGGLE:
        // TODO: 处理开关切换
        break;

      default:
        console.warn("[SettingsViewModel] unknown item type:", item.type);
    }
  }

  /**
   * 处理登出
   */
  async handleLogout(): Promise<void> {
    // 显示确认对话框
    const confirmed = await this.showLogoutConfirm();
    if (!confirmed) {
      return;
    }

    this.isLoading = true;
    try {
      const deviceId = await DeviceManager.getDeviceId();
      await SettingsApi.logout(deviceId, "user_logout");

      // 清除本地数据
      await AuthManager.clearAuthData();

      // 更新状态
      this.isLoggedIn = false;
      this.userInfo = null;

      showToast("已退出登录");

      // 跳转登录页
      this.navigateToLogin();
    } catch (error) {
      console.error("[SettingsViewModel] handleLogout error:", error);
      showToast("退出失败，请重试");
    } finally {
      this.isLoading = false;
    }
  }

  /**
   * 处理注销账号
   */
  async handleCancelAccount(): Promise<void> {
    if (this.isCancelling) {
      return;
    }

    // 显示确认对话框
    const confirmed = await this.showCancelAccountConfirm();
    if (!confirmed) {
      return;
    }

    this.isCancelling = true;
    try {
      // 可能需要短信验证码
      const needSmsCode = await this.checkNeedSmsCode();

      let verificationCode: string | undefined;
      if (needSmsCode) {
        verificationCode = await this.showSmsCodeDialog();
        if (!verificationCode) {
          return;
        }
      }

      // 调用注销接口
      const response = await SettingsApi.cancelAccount(
        this.userInfo?.userId ?? "",
        "个人原因，不再使用",
        verificationCode,
      );

      // 显示结果提示
      showToast(response.message);

      // 清除本地数据
      await AuthManager.clearAuthData();

      // 更新状态
      this.isLoggedIn = false;
      this.userInfo = null;

      // 跳转登录页
      this.navigateToLogin();
    } catch (error) {
      console.error("[SettingsViewModel] handleCancelAccount error:", error);
      showToast(error.message || "注销失败，请重试");
    } finally {
      this.isCancelling = false;
    }
  }

  // ==================== 私有辅助方法 ====================

  /**
   * 获取默认设置项分组
   */
  private getDefaultGroups(): SettingsGroup[] {
    return [
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
            destination: "https://app.ida1998.com/download",
            requireAuth: false,
            order: 2,
          },
        ],
      },
      {
        id: "agreement_group",
        title: "协议与条款",
        showHeader: true,
        order: 2,
        items: [
          {
            id: "privacy_policy",
            title: "隐私政策协议",
            icon: "icon_privacy",
            type: SettingsItemType.WEB_VIEW,
            destination: "https://crm.ida1998.com/protocols/privacy.html",
            requireAuth: false,
            order: 1,
          },
          {
            id: "user_agreement",
            title: "用户协议",
            icon: "icon_agreement",
            type: SettingsItemType.WEB_VIEW,
            destination: "https://crm.ida1998.com/protocols/terms.html",
            requireAuth: false,
            order: 2,
          },
        ],
      },
      {
        id: "account_group",
        title: "账号安全",
        showHeader: true,
        order: 3,
        items: [
          {
            id: "cancel_account",
            title: "注销账号",
            icon: "icon_delete",
            type: SettingsItemType.CONFIRM_ACTION,
            destination: "/api/v1/auth/cancel",
            requireAuth: true,
            needConfirm: true,
            confirmTitle: "确认注销账号？",
            confirmMessage:
              "注销后您的账号信息将被永久删除，且无法恢复。请谨慎操作！",
            confirmButtonText: "确认注销",
            order: 1,
          },
        ],
      },
    ];
  }

  /**
   * 显示登出确认对话框
   */
  private async showLogoutConfirm(): Promise<boolean> {
    return await Dialog.show({
      title: "确认退出登录？",
      message: "退出后需要重新登录才能继续使用",
      cancelButton: "取消",
      confirmButton: "确认退出",
    });
  }

  /**
   * 显示注销账号确认对话框
   */
  private async showCancelAccountConfirm(): Promise<boolean> {
    return await Dialog.show({
      title: "警告：确认注销账号？",
      message:
        "注销后您的账号信息将被永久删除，且无法恢复。此操作不可逆，请谨慎操作！",
      cancelButton: "我再想想",
      confirmButton: "确认注销",
      confirmStyle: "danger",
    });
  }

  /**
   * 检查是否需要短信验证码
   */
  private async checkNeedSmsCode(): Promise<boolean> {
    // 根据业务规则判断是否需要短信验证码
    // 可以调用 API 获取配置
    return false;
  }

  /**
   * 显示短信验证码输入对话框
   */
  private async showSmsCodeDialog(): Promise<string> {
    return await Dialog.showInput({
      title: "输入验证码",
      message: "请输入发送到手机的短信验证码",
      placeholder: "6 位数字验证码",
      keyboardType: "number",
      maxLength: 6,
    });
  }

  /**
   * 显示确认对话框 (通用)
   */
  private async showConfirmDialog(item: SettingsItem): Promise<void> {
    const confirmed = await Dialog.show({
      title: item.confirmTitle ?? "确认操作",
      message: item.confirmMessage ?? "确定要执行此操作吗？",
      cancelButton: "取消",
      confirmButton: item.confirmButtonText ?? "确认",
      confirmStyle: "danger",
    });

    if (confirmed && item.id === "cancel_account") {
      await this.handleCancelAccount();
    }
  }

  /**
   * 跳转到页面
   */
  private navigateToPage(url: string): void {
    router.pushUrl({ url });
  }

  /**
   * 打开 WebView
   */
  private openWebView(title: string, url: string): void {
    router.pushUrl({
      url: "pages/common/WebPage",
      params: { title, url },
    });
  }

  /**
   * 打开外部链接
   */
  private openExternalLink(url: string): void {
    // 使用系统浏览器打开
    pasteboard.setData(url);
    showToast("链接已复制，请在浏览器中打开");
    // 或者直接调用系统浏览器
    // ability.startAbility({ url });
  }

  /**
   * 跳转到登录页
   */
  private navigateToLogin(): void {
    router.replaceUrl({ url: "pages/login/Login" });
  }
}
```

---

## 3. @State 状态汇总

### 3.1 状态属性列表

| 属性名         | 类型               | 初始值                 | 说明           |
| -------------- | ------------------ | ---------------------- | -------------- |
| `isLoggedIn`   | `boolean`          | `false`                | 是否已登录     |
| `userInfo`     | `UserInfo \| null` | `null`                 | 用户信息       |
| `groups`       | `SettingsGroup[]`  | `[]`                   | 设置项分组列表 |
| `appVersion`   | `AppVersionInfo`   | `new AppVersionInfo()` | 应用版本信息   |
| `isLoading`    | `boolean`          | `false`                | 是否正在加载   |
| `errorMessage` | `string \| null`   | `null`                 | 错误信息       |
| `isRefreshing` | `boolean`          | `false`                | 是否正在刷新   |
| `isCancelling` | `boolean`          | `false`                | 注销账号处理中 |

### 3.2 计算属性 (Getters)

| 属性名               | 返回类型  | 说明                 |
| -------------------- | --------- | -------------------- |
| `showUserHeader`     | `boolean` | 是否显示用户信息区域 |
| `showLogoutButton`   | `boolean` | 是否显示登出按钮     |
| `versionDisplayText` | `string`  | 版本号显示文本       |

---

## 4. 方法汇总

### 4.1 生命周期方法

| 方法名      | 返回值          | 说明             |
| ----------- | --------------- | ---------------- |
| `init()`    | `Promise<void>` | 初始化 ViewModel |
| `dispose()` | `void`          | 页面销毁时清理   |

### 4.2 数据加载方法

| 方法名                 | 返回值          | 说明         |
| ---------------------- | --------------- | ------------ |
| `loadSettingsConfig()` | `Promise<void>` | 加载设置配置 |
| `checkLoginStatus()`   | `Promise<void>` | 检查登录状态 |
| `loadUserInfo()`       | `Promise<void>` | 加载用户信息 |
| `onRefresh()`          | `Promise<void>` | 下拉刷新     |

### 4.3 用户操作方法

| 方法名                  | 参数                 | 返回值          | 说明           |
| ----------------------- | -------------------- | --------------- | -------------- |
| `handleItemClick()`     | `item: SettingsItem` | `Promise<void>` | 处理设置项点击 |
| `handleLogout()`        | -                    | `Promise<void>` | 处理登出       |
| `handleCancelAccount()` | -                    | `Promise<void>` | 处理注销账号   |

### 4.4 私有辅助方法

| 方法名                       | 返回值                                 | 说明                     |
| ---------------------------- | -------------------------------------- | ------------------------ |
| `getDefaultGroups()`         | `SettingsGroup[]`                      | 获取默认设置项分组       |
| `showLogoutConfirm()`        | `Promise<boolean>`                     | 显示登出确认对话框       |
| `showCancelAccountConfirm()` | `Promise<boolean>`                     | 显示注销账号确认对话框   |
| `checkNeedSmsCode()`         | `Promise<boolean>`                     | 检查是否需要短信验证码   |
| `showSmsCodeDialog()`        | `Promise<string>`                      | 显示短信验证码输入对话框 |
| `showConfirmDialog()`        | `item: SettingsItem` → `Promise<void>` | 显示确认对话框           |
| `navigateToPage()`           | `url: string` → `void`                 | 跳转到页面               |
| `openWebView()`              | `title: string, url: string` → `void`  | 打开 WebView             |
| `openExternalLink()`         | `url: string` → `void`                 | 打开外部链接             |
| `navigateToLogin()`          | `void`                                 | 跳转到登录页             |

---

## 5. Repository 设计

### 5.1 SettingsRepository 接口

```typescript
/**
 * 设置中心数据仓库接口
 */
interface ISettingsRepository {
  /**
   * 获取用户信息
   */
  getUserProfile(): Promise<UserProfileResponse>;

  /**
   * 退出登录
   */
  logout(deviceId: string, reason?: string): Promise<void>;

  /**
   * 注销账号
   */
  cancelAccount(
    userId: string,
    reason: string,
    verificationCode?: string,
  ): Promise<CancelAccountResponse>;

  /**
   * 获取协议列表
   */
  getProtocols(): Promise<ProtocolInfo[]>;

  /**
   * 获取设置配置
   */
  getSettingsConfig(userId?: string): Promise<SettingsConfigResponse>;
}
```

### 5.2 SettingsRepository 实现

```typescript
/**
 * 设置中心数据仓库实现
 */
class SettingsRepositoryImpl implements ISettingsRepository {
  /**
   * 获取用户信息
   */
  async getUserProfile(): Promise<UserProfileResponse> {
    const response = await HttpClient.get<ApiResponse<UserProfileResponse>>(
      "/api/v1/user/profile",
      null,
      { needAuth: true },
    );

    if (response.code !== ResponseCode.SUCCESS) {
      throw new ApiError(response.code, response.message);
    }

    return response.data!;
  }

  /**
   * 退出登录
   */
  async logout(deviceId: string, reason?: string): Promise<void> {
    const response = await HttpClient.post<ApiResponse<void>>(
      "/api/v1/auth/logout",
      { deviceId, reason },
      { needAuth: true },
    );

    if (response.code !== ResponseCode.SUCCESS) {
      throw new ApiError(response.code, response.message);
    }
  }

  /**
   * 注销账号
   */
  async cancelAccount(
    userId: string,
    reason: string,
    verificationCode?: string,
  ): Promise<CancelAccountResponse> {
    const response = await HttpClient.post<ApiResponse<CancelAccountResponse>>(
      "/api/v1/auth/cancel",
      { userId, reason, verificationCode, confirmed: true },
      { needAuth: true },
    );

    if (response.code !== ResponseCode.SUCCESS) {
      throw new ApiError(response.code, response.message);
    }

    return response.data!;
  }

  /**
   * 获取协议列表
   */
  async getProtocols(): Promise<ProtocolInfo[]> {
    const response = await HttpClient.get<ApiResponse<ProtocolListResponse>>(
      "/api/v1/settings/protocols",
      { platform: "harmonyos", appVersion: AppInfo.versionName },
    );

    if (response.code !== ResponseCode.SUCCESS) {
      throw new ApiError(response.code, response.message);
    }

    return response.data!.protocols;
  }

  /**
   * 获取设置配置
   */
  async getSettingsConfig(userId?: string): Promise<SettingsConfigResponse> {
    const response = await HttpClient.get<ApiResponse<SettingsConfigResponse>>(
      "/api/v1/settings/config",
      {
        platform: "harmonyos",
        appVersion: AppInfo.versionName,
        locale: "zh-CN",
        userId: userId ?? "",
      },
    );

    if (response.code !== ResponseCode.SUCCESS) {
      throw new ApiError(response.code, response.message);
    }

    return response.data!;
  }
}
```

---

## 6. View 层使用示例

### 6.1 SettingsPage.ets

```typescript
import { SettingsViewModel } from "./viewmodel/SettingsViewModel";
import { SettingsItem } from "./models/SettingsItem";

@Entry
@Component
struct SettingsPage {
  @State viewModel: SettingsViewModel = new SettingsViewModel();

  aboutToAppear(): void {
    this.viewModel.init();
  }

  aboutToDisappear(): void {
    this.viewModel.dispose();
  }

  build() {
    Column() {
      // 导航栏
      this.buildNavBar()

      // 内容区域
      Scroll() {
        Column() {
          // 用户信息区域
          if (this.viewModel.showUserHeader) {
            this.buildUserHeader()
          }

          // 设置项列表
          this.buildSettingsList()

          // 底部版本信息
          this.buildFooter()
        }
        .width("100%")
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Auto)
      .onRefresh(() => {
        this.viewModel.onRefresh();
      })
    }
    .width("100%")
    .height("100%")
  }

  // 导航栏
  @Builder
  buildNavBar(): void {
    Row() {
      Text(this.viewModel.pageTitle)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
    .width("100%")
    .height(56)
    .padding({ left: 16, right: 16 })
    .justifyContent(FlexAlign.Center)
  }

  // 用户信息区域
  @Builder
  buildUserHeader(): void {
    Row() {
      // 头像
      Image(this.viewModel.userInfo?.avatar)
        .width(60)
        .height(60)
        .borderRadius(30)
        .objectFit(ImageFit.Cover)

      // 用户信息
      Column() {
        Text(this.viewModel.userInfo?.nickname ?? "")
          .fontSize(18)
          .fontWeight(FontWeight.Bold)

        Text(this.viewModel.userInfo?.currentIdentity ?? "")
          .fontSize(14)
          .fontColor("#666666")
          .margin({ top: 4 })
      }
      .margin({ left: 12 })
      .layoutWeight(1)
      .alignItems(Align.ItemStart)

      // 登出按钮
      Button("退出登录")
        .type(ButtonType.Normal)
        .size({ width: 80, height: 32 })
        .fontSize(14)
        .onClick(() => {
          this.viewModel.handleLogout();
        })
    }
    .width("100%")
    .padding(16)
    .backgroundColor("#FFFFFF")
    .margin({ top: 8, bottom: 8 })
  }

  // 设置项列表
  @Builder
  buildSettingsList(): void {
    ForEach(this.viewModel.groups, (group: SettingsGroup) => {
      Column() {
        // 分组标题
        if (group.showHeader) {
          Text(group.title)
            .fontSize(14)
            .fontColor("#999999")
            .padding({ left: 16, top: 16, bottom: 8 })
        }

        // 设置项列表
        ForEach(group.items, (item: SettingsItem) => {
          this.buildSettingsItem(item)
        })
      }
      .width("100%")
      .backgroundColor("#FFFFFF")
      .margin({ top: 8 })
    })
  }

  // 单个设置项
  @Builder
  buildSettingsItem(item: SettingsItem): void {
    Row() {
      // 图标
      Image(item.icon)
        .width(24)
        .height(24)

      // 标题
      Text(item.title)
        .fontSize(16)
        .layoutWeight(1)
        .margin({ left: 12 })

      // 副标题
      if (item.subtitle) {
        Text(item.subtitle)
          .fontSize(14)
          .fontColor("#999999")
          .margin({ right: 8 })
      }

      // 右箭头
      Image($r("sys.media.ohos_ic_public_arrow_right"))
        .width(16)
        .height(16)
        .fillColor("#CCCCCC")
    }
    .width("100%")
    .height(56)
    .padding({ left: 16, right: 16 })
    .onClick(() => {
      this.viewModel.handleItemClick(item);
    })

    Divider()
      .strokeWidth(0.5)
      .color("#EEEEEE")
      .margin({ left: 56 })
  }

  // 底部版本信息
  @Builder
  buildFooter(): void {
    Column() {
      Text(this.viewModel.versionDisplayText)
        .fontSize(14)
        .fontColor("#999999")
        .margin({ top: 16 })

      Text(this.viewModel.appVersion.icpLicense)
        .fontSize(12)
        .fontColor("#CCCCCC")
        .margin({ top: 4 })
    }
    .width("100%")
    .padding({ top: 16, bottom: 32 })
  }
}
```

---

## 7. 页面跳转路由

### 7.1 路由配置

| 路由名称   | 路径                          | 说明              | 参数           |
| ---------- | ----------------------------- | ----------------- | -------------- |
| 设置页     | `pages/settings/SettingsPage` | 设置中心主页      | -              |
| 登录页     | `pages/login/Login`           | 登录页面          | -              |
| 梦想图页   | `pages/dream/DreamMapPage`    | 我的退休梦想图    | -              |
| WebView 页 | `pages/common/WebPage`        | 通用 WebView 页面 | `title`, `url` |

### 7.2 路由跳转方式

```typescript
// 1. 普通跳转 (压入新页面)
router.pushUrl({
  url: "pages/dream/DreamMapPage",
});

// 2. 替换当前页面 (用于登录后返回设置页)
router.replaceUrl({
  url: "pages/settings/SettingsPage",
});

// 3. 带参数跳转
router.pushUrl({
  url: "pages/common/WebPage",
  params: {
    title: "隐私政策",
    url: "https://crm.ida1998.com/protocols/privacy.html",
  },
});

// 4. 返回上一页
router.back();
```

### 7.3 WebView 页面参数

```typescript
// WebPage.ets 接收参数
@Entry
@Component
struct WebPage {
  @State title: string = "";
  @State url: string = "";

  aboutToAppear(): void {
    // 从路由参数获取
    const params = router.getParams() as Record<string, string>;
    this.title = params?.title ?? "网页";
    this.url = params?.url ?? "";
  }

  build() {
    // WebView 实现
  }
}
```

---

## 8. 错误处理

### 8.1 错误处理策略

```typescript
/**
 * 统一错误处理
 */
function handleSettingsError(error: any): void {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "B00002": // 未授权
        AuthManager.clearAuthData();
        router.replaceUrl({ url: "pages/login/Login" });
        showToast("登录已过期");
        break;

      case "B00020": // 业务错误
        showToast(error.message);
        break;

      default:
        showToast(error.message || "操作失败");
    }
  } else {
    console.error("[SettingsViewModel] unknown error:", error);
    showToast("网络异常，请稍后重试");
  }
}
```

### 8.2 Loading 状态处理

```typescript
// 在需要显示 Loading 的方法中使用
async function handleLogout(): Promise<void> {
  LoadingView.show({ text: "正在退出..." });
  try {
    await viewModel.handleLogout();
  } catch (error) {
    handleSettingsError(error);
  } finally {
    LoadingView.hide();
  }
}
```

---

## 附录

### A. 文件结构

```
common/features/settings/
├── index.ets                    # 模块导出
├── models/
│   ├── SettingsItem.ets         # 设置项模型
│   ├── SettingsGroup.ets        # 设置项分组模型
│   ├── UserInfo.ets             # 用户信息模型
│   ├── AppVersionInfo.ets       # 应用版本模型
│   └── Protocol.ets             # 协议模型
├── repository/
│   ├── ISettingsRepository.ets  # 仓库接口
│   └── SettingsRepositoryImpl.ets # 仓库实现
├── viewmodel/
│   └── SettingsViewModel.ets    # ViewModel
├── pages/
│   └── SettingsPage.ets         # 设置页面
└── components/
    ├── UserHeaderView.ets       # 用户信息视图
    ├── SettingsListItem.ets     # 设置项列表项
    └── SettingsFooter.ets       # 页脚视图
```

### B. 变更日志

| 版本 | 日期       | 作者             | 变更说明 |
| ---- | ---------- | ---------------- | -------- |
| v1.0 | 2026-03-25 | mobile-architect | 初始版本 |
