# HarmonyOS 保险培训平台 - 数据结构定义文档

> 本文档定义了保险培训平台应用中的所有核心数据结构，包括业务实体、API 请求/响应模型、本地存储模型等。

---

## 1. 文档说明

### 1.1 命名规范

- **类名**: 帕斯卡命名法 (PascalCase)，如 `UserInfo`
- **接口名**: 帕斯卡命名法，如 `ApiResponse`
- **枚举名**: 帕斯卡命名法，如 `AccountType`
- **属性名**: 驼峰命名法 (camelCase)，如 `userId`
- **常量名**: 大写 + 下划线，如 `API_BASE_URL`

### 1.2 数据类型说明

| ArkTS 类型     | 说明     | 默认值      |
| -------------- | -------- | ----------- |
| `string`       | 字符串   | `''`        |
| `number`       | 数字     | `0`         |
| `boolean`      | 布尔值   | `false`     |
| `T\|null`      | 可空类型 | `null`      |
| `T\|undefined` | 可选类型 | `undefined` |
| `T[]`          | 数组     | `[]`        |
| `Record<K,V>`  | 键值对   | `{}`        |

---

## 2. 用户相关模型

### 2.1 用户实体 (User)

```typescript
/**
 * 用户实体类
 * 描述：系统中用户的核心数据模型
 */
@Observed
class User {
  /** 用户唯一标识 */
  id: string = "";

  /** 用户名 (登录账号) */
  username: string = "";

  /** 用户昵称 */
  nickname: string = "";

  /** 头像图片 URL */
  avatar: string = "";

  /** 手机号码 */
  phone: string = "";

  /** 电子邮箱 */
  email: string = "";

  /** 账号类型 */
  accountType: AccountType = AccountType.NORMAL;

  /** 所属部门 */
  department: string = "";

  /** 职位 */
  position: string = "";

  /** 工号 */
  employeeId: string = "";

  /** 创建时间戳 (毫秒) */
  createdAt: number = 0;

  /** 最后登录时间戳 (毫秒) */
  lastLoginAt: number = 0;

  /** 用户状态 */
  status: UserStatus = UserStatus.ACTIVE;
}

/**
 * 账号类型枚举
 */
enum AccountType {
  /** 普通用户 (账号密码登录) */
  NORMAL = 0,

  /** 企业微信内部员工 */
  QIWEI_INTERNAL = 1,

  /** 企业微信外部人员 */
  QIWEI_EXTERNAL = 2,
}

/**
 * 用户状态枚举
 */
enum UserStatus {
  /** 正常 */
  ACTIVE = 1,

  /** 禁用 */
  DISABLED = 0,

  /** 已注销 */
  DELETED = -1,
}
```

### 2.2 用户信息扩展 (UserProfile)

```typescript
/**
 * 用户详细信息
 * 描述：扩展用户的基础信息，包含更多个人详情
 */
@Observed
class UserProfile {
  /** 用户 ID */
  userId: string = "";

  /** 真实姓名 */
  realName: string = "";

  /** 性别: 0-未知，1-男，2-女 */
  gender: number = 0;

  /** 生日 */
  birthday?: string = undefined;

  /** 身份证号码 (加密存储) */
  idCard?: string = undefined;

  /** 所在地区 */
  region: string = "";

  /** 详细地址 */
  address: string = "";

  /** 紧急联系人 */
  emergencyContact: string = "";

  /** 紧急联系人电话 */
  emergencyPhone: string = "";

  /** 个性签名 */
  bio: string = "";
}
```

### 2.3 登录请求模型

```typescript
/**
 * 登录请求参数
 */
class LoginRequest {
  /** 账号 */
  account: string = "";

  /** 密码 */
  password: string = "";

  /** 登录类型 */
  loginType: LoginType = LoginType.ACCOUNT;

  /** 企业微信授权码 (企微登录时使用) */
  authCode?: string = undefined;

  /** 设备 ID */
  deviceId: string = "";

  /** 设备信息 JSON 字符串 */
  deviceInfo: string = "";

  /** 友盟设备 Token */
  channelId: string = "";

  /** 友盟 APP Key */
  channelApp: string = "";
}

/**
 * 登录类型枚举
 */
enum LoginType {
  /** 账号密码登录 */
  ACCOUNT = 0,

  /** 企业微信内部登录 */
  QIWEI_INTERNAL = 1,

  /** 企业微信外部登录 */
  QIWEI_EXTERNAL = 2,

  /** 验证码登录 */
  SMS_CODE = 3,
}

/**
 * 登录响应
 */
class LoginResponse {
  /** 用户 Token */
  token: string = "";

  /** Token 过期时间 (毫秒时间戳) */
  tokenExpireAt: number = 0;

  /** 用户信息 */
  user: User | null = null;

  /** 是否需要完善信息 */
  needCompleteProfile: boolean = false;
}
```

### 2.4 注册请求模型

```typescript
/**
 * 注册请求参数
 */
class RegisterRequest {
  /** 手机号 */
  phone: string = "";

  /** 验证码 */
  smsCode: string = "";

  /** 密码 */
  password: string = "";

  /** 确认密码 */
  confirmPassword: string = "";

  /** 邀请码 (可选) */
  inviteCode?: string = undefined;

  /** 协议同意标记 */
  agreeTerms: boolean = true;
}

/**
 * 发送短信验证码请求
 */
class SendSmsRequest {
  /** 手机号 */
  phone: string = "";

  /** 验证码类型 */
  smsType: SmsType = SmsType.LOGIN;

  /** 图形验证码 (部分场景需要) */
  captchaCode?: string = undefined;
}

/**
 * 短信类型枚举
 */
enum SmsType {
  /** 登录验证码 */
  LOGIN = 1,

  /** 注册验证码 */
  REGISTER = 2,

  /** 找回密码验证码 */
  RESET_PASSWORD = 3,

  /** 绑定手机验证码 */
  BIND_PHONE = 4,
}
```

---

## 3. 课程相关模型

### 3.1 课程实体 (Course)

```typescript
/**
 * 课程实体类
 * 描述：培训课程的核心数据模型
 */
@Observed
class Course {
  /** 课程唯一标识 */
  id: string = "";

  /** 课程标题 */
  title: string = "";

  /** 课程副标题/简介 */
  subtitle: string = "";

  /** 课程详细描述 (HTML/Markdown) */
  description: string = "";

  /** 封面图片 URL */
  coverImage: string = "";

  /** 讲师 ID */
  instructorId: string = "";

  /** 讲师姓名 */
  instructorName: string = "";

  /** 讲师头像 */
  instructorAvatar?: string = undefined;

  /** 分类 ID */
  categoryId: string = "";

  /** 分类名称 */
  categoryName: string = "";

  /** 课程时长 (分钟) */
  duration: number = 0;

  /** 视频总时长 (秒) */
  videoDuration: number = 0;

  /** 可获得学分 */
  credit: number = 0;

  /** 难度级别 */
  difficulty: DifficultyLevel = DifficultyLevel.BEGINNER;

  /** 课程状态 */
  status: CourseStatus = CourseStatus.PUBLISHED;

  /** 观看次数 */
  viewCount: number = 0;

  /** 学习人数 */
  learnerCount: number = 0;

  /** 评分 (1-5) */
  rating: number = 0;

  /** 评价数量 */
  reviewCount: number = 0;

  /** 是否推荐 */
  isRecommended: boolean = false;

  /** 推荐排序 (数字越小越靠前) */
  recommendOrder: number = 999;

  /** 创建时间戳 */
  createdAt: number = 0;

  /** 更新时间戳 */
  updatedAt: number = 0;

  /** 发布时间戳 */
  publishedAt?: number = undefined;
}

/**
 * 难度级别枚举
 */
enum DifficultyLevel {
  /** 入门 */
  BEGINNER = 1,

  /** 进阶 */
  INTERMEDIATE = 2,

  /** 高级 */
  ADVANCED = 3,
}

/**
 * 课程状态枚举
 */
enum CourseStatus {
  /** 草稿 */
  DRAFT = 0,

  /** 已发布 */
  PUBLISHED = 1,

  /** 已下架 */
  UNPUBLISHED = 2,

  /** 已归档 */
  ARCHIVED = 3,
}
```

### 3.2 课程章节 (CourseChapter)

```typescript
/**
 * 课程章节
 */
@Observed
class CourseChapter {
  /** 章节 ID */
  id: string = "";

  /** 课程 ID */
  courseId: string = "";

  /** 章节标题 */
  title: string = "";

  /** 章节描述 */
  description: string = "";

  /** 章节排序 */
  order: number = 1;

  /** 小节列表 */
  sections: CourseSection[] = [];

  /** 章节时长 (分钟) */
  duration: number = 0;

  /** 是否免费试听 */
  isFreePreview: boolean = false;
}

/**
 * 课程小节
 */
@Observed
class CourseSection {
  /** 小节 ID */
  id: string = "";

  /** 章节 ID */
  chapterId: string = "";

  /** 课程 ID */
  courseId: string = "";

  /** 小节标题 */
  title: string = "";

  /** 小节类型 */
  type: SectionType = SectionType.VIDEO;

  /** 视频 URL */
  videoUrl?: string = undefined;

  /** 视频时长 (秒) */
  videoDuration: number = 0;

  /** 文档 URL (PPT/PDF 等) */
  documentUrl?: string = undefined;

  /** 小节排序 */
  order: number = 1;

  /** 是否免费试听 */
  isFreePreview: boolean = false;

  /** 小节描述 */
  description?: string = undefined;
}

/**
 * 小节类型枚举
 */
enum SectionType {
  /** 视频 */
  VIDEO = 1,

  /** 文档 */
  DOCUMENT = 2,

  /** 测验 */
  QUIZ = 3,

  /** 直播 */
  LIVE = 4,

  /** 外部链接 */
  EXTERNAL_LINK = 5,
}
```

### 3.3 课程分类 (CourseCategory)

```typescript
/**
 * 课程分类
 */
@Observed
class CourseCategory {
  /** 分类 ID */
  id: string = "";

  /** 分类名称 */
  name: string = "";

  /** 父分类 ID (0 表示一级分类) */
  parentId: string = "0";

  /** 分类图标 */
  icon?: string = undefined;

  /** 分类描述 */
  description?: string = undefined;

  /** 排序值 */
  order: number = 1;

  /** 是否显示 */
  isVisible: boolean = true;

  /** 子分类列表 */
  children: CourseCategory[] = [];
}
```

### 3.4 课程查询参数

```typescript
/**
 * 课程列表查询参数
 */
class CourseQuery {
  /** 当前页码 */
  page: number = 1;

  /** 每页数量 */
  pageSize: number = 20;

  /** 分类 ID */
  categoryId?: string = undefined;

  /** 难度级别 */
  difficulty?: DifficultyLevel = undefined;

  /** 搜索关键词 */
  keyword?: string = undefined;

  /** 排序方式 */
  sort: CourseSort = CourseSort.RECOMMEND;

  /** 讲师 ID */
  instructorId?: string = undefined;

  /** 学分范围最小值 */
  minCredit?: number = undefined;

  /** 学分范围最大值 */
  maxCredit?: number = undefined;
}

/**
 * 课程排序方式枚举
 */
enum CourseSort {
  /** 推荐排序 */
  RECOMMEND = 0,

  /** 最新发布 */
  NEWEST = 1,

  /** 最热 (观看次数) */
  HOTTEST = 2,

  /** 评分最高 */
  RATING = 3,

  /** 学分从高到低 */
  CREDIT_DESC = 4,

  /** 学分从低到高 */
  CREDIT_ASC = 5,
}
```

---

## 4. 学习进度模型

### 4.1 学习进度实体 (LearningProgress)

```typescript
/**
 * 学习进度实体类
 * 描述：记录用户学习课程的状态和进度
 */
@Observed
class LearningProgress {
  /** 进度记录 ID */
  id: string = "";

  /** 用户 ID */
  userId: string = "";

  /** 课程 ID */
  courseId: string = "";

  /** 当前章节 ID */
  currentChapterId: string = "";

  /** 当前小节 ID */
  currentSectionId: string = "";

  /** 已观看时长 (秒) */
  watchedDuration: number = 0;

  /** 课程总时长 (秒) */
  totalDuration: number = 0;

  /** 进度百分比 (0-100) */
  progressPercent: number = 0;

  /** 学习状态 */
  status: ProgressStatus = ProgressStatus.NOT_STARTED;

  /** 最后学习时间戳 */
  lastWatchedAt: number = 0;

  /** 完成时间戳 */
  completedAt?: number = undefined;

  /** 小节学习进度明细 */
  sectionProgress: SectionProgress[] = [];
}

/**
 * 小节学习进度
 */
@Observed
class SectionProgress {
  /** 小节 ID */
  sectionId: string = "";

  /** 是否已完成 */
  completed: boolean = false;

  /** 观看时长 (秒) */
  watchedDuration: number = 0;

  /** 最后学习时间 */
  lastWatchedAt: number = 0;

  /** 测验得分 (如果是测验小节) */
  quizScore?: number = undefined;
}

/**
 * 学习状态枚举
 */
enum ProgressStatus {
  /** 未开始 */
  NOT_STARTED = 0,

  /** 学习中 */
  IN_PROGRESS = 1,

  /** 已完成 */
  COMPLETED = 2,

  /** 已过期 */
  EXPIRED = 3,
}
```

### 4.2 学习记录 (LearningRecord)

```typescript
/**
 * 学习记录
 * 描述：用户每次学习的详细记录
 */
@Observed
class LearningRecord {
  /** 记录 ID */
  id: string = "";

  /** 用户 ID */
  userId: string = "";

  /** 课程 ID */
  courseId: string = "";

  /** 小节 ID */
  sectionId: string = "";

  /** 学习开始时间 */
  startedAt: number = 0;

  /** 学习结束时间 */
  endedAt: number = 0;

  /** 学习时长 (秒) */
  duration: number = 0;

  /** 是否完成 */
  completed: boolean = false;

  /** 设备类型 */
  deviceType: string = "";
}
```

### 4.3 学习统计 (LearningStatistics)

```typescript
/**
 * 学习统计
 * 描述：用户学习数据的统计汇总
 */
@Observed
class LearningStatistics {
  /** 用户 ID */
  userId: string = "";

  /** 总学习课程数 */
  totalCourses: number = 0;

  /** 已完成课程数 */
  completedCourses: number = 0;

  /** 学习中课程数 */
  learningCourses: number = 0;

  /** 总学习时长 (分钟) */
  totalLearningMinutes: number = 0;

  /** 总获得学分 */
  totalCredits: number = 0;

  /** 本周学习时长 (分钟) */
  weeklyLearningMinutes: number = 0;

  /** 本月学习时长 (分钟) */
  monthlyLearningMinutes: number = 0;

  /** 连续学习天数 */
  continuousDays: number = 0;

  /** 总学习天数 */
  totalLearningDays: number = 0;

  /** 学习时长趋势 (最近 7 天) */
  weeklyTrend: DailyLearningData[] = [];
}

/**
 * 每日学习数据
 */
@Observed
class DailyLearningData {
  /** 日期 (YYYY-MM-DD) */
  date: string = "";

  /** 学习时长 (分钟) */
  minutes: number = 0;

  /** 完成课程数 */
  completedCourses: number = 0;
}
```

---

## 5. 学分相关模型

### 5.1 学分实体 (UserCredit)

```typescript
/**
 * 学分实体类
 * 描述：用户获得的学分记录
 */
@Observed
class UserCredit {
  /** 学分记录 ID */
  id: string = "";

  /** 用户 ID */
  userId: string = "";

  /** 关联课程 ID */
  courseId: string = "";

  /** 课程名称 */
  courseName: string = "";

  /** 学分数值 */
  creditAmount: number = 0;

  /** 学分类型 */
  creditType: CreditType = CreditType.COURSE;

  /** 获得时间戳 */
  earnedAt: number = 0;

  /** 过期时间戳 (可选，为空表示永久有效) */
  expireAt?: number = undefined;

  /** 学分状态 */
  status: CreditStatus = CreditStatus.VALID;

  /** 备注说明 */
  remark?: string = undefined;

  /** 证书编号 (如有) */
  certificateNo?: string = undefined;
}

/**
 * 学分类型枚举
 */
enum CreditType {
  /** 课程学分 */
  COURSE = 1,

  /** 考试学分 */
  EXAM = 2,

  /** 培训学分 */
  TRAINING = 3,

  /** 活动学分 */
  ACTIVITY = 4,
}

/**
 * 学分状态枚举
 */
enum CreditStatus {
  /** 有效 */
  VALID = 1,

  /** 已过期 */
  EXPIRED = 2,

  /** 已使用 */
  USED = 3,

  /** 已冻结 */
  FROZEN = 4,
}
```

### 5.2 学分汇总 (CreditSummary)

```typescript
/**
 * 学分汇总
 * 描述：用户学分的汇总统计
 */
@Observed
class CreditSummary {
  /** 用户 ID */
  userId: string = "";

  /** 总学分 */
  totalCredits: number = 0;

  /** 有效学分 */
  validCredits: number = 0;

  /** 已过期学分 */
  expiredCredits: number = 0;

  /** 即将过期学分 (30 天内) */
  expiringCredits: number = 0;

  /** 按类型统计 */
  creditsByType: CreditTypeCount[] = [];

  /** 本年度获得学分 */
  yearlyCredits: number = 0;

  /** 学分有效期截止日期 */
  creditExpireDate?: string = undefined;
}

/**
 * 学分类型统计
 */
@Observed
class CreditTypeCount {
  /** 学分类型 */
  type: CreditType = CreditType.COURSE;

  /** 类型名称 */
  typeName: string = "";

  /** 学分数值 */
  count: number = 0;
}
```

### 5.3 学分规则 (CreditRule)

```typescript
/**
 * 学分规则
 * 描述：学分获取的规则配置
 */
@Observed
class CreditRule {
  /** 规则 ID */
  id: string = "";

  /** 规则名称 */
  ruleName: string = "";

  /** 规则类型 */
  ruleType: CreditRuleType = CreditRuleType.COURSE_COMPLETION;

  /** 学分数值 */
  creditAmount: number = 0;

  /** 适用课程 ID 列表 (为空表示适用所有) */
  applicableCourseIds: string[] = [];

  /** 适用分类 ID 列表 */
  applicableCategoryIds: string[] = [];

  /** 每日获取上限 */
  dailyLimit: number = 0;

  /** 总获取上限 (0 表示无限制) */
  totalLimit: number = 0;

  /** 是否启用 */
  enabled: boolean = true;

  /** 生效时间 */
  effectiveFrom: number = 0;

  /** 过期时间 */
  effectiveTo?: number = undefined;
}

/**
 * 学分规则类型枚举
 */
enum CreditRuleType {
  /** 完成课程 */
  COURSE_COMPLETION = 1,

  /** 完成章节 */
  CHAPTER_COMPLETION = 2,

  /** 通过考试 */
  EXAM_PASS = 3,

  /** 每日签到 */
  DAILY_CHECKIN = 4,

  /** 邀请好友 */
  INVITE_FRIEND = 5,
}
```

---

## 6. 考试测验模型

### 6.1 考试实体 (Exam)

```typescript
/**
 * 考试实体
 */
@Observed
class Exam {
  /** 考试 ID */
  id: string = "";

  /** 考试标题 */
  title: string = "";

  /** 考试描述 */
  description: string = "";

  /** 关联课程 ID */
  courseId: string = "";

  /** 考试类型 */
  examType: ExamType = ExamType.QUIZ;

  /** 总题目数 */
  totalQuestions: number = 0;

  /** 总分值 */
  totalScore: number = 100;

  /** 及格分数 */
  passingScore: number = 60;

  /** 考试时长 (分钟) */
  duration: number = 30;

  /** 可考次数 (-1 表示无限次) */
  maxAttempts: number = -1;

  /** 答题顺序 */
  questionOrder: QuestionOrder = QuestionOrder.FIXED;

  /** 是否显示答案 */
  showAnswer: boolean = false;

  /** 开始时间 */
  startTime?: number = undefined;

  /** 结束时间 */
  endTime?: number = undefined;

  /** 状态 */
  status: ExamStatus = ExamStatus.PUBLISHED;
}

/**
 * 考试类型枚举
 */
enum ExamType {
  /** 随堂测验 */
  QUIZ = 1,

  /** 章节测试 */
  CHAPTER_TEST = 2,

  /** 结业考试 */
  FINAL_EXAM = 3,

  /** 模拟考试 */
  MOCK_EXAM = 4,
}

/**
 * 题目排序枚举
 */
enum QuestionOrder {
  /** 固定顺序 */
  FIXED = 0,

  /** 随机顺序 */
  RANDOM = 1,
}

/**
 * 考试状态枚举
 */
enum ExamStatus {
  /** 草稿 */
  DRAFT = 0,

  /** 进行中 */
  ONGOING = 1,

  /** 已结束 */
  ENDED = 2,
}
```

### 6.2 题目实体 (Question)

```typescript
/**
 * 题目实体
 */
@Observed
class Question {
  /** 题目 ID */
  id: string = "";

  /** 考试 ID */
  examId: string = "";

  /** 题目类型 */
  questionType: QuestionType = QuestionType.SINGLE_CHOICE;

  /** 题目内容 (可含 HTML) */
  content: string = "";

  /** 题目解析 */
  analysis?: string = undefined;

  /** 分值 */
  score: number = 1;

  /** 难度 */
  difficulty: number = 1;

  /** 排序 */
  order: number = 1;

  /** 选项列表 */
  options: QuestionOption[] = [];

  /** 正确答案 */
  correctAnswers: string[] = [];
}

/**
 * 题目类型枚举
 */
enum QuestionType {
  /** 单选题 */
  SINGLE_CHOICE = 1,

  /** 多选题 */
  MULTIPLE_CHOICE = 2,

  /** 判断题 */
  TRUE_FALSE = 3,

  /** 填空题 */
  FILL_BLANK = 4,

  /** 简答题 */
  SHORT_ANSWER = 5,
}

/**
 * 题目选项
 */
@Observed
class QuestionOption {
  /** 选项 ID */
  id: string = "";

  /** 选项标识 (A/B/C/D) */
  key: string = "A";

  /** 选项内容 */
  content: string = "";

  /** 是否正确 */
  isCorrect: boolean = false;
}
```

### 6.3 考试记录 (ExamRecord)

```typescript
/**
 * 考试记录
 */
@Observed
class ExamRecord {
  /** 记录 ID */
  id: string = "";

  /** 用户 ID */
  userId: string = "";

  /** 考试 ID */
  examId: string = "";

  /** 试卷总分 */
  totalScore: number = 0;

  /** 用户得分 */
  userScore: number = 0;

  /** 是否正确 */
  isPassed: boolean = false;

  /** 开始时间 */
  startedAt: number = 0;

  /** 提交时间 */
  submittedAt: number = 0;

  /** 用时 (秒) */
  usedTime: number = 0;

  /** 用户答案 */
  userAnswers: UserAnswer[] = [];

  /** 第几次尝试 */
  attemptNumber: number = 1;
}

/**
 * 用户答案
 */
@Observed
class UserAnswer {
  /** 题目 ID */
  questionId: string = "";

  /** 用户选择的答案 */
  selectedOptions: string[] = [];

  /** 是否正确 */
  isCorrect: boolean = false;

  /** 获得分数 */
  score: number = 0;
}
```

---

## 7. 通用 API 响应模型

### 7.1 基础响应结构

```typescript
/**
 * API 响应基础结构
 * @template T 响应数据类型
 */
interface ApiResponse<T> {
  /** 响应码 */
  code: ResponseCode;

  /** 响应消息 */
  message: string;

  /** 响应数据 */
  data: T | null;

  /** 时间戳 */
  timestamp: number;

  /** 追踪 ID (用于日志排查) */
  traceId?: string;
}

/**
 * 统一响应码枚举
 */
enum ResponseCode {
  /** 成功 */
  SUCCESS = "B00000",

  /** 通用错误 */
  ERROR = "B00001",

  /** 未授权 (Token 失效) */
  UNAUTHORIZED = "B00002",

  /** 禁止访问 */
  FORBIDDEN = "B00003",

  /** 资源不存在 */
  NOT_FOUND = "B00004",

  /** 方法不允许 */
  METHOD_NOT_ALLOWED = "B00005",

  /** 参数校验错误 */
  VALIDATION_ERROR = "B00010",

  /** 业务逻辑错误 */
  BUSINESS_ERROR = "B00020",

  /** 重复操作 */
  DUPLICATE_REQUEST = "B00021",

  /** 频率限制 */
  RATE_LIMITED = "B00030",

  /** 服务器内部错误 */
  SERVER_ERROR = "B00050",

  /** 服务不可用 */
  SERVICE_UNAVAILABLE = "B00051",
}
```

### 7.2 分页响应结构

```typescript
/**
 * 分页请求参数
 */
interface PageRequest {
  /** 当前页码 (从 1 开始) */
  page: number;

  /** 每页数量 */
  pageSize: number;

  /** 排序字段 */
  sortField?: string;

  /** 排序方向 */
  sortOrder?: "asc" | "desc";
}

/**
 * 分页响应结构
 * @template T 列表项数据类型
 */
interface PageResponse<T> {
  /** 数据列表 */
  list: T[];

  /** 总记录数 */
  total: number;

  /** 当前页码 */
  page: number;

  /** 每页数量 */
  pageSize: number;

  /** 总页数 */
  totalPages: number;

  /** 是否有下一页 */
  hasNext: boolean;

  /** 是否有上一页 */
  hasPrev: boolean;
}
```

### 7.3 文件上传响应

```typescript
/**
 * 文件上传响应
 */
interface UploadResponse {
  /** 文件 ID */
  fileId: string;

  /** 文件 URL */
  fileUrl: string;

  /** 文件名 */
  fileName: string;

  /** 文件大小 (字节) */
  fileSize: number;

  /** 文件类型 (MIME) */
  fileType: string;

  /** 上传时间 */
  uploadedAt: number;
}
```

---

## 8. 本地存储模型

### 8.1 用户设置 (UserSettings)

```typescript
/**
 * 用户本地设置
 * 描述：存储在 Preferences 中的用户配置
 */
@Observed
class UserSettings {
  /** 用户 Token */
  token: string = "";

  /** Token 过期时间 */
  tokenExpireAt: number = 0;

  /** 账号类型 */
  accountType: number = 0;

  /** 是否首次启动 */
  isFirstLaunch: boolean = true;

  /** 已读协议版本 */
  agreedTermsVersion: string = "";

  /** 隐私政策版本 */
  agreedPrivacyVersion: string = "";

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
}

/**
 * 字体大小枚举
 */
enum FontSize {
  SMALL = 0,
  NORMAL = 1,
  LARGE = 2,
  EXTRA_LARGE = 3,
}

/**
 * 主题模式枚举
 */
enum ThemeMode {
  SYSTEM = 0,
  LIGHT = 1,
  DARK = 2,
}
```

### 8.2 缓存数据模型

```typescript
/**
 * 缓存入口
 */
interface CacheEntry<T> {
  /** 缓存数据 */
  data: T;

  /** 缓存时间戳 */
  cachedAt: number;

  /** 过期时间戳 */
  expireAt?: number;

  /** 缓存键 */
  key: string;
}

/**
 * 缓存配置
 */
interface CacheConfig {
  /** 默认过期时间 (秒) */
  defaultExpireSeconds: number;

  /** 最大缓存数量 */
  maxCacheSize: number;

  /** 是否启用 */
  enabled: boolean;
}
```

### 8.3 广告数据 (AdvertData)

```typescript
/**
 * 开屏广告数据
 */
@Observed
class AdvertData {
  /** 是否展示广告 */
  showAd: boolean = false;

  /** 是否全屏 */
  isFull: boolean = true;

  /** 倒计时秒数 */
  adTime: number = 5;

  /** 广告跳转 URL */
  adUrl: string = "";

  /** 广告图片 URL */
  adImg: string = "";

  /** 广告开始时间 */
  startTime?: number = undefined;

  /** 广告结束时间 */
  endTime?: number = undefined;
}
```

---

## 9. 设备相关模型

### 9.1 设备信息 (DeviceInfo)

```typescript
/**
 * 设备信息
 */
interface DeviceInfo {
  /** 设备类型 */
  deviceType: string;

  /** 市场型号名称 */
  marketName: string;

  /** 设备厂商 */
  manufacturer: string;

  /** 系统版本 */
  osFullName: string;

  /** API 版本 */
  apiVersion: number;

  /** 显示版本 */
  displayVersion: string;

  /** 屏幕宽度 */
  screenWidth: number;

  /** 屏幕高度 */
  screenHeight: number;

  /** 屏幕密度 */
  screenDensity: number;
}
```

### 9.2 应用信息 (AppInfo)

```typescript
/**
 * 应用信息
 */
interface AppInfo {
  /** 应用名称 */
  appName: string;

  /** 版本名 */
  versionName: string;

  /** 版本号 */
  versionCode: number;

  /** 包名 */
  bundleName: string;

  /** 供应商 */
  vendor: string;

  /** 设备宽度 */
  deviceWidth: number;

  /** 设备高度 */
  deviceHeight: number;
}
```

### 9.3 网络请求设备信息

```typescript
/**
 * 网络请求中上报的设备信息
 */
interface RequestDeviceInfo {
  /** 设备名称 */
  device_name: string;

  /** 系统版本 */
  device_sysVersion: string;

  /** 设备品牌 */
  device_brand: string;

  /** 包名 */
  bundleId: string;

  /** App 版本 */
  appVersion: string;

  /** 屏幕分辨率 */
  dpi: string;

  /** 设备 ID */
  deviceId?: string;

  /** 友盟 DeviceToken */
  channelToken?: string;
}
```

---

## 10. 通知消息模型

### 10.1 通知消息 (Notification)

```typescript
/**
 * 通知消息
 */
@Observed
class NotificationMessage {
  /** 通知 ID */
  id: string = "";

  /** 用户 ID */
  userId: string = "";

  /** 通知类型 */
  type: NotificationType = NotificationType.SYSTEM;

  /** 通知标题 */
  title: string = "";

  /** 通知内容 */
  content: string = "";

  /** 跳转类型 */
  actionType: ActionType = ActionType.URL;

  /** 跳转数据 (URL 或课程 ID 等) */
  actionData: string = "";

  /** 是否已读 */
  isRead: boolean = false;

  /** 创建时间 */
  createdAt: number = 0;

  /** 过期时间 */
  expireAt?: number = undefined;
}

/**
 * 通知类型枚举
 */
enum NotificationType {
  /** 系统通知 */
  SYSTEM = 1,

  /** 课程通知 */
  COURSE = 2,

  /** 考试通知 */
  EXAM = 3,

  /** 学分通知 */
  CREDIT = 4,

  /** 活动通知 */
  ACTIVITY = 5,
}

/**
 * 动作类型枚举
 */
enum ActionType {
  /** 无动作 */
  NONE = 0,

  /** 打开 URL */
  URL = 1,

  /** 打开课程详情 */
  COURSE_DETAIL = 2,

  /** 打开考试 */
  EXAM = 3,

  /** 打开个人中心 */
  PROFILE = 4,
}
```

---

## 11. 版本更新模型

### 11.1 版本信息 (AppVersion)

```typescript
/**
 * App 版本信息
 */
@Observed
class AppVersion {
  /** 版本 ID */
  id: string = "";

  /** 版本号 */
  versionCode: number = 0;

  /** 版本名 */
  versionName: string = "";

  /** 版本描述 */
  description: string = "";

  /** 更新内容 (HTML) */
  updateContent: string = "";

  /** 下载 URL */
  downloadUrl: string = "";

  /** 文件大小 (字节) */
  fileSize: number = 0;

  /** 是否强制更新 */
  forceUpdate: boolean = false;

  /** 是否静默更新 */
  silentUpdate: boolean = false;

  /** 适用平台 */
  platform: string = "harmonyos";

  /** 发布时间 */
  publishedAt: number = 0;

  /** 最低支持版本 */
  minSupportVersion?: string = undefined;
}
```

---

## 附录

### A. 数据类型快速参考

| 业务领域 | 核心实体              | 请求模型                      | 响应模型                   |
| -------- | --------------------- | ----------------------------- | -------------------------- |
| 用户     | User, UserProfile     | LoginRequest, RegisterRequest | LoginResponse              |
| 课程     | Course, CourseChapter | CourseQuery                   | PageResponse<Course>       |
| 学习     | LearningProgress      | UpdateProgressRequest         | LearningStatistics         |
| 学分     | UserCredit            | CreditExchangeRequest         | CreditSummary              |
| 考试     | Exam, Question        | SubmitExamRequest             | ExamRecord                 |
| 通知     | NotificationMessage   | MarkReadRequest               | PageResponse<Notification> |

### B. 默认值规范

所有模型类的属性应设置合理的默认值:

- 字符串：`''`
- 数字：`0`
- 布尔值：`false`
- 枚举：取第一个有效值
- 数组：`[]`
- 对象：`new ClassName()` 或 `null`

### C. 变更日志

| 版本 | 日期       | 作者             | 变更说明 |
| ---- | ---------- | ---------------- | -------- |
| v1.0 | 2026-03-25 | mobile-architect | 初始版本 |
