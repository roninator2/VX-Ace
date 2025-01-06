# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Status Menu Functions   ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Status Screens         ║    09 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  Set the Windows to look like FFMQ.                      ║
# ║                                                          ║
# ║  Set the numbers for the icons to display below          ║
# ║                                                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# ** Module Element Icons for Status
#==============================================================================
module R2_Element_Icons
  Elements = {
  # Element ID => Icon number in Iconset sheet
      1 => 143,   # damage
      2 => 121,   # zombie
      3 => 96,    # fire
      4 => 97,    # water
      5 => 98,    # thunder
      6 => 100,   # earth
      7 => 101,   # wind
      8 => 159,   # shoot
      9 => 122,   # drain
      10 => 144,  # axe
      11 => 278,  # bomb
      }
end

#==============================================================================
# ** Window_Status_Command
#==============================================================================
class Window_Status_Command < Window_Command
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    self.back_opacity = 255
    refresh
    activate
    unselect
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    contents.dispose unless disposed?
    super unless disposed?
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(crisis_color)
    name = "Status"
    draw_text(4, 0, 200, line_height, name, 1)
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return Graphics.width / 2
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(1)
  end
end

#==============================================================================
# ** Window_Actor1_Exp
#==============================================================================
class Window_Actor1_Exp < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, Graphics.height / 3)
    @actor = $game_party.members[0]
    self.back_opacity = 255
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_currency_value
    draw_exp_info
  end
  #--------------------------------------------------------------------------
  # * Draw Number (Gold Etc.) with Currency Unit
  #--------------------------------------------------------------------------
  def draw_currency_value
    text = Vocab::currency_unit
    cx = text_size(text).width
    change_color(normal_color)
    draw_text(205, 0, cx + 10, line_height, $game_party.gold, 2)
    draw_text(0, 0, width, line_height, text, 0)
  end
  #--------------------------------------------------------------------------
  # * Draw Experience Information
  #--------------------------------------------------------------------------
  def draw_exp_info
    change_color(normal_color)
    s1 = @actor.max_level? ? "-------" : @actor.exp
    s2 = @actor.max_level? ? "-------" : @actor.next_level_exp - @actor.exp
    s_next = "NEXT EXP"
    draw_text(0, 40, 180, line_height, "EXP")
    draw_text(Graphics.width / 2, 40, 180, line_height, s_next)
    draw_text(Graphics.width / 2 - 210, 40, 180, line_height, s1, 2)
    draw_text(Graphics.width - 210, 40, 180, line_height, s2, 2)
  end
end

#==============================================================================
# ** Window_Actor1_Element_Status
#==============================================================================
class Window_Actor1_Element_Status < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, Graphics.height / 2 - 20, Graphics.width / 2, Graphics.height / 3)
    @actor = $game_party.members[0]
    self.back_opacity = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_icons
  end
  #--------------------------------------------------------------------------
  # * Draw Icons
  #--------------------------------------------------------------------------
  def draw_icons
    # R2_Element_Icons::Elements
    # code 13 - state rate - states
    # code 14 - state resist - states
    # code 11 - element rate - elements - 3 = fire
    # code 12 - debuff rate - params - 0 = mhp
    # code 22 - xparam
    # code 23 - sparams
    # element defense
    data1 = []
    fet = @actor.feature_objects.size
    for g in 0..fet - 1 do
      one = @actor.feature_objects[g].features
      for e in 0..one.size - 1
        if one[e].code == 11
          data1 << one[e].data_id
        end
      end
    end
    data1.compact!
    data1.uniq!
    data1.each do |el|
      num = el
      y = 24
      y = 52 if num > 5
      num -= 5 if num > 5
      draw_icon(R2_Element_Icons::Elements[el],  num * 24 + num * 8 - 30, y)
    end
    # status defense
    data2 = []
    fet2 = @actor.feature_objects.size
    for i in 0..fet2 - 1 do
      two = @actor.feature_objects[i].features
      for h in 0..two.size - 1
        if two[h].code == 14
          state = $data_states[two[h].data_id]
          data2 << state
        end
      end
    end
    data2.compact!
    data2.uniq!
    data2.each do |st|
      num = st.id
      y = 86
      y = 120 if num > 5
      num -= 5 if num > 5
      draw_icon(st.icon_index, num * 24 + num * 8 - 30, y)
    end
  end
end

#==============================================================================
# ** Window_Actor2_Element_Status
#==============================================================================
class Window_Actor2_Element_Status < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(Graphics.width / 2, Graphics.height / 2 - 20, Graphics.width / 2, Graphics.height / 3)
    @actor = $game_party.members[1]
    self.back_opacity = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_icons
  end
  #--------------------------------------------------------------------------
  # * Draw Icons
  #--------------------------------------------------------------------------
  def draw_icons
    # R2_Element_Icons::Elements
    # code 13 - state rate - states
    # code 14 - state resist - states
    # code 11 - element rate - elements - 3 = fire
    # code 12 - debuff rate - params - 0 = mhp
    # code 22 - xparam
    # code 23 - sparams
    # element defense
    @actor = $game_party.members[1]
    return if @actor.nil?
    data1 = []
    fet = @actor.feature_objects.size
    for g in 0..fet - 1 do
      one = @actor.feature_objects[g].features
      for e in 0..one.size - 1
        if one[e].code == 11
          data1 << one[e].data_id
        end
      end
    end
    data1.compact!
    data1.uniq!
    data1.each do |el|
      num = el
      y = 24
      y = 52 if num > 5
      num -= 5 if num > 5
      draw_icon(R2_Element_Icons::Elements[el],  num * 24 + num * 8 - 28, y)
    end
    # status defense
    data2 = []
    fet2 = @actor.feature_objects.size
    for i in 0..fet2 - 1 do
      two = @actor.feature_objects[i].features
      for h in 0..two.size - 1
        if two[h].code == 14
          state = $data_states[two[h].data_id]
          data2 << state
        end
      end
    end
    data2.compact!
    data2.uniq!
    data2.each do |st|
      num = st.id
      y = 86
      y = 120 if num > 5
      num -= 5 if num > 5
      draw_icon(st.icon_index, num * 24 + num * 8 - 28, y)
    end
  end
end

#==============================================================================
# ** Window_Image_Defense
#==============================================================================
class Window_Image_Defense < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(Graphics.width / 2 - 100, Graphics.height / 2 - 20, 200, Graphics.height / 3)
    self.back_opacity = 255
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_image_defense
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    return if @defense_image.nil?
    @defense_image.bitmap.dispose
    @defense_image.dispose
    super
  end
  #--------------------------------------------------------------------------
  # * Draw Image for Scene
  #--------------------------------------------------------------------------
  def draw_image_defense
    @defense_image = Sprite.new
    @defense_image.bitmap = Cache.system("Element_Defense")
    @defense_image.x = 200
    @defense_image.y = 245
    @defense_image.z = 200
  end
end

#==============================================================================
# ** Window_Actor1_Status
#==============================================================================
class Window_Actor1_Status < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 80, Graphics.width / 2, Graphics.height / 3 + 10)
    @actor = $game_party.members[0]
    self.back_opacity = 255
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(normal_color)
    draw_text(20, 0, 200, line_height, "  ATTACK...........")
    draw_text(200, 0, 44, line_height, @actor.atk, 2)
    draw_text(20, line_height, 200, line_height, "  DEFENSE.......")
    draw_text(200, line_height, 44, line_height, @actor.def, 2)
    draw_text(20, line_height * 2, 200, line_height, "  SPEED..............")
    draw_text(200, line_height * 2, 44, line_height, @actor.agi, 2)
    draw_text(20, line_height * 3, 200, line_height, "  MAGIC..............")
    draw_text(200, line_height * 3, 44, line_height, @actor.mat, 2)
    draw_text(20, line_height * 4, 200, line_height, "  ACCURACY...")
    draw_text(200, line_height * 4, 44, line_height, (@actor.hit * 100).to_i, 2)
    draw_text(20, line_height * 5, 200, line_height, "  EVADE..............")
    draw_text(200, line_height * 5, 44, line_height, (@actor.eva * 100).to_i, 2)
  end
end

#==============================================================================
# ** Window_Actor2_Status
#==============================================================================
class Window_Actor2_Status < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(Graphics.width / 2, 80, Graphics.width / 2, Graphics.height / 3 + 10)
    self.back_opacity = 255
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if !$game_party.members[1]
    @actor = $game_party.members[1]
    change_color(normal_color)
    draw_text(20, 0, 200, line_height, "  ATTACK...........")
    draw_text(200, 0, 44, line_height, @actor.atk, 2)
    draw_text(20, line_height, 200, line_height, "  DEFENSE.......")
    draw_text(200, line_height, 44, line_height, @actor.def, 2)
    draw_text(20, line_height * 2, 200, line_height, "  SPEED..............")
    draw_text(200, line_height * 2, 44, line_height, @actor.agi, 2)
    draw_text(20, line_height * 3, 200, line_height, "  MAGIC..............")
    draw_text(200, line_height * 3, 44, line_height, @actor.mat, 2)
    draw_text(20, line_height * 4, 200, line_height, "  ACCURACY...")
    draw_text(200, line_height * 4, 44, line_height, (@actor.hit * 100).to_i, 2)
    draw_text(20, line_height * 5, 200, line_height, "  EVADE..............")
    draw_text(200, line_height * 5, 44, line_height, (@actor.eva * 100).to_i, 2)
  end
end

#==============================================================================
# ** Scene_Status
#==============================================================================
class Scene_Status < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_windows
  end
  #--------------------------------------------------------------------------
  # * Make the windows
  #--------------------------------------------------------------------------
  def create_windows
    create_actor_exp_window
    create_actor1_defense_window
    create_actor2_defense_window
    create_image_window
    create_command_window
    create_actor1_status
    create_actor2_status
  end
  #--------------------------------------------------------------------------
  # * Actor 1 Exp Window
  #--------------------------------------------------------------------------
  def create_actor_exp_window
    @actor1_exp = Window_Actor1_Exp.new
  end
  #--------------------------------------------------------------------------
  # * Defense Window Actor 1
  #--------------------------------------------------------------------------
  def create_actor1_defense_window
    @actor1_exp_window = Window_Actor1_Element_Status.new
  end
  #--------------------------------------------------------------------------
  # * Defense Window Actor 2
  #--------------------------------------------------------------------------
  def create_actor2_defense_window
    @actor2_exp_window = Window_Actor2_Element_Status.new
  end
  #--------------------------------------------------------------------------
  # * Actor 1 Exp Window
  #--------------------------------------------------------------------------
  def create_image_window
    @image_window = Window_Image_Defense.new
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_Status_Command.new(Graphics.width / 2, 0)
    @command_window.set_handler(:cancel,   method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # * Status Window Actor 1
  #--------------------------------------------------------------------------
  def create_actor1_status
    @actor1_status_window = Window_Actor1_Status.new
  end
  #--------------------------------------------------------------------------
  # * Status Window Actor 2
  #--------------------------------------------------------------------------
  def create_actor2_status
    @actor2_status_window = Window_Actor2_Status.new
  end
end
