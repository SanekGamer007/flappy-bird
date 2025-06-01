extends Node
@onready var loadlocation: Node = get_node("/root/game")

func _ready() -> void:
	if OS.has_feature("debug"):
		var sceneresource: PackedScene = ResourceLoader.load("res://Objects/DebugOverlay/debug.tscn")
		var newscene: Node = sceneresource.instantiate()
		loadlocation.add_child.call_deferred(newscene)
	enable_edgetoedge()

func load_level(level: String) -> void:
	#for loadchild: int in range(loadlocation.get_child_count()):
	#	if loadlocation.get_child(loadchild).name != "Debug":
	#		loadlocation.get_child(loadchild).queue_free()
	for child: Node in loadlocation.get_children():
		if child.name != "Debug":
			child.queue_free()
	var sceneresource: PackedScene = ResourceLoader.load(level)
	if sceneresource:
		var newscene: Node = sceneresource.instantiate()
		if newscene:
			loadlocation.add_child(newscene)
		else:
			print_warn("Failed to instantiate scene: " + level)
	else:
		print_warn("Failed to load scene resource: " + level)
	

func enable_edgetoedge() -> void: # some really scary code that enables the edge to edge mode on android
	if not OS.has_feature("android") == true:
		print_warn("Running on " + OS.get_name() + OS.get_version_alias() + ", Android's Edge-to-Edge mode request ignored.")
		return
	elif OS.has_feature("debug") == true:
		print_warn("Detected debug feature flag, Edge-to-Edge mode request ignored.")
		return
	print("Running on ", OS.get_name(), OS.get_version_alias(), ", enabling Edge-to-Edge mode.")
	var android_runtime: JNISingleton
	var window: JavaObject
	var activity: JavaObject
	if Engine.has_singleton("AndroidRuntime"):
		android_runtime = Engine.get_singleton("AndroidRuntime")
		@warning_ignore("unsafe_method_access") 
		activity = android_runtime.getActivity()
		@warning_ignore("unsafe_method_access") 
		window = activity.getWindow()
	var layout_params: JavaClass = JavaClassWrapper.wrap("android.view.WindowManager$LayoutParams")

	@warning_ignore("unsafe_property_access", "unsafe_method_access") 
	window.addFlags(layout_params.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
	var callable: Callable = func () -> void:
		var view: JavaClass = JavaClassWrapper.wrap("android.view.View")

		# Allow UI to render behind status bar
		@warning_ignore("unsafe_property_access", "unsafe_method_access") 
		window.getDecorView().setSystemUiVisibility(view.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION)
		@warning_ignore("untyped_declaration", "unsafe_method_access") # - FIXME - i have no idea what type this should be.
		var insets_controller = window.getInsetsController()
		@warning_ignore("unsafe_method_access") 
		window.setStatusBarColor(Color.TRANSPARENT.to_argb32())
		@warning_ignore("unsafe_method_access") 
		window.setNavigationBarColor(Color.TRANSPARENT.to_argb32())

		var wic: JavaClass = JavaClassWrapper.wrap("android.view.WindowInsetsController")

		@warning_ignore("unsafe_property_access", "unsafe_method_access") 
		insets_controller.setSystemBarsAppearance(0, wic.APPEARANCE_LIGHT_STATUS_BARS)

	@warning_ignore("unsafe_method_access") 
	activity.runOnUiThread(android_runtime.createRunnableFromGodotCallable(callable))

func print_warn(message: String) -> void:
	print_rich("[color=yellow]", "WARN: ", message)
