# 实施计划目录

> 存放所有规划阶段产出的实施计划文档

---

## 📁 目录说明

### 文件命名规范

```
YYYY-MM-DD-<feature-name>.md
```

### 示例

- `2026-04-13-course-exchange.md`
- `2026-04-15-user-auth.md`
- `2026-04-20-credit-system.md`

---

## 📝 文档模板

```markdown
# {功能名称} - 实施计划

**日期:** YYYY-MM-DD
**设计规格:** ../specs/YYYY-MM-DD-<topic>-design.md
**所需技能:** brainstorming, tdd, code-review

---

## 文件结构映射

### 新增文件

| 文件路径 | 类型 | 说明 |
|----------|------|------|
| `path/to/NewFile.ets` | Model | 数据模型 |
| `path/to/NewViewModel.ets` | ViewModel | 视图模型 |
| `path/to/NewPage.ets` | Page | 页面视图 |

### 修改文件

| 文件路径 | 修改内容 |
|----------|----------|
| `path/to/ExistingFile.ets` | 添加 X 功能 |

---

## 任务列表

### Task 1: {任务名称}

**时间:** 2-5 分钟
**类型:** Model

**步骤 (RED-GREEN-REFACTOR):**
1. [RED] 写测试: 创建 `Tests/XxxTests.ets`，测试 Y 功能
2. [RED] 运行测试: 预期失败
3. [GREEN] 实现: 在 `Xxx.ets` 中实现 Y 功能
4. [GREEN] 运行测试: 预期通过
5. [REFACTOR] 优化: 清理代码、添加注释
6. [COMMIT] 提交: `feat: add Y functionality`

### Task 2: {任务名称}

...

---

## 审查标准

- [ ] 可构建性: 工程师能否无阻塞执行？
- [ ] 规格对齐: 是否覆盖设计规格所有需求？
- [ ] No Placeholders: 无 TBD、模糊描述、占位符

---

## 审查记录

| 审查人 | 日期 | 结论 | 备注 |
|--------|------|------|------|
| | | | |
```

---

## ⚠️ No Placeholders 规则

**计划失败条件 (必须重新规划):**

| 问题类型 | 示例 | 说明 |
|----------|------|------|
| TBD/模糊 | "TBD: 待确认" | 必须明确定义 |
| 未定义引用 | "类似 Task N" | 必须完整描述 |
| 占位符 | "// ... existing code ..." | 必须写出具体代码 |

---

## 📂 现有计划

| 文件 | 状态 | 关联规格 | 实施进度 |
|------|------|----------|----------|
| 待创建 | - | - | - |

---

**创建日期:** 2026-04-13
**来源:** Superpowers Pipeline v6.1