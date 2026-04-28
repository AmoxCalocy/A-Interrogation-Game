# GEMINI.md - 项目指导文档

## 1. 项目概览 (Project Overview)
**项目名称：** 铁窗之言 / The Interrogation Room
**核心引擎：** Godot Engine 4.x (GL Compatibility 模式)
**技术栈：** GDScript, Dialogue Manager (插件), Godot Resources
**技术栈：** GDScript, Dialogic (插件), Godot Resources

### 核心架构 (Architecture)
*   **单例模式 (Autoloads):**
    *   `GameState` (`res://autoload/GameState.gd`): 核心状态管理器，负责压力值(stress)、防备心(defense)、嫌疑人数据、证据记录及对话历史。
    *   `AudioManager` (`res://autoload/AudioManager.gd`): 全局音效管理。
*   **数据驱动设计:** 使用 Godot 的 `Resource` 类型定义游戏对象：
    *   `EvidenceResource`: 证据属性（ID, 名称, 描述, 图标）。
    *   `SuspectResource`: 嫌疑人属性（ID, 初始压力/防备, 立绘）。
    *   `TestimonyResource`: 证词属性（ID, 摘要, 全文）。
*   **对话系统:** 使用 `Dialogic` 插件驱动。剧情逻辑、时间轴 (Timelines) 和变量管理均在 Dialogic 面板中完成。支持通过信号和变量监听与 `GameState` 通信。

## 2. 核心机制 (Core Mechanics)
*   **压力值 (Stress) & 防备心 (Defense):**
    *   压力值达到临界点且防备心较低时，嫌疑人会交代真相。
    *   防备心过高（>=90）会导致审讯失败。
*   **证据出示 (Evidence Presentation):** 通过 Dialogic 的事件跳转或自定义事件开启出示环节，验证 `selected_evidence_id` 是否匹配预期。
*   **对话历史 (History):** 利用 Dialogic 内置的历史记录功能或通过 `GameState.add_to_history()` 记录。

## 3. 开发规范 (Development Conventions)
*   **资源路径:** 
    *   数据资源 (`.tres`) 存放在 `res://data/`。
    *   Dialogic 时间轴和资源建议存放在 `res://dialogic/`。
    *   脚本分为 `scripts/` (类定义) 和 `scenes/` (特定场景逻辑)。
*   **信号驱动:** UI 更新应连接 `GameState` 的信号。Dialogic 的执行结果通过其内置信号或脚本回调通知 `GameState`。
*   **对话逻辑:** 
    *   在 Dialogic 编辑器中创建时间轴。
    *   使用 `Dialogic.VAR.stress` 等方式直接操作 Dialogic 变量，或在时间轴中调用 GDScript 方法。

## 4. 构建与运行 (Building and Running)
*   **运行项目:** 在 Godot 4.x 编辑器中打开 `project.godot` 并运行 `res://scenes/Main.tscn` (主场景)。
*   **插件依赖:** 必须启用 `Dialogic` 插件。
*   **导出:** 建议使用 `GL Compatibility` 导出模板。

## 5. 关键文件清单 (Key Files)
*   `res://autoload/GameState.gd`: 游戏逻辑的“心脏”。
*   `res://scenes/main.gd`: 主场景控制器，负责启动 Dialogic 时间轴。
*   `res://dialogic/`: 包含所有 Dialogic 剧情数据、角色定义和样式配置。
*   `res://memory-bank/`: 详细的设计文档和进度记录。
