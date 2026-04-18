# 游戏架构与数据结构定义 (Architecture & Data Structures)

## 1. 核心架构模式
本项目采用 **Singleton (Autoload) + Resource 数据驱动** 架构配合 Dialogue Manager 插件。

*   **GameState (Autoload):** 负责管理全局游戏状态（数值、证据、胜负逻辑、多嫌疑人状态管理及对话历史），充当所有 UI 模块与对话系统的中央枢纽。
*   **AudioManager (Autoload):** 负责全局音频生命周期管理，支持氛围音循环与动态 SFX 播放。
*   **Dialogue Manager:** 插件化处理对话流，通过 GDScript 接口与 GameState 深度联动。

## 2. 核心数据结构 (Resources)
- **EvidenceResource**: 存储证据 ID、名称、描述及图标。
- **TestimonyResource**: 记录证词文本及其摘要。
- **SuspectResource**: 定义嫌疑人唯一标识 (`id`)、姓名、初始心理数值 (Stress/Defense) 及视觉立绘 (Portrait)。

## 3. 全局状态管理器 (GameState.gd)
### 3.1 状态存储
- `suspects_state`: 持久化字典，用于在切换对象时保存和恢复各个嫌疑人的数值。
- `dialogue_history`: 动态数组，顺序存储整个审讯过程中的每一条对话记录。
- `is_game_over`: 针对每个嫌疑人独立的逻辑锁，确保胜负流程的原子性。

### 3.2 核心方法
- `switch_suspect(suspect_id)`: 封装了状态的序列化与加载。
- `add_to_history(speaker, text)`: 统一的对话记录入口，并触发更新信号。

### 3.3 核心信号
- `case_solved / case_failed`: 触发最终结算。
- `suspect_switched`: 驱动 UI 进行大盘刷新。
- `history_updated`: 驱动对话回顾列表的实时重绘。

## 4. 视觉与层级系统 (Visuals & Layering)
本项目采用 **多 CanvasLayer 隔离架构**：

- **VisualsLayer (Layer 1)**: 包含背景和嫌疑人立绘，处于最底层。
- **DialogueBalloon (Layer ~100)**: 插件默认层级，浮于视觉资产之上。
- **ControlLayer (Layer 128)**: 处于最顶层。包含 HUD、功能按钮、情报面板（含证据/证词/对话回顾）和结算面板。确保交互控件永远不被遮挡。

## 5. 关键文件作用说明

| 文件路径 | 职责描述 |
| :--- | :--- |
| `autoload/GameState.gd` | **业务枢纽**。管理数值、记录历史、控制指证逻辑。 |
| `autoload/AudioManager.gd` | **音频中心**。提供跨场景音效接口，管理 BGM 循环。 |
| `scripts/InterrogationUI.gd` | **界面主控**。驱动动效，分发信号，协调对话启动。 |
| `scenes/IntelligencePanel.tscn` | **情报中心**。整合了证据、证词和对话历史回顾的 Tab 面板。 |
| `scripts/IntelligencePanel.gd` | **情报控制器**。负责三个页签列表的动态刷新与数据绑定。 |
| `scenes/HistoryItem.tscn` | **历史条目**。对话回顾列表中的单个文本容器，支持说话人自动着色。 |
| `data/main_dialogue.dialogue` | **逻辑剧本**。定义审讯分支，并显式调用历史记录方法。 |
| `scripts/ResultPanel.gd` | **结算反馈**。动态展示胜负结果，并处理场景与音频的重置。 |
