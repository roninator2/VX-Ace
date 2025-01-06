# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Map Item Menu                          ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Call a item menu on the map                   ║    14 Jan 2024     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Show Item Menu on map without main menu                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║  Change the values below to the desired configuration              ║
# ║                                                                    ║
# ║  Call_Item_Button -> Button pressed to call the menu               ║
# ║                                                                    ║
# ║  POSITION -> values are 0, 1, 2, 3                                 ║
# ║              0 = Help window left side                             ║
# ║              1 = Help window right side                            ║
# ║              2 = Help window top                                   ║
# ║              3 = Help window bottom                                ║
# ║    All other windows move based on the Help window                 ║
# ║                                                                    ║
# ║  USE_NOTE -> allows using note tags in the item notebox            ║
# ║    If using the note tags they are to be used like this            ║
# ║       <item text>                                                  ║
# ║        write all your text here                                    ║
# ║        and more text here                                          ║
# ║        also supports icon codes \i[112]                            ║
# ║       </item text>                                                 ║
# ║    If not using item note tags then it will write the              ║
# ║    default item description                                        ║
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
# ║  ITEM_X & ITEM_Y -> move the window away from the                  ║
# ║                       screen edge                                  ║
# ║  FULL_WIDTH -> Ignore the X value and go full width                ║
# ║  ITEM_COLUMNS -> How many item columns to display                  ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Note:                                                              ║
# ║   This script does not adjust for new item categories.             ║
# ║   The script is based on the default system.                       ║
# ║   If you add in new item categories then this script               ║
# ║   will need to be adjusted accordingly.                            ║
# ║   Default is :item, :weapon, :armor, :key_item                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 22 Nov 2024 - Script finished                               ║
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

module R2_MAP_ITEM_MENU
  Call_Item_Button = :Z
	# :C = Z, :B = X, :A = SHIFT, :X = A, :Y = S, :Z = D, :L = Q, :R = W
  
  # ======================================================
  POSITION = 3
  # 0 = left, 1 = Right, 2 = top, 3 = bottom
  # help window goes to the indicated position
  
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
  # Command Window
  COMMAND_X = 20
  # position of where the ommand window is positioned on X axis
  COMMAND_Y = 20
  # position of where the ommand window is positioned on Y axis
  COMMAND_COLUMNS = 4
  # position 0 & 1 -> recommend 1 or 2, position 2 & 3 -> recommend < 5

  # ======================================================
  # Item Window
  ITEM_X = 20
  # position of where the Skill window is positioned on X axis
  ITEM_Y = 20
  # position of where the Skill window is positioned on Y axis
  FULL_WIDTH = false
  # wether to span across the window width
  ITEM_COLUMNS = 2
  # number of columns in window
  # position 0 & 1 -> recommend 1, position 2 & 3 -> recommend 2 or 3
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

#==============================================================================
# ** Window_Help
#==============================================================================

class Window_ItemHelp < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(line_number = R2_MAP_ITEM_MENU::HELP_LINES)
    @position = R2_MAP_ITEM_MENU::POSITION
    super(R2_MAP_ITEM_MENU::HELP_X, R2_MAP_ITEM_MENU::HELP_Y, width, fitting_height(line_number))
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
    if R2_MAP_ITEM_MENU::USE_NOTE == true
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
      Graphics.width / 2 - R2_MAP_ITEM_MENU::HELP_X
    when 2..3
      Graphics.width - R2_MAP_ITEM_MENU::HELP_X * 2
    end
  end
  #--------------------------------------------------------------------------
  # * Move Help Window
  #--------------------------------------------------------------------------
  def adjust_help_position(position)
    case position
    when 0
      self.x = R2_MAP_ITEM_MENU::HELP_X
      self.y = R2_MAP_ITEM_MENU::HELP_Y
    when 1
      self.x = Graphics.width / 2
      self.y = R2_MAP_ITEM_MENU::HELP_Y
    when 2
      self.x = R2_MAP_ITEM_MENU::HELP_X
      self.y = R2_MAP_ITEM_MENU::HELP_Y
    when 3
      self.x = R2_MAP_ITEM_MENU::HELP_X
      self.y = Graphics.height - self.height - R2_MAP_ITEM_MENU::HELP_Y / 2
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
# ** Window_MapSkillCommand
#==============================================================================

class Window_MapItemCommand < Window_HorzCommand
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :item_window
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    @position = R2_MAP_ITEM_MENU::POSITION
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
      Graphics.width / 2 - R2_MAP_ITEM_MENU::COMMAND_X
    when 2..3
      Graphics.width - R2_MAP_ITEM_MENU::COMMAND_X * 2
    end
  end
  #--------------------------------------------------------------------------
  # * Move Command Window
  #--------------------------------------------------------------------------
  def adjust_command_position(position)
    case position
    when 0
      self.x = Graphics.width / 2
      self.y = R2_MAP_ITEM_MENU::COMMAND_Y
    when 1
      self.x = R2_MAP_ITEM_MENU::COMMAND_X
      self.y = R2_MAP_ITEM_MENU::COMMAND_Y
    when 2
      self.x = R2_MAP_ITEM_MENU::COMMAND_X
      self.y = Graphics.height - R2_MAP_ITEM_MENU::COMMAND_Y - self.height
    when 3
      self.x = R2_MAP_ITEM_MENU::COMMAND_X
      self.y = R2_MAP_ITEM_MENU::COMMAND_Y
    end
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return R2_MAP_ITEM_MENU::COMMAND_COLUMNS
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::item,     :item)
    add_command(Vocab::weapon,   :weapon)
    add_command(Vocab::armor,    :armor)
    add_command(Vocab::key_item, :key_item)
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    @item_window.category = current_symbol if @item_window
  end
  #--------------------------------------------------------------------------
  # * Set Skill Window
  #--------------------------------------------------------------------------
  def item_window=(item_window)
    @item_window = item_window
    update
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

class Window_MapItemList < Window_ItemList
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @category = :none
    @data = []
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return R2_MAP_ITEM_MENU::ITEM_COLUMNS
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
end # Window_MapItemList

#==============================================================================
# ** Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Update Scene Transition
  #--------------------------------------------------------------------------
  alias r2_update_call_item_map_scene  update_scene
  def update_scene
    r2_update_call_item_map_scene
    update_call_item_menu unless scene_changing?
  end
  #--------------------------------------------------------------------------
  # * Determine if Menu is Called due to Cancel Button
  #--------------------------------------------------------------------------
  def update_call_item_menu
    if !$game_system.menu_disabled || !$game_map.interpreter.running? 
      if Input.trigger?(R2_MAP_ITEM_MENU::Call_Item_Button) && !$game_player.moving?
        call_item_menu
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Call Menu Screen
  #--------------------------------------------------------------------------
  def call_item_menu
    Sound.play_ok
    SceneManager.call(Scene_Item_Menu)
  end
end

#==============================================================================
# ** Scene_Skill
#==============================================================================

class Scene_Item_Menu < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_command_window
    create_item_window
  end
  #--------------------------------------------------------------------------
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_ItemHelp.new
    @help_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_MapItemCommand.new(0, 0)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    @command_window.set_handler(:ok,     method(:on_category_ok))
    @command_window.set_handler(:cancel,   method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    wx = 0
    ww = Graphics.width
    case R2_MAP_ITEM_MENU::POSITION
    when 0
      wx = Graphics.width / 2
      wy = @command_window.y + @command_window.height
      ww = Graphics.width / 2 - R2_MAP_ITEM_MENU::ITEM_X unless R2_MAP_ITEM_MENU::FULL_WIDTH
      wh = Graphics.height - wy - (R2_MAP_ITEM_MENU::ITEM_Y - 5)
    when 1
      wx = R2_MAP_ITEM_MENU::ITEM_X
      wy = @command_window.y + @command_window.height
      ww = Graphics.width / 2 - R2_MAP_ITEM_MENU::ITEM_X unless R2_MAP_ITEM_MENU::FULL_WIDTH
      wh = Graphics.height - wy - (R2_MAP_ITEM_MENU::ITEM_Y - 5)
    when 2
      wx = R2_MAP_ITEM_MENU::ITEM_X unless R2_MAP_ITEM_MENU::FULL_WIDTH
      wy = @help_window.y + @help_window.height
      ww = Graphics.width - R2_MAP_ITEM_MENU::ITEM_X * 2 unless R2_MAP_ITEM_MENU::FULL_WIDTH
      wh = Graphics.height - @help_window.height - @command_window.height - R2_MAP_ITEM_MENU::ITEM_Y * 2
    when 3
      wx = R2_MAP_ITEM_MENU::ITEM_X unless R2_MAP_ITEM_MENU::FULL_WIDTH
      wy = @command_window.height + R2_MAP_ITEM_MENU::ITEM_Y
      ww = Graphics.width - R2_MAP_ITEM_MENU::ITEM_X * 2 unless R2_MAP_ITEM_MENU::FULL_WIDTH
      wh = Graphics.height - @help_window.height - @command_window.height -  + R2_MAP_ITEM_MENU::ITEM_Y
      wh -= (R2_MAP_ITEM_MENU::ITEM_Y - 10)
    end
    @item_window = Window_MapItemList.new(wx, wy, ww, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @command_window.item_window = @item_window
  end
  #--------------------------------------------------------------------------
  # * [Skill] Command
  #--------------------------------------------------------------------------
  def on_category_ok
    @item_window.activate
    @item_window.select_last
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
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
    @item_window.refresh
  end
end
