# 游戏架构与数据结构定义 (Architecture & Data Structures)

## 1. 核心架构模式
本项目采用 **Singleton (Autoload) + Resource 数据驱动** 架构配合 Dialogic 叙事系统。

*   **GameState (Autoload):** 负责管理全局游戏状态（数值、证据、胜负逻辑、多嫌疑人状态管理及对话历史），充当所有 UI 模块与剧情系统的中央枢纽。
*   **AudioManager (Autoload):** 负责全局音频生命周期管理，支持氛围音循环与动态 SFX 播放。
*   **Dialogic (Plugin):** 处理对话流、时间轴管理和变量存储。通过 Dialogic 的信号系统（如 `signal_event`）和脚本 API 与 GameState 交互。

## 2. 核心数据结构 (Resources)
- **EvidenceResource**: 存储证据 ID、名称、描述及图标。
- **TestimonyResource**: 记录证词文本及其摘要。
- **SuspectResource**: 定义嫌疑人唯一标识 (`id`)、姓名、初始心理数值 (Stress/Defense) 及视觉立绘 (Portrait)。

## 3. 全局状态管理器 (GameState.gd)
### 3.1 状态存储
- `suspects_state`: 持久化字典，用于在切换对象时保存和恢复各个嫌疑人的数值。
- `dialogue_history`: 动态数组，顺序存储整个审讯过程中的每一条对话记录。
- `is_game_over`: 针对每个嫌疑人独立的逻辑锁，确保胜负流程的原子性。
- **变量同步**: 关键数值（Stress/Defense）应与 Dialogic 内部变量保持双向同步。

### 3.2 核心方法 (供 Dialogic 交互)
- `adjust_stress(amount)`: 修改当前嫌疑人压力值，同步更新 Dialogic 变量。
- `adjust_defense(amount)`: 修改当前嫌疑人防备心，同步更新 Dialogic 变量。
- `add_to_history(speaker, text)`: 统一的对话记录入口。
- `enable_presentation(expected_id)`: 开启指证环节，Dialogic 等待该过程结束。

### 3.3 核心信号
- `case_solved / case_failed`: 触发最终结算。
- `suspect_switched`: 驱动 UI 进行大盘刷新。
- `history_updated`: 驱动对话回顾列表的实时重绘。

## 4. 视觉与层级系统 (Visuals & Layering)
本项目采用 **多 CanvasLayer 隔离架构**：

- **VisualsLayer (Layer 1)**: 包含背景和嫌疑人立绘（Dialogic 可直接控制其角色立绘系统）。
- **DialogicLayout (Layer ~100)**: Dialogic 的对话层，负责渲染文本、选项和角色表情。
- **ControlLayer (Layer 128)**: 处于最顶层。包含 HUD、功能按钮、情报面板和结算面板。

## 5. 关键文件作用说明

| 文件路径 | 职责描述 |
| :--- | :--- |
| `autoload/GameState.gd` | **业务枢纽**。管理数值、记录历史、提供外部接口。 |
| `autoload/AudioManager.gd` | **音频中心**。提供跨场景音效接口，管理 BGM 循环。 |
| `res://dialogic/` | **剧情中心**。包含所有时间轴 (Timelines)、变量定义和 UI 布局配置。 |
| `scenes/IntelligencePanel.tscn` | **情报中心**。整合了证据、证词和对话历史回顾的 Tab 面板。 |


