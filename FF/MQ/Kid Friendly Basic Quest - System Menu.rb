# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ System Menu Functions   ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style System Screens         ║    09 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  Set the Windows to look like FFMQ.                      ║
# ║                                                          ║
# ║  Code has been used (copied/retyped/modified) from       ║
# ║  other scripts. Credit must be given to those creators.  ║
# ║  Roninator2, Yanfly, Zero_G, Kamesoft                    ║
# ║                                                          ║
# ║  Config options below                                    ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# ** Module System
#==============================================================================
module R2
  module SYSTEM
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - System Option Defaults
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMMAND_NAME = "CUSTOMIZE"   # Command name used to replace Game End.
    DEFAULT_AUTOBATTLE = false   # Enable automatic battle control by default?
    DEFAULT_MSGSPEED   = 4       # Set the default message speed. 4 = normal
    DEFAULT_LIFE       = false   # Set life bar setting, true equals figure
    MSG_SPEED_IMG = "msg-speed-" # file used to draw image for message speed
      # file name is the base name. the variable value will be added to make
      # the filename complete. e.g. msg-speed-4.png
    WINDOW_COLOUR = "Color-Bar"  # filename for drawing window colour setting
    COLOUR_DOT = "Color-Dot"     # filename of colour indicator
    
    COMMAND_VOCAB ={
    # -------------------------------------------------------------------------
    # :command    => [Command Name, Option1, Option2
    #                 Help Window Description,
    #                ], # Do not remove this.
    # -------------------------------------------------------------------------
      :title      => [COMMAND_NAME, nil, nil,
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
      :lifeindicate => ["LIFE INDICATE", "SCALE", "FIGURE",
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
      :autobattle => ["CONTROL", "MANUAL", "AUTO",
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
      :msgspeed   => ["MESSAGE SPEED", 1, 7, 5,
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
      :window_red => ["R", "None", "None",
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
      :window_grn => ["G", "None", "None",
                     ], # Do not remove this.
    # -------------------------------------------------------------------------
      :window_blu => ["B", "None", "None",
                     ], # Do not remove this.
    }
  end # SYSTEM
end # YEA

#==============================================================================
# ■ Set Command Vocab
#==============================================================================

module Vocab
  #--------------------------------------------------------------------------
  # overwrite method: self.game_end
  #--------------------------------------------------------------------------
  def self.game_end
    return R2::SYSTEM::COMMAND_NAME
  end
end # Vocab

#==============================================================================
# ■ Set Game System Options
#==============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias game_system_initialize_92v81cfe7gh initialize
  def initialize
    game_system_initialize_92v81cfe7gh
    init_autobattle
    init_msgspeed
    init_life
  end
  #--------------------------------------------------------------------------
  # new method: init_autobattle
  #--------------------------------------------------------------------------
  def init_autobattle
    @autobattle = R2::SYSTEM::DEFAULT_AUTOBATTLE
  end
  #--------------------------------------------------------------------------
  # new method: autobattle?
  #--------------------------------------------------------------------------
  def autobattle?
    init_autobattle if @autobattle.nil?
    return @autobattle
  end
  #--------------------------------------------------------------------------
  # new method: autobattle?
  #--------------------------------------------------------------------------
  def autobattle=(value)
    @autobattle = value
  end
  #--------------------------------------------------------------------------
  # new method: set_autobattle
  #--------------------------------------------------------------------------
  def set_autobattle(bool = false)
    @autobattle = bool
  end
  #--------------------------------------------------------------------------
  # new method: init_msgspeed
  #--------------------------------------------------------------------------
  def init_msgspeed
    @msgspeed = R2::SYSTEM::DEFAULT_MSGSPEED
  end
  #--------------------------------------------------------------------------
  # new method: msgspeed
  #--------------------------------------------------------------------------
  def msgspeed
    init_msgspeed if @msgspeed.nil?
    return @msgspeed
  end
  #--------------------------------------------------------------------------
  # new method: set_msgspeed
  #--------------------------------------------------------------------------
  def set_msgspeed(value)
    @msgspeed = value
  end
  #--------------------------------------------------------------------------
  # new method: init_life
  #--------------------------------------------------------------------------
  def init_life
    @life_indicator = R2::SYSTEM::DEFAULT_LIFE
  end
  #--------------------------------------------------------------------------
  # new method: life_indicator?
  #--------------------------------------------------------------------------
  def life_indicator?
    init_life if @life_indicator.nil?
    return @life_indicator
  end
  #--------------------------------------------------------------------------
  # new method: set_life
  #--------------------------------------------------------------------------
  def set_life(bool = false)
    @life_indicator = bool
  end
end

#==============================================================================
# ■ ********* Autobattle Controls ***************
#==============================================================================
#==============================================================================
# ■ BattleManager
#==============================================================================
module BattleManager
  #--------------------------------------------------------------------------
  # Next Command
  #--------------------------------------------------------------------------
  def self.next_command
    begin
      if !actor || !actor.next_command
        @actor_index += 1
        return false if (@actor_index >= 1) && $game_system.autobattle?
        return false if @actor_index >= $game_party.members.size
        return false if actor.dead? && (@actor_index >= 1) && !$game_system.autobattle?
      end
    end until actor.inputable?
    return true
  end
end

#==============================================================================
# ■ Game BattlerBase
#==============================================================================
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # Check for Autobattle
  #--------------------------------------------------------------------------
  def inputable?
    normal? && !auto_battle? || (!$game_system.autobattle? && (self != $game_party.leader))
  end
end # Game_BattlerBase

#==============================================================================
# ■ Game Actor
#==============================================================================
class Game_Actor
  #--------------------------------------------------------------------------
  # Actor performs Autobattle
  #--------------------------------------------------------------------------
  def make_actions
    super
    if auto_battle? || $game_system.autobattle?
      make_auto_battle_actions
    elsif confusion?
      make_confusion_actions
    end
  end
end # Game_Actor

#==============================================================================
# ■ ********* Message Speed Controls ***************
#==============================================================================
#==============================================================================
# ■ Message Speed
#==============================================================================
module DataManager
  class << self; alias r2_setup_new_game_kfbq setup_new_game; end
  def self.setup_new_game
    r2_setup_new_game_kfbq
    $game_variables[R2::SYSTEM::COMMAND_VOCAB[:msgspeed][3]] = $game_system.msgspeed
  end
end

#==============================================================================
# ■ Window Message
#==============================================================================
class Window_Message < Window_Base
  #--------------------------------------------------------------------------
  # draw_title
  #--------------------------------------------------------------------------
  def find_msg_speed
    case $game_variables[R2::SYSTEM::COMMAND_VOCAB[:msgspeed][3]]
    when 1
      return 3
    when 2
      return 2
    when 3
      return 1
    when 4
      return 0
    when 5
      return -1
    when 6
      return -2
    when 7
      return -3
    end
  end
  #--------------------------------------------------------------------------
  # Update Fiber
  #--------------------------------------------------------------------------
  def update_fiber
    if @fiber
      @fiber.resume
      for i in 2..find_msg_speed
        @fiber.resume unless @fiber.nil?
      end
    elsif $game_message.busy? && !$game_message.scroll_mode
      @fiber = Fiber.new { fiber_main }
      @fiber.resume
    else
      $game_message.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # Fiber Main
  #--------------------------------------------------------------------------
  def fiber_main
    $game_message.visible = true
    update_background
    update_placement
    loop do
      process_all_text if $game_message.has_text?
      process_input
      $game_message.clear
      @gold_window.close
      Fiber.yield
      for i in 2..find_msg_speed
        Fiber.yield
      end
      break unless text_continue?
    end
    close_and_wait
    $game_message.visible = false
    @fiber = nil
  end
  #--------------------------------------------------------------------------
  # Wait for one Character Drawing
  #--------------------------------------------------------------------------
  alias zero_wait_for_one_character wait_for_one_character
  def wait_for_one_character
    zero_wait_for_one_character
    for i in find_msg_speed..-2
      Fiber.yield unless @show_fast || @line_show_fast
    end
  end
end # class Window_Message

#==============================================================================
# ■ ********* Create Windows ***************
#==============================================================================
#==============================================================================
# ■ Window_KFBQSystemBlank
#==============================================================================
class Window_KFBQSystemBlank < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, w, h)
    hgt = line_height * h + 10
    super(x, y, w, hgt)
  end
  #--------------------------------------------------------------------------
  # * Get Line Height
  #--------------------------------------------------------------------------
  def line_height
    return 21
  end  
end

#==============================================================================
# ■ Window_KFBQSystemName
#==============================================================================
class Window_KFBQSystemName < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(Graphics.width/2, 0, window_width, fitting_height(1))
    draw_title
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return Graphics.width / 2
  end
  #--------------------------------------------------------------------------
  # draw_title
  #--------------------------------------------------------------------------
  def draw_title
    name = R2::SYSTEM::COMMAND_NAME
    draw_text(0, 0, contents.width, line_height, name, 1)
  end
end

#==============================================================================
# ■ Window_KFBQSystemOptions
#==============================================================================
class Window_KFBQSystemOptions < Window_Command
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    super(0, 45)
    self.opacity = 0
    self.back_opacity = 0
    @color_dot = {}
    refresh
  end
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return Graphics.width; end
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height; return Graphics.height - 100; end
  #--------------------------------------------------------------------------
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    window_height / @list.size - 5
  end
  #--------------------------------------------------------------------------
  # * Get Line Height
  #--------------------------------------------------------------------------
  def line_height
    return 20
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    ensure_cursor_visible
    cursor_rect.set(item_rect(@index))
    cursor_rect.height -= 15
    cursor_rect.y += 3
    case @list[index][:symbol]
    when :autobattle
      cursor_rect.y += 7
    when :msgspeed
      cursor_rect.y += 9
    when :window_red
      cursor_rect.y += 10
    when :window_grn
      cursor_rect.y -= 7
    when :window_blu
      cursor_rect.y -= 22
    end
  end
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(R2::SYSTEM::COMMAND_VOCAB[:lifeindicate][0], :lifeindicate)
    add_command(R2::SYSTEM::COMMAND_VOCAB[:autobattle][0], :autobattle)
    add_command(R2::SYSTEM::COMMAND_VOCAB[:msgspeed][0], :msgspeed)
    add_command(R2::SYSTEM::COMMAND_VOCAB[:window_red][0], :window_red)
    add_command(R2::SYSTEM::COMMAND_VOCAB[:window_grn][0], :window_grn)
    add_command(R2::SYSTEM::COMMAND_VOCAB[:window_blu][0], :window_blu)
  end
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    reset_font_settings
    rect = item_rect(index)
    rect.height -= 15
    case index
    when 3
      rect.y += 15
    when 5
      rect.y -= 10
    end
    contents.clear_rect(rect)
    case @list[index][:symbol]
    when :lifeindicate, :autobattle
      draw_option_toggle(rect, index, @list[index][:symbol])
    when :msgspeed
      draw_msgspeed_variable(rect, index, @list[index][:symbol])
    when :window_red, :window_grn, :window_blu
      draw_window_tone(rect, index, @list[index][:symbol])
    end
  end
  #--------------------------------------------------------------------------
  # draw_window_background
  #--------------------------------------------------------------------------
  def create_option_window_backs(index)
    @option_title[index] = Window_KFBQSystemName.new(index)
  end
  #--------------------------------------------------------------------------
  # draw_option_toggle
  #--------------------------------------------------------------------------
  def draw_option_toggle(rect, index, symbol)
    name = @list[index][:name]
    px = contents.width / 2
    rect.y += 5
    case symbol
    when :lifeindicate
      enabled = $game_system.life_indicator?
      draw_text(0, rect.y, contents.width/2, line_height, name, 1)
    when :autobattle
      enabled = $game_system.autobattle?
      rect.y += 7
      draw_text(0, rect.y, contents.width/2, line_height, name, 1)
    end
    change_color(crisis_color) if !enabled
    change_color(normal_color) if enabled
    option1 = R2::SYSTEM::COMMAND_VOCAB[symbol][1]
    draw_text(px, rect.y, contents.width/4, line_height, option1, 1)
    px += contents.width/4
    change_color(crisis_color) if enabled
    change_color(normal_color) if !enabled
    option2 = R2::SYSTEM::COMMAND_VOCAB[symbol][2]
    draw_text(px, rect.y, contents.width/4, line_height, option2, 1)
  end
  #--------------------------------------------------------------------------
  # draw_msgspeed_variable
  #--------------------------------------------------------------------------
  def draw_msgspeed_variable(rect, index, var)
    name = @list[index][:name]
    rect.y += 17
    draw_text(0, rect.y, contents.width/2, line_height, name, 1)
    px = contents.width / 2
    value = $game_variables[R2::SYSTEM::COMMAND_VOCAB[var][3]]
    minimum = R2::SYSTEM::COMMAND_VOCAB[var][1]
    maximum = R2::SYSTEM::COMMAND_VOCAB[var][2]
    rate = (value - minimum).to_f / [(maximum - minimum).to_f, 0.01].max
    draw_message_gauge
  end
  #--------------------------------------------------------------------------
  # draw_window_tone
  #--------------------------------------------------------------------------
  def draw_window_tone(rect, index, symbol)
    name = @list[index][:name]
    #---
    px = contents.width / 2
    rect.height -= 5
    tone = $game_system.window_tone
    case symbol
    when :window_red
      name = "WINDOW COLOR"
      draw_text(30, rect.y + 5, contents.width/2, line_height, name, 0)
      name = @list[index][:name]
      draw_text(0, rect.y + 4, contents.width/2, line_height, name, 2)
      value = tone.red.to_i
      minimum = 0
      maximum = 248
      value = [[value, minimum].max, maximum].min
      tone.red = value
      draw_window_colour_base(0)
      draw_window_colour_dot(0, value)
    when :window_grn
      draw_text(0, rect.y + 2, contents.width/2, line_height, name, 2)
      value = tone.green.to_i
      minimum = 0
      maximum = 248
      value = [[value, minimum].max, maximum].min
      tone.green = value
      draw_window_colour_base(1)
      draw_window_colour_dot(1, value)
    when :window_blu
      draw_text(0, rect.y - 4, contents.width/2, line_height, name, 2)
      value = tone.blue.to_i
      minimum = 0
      maximum = 248
      value = [[value, minimum].max, maximum].min
      tone.blue = value
      draw_window_colour_base(2)
      draw_window_colour_dot(2, value)
    end
  end
  #--------------------------------------------------------------------------
  # cursor_right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    cursor_change(:right)
    super(wrap)
  end
  #--------------------------------------------------------------------------
  # cursor_left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    cursor_change(:left)
    super(wrap)
  end
  #--------------------------------------------------------------------------
  # party_full
  #--------------------------------------------------------------------------
  def party_full_enabled?
    return true if $game_party.members.size > 1
    return false
  end
  #--------------------------------------------------------------------------
  # cursor_change
  #--------------------------------------------------------------------------
  def cursor_change(direction)
    case current_symbol
    when :window_red, :window_blu, :window_grn
      change_window_tone(direction)
    when :lifeindicate
      change_toggle(direction)
    when :autobattle
      if !party_full_enabled?
        Sound.play_buzzer
        return
      end
      change_toggle(direction)
    when :msgspeed
      change_msgspeed_variable(direction)
    end
  end
  #--------------------------------------------------------------------------
  # change_window_tone
  #--------------------------------------------------------------------------
  def change_window_tone(direction)
    Sound.play_cursor
    value = direction == :left ? -31 : 31
    tone = $game_system.window_tone.clone
    case current_symbol
    when :window_red; tone.red += value
      value = tone.red
      minimum = 0; maximum = 248
      value = [[value, minimum].max, maximum].min
      tone.red = value
    when :window_grn; tone.green += value
      value = tone.green
      minimum = 0; maximum = 248
      value = [[value, minimum].max, maximum].min
      tone.green = value
    when :window_blu; tone.blue += value
      value = tone.blue
      minimum = 0; maximum = 248
      value = [[value, minimum].max, maximum].min
      tone.blue = value
    end
    $game_system.window_tone = tone
    draw_item(index)
  end
  #--------------------------------------------------------------------------
  # change_toggle
  #--------------------------------------------------------------------------
  def change_toggle(direction)
    value = direction == :left ? false : true
    case current_symbol
    when :autobattle
      current_case = $game_system.autobattle?
      $game_system.set_autobattle(value)
      SceneManager.scene.change_data(true)
    when :lifeindicate
      current_case = $game_system.life_indicator?
      $game_system.set_life(value)
    end
    Sound.play_cursor if value != current_case
    draw_item(index)
  end
  #--------------------------------------------------------------------------
  # change_custom_variables
  #--------------------------------------------------------------------------
  def change_msgspeed_variable(direction)
    Sound.play_cursor
    value = direction == :left ? -1 : 1
    var = R2::SYSTEM::COMMAND_VOCAB[:msgspeed][3]
    minimum = R2::SYSTEM::COMMAND_VOCAB[:msgspeed][1]
    maximum = R2::SYSTEM::COMMAND_VOCAB[:msgspeed][2]
    $game_variables[var] += value
    $game_variables[var] = [[$game_variables[var], minimum].max, maximum].min
    draw_item(index)
  end
  #--------------------------------------------------------------------------
  # draw_message_popup
  #--------------------------------------------------------------------------
  def draw_message_gauge
    rect = item_rect(2)
    py = rect.y + 18
    px = contents.width / 2
    rect = Rect.new(0, 0, 200, 25)
    img = Cache.system(R2::SYSTEM::MSG_SPEED_IMG + $game_variables[R2::SYSTEM::COMMAND_VOCAB[:msgspeed][3]].to_s)
    contents.blt(px + 20, py, img, rect)
  end
  #--------------------------------------------------------------------------
  # draw_window_colour_base
  #--------------------------------------------------------------------------
  def draw_window_colour_base(index)
    rect = item_rect(3+index)
    rect.height -= 5
    py = rect.y + 20 - (index * 15)
    px = contents.width / 2
    rect = Rect.new(0, 0, 220, 25)
    img = Cache.system(R2::SYSTEM::WINDOW_COLOUR)
    contents.blt(px + 20, py, img, rect)
  end
  #--------------------------------------------------------------------------
  # draw_window_colour_dot
  #--------------------------------------------------------------------------
  def draw_window_colour_dot(index, value)
    rect = item_rect(3+index)
    rect.height -= 5
    py = rect.y + 25 - (index * 15)
    px = contents.width / 2 + 20
    ax = (value / 31).to_i * 25
    rect = Rect.new(0, 0, 200, 25)
    img = Cache.system(R2::SYSTEM::COLOUR_DOT)
    contents.blt(px + ax, py, img, rect)
  end
end

#==============================================================================
# ■ Call Scene
#==============================================================================
class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # overwrite method: command_game_end
  #--------------------------------------------------------------------------
  def command_game_end
    SceneManager.call(Scene_KFBQSystem)
  end
end # Scene_Menu

#==============================================================================
# ■ Scene_System
#==============================================================================
class Scene_KFBQSystem < Scene_MenuBase
  #--------------------------------------------------------------------------
  # Start
  #--------------------------------------------------------------------------
  def start
    super
    create_option_title
    create_option_window
    create_dummy_windows
  end
  #--------------------------------------------------------------------------
  # Create Option Window
  #--------------------------------------------------------------------------
  def create_option_window
    @options_window = Window_KFBQSystemOptions.new
    @options_window.set_handler(:cancel, method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # Create Option Title
  #--------------------------------------------------------------------------
  def create_option_title
    @option_title = Window_KFBQSystemName.new
  end
  #--------------------------------------------------------------------------
  # Create Dummy Windows
  #--------------------------------------------------------------------------
  def create_dummy_windows
    @life_window = Window_KFBQSystemBlank.new(0, 56, Graphics.width, 2)
    @life_window.z = 1
    @auto_window = Window_KFBQSystemBlank.new(0, 120, Graphics.width, 2)
    @auto_window.z = 1
    @msgspd_window = Window_KFBQSystemBlank.new(0, 180, Graphics.width, 2)
    @msgspd_window.z = 1
    @colour_window = Window_KFBQSystemBlank.new(0, 240, Graphics.width, 6)
    @colour_window.z = 1
  end
end # Scene_System
