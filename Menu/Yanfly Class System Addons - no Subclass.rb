=begin
redesigns the class script to have classes changed only, not subclasses

=end

class Window_ClassList < Window_Selectable

  def select_last
    select(@data.index(@actor.class))
  end

  def update_param_window
    return if @last_item == item
    @last_item = item
    class_id = item.nil? ? @actor.class_id : item.id
    temp_actor = Marshal.load(Marshal.dump(@actor))
    temp_actor.temp_flag = true
    temp_actor.change_class(class_id, YEA::CLASS_SYSTEM::MAINTAIN_LEVELS)
    @status_window.set_temp_actor(temp_actor)
  end
 
end

class Scene_Class < Scene_MenuBase

  def start
    super
    create_help_window
    create_command_window
    create_status_window
    create_param_window
    create_item_window
    relocate_windows
    command_class_change # added in
  end
  #--------------------------------------------------------------------------
  # create_status_window
  #--------------------------------------------------------------------------
  def create_item_window
    dy = @status_window.y + @status_window.height
    @item_window = Window_ClassList.new(0, dy)
    @item_window.help_window = @help_window
    @item_window.command_window = @command_window
    @item_window.status_window = @param_window
    @item_window.viewport = @viewport
    @item_window.actor = @actor
    @command_window.item_window = @item_window
    @item_window.set_handler(:ok,     method(:on_class_ok))
    @item_window.set_handler(:cancel, method(:on_class_cancel))
    @item_window.set_handler(:pagedown, method(:next_actor)) # added in
    @item_window.set_handler(:pageup,   method(:prev_actor)) # added in
  end
  #--------------------------------------------------------------------------
  # create_status_window
  #--------------------------------------------------------------------------
  def create_status_window
    wy = @help_window.height
    @status_window = Window_ClassStatus.new(0, wy)
    @status_window.viewport = @viewport
    @status_window.actor = @actor
  end
  #--------------------------------------------------------------------------
  # create_command_window
  #--------------------------------------------------------------------------
  def create_command_window
    wy = @help_window.height
    @command_window = Window_ClassCommand.new(-200, wy)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    @command_window.actor = @actor
    @command_window.set_handler(:cancel,   method(:return_scene))
    @command_window.set_handler(:primary,  method(:command_class_change))
    @command_window.set_handler(:subclass, method(:command_class_change))
    process_custom_class_commands
    return if $game_party.in_battle
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
    @command_window.set_handler(:learn_skill, method(:command_learn_skill))
  end
 
  def on_actor_change
    @command_window.actor = @actor
    @status_window.actor = @actor
    @param_window.actor = @actor
    @item_window.actor = @actor
    @item_window.activate # added in
  end
 
  def on_class_cancel
    SceneManager.return
  end
 
  def command_class_change
    @command_window.deactivate # added in
    @item_window.activate
    @item_window.select(0)
  end
end

class Window_ClassStatus < Window_Base
 
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(dx, dy)
    super(dx, dy, Graphics.width, fitting_height(4))
    @actor = nil
  end
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if @actor.nil?
    draw_actor_face(@actor, 0, 0)
    draw_actor_simple_status(@actor, Graphics.width / 3 , line_height / 2)
  end

end
