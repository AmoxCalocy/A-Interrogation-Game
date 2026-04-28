# 《铁窗之言》核心原型实施计划

本计划聚焦于使用 **Godot 4.x (GDScript)** 构建游戏的最小可行性产品（MVP），包含对话、语气选择、证词本、证据出示和压力值/防备心系统的核心逻辑。

## 第一阶段：项目脚手架与基础结构

### 步骤 1.1：创建 Godot 项目与文件夹结构
**指令：**
1. 创建一个新的 Godot 4.x 项目。
2. 在 `res://` 根目录下创建以下文件夹：`scenes/`, `scripts/`, `assets/ui/`, `assets/sprites/`, `data/`, `autoload/`。
3. 设置项目的默认分辨率为 1280x720，并配置拉伸模式为 `canvas_items`。
**验证测试：**
* 运行项目，能够看到一个空白的窗口且没有任何启动报错。

### 步骤 1.2：定义基础数据资源与 Autoload (基于架构文档)
**指令：**
1. 创建三个自定义 Resource 脚本：`EvidenceResource`、`TestimonyResource` 和 `SuspectResource`（参考 `architecture.md`）。
2. 在 `data/` 文件夹下创建一个示例证据资源（如“带血的刀”）、一个示例证词资源和一个示例嫌疑人资源。
3. 在 `autoload/` 中创建 `GameState.gd`，包含压力值 (`current_stress`)、防备心 (`current_defense`) 等全局状态及判定方法，并配置为单例 Autoload。
**验证测试：**
* 在项目设置的 Autoload 列表中能看到 `GameState`。
* 在任意脚本中 `print(GameState.current_stress)` 不会报错。

---

## 第二阶段：对话系统集成 (Dialogic) 与变量同步

### 步骤 2.1：配置 Dialogic 2 插件与样式
**指令：**
1. 下载并安装 `Dialogic 2` 插件至 `res://addons/dialogic/`。
2. 在项目设置中启用插件。
3. 在 Dialogic 控制面板中创建基本角色（警官、嫌疑人）和首个时间轴 (Timeline)。
4. 配置 Dialogic Layout，确保其与项目的审讯氛围匹配。
**验证测试：**
* 成功在 `Main.tscn` 中通过 `Dialogic.start("start_timeline")` 启动对话，文本和角色立绘显示正常。

### 步骤 2.2：建立变量同步与事件监听
**指令：**
1. 在 Dialogic 变量面板中创建 `Stress` 和 `Defense` 变量。
2. 在 `GameState.gd` 中实现变量监听，使 Dialogic 变量的变化能实时反馈到 UI。
3. 利用 Dialogic 的“信号事件”触发指证环节。
**验证测试：**
* 在对话时间轴中修改变量，UI 进度条实时更新；触发信号时，游戏进入出示证据模式。


---


## 第三阶段：情报系统（档案夹与证词本）

### 步骤 3.1：构建情报面板与刷新逻辑
**指令：**
1. 构建 `IntelligencePanel` UI，支持 Tab 切换证据和证词列表。
2. 实现 `EvidenceItem` 和 `TestimonyItem` 动态列表项。
3. 解决 UI 初始化顺序问题，确保数据加载后界面同步更新。
**验证测试：**
* 点击档案按钮能滑出面板，证据列表中显示初始证据。

---

## 第四阶段：审讯核心逻辑（攻防博弈）

### 步骤 4.1：实现出示证据校验
**指令：**
1. 在 UI 中添加“出示证据”按钮。
2. 实现 `GameState` 中的证据校验逻辑与对话系统的联动。
3. 解决 CanvasLayer 层级冲突，确保 UI 在对话期间可交互。
**验证测试：**
* 在对话矛盾点点击出示正确证据，触发嫌疑人心理压力上涨。

---

## 第五阶段：完整回路、动效与音效增强

### 步骤 5.1：实现结算与重置
**指令：**
1. 实现 `ResultPanel` 结算面板。
2. 实现游戏重置逻辑（`GameState.reset()` 和场景重载）。
**验证测试：**
* 攻破防线后弹出结算面板，点击重新开始能回到初始状态。

### 步骤 5.2：视听效果增强
**指令：**
1. 使用 `Tween` 实现平滑进度条、面板侧滑和按钮交互反馈。
2. 创建 `AudioManager` 全局单例，管理背景氛围音和交互 SFX。
3. 在 `project.godot` 中注册音频单例并挂载音效触发点。
**验证测试：**
* 进度条不再瞬间跳变，点击 UI 有清脆反馈音。
