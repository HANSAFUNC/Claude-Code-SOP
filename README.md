# 项目开发指南

> 基于 Claude Code + Superpowers 插件的通用项目开发指南

## 📋 目录

- [快速开始](#快速开始)
- [项目结构](#项目结构)
- [开发流程](#开发流程)
- [常用命令](#常用命令)
- [文档索引](#文档索引)

---

## 🚀 快速开始

### 前提条件

| 工具 | 用途 |
|------|------|
| Node.js 16+ | 运行环境 |
| Claude Code | AI 辅助开发 |

### 环境配置

```bash
# 安装 Claude Code
npm install -g @anthropics/claude-code

# 配置 API Key
export ANTHROPIC_API_KEY=your_api_key
```

---

## 📁 项目结构

```
.
├── .claude/                    # Claude Code 配置
│   ├── agents/                 # Agent 角色定义
│   ├── rules/                  # 项目规则
│   ├── settings.json           # 设置
│   ├── teams/                  # 团队配置
│   └── CLAUDE.md               # 项目指令
├── Architect/                  # 架构设计文档
├── Design/                     # UI 设计稿
├── Docs/                       # 团队规范文档
│   ├── SOP/                    # 标准操作流程
│   ├── Guides/                 # 协作指南
│   ├── Records/                # 模块变更记录
│   └── Tests/                  # 测试计划
├── PRD/                        # 产品需求文档
├── CLAUDE.md                   # 核心指令
└── README.md                   # 本文件
```

---

## 🔄 开发流程

### 新功能开发流程

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  需求输入   │ -> │  架构设计   │ -> │  并行开发   │ -> │  测试验证   │
│ PRD + Design│    │  Gate 1    │    │ Code+Test  │    │  Gate 2    │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                                                                   │
┌─────────────┐    ┌─────────────┐    ┌─────────────┐              │
│  模块记录   │ <- │  代码审查   │ <- │  合并发布   │              │
│  Gate 4    │    │  Gate 3    │    │  Release   │              │
└─────────────┘    └─────────────┘    └─────────────┘              │
```

### 使用 Claude Code

1. **启动 Superpowers 流程**
   ```bash
   /superpowers
   ```

2. **创建团队**（开发新功能前）
   ```bash
   TeamCreate({
     team_name: "module-name-team",
     description: "模块开发团队"
   })
   ```

3. **按流程执行**
   - 需求分析 → 架构设计 → 测试先行 → 代码实现 → 审查验证

---

## 🛠️ 常用命令

### Git 操作

```bash
# 查看状态
git status

# 提交更改
git add .
git commit -m "feat: 描述更改"

# 推送远程
git push origin main
```

### Commit 规范

采用 Conventional Commits:

| Type | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat(user): 添加用户管理` |
| `fix` | Bug 修复 | `fix(auth): 修复认证问题` |
| `refactor` | 重构 | `refactor(utils): 抽取工具函数` |
| `docs` | 文档更新 | `docs(README): 更新说明` |
| `test` | 测试 | `test(user): 添加单元测试` |
| `chore` | 构建/依赖 | `chore(deps): 升级依赖` |

---

## 📚 文档索引

### 产品文档
| 文档 | 路径 |
|------|------|
| PRD 目录 | `PRD/README.md` |
| 设计稿 | `Design/README.md` |

### 架构文档
| 文档 | 路径 |
|------|------|
| 架构设计 | `Architect/ArchitectureDesign.md` |
| 数据模型 | `Architect/DataModels.md` |
| API 设计 | `Architect/APIDesign.md` |

### 团队规范
| 文档 | 路径 |
|------|------|
| SOP 总览 | `Docs/SOP/README.md` |
| 团队角色 | `Docs/SOP/01-roles.md` |
| 开发流程 | `Docs/SOP/02-flow.md` |
| 代码审查 | `Docs/SOP/03-review.md` |
| 测试要求 | `Docs/SOP/04-testing.md` |
| Commit 规范 | `Docs/SOP/05-commit.md` |
| 质量门禁 | `Docs/SOP/06-gates.md` |

### 模块记录
| 文档 | 路径 |
|------|------|
| 记录索引 | `Docs/Records/README.md` |

---

## 👥 团队角色

| 角色 | 职责 |
|------|------|
| **PM** | 需求定义、PRD 编写 |
| **Architect** | 架构设计、技术评审 |
| **开发** | 代码实现 |
| **QA** | 测试验证、覆盖率检查 |
| **Code Reviewer** | 代码审查、安全扫描 |

---

## ✅ 质量门禁

### Gate 1: 架构评审
- [ ] 架构文档完整
- [ ] 数据模型定义清晰
- [ ] API 接口设计合理
- [ ] 全员评审通过

### Gate 2: 测试验证
- [ ] 所有测试用例通过
- [ ] 测试覆盖率 ≥ 80%
- [ ] 无阻塞性 Bug

### Gate 3: 代码审查
- [ ] 代码符合规范
- [ ] 无安全漏洞
- [ ] 审查问题全部解决

### Gate 4: 模块记录
- [ ] 模块概述已创建
- [ ] 变更历史已登记
- [ ] 索引已更新

---

## 🔗 相关资源

- [Claude Code 官方文档](https://docs.anthropic.com/claude-code)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

**版本**: 1.0  
**更新日期**: 2026-04-07
