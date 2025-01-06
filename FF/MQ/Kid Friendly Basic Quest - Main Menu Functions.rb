# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Main Menu Functions     ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Menu Screens           ║    09 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  Set the Windows to look like FFMQ.                      ║
# ║                                                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# * Window Menu Command
#==============================================================================
class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    x = Graphics.width - window_width
    super(x, 0)
    select_last
  end
  #--------------------------------------------------------------------------
  # * Get Spacing for Items Arranged Side by Side
  #--------------------------------------------------------------------------
  def spacing
    return 15
  end
  #--------------------------------------------------------------------------
  # * Window Width
  #--------------------------------------------------------------------------
  def window_width
    return Graphics.width / 2
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(visible_line_number)
  end
  #--------------------------------------------------------------------------
  # * Get Line Height
  #--------------------------------------------------------------------------
  def line_height
    return 35
  end
  #--------------------------------------------------------------------------
  # * Visible Line Number
  #--------------------------------------------------------------------------
  def visible_line_number
    item_max
  end
  #--------------------------------------------------------------------------
  # * Make Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_main_commands
  end
  #--------------------------------------------------------------------------
  # * Add Main Commands
  #--------------------------------------------------------------------------
  def add_main_commands
    add_command("Items",   :item)
    add_command("Spells",  :spell)
    add_command("Armour",  :armour)
    add_command("Weapons",  :weapon)
    add_command("Status", :status)
    add_command("Customize", :game_end)
    add_command("Save", :save, save_enabled)
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items (for Text)
  #--------------------------------------------------------------------------
  def item_rect_for_text(index)
    rect = item_rect(index)
    rect.x += 40
    rect.y -= 10
    rect.width -= 8
    rect.height += 15
    rect
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    make_font_bigger
    change_color(normal_color, command_enabled?(index))
    draw_text(item_rect_for_text(index), command_name(index), alignment)
    make_font_smaller
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @cursor_all
      cursor_rect.set(0, 0, contents.width, row_max * item_height)
      self.top_row = 0
    elsif @index < 0
      cursor_rect.empty
    else
      ensure_cursor_visible
      cursor_rect.set(item_rect(@index))
    end
    name = command_name(index)
    adj = name.size * 6
    width = text_size(name).width + adj
    cursor_rect.x += 30
    cursor_rect.width = width
  end
  #--------------------------------------------------------------------------
  # * Get Text Size
  #--------------------------------------------------------------------------
  def text_size(str)
    contents.text_size(str)
  end
end

#==============================================================================
# ** Scene_Menu
#==============================================================================
class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_blank_window
    create_spell_window
    create_spell_window2
    create_item_window
    create_spell_count_window
    create_command_window
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_MenuCommand.new
    @command_window.z = 200
    @command_window.set_handler(:item,      method(:command_item))
    @command_window.set_handler(:spell,     method(:command_spell))
    @command_window.set_handler(:armour,    method(:command_armour))
    @command_window.set_handler(:weapon,    method(:command_weapons))
    @command_window.set_handler(:status,    method(:command_status))
    @command_window.set_handler(:save,      method(:command_save))
    @command_window.set_handler(:game_end,  method(:command_game_end))
    @command_window.set_handler(:cancel,    method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # * command_item
  #--------------------------------------------------------------------------
  def command_item
    SceneManager.call(Scene_Item)
  end
  #--------------------------------------------------------------------------
  # * command_spell
  #--------------------------------------------------------------------------
  def command_spell
    SceneManager.call(Scene_Spell)
  end
  #--------------------------------------------------------------------------
  # * command_armour
  #--------------------------------------------------------------------------
  def command_armour
    SceneManager.call(Scene_Armour)
  end
  #--------------------------------------------------------------------------
  # * command_weapons
  #--------------------------------------------------------------------------
  def command_weapons
    SceneManager.call(Scene_Weapons)
  end
  #--------------------------------------------------------------------------
  # * command_status
  #--------------------------------------------------------------------------
  def command_status
    SceneManager.call(Scene_Status)
  end
  #--------------------------------------------------------------------------
  # * command_save
  #--------------------------------------------------------------------------
  def command_save
    SceneManager.call(Scene_Save)
  end
  #--------------------------------------------------------------------------
  # * Create Spell Window1
  #--------------------------------------------------------------------------
  def create_spell_window
    ww = Graphics.width / 2
    wh = Graphics.height - 220
    @spell_window = Window_SpellList.new(0, 60, ww, wh)
    @spell_window.actor = $game_party.members[0]
    @spell_window.viewport = @viewport
    @spell_window.actor = $game_party.members[0]
    @spell_window.z = 50
    @spell_window.back_opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Create Spell Window2
  #--------------------------------------------------------------------------
  def create_spell_window2
    ww = Graphics.width / 2
    wh = Graphics.height - 220
    @spell_window2 = Window_SpellList.new(ww, 60, ww, wh)
    @spell_window2.actor = $game_party.members[1]
    @spell_window2.viewport = @viewport
    @spell_window2.actor = $game_party.members[1]
    @spell_window2.z = 10
    @spell_window2.back_opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    wh = Graphics.height - 258
    @item_window = Window_ItemList.new(0, 48, Graphics.width / 2, wh)
    @item_window.viewport = @viewport
    @item_window.z = 100
    @item_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Create Spell Count Window
  #--------------------------------------------------------------------------
  def create_spell_count_window
    @spell_count_window = Window_KFBQSpellCount.new(0, Graphics.height - 160, Graphics.width, 60)
    @spell_count_window.z = 60
  end
  #--------------------------------------------------------------------------
  # * Create Blank Window
  #--------------------------------------------------------------------------
  def create_blank_window
    @help_window = Window_ItemHelp.new
    @help_window.viewport = @viewport
  end
end

# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Menu Background         ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Dark Background        ║    09 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  Configures the menubase to show a black background      ║
# ║  for all menu scenes.                                    ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

class Scene_MenuBase < Scene_Base
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_background if @background_sprite
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(0, 0, 0, 255)
  end
  #--------------------------------------------------------------------------
  # * Free Background
  #--------------------------------------------------------------------------
  def dispose_background
    if @background_sprite
      @background_sprite.bitmap.dispose
      @background_sprite.dispose
    end
  end
end
