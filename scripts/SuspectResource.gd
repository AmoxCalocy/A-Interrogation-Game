class_name SuspectResource extends Resource

@export var id: String             # 唯一标识符
@export var suspect_name: String   # 嫌疑人姓名
@export var base_stress: int       # 初始压力值 (0-100)
@export var base_defense: int      # 初始防备心 (0-100)
@export var portrait: Texture2D    # 默认立绘
