# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Map Skill Menu                         ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Call a skill menu on the map                  ║    11 Oct 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Call Skill Scene on map without Main Menu                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║  Change the values below to the desired configuration              ║
# ║                                                                    ║
# ║  The skills shown in the window are skills usable in the           ║
# ║  menu, not battle skills                                           ║
# ║                                                                    ║
# ║  Call_Skill_Button -> Button pressed to call the menu              ║
# ║                                                                    ║
# ║  POSITION -> values are 0, 1, 2, 3                                 ║
# ║              0 = Help window left side                             ║
# ║              1 = Help window right side                            ║
# ║              2 = Help window top                                   ║
# ║              3 = Help window bottom                                ║
# ║    All other windows move based on the Help window                 ║
# ║                                                                    ║
# ║  USE_NOTE -> allows using note tags in the skill notebox           ║
# ║    If using the note tags they are to be used like this            ║
# ║       <item text>                                                  ║
# ║        write all your text here                                    ║
# ║        and more text here                                          ║
# ║        also supports icon codes \i[112]                            ║
# ║       </item text>                                                 ║
# ║    If not using item note tags then it will write the              ║
# ║    default skill description                                       ║
# ║                                                                    ║
# ║  HELP_X and HELP_Y -> move the window away from the                ║
# ║                       screen edge                                  ║
# ║  HELP_LINES -> How many lines to have for the help window          ║
# ║                                                                    ║
# ║  STATUS_X and STATUS_Y ->  move the window away from the           ║
# ║                            screen edge                             ║
# ║  GRAPHICS_SPRITE -> use the walking sprite, or face                ║
# ║  STATUS_ROWS -> How many lines to use for the status               ║
# ║    window. Positoin 0 & 1 -> recommend 4                           ║
# ║            Positoin 2 & 3 -> recommend 3                           ║
# ║                                                                    ║
# ║  COMMAND_X & COMMAND_Y -> move the window away from the            ║
# ║                           screen edge                              ║
# ║  COMMAND_COLUMNS -> How many commands to show in window            ║
# ║   More commands in small window means they get squished            ║
# ║                                                                    ║
# ║  SKILL_X & SKILL_Y -> move the window away from the                ║
# ║                       screen edge                                  ║
# ║  FULL_WIDTH -> Ignore the X value and go full width                ║
# ║  SKILL_COLUMNS -> How many skills columns to display               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 11 Oct 2023 - Script finished                               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   DP3 & Tsukihime for their code                                   ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Terms of use:                                                      ║
# ║  Follow the original Authors terms of use where applicable         ║
# ║    - When not made by me (Roninator2)                              ║
# ║  Free for all uses in RPG Maker except nudity                      ║
# ║  Anyone using this script in their project before these terms      ║
# ║  were changed are allowed to use this script even if it conflicts  ║
# ║  with these new terms. New terms effective 03 Apr 2024             ║
# ║  No part of this code can be used with AI programs or tools        ║
# ║  Credit must be given                                              ║
# ╚════════════════════════════════════════════════════════════════════╝

module R2_MAP_SKILL_MENU
  Call_Skill_Button = :Y
	# :C = Z, :B = X, :A = SHIFT, :X = A, :Y = S, :Z = D, :L = Q, :R = W
  
  # ======================================================
  POSITION = 3
  # 0 = left, 1 = Right, 2 = top, 3 = bottom
  # help window goes in the opposite side
  
  # ======================================================
  # Help Window
  USE_NOTE = true
  # configure to use Note Box for Item Description or 
  # use description from the item itself.
  # true = use note box tag
  # false = use built in description box
  HELP_X = 20
  # position of where the Help window is positioned on X axis
  # This will position the window away from the edge of the screen
  HELP_Y = 20
  # position of where the Help window is positioned on Y axis
  # This will position the window away from the edge of the screen
  HELP_LINES = 4
  # The number of lines the help window will show. Sets the height
  # position 0 & 1 -> recommend 15, position 2 & 3 -> recommend 4
  
  # ======================================================
  # Status Window
  STATUS_X = 20
  # position of where the Status window is positioned on X axis
  STATUS_Y = 20
  # position of where the Status window is positioned on Y axis
  GRAPHICS_SPRITE = false
  # True will draw Sprite, false will draw face.
  STATUS_ROWS = 3
  # how many lines the status takes up.
  # position 0 & 1 -> recommend 4, position 2 & 3 -> recommend 3
  
  # ======================================================
  # Command Window
  COMMAND_X = 20
  # position of where the ommand window is positioned on X axis
  COMMAND_Y = 20
  # position of where the ommand window is positioned on Y axis
  COMMAND_COLUMNS = 4
  # position 0 & 1 -> recommend 1 or 2, position 2 & 3 -> recommend < 5

  # ======================================================
  # Skill Window
  SKILL_X = 20
  # position of where the Skill window is positioned on X axis
  SKILL_Y = 20
  # position of where the Skill window is positioned on Y axis
  FULL_WIDTH = false
  # wether to span across the window width
  SKILL_COLUMNS = 3
  # number of columns in window
  # position 0 & 1 -> recommend 1, position 2 & 3 -> recommend 2 or 3
end

#==============================================================================
# ** Window_Help
#==============================================================================

class Window_SkillHelp < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(line_number = R2_MAP_SKILL_MENU::HELP_LINES)
    @position = R2_MAP_SKILL_MENU::POSITION
    super(R2_MAP_SKILL_MENU::HELP_X, R2_MAP_SKILL_MENU::HELP_Y, width, fitting_height(line_number))
    adjust_help_position(@position)
    @text_desc = []
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #--------------------------------------------------------------------------
  def set_text(text)
    @text_desc = []
    if text != @text
      @text = text
      @text_desc.push("#{@text}")
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    contents.clear
    @text_desc = []
    set_text("")
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #     item : Skills and items etc.
  #--------------------------------------------------------------------------
  def set_item(item)
    @text_desc = []
    if R2_MAP_SKILL_MENU::USE_NOTE == true
      @text_desc = []
      return if item.nil?
      results = item.note.scan(/<item[-_ ]*text>(.*?)<\/item[-_ ]*text>/imx)
      results.each do |res|
        res[0].strip.split("\r\n").each do |line| 
        @text_desc.push("#{line}") 
        end
      end
    else
      set_text(item ? item.description : "")
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    @y = 0
    @text_desc.each do |l|
      draw_text_ex(0, @y, word_wrapping(l))
      @y += line_height
    end
  end
  #--------------------------------------------------------------------------
  # * Calculate Width of Window Contents
  #--------------------------------------------------------------------------
  def width
    case @position
    when 0..1
      Graphics.width / 2 - R2_MAP_SKILL_MENU::HELP_X
    when 2..3
      Graphics.width - R2_MAP_SKILL_MENU::HELP_X * 2
    end
  end
  #--------------------------------------------------------------------------
  # * Move Help Window
  #--------------------------------------------------------------------------
  def adjust_help_position(position)
    case position
    when 0
      self.x = R2_MAP_SKILL_MENU::HELP_X
      self.y = R2_MAP_SKILL_MENU::HELP_Y
    when 1
      self.x = Graphics.width / 2
      self.y = R2_MAP_SKILL_MENU::HELP_Y
    when 2
      self.x = R2_MAP_SKILL_MENU::HELP_X
      self.y = R2_MAP_SKILL_MENU::HELP_Y
    when 3
      self.x = R2_MAP_SKILL_MENU::HELP_X
      self.y = Graphics.height - self.height - R2_MAP_SKILL_MENU::HELP_Y / 2
    end
  end
  #--------------------------------------------------------------------------
  # * Word Wrapping
  #--------------------------------------------------------------------------
  def word_wrapping(text, pos = 0)
    # Current Text Position
    current_text_position = 0    
    for i in 0..(text.length - 1)
      if text[i] == "\n"
        current_text_position = 0
        next
      end
      # Current Position += character width
      current_text_position += contents.text_size(text[i]).width
      # If Current Position > Window Width
      if (pos + current_text_position) >= (contents.width)
        # Then Format the Sentence to fit Line
        current_element = i
        while(text[current_element] != " ")
          break if current_element == 0
          current_element -= 1
        end
        temp_text = ""
        for j in 0..(text.length - 1)
          temp_text += text[j]
          temp_text += "\n" if j == current_element
          @y += line_height if j == current_element
        end
        text = temp_text
        i = current_element
        current_text_position = 0
      end
    end
    return text
  end
end

#==============================================================================
# ** Window_MapSkillStatus
#==============================================================================

class Window_MapSkillStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    @position = R2_MAP_SKILL_MENU::POSITION
    super(x, y, window_width, fitting_height(R2_MAP_SKILL_MENU::STATUS_ROWS))
    adjust_status_position(@position)
    @actor = nil
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    case @position
    when 0..1
      Graphics.width / 2 - R2_MAP_SKILL_MENU::STATUS_X
    when 2..3
      Graphics.width - R2_MAP_SKILL_MENU::STATUS_X * 2
    end
  end
  #--------------------------------------------------------------------------
  # * Move Status Window
  #--------------------------------------------------------------------------
  def adjust_status_position(position)
    case position
    when 0
      self.x = Graphics.width / 2
      self.y = R2_MAP_SKILL_MENU::STATUS_Y
    when 1
      self.x = R2_MAP_SKILL_MENU::STATUS_X
      self.y = R2_MAP_SKILL_MENU::STATUS_Y
    when 2
      self.x = R2_MAP_SKILL_MENU::STATUS_X
      self.y = Graphics.height - self.height - R2_MAP_SKILL_MENU::STATUS_Y
    when 3
      self.x = R2_MAP_SKILL_MENU::STATUS_X
      self.y = R2_MAP_SKILL_MENU::STATUS_Y
    end
  end
  #--------------------------------------------------------------------------
  # * Actor Settings
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return unless @actor
    x = 0
    draw_actor_graphic(@actor, 75, 50) if R2_MAP_SKILL_MENU::GRAPHICS_SPRITE
    if @position == 2 || @position == 3
      draw_actor_face(@actor, x, 0) if !R2_MAP_SKILL_MENU::GRAPHICS_SPRITE
      x = 120
    else
      draw_actor_face(@actor, x, 0) if !R2_MAP_SKILL_MENU::GRAPHICS_SPRITE
    end
    draw_actor_name(@actor, x, 0)
    draw_actor_level(@actor, x, line_height * 1)
    draw_actor_icons(@actor, x, line_height * 2)
    draw_actor_class(@actor, x + 100, 0)
    draw_actor_hp(@actor, x + 100, line_height * 1)
    draw_actor_mp(@actor, x + 100, line_height * 2)
  end
end # Window_MapSkillStatus

#==============================================================================
# ** Window_MapSkillCommand
#==============================================================================

class Window_MapSkillCommand < Window_HorzCommand
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :skill_window
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    @position = R2_MAP_SKILL_MENU::POSITION
    super(x, y)
    adjust_command_position(@position)
    @actor = nil
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    case @position
    when 0..1
      Graphics.width / 2 - R2_MAP_SKILL_MENU::COMMAND_X
    when 2..3
      Graphics.width - R2_MAP_SKILL_MENU::COMMAND_X * 2
    end
  end
  #--------------------------------------------------------------------------
  # * Move Command Window
  #--------------------------------------------------------------------------
  def adjust_command_position(position)
    case position
    when 0
      self.x = Graphics.width / 2
      self.y = R2_MAP_SKILL_MENU::COMMAND_Y + fitting_height(R2_MAP_SKILL_MENU::STATUS_ROWS)
    when 1
      self.x = R2_MAP_SKILL_MENU::COMMAND_X
      self.y = R2_MAP_SKILL_MENU::COMMAND_Y + fitting_height(R2_MAP_SKILL_MENU::STATUS_ROWS)
    when 2
      self.x = R2_MAP_SKILL_MENU::COMMAND_X
      self.y = Graphics.height - R2_MAP_SKILL_MENU::COMMAND_Y - fitting_height(R2_MAP_SKILL_MENU::STATUS_ROWS) - self.height
    when 3
      self.x = R2_MAP_SKILL_MENU::COMMAND_X
      self.y = R2_MAP_SKILL_MENU::COMMAND_Y + fitting_height(R2_MAP_SKILL_MENU::STATUS_ROWS)
    end
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return R2_MAP_SKILL_MENU::COMMAND_COLUMNS
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
    select_last
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    return unless @actor
    @actor.added_skill_types.sort.each do |stype_id|
      name = $data_system.skill_types[stype_id]
      add_command(name, :skill, true, stype_id)
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    @skill_window.stype_id = current_ext if @skill_window
  end
  #--------------------------------------------------------------------------
  # * Set Skill Window
  #--------------------------------------------------------------------------
  def skill_window=(skill_window)
    @skill_window = skill_window
    update
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    skill = @actor.last_skill.object
    if skill
      select_ext(skill.stype_id)
    else
      select(0)
    end
  end
  #--------------------------------------------------------------------------
  # * Set Leading Digits
  #--------------------------------------------------------------------------
  def top_col=(col)
    col = 0 if col < 0
    col = item_max if col > item_max
    self.ox = col * (item_width + spacing)
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Right # col_max >= 2 && 
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    if (index < item_max - 1 || (wrap && horizontal?))
      select((index + 1) % item_max)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    if (index > 0 || (wrap && horizontal?))
      select((index - 1 + item_max) % item_max)
    end
  end
end # Window_MapSkillCommand

#==============================================================================
# ** Window_MapSkillList
#==============================================================================

class Window_MapSkillList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @actor = nil
    @stype_id = 0
    @data = []
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * Set Skill Type ID
  #--------------------------------------------------------------------------
  def stype_id=(stype_id)
    return if @stype_id == stype_id
    @stype_id = stype_id
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return R2_MAP_SKILL_MENU::SKILL_COLUMNS
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * Get Skill
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index])
  end
  #--------------------------------------------------------------------------
  # * Include in Skill List? 
  #--------------------------------------------------------------------------
  def include?(item)
    item && item.stype_id == @stype_id && item.menu_ok?
  end
  #--------------------------------------------------------------------------
  # * Display Skill in Active State?
  #--------------------------------------------------------------------------
  def enable?(item)
    @actor && @actor.usable?(item)
  end
  #--------------------------------------------------------------------------
  # * Create Skill List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = @actor ? @actor.skills.select {|skill| include?(skill) } : []
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select(@data.index(@actor.last_skill.object) || 0)
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = @data[index]
    if skill
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(skill, rect.x, rect.y, enable?(skill))
      draw_skill_cost(rect, skill)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Skill Use Cost
  #--------------------------------------------------------------------------
  def draw_skill_cost(rect, skill)
    if @actor.skill_tp_cost(skill) > 0
      change_color(tp_cost_color, enable?(skill))
      draw_text(rect, @actor.skill_tp_cost(skill), 2)
    elsif @actor.skill_mp_cost(skill) > 0
      change_color(mp_cost_color, enable?(skill))
      draw_text(rect, @actor.skill_mp_cost(skill), 2)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end # Window_MapSkillList

#==============================================================================
# ** Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Update Scene Transition
  #--------------------------------------------------------------------------
  alias r2_update_call_skill_map_scene  update_scene
  def update_scene
    r2_update_call_skill_map_scene
    update_call_skill_menu unless scene_changing?
  end
  #--------------------------------------------------------------------------
  # * Determine if Menu is Called due to Cancel Button
  #--------------------------------------------------------------------------
  def update_call_skill_menu
    if !$game_system.menu_disabled || !$game_map.interpreter.running? 
      if Input.trigger?(R2_MAP_SKILL_MENU::Call_Skill_Button) && !$game_player.moving?
        call_skill_menu
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Call Menu Screen
  #--------------------------------------------------------------------------
  def call_skill_menu
    Sound.play_ok
    SceneManager.call(Scene_Skill_Menu)
  end
end

#==============================================================================
# ** Scene_Skill
#==============================================================================

class Scene_Skill_Menu < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_command_window
    create_status_window
    create_item_window
  end
  #--------------------------------------------------------------------------
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_SkillHelp.new
    @help_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_MapSkillCommand.new(0, 0)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    @command_window.actor = @actor
    @command_window.set_handler(:skill,    method(:command_skill))
    @command_window.set_handler(:cancel,   method(:return_scene))
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
  end
  #--------------------------------------------------------------------------
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_status_window
    case R2_MAP_SKILL_MENU::POSITION
    when 0
      sx = Graphics.width / 2
      sy = R2_MAP_SKILL_MENU::STATUS_Y
    when 1
      sx = 0
      sy = R2_MAP_SKILL_MENU::STATUS_Y
    when 2
      sx = R2_MAP_SKILL_MENU::STATUS_X
      sy = R2_MAP_SKILL_MENU::STATUS_Y
    when 3
      sx = R2_MAP_SKILL_MENU::STATUS_X
      sy = R2_MAP_SKILL_MENU::STATUS_Y
    end
    @status_window = Window_MapSkillStatus.new(sx, sy)
    @status_window.viewport = @viewport
    @status_window.actor = @actor
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    wx = 0
    ww = Graphics.width
    case R2_MAP_SKILL_MENU::POSITION
    when 0
      wx = Graphics.width / 2
      wy = @command_window.y + @command_window.height
      ww = Graphics.width / 2 - R2_MAP_SKILL_MENU::SKILL_X unless R2_MAP_SKILL_MENU::FULL_WIDTH
      wh = Graphics.height - wy - (R2_MAP_SKILL_MENU::SKILL_Y - 5)
    when 1
      wx = R2_MAP_SKILL_MENU::SKILL_X
      wy = @command_window.y + @command_window.height
      ww = Graphics.width / 2 - R2_MAP_SKILL_MENU::SKILL_X unless R2_MAP_SKILL_MENU::FULL_WIDTH
      wh = Graphics.height - wy - (R2_MAP_SKILL_MENU::SKILL_Y - 5)
    when 2
      wx = R2_MAP_SKILL_MENU::SKILL_X unless R2_MAP_SKILL_MENU::FULL_WIDTH
      wy = @help_window.y + @help_window.height
      ww = Graphics.width - R2_MAP_SKILL_MENU::SKILL_X * 2 unless R2_MAP_SKILL_MENU::FULL_WIDTH
      wh = Graphics.height - @status_window.height - @help_window.height - @command_window.height - R2_MAP_SKILL_MENU::SKILL_Y * 2
    when 3
      wx = R2_MAP_SKILL_MENU::SKILL_X unless R2_MAP_SKILL_MENU::FULL_WIDTH
      wy = @status_window.y + @status_window.height + @command_window.height
      ww = Graphics.width - R2_MAP_SKILL_MENU::SKILL_X * 2 unless R2_MAP_SKILL_MENU::FULL_WIDTH
      wh = Graphics.height - @help_window.height - @status_window.height - @command_window.height - @status_window.y
      wh -= (R2_MAP_SKILL_MENU::SKILL_Y - 10)
    end
    @item_window = Window_MapSkillList.new(wx, wy, ww, wh)
    @item_window.actor = @actor
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @command_window.skill_window = @item_window
  end
  #--------------------------------------------------------------------------
  # * Get Skill's User
  #--------------------------------------------------------------------------
  def user
    @actor
  end
  #--------------------------------------------------------------------------
  # * [Skill] Command
  #--------------------------------------------------------------------------
  def command_skill
    @item_window.activate
    @item_window.select_last
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    @actor.last_skill.object = item
    determine_item
  end
  #--------------------------------------------------------------------------
  # * Item [Cancel]
  #--------------------------------------------------------------------------
  def on_item_cancel
    @help_window.clear
    @item_window.unselect
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * Play SE When Using Item
  #--------------------------------------------------------------------------
  def play_se_for_item
    Sound.play_use_skill
  end
  #--------------------------------------------------------------------------
  # * Use Item
  #--------------------------------------------------------------------------
  def use_item
    super
    @status_window.refresh
    @item_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Change Actors
  #--------------------------------------------------------------------------
  def on_actor_change
    @command_window.actor = @actor
    @status_window.actor = @actor
    @item_window.actor = @actor
    @command_window.activate
  end
end
