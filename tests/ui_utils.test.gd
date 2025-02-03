@tool
class_name EditorUITests extends TDTest

var spies
var editor_ui
var mouse_pos
func test_drive():  
  before_each(func():
    mouse_pos = Vector2(0, 0)
    var MockViewPort = mock(SubViewport)
    MockViewPort.get_mouse_position.mock(func():
      return mouse_pos
    )
    var viewport = MockViewPort.new()

    var MockSceneTree = mock(SceneTree)
    var scene_tree = MockSceneTree.new()

    var MockBaseControl = mock(Control)
    MockBaseControl.get_viewport.returns(viewport)
    MockBaseControl.get_tree.returns(scene_tree)
    var base_control = MockBaseControl.new()

    var MockEditorInterface = mock(EditorInterfaceWrapper)
    MockEditorInterface.get_editor_settings.returns(mock(EditorSettingsWrapper).new())
    MockEditorInterface.get_editor_main_screen.returns(autofree(VBoxContainer.new()))
    MockEditorInterface.get_base_control.returns(base_control)
    var editor_interface = MockEditorInterface.new()

    editor_ui = EditorUI.new()
    editor_ui.__editor = editor_interface
    spies = {
      get_editor_main_screen=spy(editor_interface.get_editor_main_screen),
      get_base_control=spy(editor_interface.get_base_control),
      get_editor_settings=spy(editor_interface.get_editor_settings),
      create_timer=spy(scene_tree.create_timer)
    }

  )
  
  group('basics', func():
    test("can get the editor's main screen", func():
      assert_equal(spies.get_editor_main_screen.num_calls, 0)
      assert_true(editor_ui.main_screen is VBoxContainer)
      assert_equal(spies.get_editor_main_screen.num_calls, 1)
    )
    
    test("can get the editor's base control", func():
      assert_equal(spies.get_base_control.num_calls, 0)
      assert_exists(editor_ui.editor)
      assert_equal(spies.get_base_control.num_calls, 1)
    )

    test("can get the editor settings", func():
      assert_equal(spies.get_editor_settings.num_calls, 0)
      assert_exists(editor_ui.settings)
      assert_equal(spies.get_editor_settings.num_calls, 1)
    )
  )

  group('is_mouse_over()', func():
    test("returns true when the mouse is over the given control", func():
      var control: Control = N.create_native(Control)
      control.size = Vector2(1000, 1000)
      control.global_position = Vector2.ZERO
      mouse_pos.x = 500
      mouse_pos.y = 500
      assert_true(editor_ui.is_mouse_over(control))
    )

    test("returns false when the mouse is not over the given control", func():
      var control: Control = N.create_native(Control)
      control.size = Vector2(0, 0)
      control.global_position = Vector2.ZERO
      mouse_pos.x = 1500
      mouse_pos.y = 1500
      assert_false(editor_ui.is_mouse_over(control))
    )
  )
