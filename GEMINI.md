# GEMINI.md - 项目指导文档

## 1. 项目概览 (Project Overview)
**项目名称：** 铁窗之言 / The Interrogation Room
**核心引擎：** Godot Engine 4.x (GL Compatibility 模式)
**技术栈：** GDScript, Dialogue Manager (插件), Godot Resources
**游戏类型：** 逻辑推理 / 心理博弈。玩家扮演刑警，通过审讯嫌疑人、管理压力/防备系统并出示证据来揭开真相。

### 核心架构 (Architecture)
*   **单例模式 (Autoloads):**
    *   `GameState` (`res://autoload/GameState.gd`): 核心状态管理器，负责压力值(stress)、防备心(defense)、嫌疑人数据、证据记录及对话历史。
    *   `AudioManager` (`res://autoload/AudioManager.gd`): 全局音效管理。
*   **数据驱动设计:** 使用 Godot 的 `Resource` 类型定义游戏对象：
    *   `EvidenceResource`: 证据属性（ID, 名称, 描述, 图标）。
    *   `SuspectResource`: 嫌疑人属性（ID, 初始压力/防备, 立绘）。
    *   `TestimonyResource`: 证词属性（ID, 摘要, 全文）。
*   **对话系统:** 使用 `Dialogue Manager` 插件，对话逻辑位于 `res://data/main_dialogue.dialogue`，支持复杂的信号回调和状态检查。

## 2. 核心机制 (Core Mechanics)
*   **压力值 (Stress) & 防备心 (Defense):**
    *   压力值达到临界点且防备心较低时，嫌疑人会交代真相。
    *   防备心过高（>=90）会导致审讯失败。
*   **证据出示 (Evidence Presentation):** 通过 `GameState.enable_presentation(id)` 在对话中开启出示环节，验证 `selected_evidence_id` 是否匹配预期。
*   **对话历史 (History):** 所有对话均通过 `GameState.add_to_history()` 记录，并可在 UI 中回顾。

## 3. 开发规范 (Development Conventions)
*   **资源路径:** 
    *   数据资源 (`.tres`) 存放在 `res://data/`。
    *   脚本分为 `scripts/` (类定义) 和 `scenes/` (特定场景逻辑)。
*   **信号驱动:** UI 更新应连接 `GameState` 的信号（如 `stress_changed`, `evidence_presented`），避免紧耦合。
*   **对话逻辑:** 
    *   对话文件使用特定前缀（如 `start_wang_01`）作为入口。
    *   在对话中使用 `do GameState.adjust_stress(amount)` 直接操作状态。

## 4. 构建与运行 (Building and Running)
*   **运行项目:** 在 Godot 4.x 编辑器中打开 `project.godot` 并运行 `res://scenes/Main.tscn` (主场景)。
*   **插件依赖:** 必须启用 `Dialogue Manager` 插件才能正常运行对话分支。
*   **导出:** 建议使用 `GL Compatibility` 导出模板以保证 2D 渲染兼容性。

## 5. 关键文件清单 (Key Files)
*   `res://autoload/GameState.gd`: 游戏逻辑的“心脏”。
*   `res://scenes/main.gd`: 主场景控制器，管理视觉表现和信号分发。
*   `res://data/main_dialogue.dialogue`: 包含所有角色的剧本和逻辑分支。
*   `res://memory-bank/`: 详细的设计文档和进度记录。
