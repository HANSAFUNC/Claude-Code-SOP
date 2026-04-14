# 人工操作指南

**版本:** 3.0
**日期:** 2026-04-14

---

## 1. Phase 1: Design 人工操作

### 1.1 触发命令

```text
用户输入: /superpowers
Claude: 正在使用 brainstorming skill 进行设计...
```

### 1.2 回答澄清问题

**正确方式:**
```text
用户: 目标用户是保险公司培训学员，需要支持离线模式。
✅ 好: 一次性提供完整信息 + 具体场景
```

**错误方式:**
```text
用户: TBD，等产品确认
❌ 错误: 使用 TBD (违反 No Placeholders)
```

### 1.3 方案选择

Claude 提出 2-3 个方案后:
- 评估各方案优劣
- 选择推荐方案或提出修改意见
- 补充考虑点

### 1.4 设计文档审查

```text
检查项:
☐ 无 TBD 字样
☐ 无模糊描述
☐ 无占位符
☐ 数据模型已定义
☐ API 已设计
☐ UI 组件已说明

批准签字: "设计文档审查通过，进入 Phase 2"
```

---

## 2. Phase 2: Planning 人工操作

### 2.1 触发命令

```text
Phase 1 通过后自动进入
或用户输入: 继续 Phase 2 规划
```

### 2.2 文件结构确认

Claude 列出文件结构后:
```text
用户确认:
☐ 文件路径符合规范
☐ 无遗漏文件
☐ 无多余文件
确认回复: "文件结构确认，继续任务定义"
```

### 2.3 任务粒度检查

每个任务应为 2-5 分钟:
```text
如果时间过长 (>5分钟):
用户反馈: "Task 1 时间过长，请拆分"
```

### 2.4 No Placeholders 检查

```bash
# 搜索禁止内容
grep -n "TBD" docs/superpowers/plans/*.md
grep -n "待" docs/superpowers/plans/*.md
grep -n "... existing" docs/superpowers/plans/*.md
```

---

## 3. Phase 3: Implementation 人工操作

### 3.1 Git Worktree

**自动执行:**
```text
Claude: EnterWorktree({ name: "feature-001" })
系统: 已切换到 .claude/worktrees/feature-001/
```

**手动操作:**
```bash
git checkout -b feature/course-list
cd .claude/worktrees/course-001
```

### 3.2 RED-GREEN-REFACTOR

```text
[RED] Step 1: 写测试 → 运行 → 确认失败
[GREEN] Step 2: 实现 → 运行 → 确认通过
[REFACTOR] Step 3: 检查代码质量 → 再次运行确认
[COMMIT] Step 4: git add + git commit
```

### 3.3 完成验证

```text
Verification Checklist:
─────────────────────────────────────────
☐ 运行测试: npm test / xcodebuild test
☐ 检查覆盖率: ≥80%
☐ 功能验证: 启动应用手动测试
☐ 无编译错误/警告
☐ 代码已提交

确认回复: "验证通过，任务完成"
```

---

## 4. HARD-GATE 3 人工审查

### 4.1 Spec Compliance 检查

```text
Step 1: 打开设计规格 docs/superpowers/specs/*.md
Step 2: 打开审查模板 docs/superpowers/reviews/*-review.md
Step 3: 逐一对照检查:
        ☐ 需求满足
        ☐ 数据模型一致
        ☐ API 接口一致
        ☐ UI/UX 实现一致
```

### 4.2 Code Quality 检查

```text
检查项:
☐ 代码规范 (命名、格式、注释)
☐ 测试覆盖率 ≥80%
☐ 无安全漏洞
☐ 性能无回归
```

### 4.3 问题分级

| 级别 | 条件 | 时限 |
|------|------|------|
| CRITICAL | 功能不工作/安全漏洞 | 24h |
| HIGH | 覆盖率不足/规范违规 | 48h |
| MEDIUM | 代码风格问题 | 下周 |
| LOW | 小改进建议 | 技术债 |

### 4.4 审查签字

```markdown
---
**审查人:** @architect
**审查日期:** YYYY-MM-DD
**HARD-GATE 3:** ✅ 通过
```

---

## 5. 合并发布操作

### 5.1 HARD-GATE 3 通过后

```bash
git checkout main
git merge feature/course-list --no-ff
git push origin main
git tag -a v1.2.0 -m "Release v1.2.0"
git push origin v1.2.0
```

### 5.2 更新模块记录

```text
更新 Docs/Records/{module}/overview.md
更新 Docs/Records/{module}/harmony.md (或 ios.md)
更新 Docs/Records/README.md 索引
```

---

## 6. 快速参考

### 6.1 常用命令

| 场景 | 命令 |
|------|------|
| 触发 Superpowers | `/superpowers` |
| 运行测试 | `npm test` / `xcodebuild test` |
| 查看 git 状态 | `git status` |
| 创建分支 | `git checkout -b feature/name` |
| 合并分支 | `git merge feature/name --no-ff` |

### 6.2 文档位置

| 文档 | 位置 |
|------|------|
| 设计规格 | `docs/superpowers/specs/YYYY-MM-DD-*-design.md` |
| 实施计划 | `docs/superpowers/plans/YYYY-MM-DD-*.md` |
| 审查报告 | `docs/superpowers/reviews/YYYY-MM-DD-*-review.md` |

---

## 7. 培训要点

### 7.1 核心概念

| 概念 | 说明 |
|------|------|
| 硬门禁 | 不通过 = 禁止继续 |
| No Placeholders | 禁止 TBD/模糊描述/占位符 |
| RED-GREEN-REFACTOR | 测试先行 → 实现 → 重构 |
| 任务粒度 | 2-5 分钟/任务 |

### 7.2 常见问题

**Q: HARD-GATE 未通过怎么办?**
```text
A: 阅读驳回原因 → 修复 → 重新提交审查
```

**Q: 任务执行失败怎么办?**
```text
A: /debug 调试修复 → 或 ExitWorktree 丢弃重来
```

**Q: 测试覆盖率不足怎么办?**
```text
A: 补充测试用例 → 重新运行验证
```

---

**版本**: 3.0
**更新日期**: 2026-04-14