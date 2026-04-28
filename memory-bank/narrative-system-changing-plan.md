# 叙事系统迁移计划：转向 Dialogic 2

本计划旨在将《铁窗之言》的对话逻辑从 `Dialogue Manager` 迁移至 `Dialogic 2`，充分利用其可视化编辑器和原生变量系统。

## 1. 准备阶段 (Setup)
- [ ] **下载插件**：获取 [Dialogic 2](https://github.com/dialogic-godot/dialogic) 插件并放入 `res://addons/dialogic`。
- [ ] **启用插件**：在 `Project Settings -> Plugins` 中启用 Dialogic。
- [ ] **基础配置**：在 Dialogic 面板中配置默认样式、角色（警官、嫌疑人）和输入设置。

## 2. 内容迁移 (Content Migration)
- [ ] **时间轴重建**：在 Dialogic 编辑器中为每个嫌疑人创建时间轴 (Timelines)。
- [ ] **变量定义**：在 Dialogic 变量面板中创建全局变量：
    - `Stress` (int)
    - `Defense` (int)
    - `CurrentSuspect` (string)
- [ ] **逻辑复刻**：将原 `.dialogue` 脚本中的分支跳转、数值修改逻辑迁移至 Dialogic 时间轴事件。

## 3. 逻辑集成 (Logic Integration)
- [ ] **GameState 桥接**：
    - 在 `GameState.gd` 中连接 Dialogic 的 `variable_changed` 信号，确保 `stress` 和 `defense` 的变化能同步到游戏 UI。
    - 使用 `Dialogic.VAR.stress = GameState.current_stress` 进行初始化同步。
- [ ] **事件监听**：
    - 利用 Dialogic 的“信号事件”触发指证环节 (`GameState.enable_presentation`)。
- [ ] **启动重构**：
    - 修改 `main.gd` 或相关入口，使用 `Dialogic.start(timeline_path)` 替换旧的启动代码。

## 4. UI 与表现 (UI & Presentation)
- [ ] **样式定制**：
    - 使用 Dialogic 的 Layout 编辑器自定义对话框、选项按钮和角色立绘位置。
    - 确保 Dialogic 的层级在 `VisualsLayer` 之上，`ControlLayer` 之下（或根据需要调整）。
- [ ] **历史回放适配**：
    - 决定使用 Dialogic 自带的历史面板，还是将 Dialogic 文本通过信号发送给 `GameState.add_to_history()`。

## 5. 验证与清理 (Validation & Cleanup)
- [ ] **全流程走通**：验证三人连环审讯的跨嫌疑人变量逻辑是否依然正确。
- [ ] **资源移除**：彻底删除 `res://addons/dialogue_manager/` 及其相关文件。

## 6. 风险点提示
- **变量命名冲突**：确保 Dialogic 内部变量名与 `GameState` 属性一致，避免混淆。
- **保存系统协同**：Dialogic 有独立的保存机制，需要考虑如何将其与 `GameState` 的保存逻辑整合。
