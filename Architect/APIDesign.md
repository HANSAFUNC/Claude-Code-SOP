# HarmonyOS 保险培训平台 - API 接口设计规范

> 本文档定义了保险培训平台应用的 API 接口设计规范，包括基础规范、接口列表、错误处理、安全机制等内容。

---

## 1. 接口设计原则

### 1.1 RESTful 风格

- 使用资源命名：`/api/users`, `/api/courses`
- 使用 HTTP 动词表示操作：GET(查询), POST(创建), PUT(更新), DELETE(删除)
- 资源层级不超过 3 级：`/api/courses/{id}/sections`

### 1.2 统一响应格式

所有 API 响应遵循统一的数据结构:

```typescript
interface ApiResponse<T> {
  code: string; // 响应码
  message: string; // 响应消息
  data: T | null; // 响应数据
  timestamp: number; // 时间戳
  traceId?: string; // 追踪 ID
}
```

### 1.3 版本控制

- API 版本在路径中体现：`/api/v1/courses`
- 重大变更时升级版本号
- 旧版本至少保留 3 个月过渡期

### 1.4 分页规范

列表接口统一使用以下分页参数:

```typescript
interface PageRequest {
  page: number; // 当前页码，从 1 开始
  pageSize: number; // 每页数量，默认 20，最大 100
  sort?: string; // 排序字段
  order?: "asc" | "desc"; // 排序方向
}
```

分页响应:

```typescript
interface PageResponse<T> {
  list: T[]; // 数据列表
  total: number; // 总记录数
  page: number; // 当前页码
  pageSize: number; // 每页数量
  totalPages: number; // 总页数
}
```

---

## 2. 基础配置

### 2.1 环境配置

```typescript
// 环境配置常量
const API_CONFIG = {
  // 开发环境
  development: {
    baseUrl: "https://crm.ida1998.com/api",
    timeout: 30000,
  },
  // 测试环境 (QA)
  test: {
    baseUrl: "https://qa9527.api.imm.plus:18497/api",
    timeout: 30000,
  },
  // 生产环境
  production: {
    baseUrl: "https://api.imm-plus.com/api",
    timeout: 30000,
  },
};

// 当前环境
const CURRENT_ENV = "development"; // 或 'test', 'production'
```

### 2.2 请求头规范

```typescript
// 标准请求头
const DEFAULT_HEADERS = {
  "Content-Type": "application/json; charset=UTF-8",
  Accept: "application/json",
};

// 认证请求头
const AUTH_HEADERS = {
  ...DEFAULT_HEADERS,
  Authorization: `Bearer ${token}`, // Token 认证
};

// 自定义请求头
const CUSTOM_HEADERS = {
  ...DEFAULT_HEADERS,
  "X-Device-Id": deviceId, // 设备 ID
  "X-App-Version": versionName, // App 版本
  "X-Platform": "harmonyos", // 平台
  "X-Channel": channelId, // 渠道
};
```

### 2.3 超时配置

| 接口类型 | 超时时间 | 说明       |
| -------- | -------- | ---------- |
| 普通请求 | 30 秒    | 大部分 API |
| 文件上传 | 120 秒   | 大文件上传 |
| 文件下载 | 120 秒   | 大文件下载 |
| 流式接口 | 300 秒   | 长连接接口 |

---

## 3. 认证授权 API

### 3.1 账号密码登录

```typescript
// 请求
POST /api/v1/auth/login
Content-Type: application/json

{
  "account": "username",
  "password": "password123",
  "loginType": 0,
  "deviceId": "xxx-xxx-xxx",
  "deviceInfo": "{\"device_name\":\"HUAWEI Mate 60\",...}"
}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "tokenExpireAt": 1711555200000,
    "user": {
      "id": "1",
      "username": "zhangsan",
      "nickname": "张三",
      "avatar": "https://..."
    },
    "needCompleteProfile": false
  }
}
```

### 3.2 企业微信登录 (内部)

```typescript
// 请求
GET /api/v1/auth/qiwei/internal?code=AUTH_CODE&deviceId=xxx

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "token": "...",
    "tokenExpireAt": 1711555200000,
    "user": {...}
  }
}
```

### 3.3 企业微信登录 (外部)

```typescript
// 请求
GET /api/v1/auth/qiwei/external?deviceId=xxx

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "token": "...",
    "user": {...}
  }
}
```

### 3.4 退出登录

```typescript
// 请求
POST /api/v1/auth/logout
Authorization: Bearer {token}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": null
}
```

### 3.5 刷新 Token

```typescript
// 请求
POST /api/v1/auth/refresh
Authorization: Bearer {token}

{
  "refreshToken": "xxx"
}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "token": "new_token...",
    "tokenExpireAt": 1711555200000
  }
}
```

### 3.6 获取当前用户信息

```typescript
// 请求
GET /api/v1/auth/me
Authorization: Bearer {token}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "id": "1",
    "username": "zhangsan",
    "nickname": "张三",
    "avatar": "https://...",
    "phone": "13800138000",
    "email": "zhangsan@example.com",
    "department": "培训部",
    "position": "培训专员",
    "accountType": 1
  }
}
```

---

## 4. 课程相关 API

### 4.1 获取课程列表

```typescript
// 请求
GET /api/v1/courses
Authorization: Bearer {token}

Query Parameters:
- page: 1           // 页码
- pageSize: 20      // 每页数量
- categoryId: xxx   // 分类 ID (可选)
- difficulty: 1     // 难度级别 (可选)
- keyword: xxx      // 搜索关键词 (可选)
- sort: 0           // 排序方式 (可选)

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "list": [
      {
        "id": "1",
        "title": "保险基础知识",
        "subtitle": "保险行业入门课程",
        "coverImage": "https://...",
        "instructorName": "李老师",
        "categoryName": "基础课程",
        "duration": 120,
        "credit": 10,
        "difficulty": 1,
        "viewCount": 1000,
        "rating": 4.8,
        "learnerCount": 500
      }
    ],
    "total": 100,
    "page": 1,
    "pageSize": 20,
    "totalPages": 5
  }
}
```

### 4.2 获取课程详情

```typescript
// 请求
GET /api/v1/courses/{courseId}
Authorization: Bearer {token}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "id": "1",
    "title": "保险基础知识",
    "description": "<p>课程详细介绍...</p>",
    "coverImage": "https://...",
    "instructorId": "100",
    "instructorName": "李老师",
    "instructorAvatar": "https://...",
    "categoryId": "10",
    "categoryName": "基础课程",
    "duration": 120,
    "videoDuration": 7200,
    "credit": 10,
    "difficulty": 1,
    "status": 1,
    "viewCount": 1000,
    "rating": 4.8,
    "reviewCount": 50,
    "chapters": [
      {
        "id": "1",
        "title": "第一章 保险概述",
        "order": 1,
        "sections": [
          {
            "id": "1-1",
            "title": "1.1 保险的定义",
            "type": 1,
            "videoUrl": "https://...",
            "videoDuration": 600,
            "order": 1,
            "isFreePreview": true
          }
        ]
      }
    ]
  }
}
```

### 4.3 获取课程分类

```typescript
// 请求
GET /api/v1/course/categories
Authorization: Bearer {token}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": [
    {
      "id": "1",
      "name": "基础课程",
      "parentId": "0",
      "icon": "https://...",
      "order": 1,
      "children": [
        {
          "id": "1-1",
          "name": "保险入门",
          "parentId": "1",
          "order": 1
        }
      ]
    }
  ]
}
```

### 4.4 获取推荐课程

```typescript
// 请求
GET /api/v1/courses/recommended
Authorization: Bearer {token}

Query Parameters:
- limit: 10    // 返回数量

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": [
    {
      "id": "1",
      "title": "保险基础知识",
      "coverImage": "https://...",
      "credit": 10,
      "learnerCount": 500,
      "isRecommended": true,
      "recommendOrder": 1
    }
  ]
}
```

---

## 5. 学习进度 API

### 5.1 获取学习进度

```typescript
// 请求
GET /api/v1/learning/progress/{courseId}
Authorization: Bearer {token}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "id": "1",
    "userId": "100",
    "courseId": "1",
    "currentChapterId": "1",
    "currentSectionId": "1-2",
    "watchedDuration": 1800,
    "totalDuration": 7200,
    "progressPercent": 25,
    "status": 1,
    "lastWatchedAt": 1711455200000,
    "sectionProgress": [
      {
        "sectionId": "1-1",
        "completed": true,
        "watchedDuration": 600,
        "lastWatchedAt": 1711455000000
      }
    ]
  }
}
```

### 5.2 更新学习进度

```typescript
// 请求
PUT /api/v1/learning/progress
Authorization: Bearer {token}
Content-Type: application/json

{
  "courseId": "1",
  "sectionId": "1-2",
  "watchedDuration": 300,
  "completed": false
}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "progressPercent": 30,
    "updated": true
  }
}
```

### 5.3 完成课程

```typescript
// 请求
POST /api/v1/learning/complete/{courseId}
Authorization: Bearer {token}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "completed": true,
    "creditEarned": 10,
    "completedAt": 1711555200000
  }
}
```

### 5.4 获取学习统计

```typescript
// 请求
GET /api/v1/learning/statistics
Authorization: Bearer {token}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "userId": "100",
    "totalCourses": 20,
    "completedCourses": 5,
    "learningCourses": 3,
    "totalLearningMinutes": 1200,
    "totalCredits": 50,
    "weeklyLearningMinutes": 120,
    "monthlyLearningMinutes": 480,
    "continuousDays": 7,
    "weeklyTrend": [
      {
        "date": "2026-03-19",
        "minutes": 60,
        "completedCourses": 1
      }
    ]
  }
}
```

### 5.5 获取学习记录列表

```typescript
// 请求
GET /api/v1/learning/records
Authorization: Bearer {token}

Query Parameters:
- page: 1
- pageSize: 20
- courseId: xxx (可选)
- startDate: 2026-01-01 (可选)
- endDate: 2026-03-25 (可选)

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "list": [
      {
        "id": "1",
        "courseId": "1",
        "courseName": "保险基础知识",
        "sectionId": "1-1",
        "startedAt": 1711455000000,
        "endedAt": 1711455600000,
        "duration": 600,
        "completed": true
      }
    ],
    "total": 50,
    "page": 1,
    "pageSize": 20
  }
}
```

---

## 6. 学分相关 API

### 6.1 获取学分汇总

```typescript
// 请求
GET /api/v1/credits/summary
Authorization: Bearer {token}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "userId": "100",
    "totalCredits": 150,
    "validCredits": 120,
    "expiredCredits": 10,
    "expiringCredits": 20,
    "yearlyCredits": 80,
    "creditsByType": [
      {
        "type": 1,
        "typeName": "课程学分",
        "count": 100
      },
      {
        "type": 2,
        "typeName": "考试学分",
        "count": 50
      }
    ]
  }
}
```

### 6.2 获取学分记录列表

```typescript
// 请求
GET /api/v1/credits/records
Authorization: Bearer {token}

Query Parameters:
- page: 1
- pageSize: 20
- type: 1 (可选，学分类型)
- status: 1 (可选，状态)

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "list": [
      {
        "id": "1",
        "courseId": "1",
        "courseName": "保险基础知识",
        "creditAmount": 10,
        "creditType": 1,
        "earnedAt": 1711555200000,
        "expireAt": 1743091200000,
        "status": 1
      }
    ],
    "total": 30,
    "page": 1,
    "pageSize": 20
  }
}
```

### 6.3 获取学分规则

```typescript
// 请求
GET /api/v1/credits/rules
Authorization: Bearer {token}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": [
    {
      "id": "1",
      "ruleName": "完成课程奖励",
      "ruleType": 1,
      "creditAmount": 10,
      "dailyLimit": 50,
      "enabled": true
    }
  ]
}
```

---

## 7. 考试测验 API

### 7.1 获取考试列表

```typescript
// 请求
GET /api/v1/exams
Authorization: Bearer {token}

Query Parameters:
- courseId: xxx (可选)
- status: 1 (可选)

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "list": [
      {
        "id": "1",
        "title": "保险基础知识测试",
        "courseId": "1",
        "courseName": "保险基础知识",
        "examType": 1,
        "totalQuestions": 20,
        "totalScore": 100,
        "passingScore": 60,
        "duration": 30,
        "maxAttempts": 3,
        "status": 1
      }
    ]
  }
}
```

### 7.2 获取考试详情

```typescript
// 请求
GET /api/v1/exams/{examId}
Authorization: Bearer {token}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "id": "1",
    "title": "保险基础知识测试",
    "description": "本测试共 20 题，满分 100 分...",
    "examType": 1,
    "totalQuestions": 20,
    "totalScore": 100,
    "passingScore": 60,
    "duration": 30,
    "questions": [
      {
        "id": "1",
        "questionType": 1,
        "content": "保险的定义是什么？",
        "score": 5,
        "options": [
          {"id": "1", "key": "A", "content": "选项 A"},
          {"id": "2", "key": "B", "content": "选项 B"},
          {"id": "3", "key": "C", "content": "选项 C"},
          {"id": "4", "key": "D", "content": "选项 D"}
        ]
      }
    ]
  }
}
```

### 7.3 提交考试

```typescript
// 请求
POST /api/v1/exams/{examId}/submit
Authorization: Bearer {token}
Content-Type: application/json

{
  "userAnswers": [
    {
      "questionId": "1",
      "selectedOptions": ["A"]
    }
  ],
  "usedTime": 1200
}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "examRecordId": "1",
    "userScore": 85,
    "totalScore": 100,
    "isPassed": true,
    "correctCount": 17,
    "totalQuestions": 20,
    "usedTime": 1200
  }
}
```

### 7.4 获取考试记录

```typescript
// 请求
GET /api/v1/exams/records
Authorization: Bearer {token}

Query Parameters:
- page: 1
- pageSize: 20

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "list": [
      {
        "id": "1",
        "examId": "1",
        "examTitle": "保险基础知识测试",
        "userScore": 85,
        "totalScore": 100,
        "isPassed": true,
        "submittedAt": 1711555200000,
        "usedTime": 1200
      }
    ],
    "total": 10,
    "page": 1,
    "pageSize": 20
  }
}
```

---

## 8. 用户相关 API

### 8.1 更新用户信息

```typescript
// 请求
PUT /api/v1/users/profile
Authorization: Bearer {token}
Content-Type: application/json

{
  "nickname": "新昵称",
  "avatar": "https://...",
  "phone": "13800138000",
  "email": "new@example.com"
}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "updated": true
  }
}
```

### 8.2 修改密码

```typescript
// 请求
POST /api/v1/users/change-password
Authorization: Bearer {token}
Content-Type: application/json

{
  "oldPassword": "old123",
  "newPassword": "new123"
}

// 响应
{
  "code": "B00000",
  "message": "密码修改成功",
  "data": null
}
```

### 8.3 发送短信验证码

```typescript
// 请求
POST /api/v1/users/sms/send
Content-Type: application/json

{
  "phone": "13800138000",
  "smsType": 1
}

// 响应
{
  "code": "B00000",
  "message": "验证码已发送",
  "data": {
    "expireSeconds": 300
  }
}
```

### 8.4 验证短信验证码

```typescript
// 请求
POST /api/v1/users/sms/verify
Content-Type: application/json

{
  "phone": "13800138000",
  "smsCode": "123456",
  "smsType": 1
}

// 响应
{
  "code": "B00000",
  "message": "验证成功",
  "data": {
    "verified": true
  }
}
```

---

## 9. 通知消息 API

### 9.1 获取通知列表

```typescript
// 请求
GET /api/v1/notifications
Authorization: Bearer {token}

Query Parameters:
- page: 1
- pageSize: 20
- type: 1 (可选)
- isRead: false (可选)

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "list": [
      {
        "id": "1",
        "type": 1,
        "typeName": "系统通知",
        "title": "新课程上线",
        "content": "《保险销售技巧》已上线...",
        "actionType": 2,
        "actionData": "1",
        "isRead": false,
        "createdAt": 1711555200000
      }
    ],
    "total": 50,
    "page": 1,
    "pageSize": 20,
    "unreadCount": 5
  }
}
```

### 9.2 标记通知已读

```typescript
// 请求
POST /api/v1/notifications/read
Authorization: Bearer {token}
Content-Type: application/json

{
  "ids": ["1", "2", "3"]
}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "count": 3
  }
}
```

### 9.3 获取未读通知数量

```typescript
// 请求
GET /api/v1/notifications/unread/count
Authorization: Bearer {token}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "count": 5
  }
}
```

---

## 10. 文件上传 API

### 10.1 单文件上传

```typescript
// 请求
POST /api/v1/files/upload
Authorization: Bearer {token}
Content-Type: multipart/form-data

FormData:
- file: (binary)

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "fileId": "1",
    "fileUrl": "https://...",
    "fileName": "image.jpg",
    "fileSize": 102400,
    "fileType": "image/jpeg",
    "uploadedAt": 1711555200000
  }
}
```

---

## 11. 广告相关 API

### 11.1 获取开屏广告

```typescript
// 请求
GET /api/v1/advert/splash
Authorization: Bearer {token}

// 响应
{
  "code": "B00000",
  "message": "成功",
  "data": {
    "showAd": true,
    "isFull": true,
    "adTime": 5,
    "adUrl": "https://...",
    "adImg": "https://...",
    "startTime": 1711455200000,
    "endTime": 1711655200000
  }
}
```

---

## 12. 错误处理

### 12.1 错误码定义

| 错误码 | 说明           | 处理建议               |
| ------ | -------------- | ---------------------- |
| B00000 | 成功           | -                      |
| B00001 | 通用错误       | 提示用户稍后重试       |
| B00002 | 未授权         | Token 失效，跳转登录页 |
| B00003 | 禁止访问       | 提示无权限             |
| B00004 | 资源不存在     | 提示资源不存在         |
| B00005 | 方法不允许     | 检查请求方法           |
| B00010 | 参数校验错误   | 提示具体错误信息       |
| B00020 | 业务逻辑错误   | 提示具体业务错误       |
| B00021 | 重复操作       | 提示操作过于频繁       |
| B00030 | 频率限制       | 提示稍后重试           |
| B00050 | 服务器内部错误 | 提示稍后重试，联系开发 |
| B00051 | 服务不可用     | 提示服务维护中         |

### 12.2 错误处理流程

```typescript
// 客户端错误处理伪代码
async function handleApiError(error: ApiError) {
  switch (error.code) {
    case "B00002": // 未授权
      // 清除本地 Token
      await clearToken();
      // 跳转登录页
      router.replaceUrl({ url: "pages/login/Login" });
      break;

    case "B00010": // 参数错误
      // 显示具体错误消息
      showToast(error.message);
      break;

    case "B00030": // 频率限制
      // 防抖处理
      showDebouncedToast("操作过于频繁");
      break;

    default:
      // 通用错误提示
      showToast(error.message || "系统错误");
  }
}
```

### 12.3 请求重试机制

```typescript
// 重试配置
const RETRY_CONFIG = {
  maxRetries: 3, // 最大重试次数
  retryDelay: 1000, // 重试间隔 (ms)
  retryableCodes: [
    // 可重试的错误码
    "B00001",
    "B00050",
    "B00051",
  ],
};

// 重试逻辑伪代码
async function requestWithRetry(config: RequestConfig) {
  let lastError: Error | null = null;

  for (let i = 0; i < RETRY_CONFIG.maxRetries; i++) {
    try {
      return await request(config);
    } catch (error) {
      lastError = error;

      // 判断是否可重试
      if (!RETRY_CONFIG.retryableCodes.includes(error.code)) {
        throw error;
      }

      // 等待后重试
      await sleep(RETRY_CONFIG.retryDelay * (i + 1));
    }
  }

  throw lastError;
}
```

---

## 13. 安全机制

### 13.1 Token 管理

```typescript
// Token 存储
- 存储位置：Preferences (加密存储)
- Token 前缀：Bearer
- 有效期：默认 7 天

// Token 刷新机制
- 过期前 1 小时自动刷新
- 刷新失败清除本地 Token
- 刷新期间请求队列等待
```

### 13.2 请求签名

```typescript
// 签名生成算法
function generateSignature(
  params: Object,
  timestamp: number,
  nonce: string,
): string {
  // 1. 参数排序
  const sortedKeys = Object.keys(params).sort();

  // 2. 拼接字符串
  const signString =
    sortedKeys.map((key) => `${key}=${params[key]}`).join("&") +
    `&timestamp=${timestamp}&nonce=${nonce}&appSecret=${APP_SECRET}`;

  // 3. MD5 加密
  return md5(signString).toUpperCase();
}

// 请求头添加签名
headers["X-Signature"] = signature;
headers["X-Timestamp"] = timestamp;
headers["X-Nonce"] = nonce;
```

### 13.3 数据加密

敏感数据传输需加密:

- 密码：BCrypt 加密后传输
- 手机号：AES 加密
- 身份证：AES 加密

---

## 14. API 版本历史

| 版本 | 日期       | 变更说明                   |
| ---- | ---------- | -------------------------- |
| v1.0 | 2026-03-25 | 初始版本，包含基础功能 API |

---

## 附录

### A. 完整 API 清单

| 模块     | 接口数 | 说明                    |
| -------- | ------ | ----------------------- |
| 认证授权 | 6      | 登录/退出/刷新 Token 等 |
| 课程管理 | 4      | 列表/详情/分类/推荐     |
| 学习进度 | 5      | 进度查询/更新/统计等    |
| 学分管理 | 3      | 汇总/记录/规则          |
| 考试测验 | 4      | 列表/详情/提交/记录     |
| 用户管理 | 4      | 信息更新/改密/短信      |
| 通知消息 | 3      | 列表/已读/未读数        |
| 文件上传 | 1      | 单文件上传              |
| 广告     | 1      | 开屏广告                |
| **合计** | **31** |                         |

### B. 请求工具类参考

```typescript
// HttpClient 使用示例
import { HttpClient } from "basic";

// GET 请求
const courses = await HttpClient.get<PageResponse<Course>>("/api/v1/courses", {
  page: 1,
  pageSize: 20,
});

// POST 请求
const loginResult = await HttpClient.post<LoginResponse>("/api/v1/auth/login", {
  account: "username",
  password: "password",
});

// 带认证头的请求
const userInfo = await HttpClient.get<User>("/api/v1/auth/me", null, {
  needAuth: true,
});
```
