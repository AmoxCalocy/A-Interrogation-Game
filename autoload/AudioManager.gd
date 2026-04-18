extends Node

# 音效播放器
var bgm_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

# 预载音效资源路径 (用户需将对应的 wav/ogg 文件放入 assets/audio 文件夹)
const AMBIENCE_PATH = "res://assets/audio/ambience_room.ogg"
const CLICK_SFX_PATH = "res://assets/audio/ui_click.wav"
const HOVER_SFX_PATH = "res://assets/audio/ui_hover.wav"
const IMPACT_SUCCESS_PATH = "res://assets/audio/impact_success.wav"
const IMPACT_FAIL_PATH = "res://assets/audio/impact_fail.wav"
const PAPER_SLIDE_PATH = "res://assets/audio/paper_slide.wav"

func _ready() -> void:
	# 初始化背景音乐播放器
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "Master"
	add_child(bgm_player)
	
	# 强制循环播放：当播放完毕时再次调用 play()
	bgm_player.finished.connect(bgm_player.play)
	
	# 初始化音效播放器
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "Master"
	add_child(sfx_player)
	
	# 自动播放背景氛围音
	play_ambience()

func play_ambience() -> void:
	var stream = load_if_exists(AMBIENCE_PATH)
	if stream:
		bgm_player.stream = stream
		bgm_player.play()

func play_sfx(path: String, volume_db: float = 0.0) -> void:
	var stream = load_if_exists(path)
	if stream:
		# 使用专门的播放器播放一次性音效
		var temp_player = AudioStreamPlayer.new()
		add_child(temp_player)
		temp_player.stream = stream
		temp_player.volume_db = volume_db
		temp_player.play()
		temp_player.finished.connect(temp_player.queue_free)

# 安全加载函数，防止找不到文件报错
func load_if_exists(path: String) -> Resource:
	if FileAccess.file_exists(path):
		return load(path)
	else:
		print_debug("【音效警告】未找到音频文件: ", path, " 请放入对应资源。")
		return null
