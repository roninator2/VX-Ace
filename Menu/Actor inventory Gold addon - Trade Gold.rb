# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Actor Trade Gold             ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function: For trading gold between  ║   Date Created     ║
# ║actors. Requires Hime Actor Inventory╠════════════════════╣
# ║   and Roninator2 Gold Inventory     ║    29 Mar 2022     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Allows to Trade gold between actors                      ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║   Set the variable below to one you will not use         ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker except nudity             ║
# ╚══════════════════════════════════════════════════════════╝

module R2_Gold_Trade
  Variable = 10
end

class Scene_Menu < Scene_MenuBase
  alias r2_menu_command_gold_trade  create_command_window
  def create_command_window
    r2_menu_command_gold_trade
    @command_window.set_handler(:trade_gold,    method(:command_trade_gold))
  end
  def command_trade_gold
    SceneManager.call(Scene_Trade_Gold)
  end
end

class Window_MenuCommand < Window_Command
  alias r2_trade_gold_menu_command  add_original_commands
  def add_original_commands
    r2_trade_gold_menu_command
    add_command("Trade Gold",   :trade_gold)
  end
end

class Window_Gold_Trade_Command < Window_HorzCommand
  def initialize(x, y, width)
    @window_width = width
    super(x, y)
    activate
  end
  def window_width
    @window_width
  end
  def col_max
    return 2
  end
  def make_command_list
    add_command("Trade Gold", :trade)
    add_command("Cancel",     :cancel)
  end
end

class Window_Number_Trade < Window_Selectable
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @number = 0
    @digits_max = 1
    @index = 0
    start
  end
  def start
    @digits_max = 7
    @number = $game_variables[R2_Gold_Trade::Variable]
    @number = [[@number, 0].max, 10 ** @digits_max - 1].min
    @index = 6
    create_contents
  end
  def cursor_right(wrap)
    if @index < @digits_max - 1 || wrap
      @index = (@index + 1) % @digits_max
    end
    deactivate
  end
  def cursor_left(wrap)
    if @index > 0 || wrap
      @index = (@index + @digits_max - 1) % @digits_max
    end
    deactivate
  end
  def update
    super
    process_cursor_move
    process_digit_change
    process_handling
    update_cursor
  end
  def process_cursor_move
    if !active
      activate
      return
    end
    return unless active
    last_index = @index
    cursor_right(Input.trigger?(:RIGHT)) if Input.repeat?(:RIGHT)
    cursor_left(Input.trigger?(:LEFT))  if Input.repeat?(:LEFT)
    Sound.play_cursor if @index != last_index
  end
  def process_digit_change
    return unless active
    if Input.repeat?(:UP) || Input.repeat?(:DOWN)
      Sound.play_cursor
      place = 10 ** (@digits_max - 1 - @index)
      n = @number / place % 10
      @number -= n * place
      n = (n + 1) % 10 if Input.repeat?(:UP)
      n = (n + 9) % 10 if Input.repeat?(:DOWN)
      @number += n * place
      refresh
    end
  end
  def process_handling
    return unless active
    return process_ok     if Input.trigger?(:C)
    return process_max    if Input.trigger?(:X)
    return process_cancel if Input.trigger?(:B)
  end
  def process_ok
    Sound.play_ok
    $game_variables[R2_Gold_Trade::Variable] = @number
    deactivate
    close
    SceneManager.scene.on_number_ok
  end
  def process_max
    Sound.play_ok
    @number = @actor.inventory_gold
    refresh
  end
  def process_cancel
    Sound.play_cancel
    $game_variables[R2_Gold_Trade::Variable] = 0
    deactivate
    close
    SceneManager.scene.on_number_cancel
  end
  def item_rect(index)
    Rect.new(index * 20, 0, 20, line_height)
  end
  def refresh
    contents.clear
    change_color(normal_color)
    if @number > @actor.inventory_gold
      @number = @actor.inventory_gold
    end
    s = sprintf("%0*d", @digits_max, @number)
    @digits_max.times do |i|
      rect = item_rect(i)
      rect.x += 1
      draw_text(rect, s[i,1], 1)
    end
  end
  def update_cursor
    cursor_rect.set(item_rect(@index))
  end
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
end

class Window_ActorGold < Window_Selectable
  attr_reader :actor
  def initialize(actor)
    super(0, 0, window_width, window_height)
    @actor = actor
    refresh
  end
  def window_width
    return 200
  end
  def window_height
    return 150
  end
  def standard_padding
    return 10
  end
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  def refresh
    contents.clear
    draw_text(0, 0, width, line_height, @actor.name)
    draw_actor_face(@actor, 40, 30)
    draw_actor_gold(@actor, 0, 0)
    draw_left_arrow(0, 70)
    draw_right_arrow(140, 70)
  end
  def value(id)
    $game_actors[id].inventory_gold
  end
  def currency_unit
    Vocab::currency_unit
  end
  def draw_actor_gold(actor, x, y)
    change_color(normal_color)
    draw_currency_value(value(@actor.id), currency_unit, x, y, contents.width - 8)
  end
  def draw_left_arrow(x, y)
    change_color(system_color)
    draw_text(x, y, 40, line_height, "L <-", 0)
  end
  def draw_right_arrow(x, y)
    change_color(system_color)
    draw_text(x, y, 40, line_height, "-> R", 2)
  end
end

class Scene_Trade_Gold < Scene_MenuBase
  def start
    super
    create_scene_window
    create_command_window
    @actor1 = $game_party.battle_members[0]
    @actor2 = $game_party.battle_members[1]
    create_actor_select_window
    create_actor_trade_window
    create_number_window
  end
  def create_scene_window
    @scene_gold_trade_window = Window_Base.new(0, 0, Graphics.width, Graphics.height)
    @scene_gold_trade_window.viewport = @viewport
    @scene_gold_trade_window.deactivate
  end
  def create_command_window
    @command_window = Window_Gold_Trade_Command.new(150, 10, 250)
    @command_window.viewport = @viewport
    @command_window.activate
    @command_window.set_handler(:trade,    method(:command_trade))
    @command_window.set_handler(:cancel, method(:return_scene))
  end
  def create_actor_select_window
    @actor_status_window = Window_ActorGold.new(@actor1)
    @actor_status_window.viewport = @viewport
    @actor_status_window.x = 30
    @actor_status_window.y = 100
    @actor_status_window.actor = @actor1
    @actor_status_window.deactivate
    @actor_status_window.hide
    @actor_status_window.set_handler(:ok,     method(:on_actor_ok))
    @actor_status_window.set_handler(:pageup,   method(:change_actor_before))
    @actor_status_window.set_handler(:pagedown, method(:change_actor_after))
    @actor_status_window.set_handler(:cancel, method(:on_actor_cancel))
  end
  def create_actor_trade_window
    @trade_status_window = Window_ActorGold.new(@actor2)
    @trade_status_window.viewport = @viewport
    @trade_status_window.x = 300
    @trade_status_window.y = 100
    @trade_status_window.actor = @actor2
    @trade_status_window.deactivate
    @trade_status_window.hide
    @trade_status_window.set_handler(:ok,     method(:on_trade_ok))
    @trade_status_window.set_handler(:pageup,   method(:change_actor_before))
    @trade_status_window.set_handler(:pagedown, method(:change_actor_after))
    @trade_status_window.set_handler(:cancel, method(:on_trade_cancel))
  end
  def create_number_window
    @number_window = Window_Number_Trade.new(200, 300, 170, 48)
    @number_window.viewport = @viewport
    @number_window.hide
    @number_window.deactivate
    @number_window.actor = @actor1
    @number_window.set_handler(:ok,     method(:on_number_ok))
    @number_window.set_handler(:max,    method(:max_number_ok))
    @number_window.set_handler(:cancel, method(:on_number_cancel))
  end
  def command_trade
    @command_window.deactivate
    @actor_status_window.show
    @actor_status_window.activate
    @actor_status_window.select(0)
  end
  def on_actor_ok
    @actor1 = @actor_status_window.actor
    @actor_status_window.unselect
    @actor_status_window.deactivate
    @trade_status_window.show
    @trade_status_window.activate
    @trade_status_window.select(0)
  end
  def on_actor_cancel
    @actor_status_window.deactivate
    @actor_status_window.hide
    @command_window.activate
  end
  def on_trade_ok
    text = "Press A to select Max currency"
    @scene_gold_trade_window.draw_text_ex(100, 348, text)
    @actor2 = @trade_status_window.actor
    @trade_status_window.unselect
    @trade_status_window.deactivate
    @number_window.show
    @number_window.open
    @number_window.activate
  end
  def on_trade_cancel
    @trade_status_window.deactivate
    @trade_status_window.hide
    @actor_status_window.activate
    @actor_status_window.select(0)
  end
  def on_number_ok
    trade_gold($game_variables[R2_Gold_Trade::Variable])
    end_number_input
  end
  def on_number_cancel
    Sound.play_cancel
    end_number_input
  end
  def max_number_ok
  end
  def trade_gold(number)
    return if @trade_status_window.active
    $game_actors[@actor1.id].lose_gold(number)
    $game_actors[@actor2.id].gain_gold(number)
    @actor_status_window.refresh
    @trade_status_window.refresh
  end
  def end_number_input
    @scene_gold_trade_window.create_contents
    @number_window.close
    @number_window.deactivate
    @trade_status_window.activate
    @trade_status_window.select(0)
  end
  def change_actor_before
    if @chkwindow == 1
      id = $game_party.members.index(@actor_status_window.actor)
    else @chkwindow == 2
      id = $game_party.members.index(@trade_status_window.actor)
    end
    size = $game_party.members.size
    id -= 1
    id = size - 1 if id < 0
    if @chkwindow == 1
      @actor1 = $game_party.members[id]
      @actor_status_window.actor = @actor1
      @actor_status_window.activate
    elsif @chkwindow == 2
      @actor2 = $game_party.members[id]
      @trade_status_window.actor = @actor2
      @trade_status_window.activate
    end
    @number_window.actor = @actor1
  end
  def change_actor_after
    if @chkwindow == 1
      id = $game_party.members.index(@actor_status_window.actor)
    else @chkwindow == 2
      id = $game_party.members.index(@trade_status_window.actor)
    end
    size = $game_party.members.size
    id += 1
    id = 0 if id > size - 1
    if @chkwindow == 1
      @actor1 = $game_party.members[id]
      @actor_status_window.actor = @actor1
      @actor_status_window.activate
    elsif @chkwindow == 2
      @actor2 = $game_party.members[id]
      @trade_status_window.actor = @actor2
      @trade_status_window.activate
    end
    @number_window.actor = @actor1
  end
  alias r2_trade_gold_update  update
  def update
    r2_trade_gold_update
    if @command_window.active
      @chkwindow = 0
    elsif @actor_status_window.active
      @chkwindow = 1
    elsif @trade_status_window.active
      @chkwindow = 2
    end
  end
end
