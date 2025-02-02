class_name EditorUI

var __editor = EditorInterface

var __main_screen
var main_screen: VBoxContainer:
  get:
    if not __main_screen:
      __main_screen = __editor.get_editor_main_screen()
    return __main_screen
    
var __editor_base_control: Control
var editor: Control:
  get:
    if not __editor_base_control:
      __editor_base_control = __editor.get_base_control()
    return __editor_base_control

var mouse_position: Vector2:
  get: return editor.get_viewport().get_mouse_position()

var settings:
  get: return __editor.get_editor_settings()

func timer(time_sec: float, process_always: bool = true, process_in_physics: bool = false, ignore_time_scale: bool = false) -> SceneTreeTimer:
  return editor.get_tree().create_timer(time_sec, process_always, process_in_physics, ignore_time_scale)

func is_mouse_over(control) -> bool:
  return N.is_inside(mouse_position, control)
