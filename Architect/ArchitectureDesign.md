# HarmonyOS 保险培训平台 - 架构设计文档

## 1. 项目概述

### 1.1 项目背景

保险培训学习平台 HarmonyOS 原生应用，使用 ArkTS 语言和 ArkUI 框架开发，为保险从业人员提供在线课程学习、学分管理、培训认证等功能。

### 1.2 技术栈

- **开发语言**: ArkTS (Ark TypeScript)
- **UI 框架**: ArkUI (声明式 UI 框架)
- **目标平台**: HarmonyOS NEXT (API 12+)
- **包名**: `com.imm.chrp`

### 1.3 当前项目状态

| 模块         | 状态      | 说明                               |
| ------------ | --------- | ---------------------------------- |
| 项目基础框架 | ✅ 已完成 | entry 模块 + common/basic 基础模块 |
| 友盟 SDK     | ✅ 已集成 | 推送 (Push) + 统计 (Analytics)     |
| 登录流程     | ✅ 已完成 | 账号密码登录 + 企业微信登录        |
| 广告系统     | ✅ 已完成 | 开屏广告 + WebView 广告            |
| 企业微信 SDK | ✅ 已集成 | 内部/外部人员登录                  |

---

## 2. 现有架构分析

### 2.1 当前目录结构

```
harmony_chrp_app/
├── entry/                          # 主应用模块
│   ├── src/main/ets/
│   │   ├── abilityStage/           # Ability 生命周期
│   │   ├── entryability/           # EntryAbility 入口
│   │   ├── components/             # 业务组件 (login)
│   │   └── pages/                  # 页面视图
│   │       ├── Index.ets           # 首页 (Tab 容器)
│   │       ├── login/              # 登录页面
│   │       ├── start/              # 启动页/广告页
│   │       └── ad/                 # 广告相关页面
│   └── ...
├── common/basic/                   # 公共基础模块
│   ├── src/main/ets/
│   │   ├── api/                    # API 接口层
│   │   │   ├── index.ets           # API 导出
│   │   │   └── login.ets           # 登录 API
│   │   ├── components/             # 通用 UI 组件
│   │   │   ├── card/               # 卡片组件
│   │   │   ├── confirm/            # 确认对话框
│   │   │   ├── nav/                # 导航栏
│   │   │   ├── toast/              # Toast 提示
│   │   │   └── web/                # WebView 组件
│   │   ├── constants/              # 常量定义
│   │   │   ├── advert.ets          # 广告常量
│   │   │   ├── request.ets         # 请求常量
│   │   │   └── sdk.ets             # SDK 配置
│   │   ├── models/                 # 数据模型
│   │   │   ├── advert.ets          # 广告模型
│   │   │   ├── request.ets         # 请求模型
│   │   │   └── index.ets           # 模型导出
│   │   ├── utils/                  # 工具函数
│   │   │   ├── app.ets             # App 信息
│   │   │   ├── device.ets          # 设备信息
│   │   │   ├── request.ets         # 网络请求封装
│   │   │   ├── setting.ets         # 首选项存储
│   │   │   └── toast.ets           # Toast 工具
│   │   └── Index.ets               # 模块导出入口
│   └── ...
└── oh_modules/                     # 第三方依赖
    ├── @umeng/push                 # 友盟推送
    ├── @umeng/analytics            # 友盟统计
    ├── @tencent/wecom_open_sdk     # 企业微信 SDK
    └── @yue/webview_javascript_bridge  # WebView 桥接
```

### 2.2 现有架构问题识别

| 问题类别 | 问题描述                                                | 影响                       |
| -------- | ------------------------------------------------------- | -------------------------- |
| 模块划分 | 业务逻辑分散在 pages 中，缺乏独立 ViewModel 层          | 代码复用困难，测试困难     |
| 状态管理 | 过度依赖 `AppStorage` 全局存储                          | 状态变更追踪困难，难以调试 |
| 数据模型 | 模型定义不完整，缺少核心业务实体 (User/Course/Progress) | 业务扩展受限               |
| API 规范 | 缺少统一的错误处理和请求拦截机制                        | 错误处理不一致             |
| 组件复用 | 组件职责不够清晰，部分组件耦合业务逻辑                  | 跨模块复用困难             |

---

## 3. 架构设计原则

### 3.1 核心原则

1. **单一职责**: 每个模块/组件只负责单一功能领域
2. **关注点分离**: UI、业务逻辑、数据访问明确分离
3. **不可变性**: 状态更新创建新对象，避免原地修改
4. **依赖倒置**: 高层模块不依赖低层模块，都依赖抽象

### 3.2 架构模式：MVVM + Repository

```
┌─────────────────────────────────────────────────────────┐
│                      View Layer (ArkUI)                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   Pages     │  │ Components  │  │  Dialogs    │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
│                         │ ↑                              │
│                         │ │ @Observed @ObjectLink       │
│                         ↓ │                              │
│  ┌─────────────────────────────────────────────────┐    │
│  │              ViewModel Layer                     │    │
│  │  @State @Prop @Link 状态管理 + 业务逻辑          │    │
│  └─────────────────────────────────────────────────┘    │
│                         │                                │
│                         ↓                                │
│  ┌─────────────────────────────────────────────────┐    │
│  │              Repository Layer                    │    │
│  │     数据仓库：统一数据源 (API + Local)           │    │
│  └─────────────────────────────────────────────────┘    │
│                    ↙         ↘                          │
│                   ↓           ↓                         │
│  ┌───────────────────┐  ┌───────────────────┐         │
│  │   API Layer       │  │   Local Storage   │         │
│  │   (Remote Data)   │  │   (Preferences/DB)│         │
│  └───────────────────┘  └───────────────────┘         │
└─────────────────────────────────────────────────────────┘
```

---

## 4. 模块划分与职责定义

### 4.1 模块结构总览

```
harmony_chrp_app/
├── entry/                          # 应用入口模块 (保持轻量)
├── common/
│   ├── basic/                      # 基础公共模块
│   │   ├── api/                    # 基础 API 封装
│   │   ├── components/             # 通用 UI 组件
│   │   ├── constants/              # 全局常量
│   │   ├── models/                 # 基础数据模型
│   │   ├── utils/                  # 工具函数
│   │   └── network/                # 网络层 (新增)
│   ├── features/                   # 业务功能模块 (新增)
│   │   ├── auth/                   # 认证模块
│   │   ├── course/                 # 课程模块
│   │   ├── learning/               # 学习模块
│   │   ├── profile/                # 个人中心
│   │   └── settings/               # 设置模块
│   └── domain/                     # 领域模型层 (新增)
│       ├── entities/               # 业务实体
│       ├── repositories/           # 仓库接口定义
│       └── usecases/               # 业务用例
└── Architect/                      # 架构文档目录
```

### 4.2 各模块职责

#### 4.2.1 entry 模块

| 职责     | 说明                         |
| -------- | ---------------------------- |
| 应用入口 | EntryAbility 生命周期管理    |
| 页面路由 | 主导航结构 (Tabs/Navigation) |
| 初始化   | SDK 初始化、全局状态初始化   |

#### 4.2.2 common/basic 模块

| 目录          | 职责                            |
| ------------- | ------------------------------- |
| `api/`        | 基础网络请求封装、通用 API      |
| `components/` | 无状态通用组件 (Card/Nav/Toast) |
| `constants/`  | 环境配置、Code 码、常量定义     |
| `models/`     | 基础响应模型、通用数据模型      |
| `network/`    | HTTP 客户端、拦截器、错误处理   |
| `utils/`      | 设备信息、存储、工具函数        |

#### 4.2.3 common/features 模块 (新增)

| 模块        | 职责     | 包含内容               |
| ----------- | -------- | ---------------------- |
| `auth/`     | 认证授权 | 登录/注册/Token 管理   |
| `course/`   | 课程管理 | 课程列表/详情/分类     |
| `learning/` | 学习过程 | 视频播放/进度跟踪/测验 |
| `profile/`  | 个人中心 | 用户信息/学分/证书     |
| `settings/` | 系统设置 | 通知/隐私/关于         |

每个 feature 模块内部结构:

```
feature-name/
├── index.ets               # 模块导出
├── models/                 # 领域模型
│   └── XxxModel.ets
├── repository/             # 数据仓库
│   ├── XxxRepository.ets   # 接口定义
│   └── XxxRepositoryImpl.ets # 实现
├── viewmodel/              # 视图模型
│   └── XxxViewModel.ets
├── pages/                  # 业务页面
│   └── XxxPage.ets
└── components/             # 业务组件
    └── XxxComponent.ets
```

#### 4.2.4 common/domain 模块 (新增)

纯类型定义，无 UI 依赖:

```
domain/
├── entities/               # 业务实体 (纯净 POJO)
│   ├── User.ets
│   ├── Course.ets
│   └── Progress.ets
├── repositories/           # 仓库接口 (抽象)
│   └── Repository.ets
└── usecases/              # 业务用例
    ├── GetCourseListUseCase.ets
    └── UpdateProgressUseCase.ets
```

---

## 5. 数据模型设计

### 5.1 核心业务实体

#### User (用户模型)

```typescript
// 用户实体
class User {
  id: string = ""; // 用户 ID
  username: string = ""; // 用户名
  nickname: string = ""; // 昵称
  avatar: string = ""; // 头像 URL
  phone: string = ""; // 手机号
  email: string = ""; // 邮箱
  accountType: AccountType = AccountType.NORMAL; // 账号类型
  department: string = ""; // 部门
  position: string = ""; // 职位
  createdAt: number = 0; // 创建时间戳
  lastLoginAt: number = 0; // 最后登录时间
}

enum AccountType {
  NORMAL = 0, // 普通用户 (账号密码)
  QIWEI_INTERNAL = 1, // 企业微信内部
  QIWEI_EXTERNAL = 2, // 企业微信外部
}
```

#### Course (课程模型)

```typescript
class Course {
  id: string = ""; // 课程 ID
  title: string = ""; // 课程标题
  description: string = ""; // 课程描述
  coverImage: string = ""; // 封面图 URL
  instructorId: string = ""; // 讲师 ID
  instructorName: string = ""; // 讲师姓名
  categoryId: string = ""; // 分类 ID
  categoryName: string = ""; // 分类名称
  duration: number = 0; // 时长 (分钟)
  credit: number = 0; // 学分值
  difficulty: DifficultyLevel = DifficultyLevel.BEGINNER; // 难度
  status: CourseStatus = CourseStatus.PUBLISHED; // 状态
  viewCount: number = 0; // 观看次数
  rating: number = 0; // 评分
  createdAt: number = 0; // 创建时间
  updatedAt: number = 0; // 更新时间
}

enum DifficultyLevel {
  BEGINNER = 1, // 入门
  INTERMEDIATE = 2, // 进阶
  ADVANCED = 3, // 高级
}

enum CourseStatus {
  DRAFT = 0, // 草稿
  PUBLISHED = 1, // 已发布
  ARCHIVED = 2, // 已归档
}
```

#### LearningProgress (学习进度模型)

```typescript
class LearningProgress {
  id: string = ""; // 进度 ID
  userId: string = ""; // 用户 ID
  courseId: string = ""; // 课程 ID
  currentChapterId: string = ""; // 当前章节 ID
  currentSectionId: string = ""; // 当前小节 ID
  watchedDuration: number = 0; // 已观看时长 (秒)
  totalDuration: number = 0; // 总时长 (秒)
  progressPercent: number = 0; // 进度百分比 (0-100)
  status: ProgressStatus = ProgressStatus.NOT_STARTED;
  lastWatchedAt: number = 0; // 最后观看时间
  completedAt?: number; // 完成时间
}

enum ProgressStatus {
  NOT_STARTED = 0, // 未开始
  IN_PROGRESS = 1, // 学习中
  COMPLETED = 2, // 已完成
}
```

#### UserCredit (学分模型)

```typescript
class UserCredit {
  id: string = ""; // 记录 ID
  userId: string = ""; // 用户 ID
  courseId: string = ""; // 关联课程 ID
  courseName: string = ""; // 课程名称
  creditAmount: number = 0; // 学分数值
  creditType: CreditType = CreditType.COURSE; // 学分类型
  earnedAt: number = 0; // 获得时间
  expireAt?: number; // 过期时间 (可选)
  status: CreditStatus = CreditStatus.VALID; // 状态
}

enum CreditType {
  COURSE = 1, // 课程学分
  EXAM = 2, // 考试学分
  TRAINING = 3, // 培训学分
}

enum CreditStatus {
  VALID = 1, // 有效
  EXPIRED = 2, // 已过期
  USED = 3, // 已使用
}
```

### 5.2 通用响应模型

```typescript
// API 响应基础结构
interface ApiResponse<T> {
  code: ResponseCode; // 响应码
  message: string; // 响应消息
  data: T | null; // 响应数据
  timestamp: number; // 时间戳
  traceId?: string; // 追踪 ID (用于日志)
}

// 分页响应结构
interface PageResponse<T> {
  list: T[]; // 数据列表
  total: number; // 总记录数
  page: number; // 当前页码
  pageSize: number; // 每页大小
  totalPages: number; // 总页数
}

// 统一响应码
enum ResponseCode {
  SUCCESS = "B00000", // 成功
  ERROR = "B00001", // 通用错误
  UNAUTHORIZED = "B00002", // 未授权
  FORBIDDEN = "B00003", // 禁止访问
  NOT_FOUND = "B00004", // 资源不存在
  VALIDATION_ERROR = "B00010", // 参数校验错误
  SERVER_ERROR = "B00050", // 服务器内部错误
}
```

---

## 6. API 接口设计规范

### 6.1 基础规范

| 规范项   | 说明                                |
| -------- | ----------------------------------- |
| 协议     | HTTPS                               |
| 数据格式 | JSON                                |
| 认证方式 | Bearer Token (Authorization Header) |
| 字符编码 | UTF-8                               |
| 时间格式 | Unix Timestamp (毫秒)               |

### 6.2 请求规范

```typescript
// 请求配置接口
interface RequestConfig {
  url: string;
  method: HttpMethod;
  params?: Record<string, any>; // URL 参数
  data?: Record<string, any>; // 请求体
  headers?: Record<string, string>; // 请求头
  timeout?: number; // 超时时间 (ms)
}

// 请求拦截器配置
interface Interceptors {
  request?: (config: RequestConfig) => RequestConfig;
  response?: <T>(response: ApiResponse<T>) => ApiResponse<T>;
  error?: (error: any) => Promise<never>;
}
```

### 6.3 错误处理规范

```typescript
// 错误类型定义
class ApiError extends Error {
  code: ResponseCode;
  message: string;
  traceId?: string;

  constructor(code: ResponseCode, message: string, traceId?: string) {
    super(message);
    this.code = code;
    this.message = message;
    this.traceId = traceId;
  }
}

// 错误处理策略
const errorHandlers: Map<ResponseCode, (error: ApiError) => void> = new Map([
  [ResponseCode.UNAUTHORIZED, handleUnauthorized], // Token 失效，跳转登录
  [ResponseCode.FORBIDDEN, handleForbidden], // 无权限，提示用户
  [ResponseCode.NOT_FOUND, handleNotFound], // 资源不存在
  [ResponseCode.SERVER_ERROR, handleServerError], // 服务器错误，稍后重试
]);
```

### 6.4 API 模块组织

```
api/
├── index.ets               # API 导出入口
├── HttpClient.ets          # HTTP 客户端封装
├── interceptors/           # 拦截器
│   ├── AuthInterceptor.ets # 认证拦截器
│   └── LogInterceptor.ets  # 日志拦截器
├── auth.api.ets            # 认证 API
├── course.api.ets          # 课程 API
├── learning.api.ets        # 学习 API
└── user.api.ets            # 用户 API
```

---

## 7. 组件复用策略

### 7.1 组件分类

| 类别     | 位置                           | 特点                   | 示例                       |
| -------- | ------------------------------ | ---------------------- | -------------------------- |
| 基础组件 | `common/basic/components`      | 无业务逻辑，高度复用   | Card, Nav, Toast           |
| 业务组件 | `common/features/*/components` | 含业务逻辑，模块内复用 | CourseCard, VideoPlayer    |
| 页面组件 | `common/features/*/pages`      | 完整页面，路由级别     | CourseListPage, DetailPage |

### 7.2 组件设计原则

1. **Props 驱动**: 组件行为完全由 Props 控制
2. **事件回调**: 通过回调函数与父组件通信
3. **插槽支持**: 使用 `@Builder` 实现内容插槽
4. **样式隔离**: 组件内部样式不影响外部

### 7.3 组件接口规范

```typescript
@Component
struct ReusableComponent {
  // Props - 输入参数
  @Prop title: string
  @Prop data: ListItem[]

  // Events - 输出事件
  onItemClick?: (item: ListItem) => void
  onAction?: (action: string) => void

  // 内部状态
  @State private isLoading: boolean = false

  build() {
    Column() {
      // 组件内容
    }
  }
}
```

---

## 8. 状态管理方案

### 8.1 状态层级

| 级别   | 范围      | 方案                              | 适用场景           |
| ------ | --------- | --------------------------------- | ------------------ |
| 组件内 | 单组件    | `@State`                          | 组件内部 UI 状态   |
| 父子间 | 父子组件  | `@Prop` / `@Link`                 | 父子数据传递       |
| 跨组件 | 兄弟/跨级 | `@Provide` / `@Consume`           | 跨层级共享         |
| 全局   | 应用级    | `AppStorage` / `LocalStorage`     | 全局配置、用户信息 |
| 持久化 | 持久存储  | `Preferences` / `RelationalStore` | 本地数据缓存       |

### 8.2 状态管理最佳实践

```typescript
// 1. 组件内状态 - 使用 @State
@State private count: number = 0

// 2. 父子传递 - 使用 @Prop (单向) / @Link (双向)
@Prop config: Config
@Link isChecked: boolean

// 3. 跨层级 - 使用 @Provide / @Consume
@Provide theme: Theme = new Theme()
@Consume theme: Theme

// 4. 全局状态 - 使用 AppStorage (谨慎使用)
AppStorage.set('user', user)
AppStorage.get<User>('user')

// 5. 复杂对象 - 使用 @Observed + @ObjectLink
@Observed class FormData { ... }
@ObjectLink formData: FormData
```

### 8.3 ViewModel 模式

```typescript
// ViewModel 基类
abstract class BaseViewModel {
  @State isLoading: boolean = false;
  @State error: string | null = null;

  abstract load(): Promise<void>;
  abstract refresh(): Promise<void>;
}

// 具体 ViewModel
class CourseListViewModel extends BaseViewModel {
  @State courses: Course[] = [];
  @State filter: CourseFilter = new CourseFilter();

  private repository: CourseRepository;

  async load(): Promise<void> {
    this.isLoading = true;
    try {
      this.courses = await this.repository.getList(this.filter);
    } catch (e) {
      this.error = e.message;
    } finally {
      this.isLoading = false;
    }
  }
}
```

---

## 9. 目录结构规范

### 9.1 最终目录结构

```
harmony_chrp_app/
├── entry/
│   └── src/main/ets/
│       ├── abilityStage/           # Ability 生命周期
│       ├── entryability/           # EntryAbility
│       └── pages/
│           └── Index.ets           # 主页面 (Tab 导航)
│
├── common/
│   ├── basic/                      # 基础公共模块
│   │   ├── api/
│   │   │   ├── index.ets
│   │   │   ├── HttpClient.ets      # HTTP 客户端
│   │   │   └── interceptors/       # 拦截器
│   │   ├── components/
│   │   │   ├── card/
│   │   │   ├── confirm/
│   │   │   ├── nav/
│   │   │   ├── toast/
│   │   │   └── web/
│   │   ├── constants/
│   │   ├── models/
│   │   ├── network/
│   │   ├── utils/
│   │   └── Index.ets
│   │
│   ├── domain/                     # 领域层 (纯业务定义)
│   │   ├── entities/               # 业务实体
│   │   │   ├── User.ets
│   │   │   ├── Course.ets
│   │   │   ├── LearningProgress.ets
│   │   │   └── UserCredit.ets
│   │   ├── repositories/           # 仓库接口
│   │   │   └── Repository.ets
│   │   └── usecases/               # 业务用例
│   │
│   └── features/                   # 功能模块
│       ├── auth/
│       │   ├── models/
│       │   ├── repository/
│       │   ├── viewmodel/
│       │   ├── pages/
│       │   └── components/
│       ├── course/
│       ├── learning/
│       ├── profile/
│       └── settings/
│
├── Architect/                      # 架构文档
│   ├── ArchitectureDesign.md
│   ├── DataModels.md
│   └── APIDesign.md
│
└── oh_modules/                     # 第三方依赖
```

### 9.2 文件命名规范

| 类型     | 命名规则           | 示例                 |
| -------- | ------------------ | -------------------- |
| 页面文件 | 帕斯卡命名 + Page  | `CourseListPage.ets` |
| 组件文件 | 帕斯卡命名         | `CourseCard.ets`     |
| 模型文件 | 帕斯卡命名 + Model | `CourseModel.ets`    |
| API 文件 | 小写 + .api        | `course.api.ets`     |
| 工具文件 | 小写               | `date.ets`           |
| 常量文件 | 小写               | `constants.ets`      |

---

## 10. 实施路线图

### Phase 1: 基础重构 (优先级: 高)

- [ ] 抽取领域模型到 `common/domain/entities`
- [ ] 实现 Repository 层接口
- [ ] 完善 HTTP 客户端和拦截器
- [ ] 迁移登录逻辑到 `features/auth`

### Phase 2: 课程模块 (优先级: 高)

- [ ] 实现 Course 实体和 Repository
- [ ] 课程列表页面和 ViewModel
- [ ] 课程详情页面
- [ ] 课程分类功能

### Phase 3: 学习模块 (优先级: 中)

- [ ] 学习进度跟踪
- [ ] 视频播放器集成
- [ ] 学分计算逻辑
- [ ] 完成状态同步

### Phase 4: 个人中心 (优先级: 中)

- [ ] 用户信息展示
- [ ] 学分记录查询
- [ ] 学习历史
- [ ] 证书管理

### Phase 5: 优化完善 (优先级: 低)

- [ ] 离线缓存
- [ ] 性能优化
- [ ] 单元测试覆盖
- [ ] 无障碍支持

---

## 附录

### A. 参考资源

- [HarmonyOS 官方文档](https://developer.harmonyos.com/)
- [ArkTS 语言指南](https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-get-started-0000001778152463-V3)
- [ArkUI 组件参考](https://developer.harmonyos.com/cn/docs/documentation/doc-references-V3/arkui-overview-0000001778210315-V3)

### B. 变更日志

| 版本 | 日期       | 作者             | 变更说明 |
| ---- | ---------- | ---------------- | -------- |
| v1.0 | 2026-03-25 | mobile-architect | 初始版本 |
