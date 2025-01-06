# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Item Menu Functions     ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Item Screens           ║    09 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  Set the Windows to look like FFMQ.                      ║
# ║                                                          ║
# ║  Due to the nature of how this script works, a note tag  ║
# ║  is used to stop database entries from showing up in the ║
# ║  menu. use note tag <kfbq exclude> to prevent an item    ║
# ║  from showing in the item menu in game.                  ║
# ║                                                          ║
# ║  Use note tag <bomb> to indicate if a weapon is a bomb.  ║
# ║  Then the item will be treated differently.              ║
# ║  It will have a specified number of uses attached to it. ║
# ║                                                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# ■ RPG::BaseItem
#==============================================================================
class RPG::BaseItem
  def kfbq_exclude?
    @note =~ /<kfbq exclude>/i
  end
  def bomb_item?
    @note =~ /<bomb>/i
  end
end

#==============================================================================
# ** Window_Help
#==============================================================================
class Window_ItemHelp < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(line_number = 1)
    super(0, 0, Graphics.width / 2, fitting_height(line_number))
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #--------------------------------------------------------------------------
  def set_text(text)
    if text != @text
      @text = text
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    set_text("")
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #     item : Skills and items etc.
  #--------------------------------------------------------------------------
  def set_item(item)
    set_text(item ? item.name : "")
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_text_ex(4, 0, @text)
  end
end

#==============================================================================
# ** Window_Item_Command
#==============================================================================
class Window_Item_Command < Window_Base
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    super(Graphics.width / 2 + 60, 0, Graphics.width / 2 - 60, fitting_height(1))
    refresh
  end
  #--------------------------------------------------------------------------
  # dispose
  #--------------------------------------------------------------------------
  def dispose
    contents.dispose unless disposed?
    super unless disposed?
  end
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(crisis_color)
    name = "Items"
    draw_text(4, 0, 200, line_height, name, 1)
  end
end

#==============================================================================
# ** Window_ItemList
#==============================================================================
class Window_ItemList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    self.back_opacity = 255
    @category = :none
    @data = []
  end
  #--------------------------------------------------------------------------
  # *  Column Maximum
  #--------------------------------------------------------------------------
  def col_max
    return 4
  end
  #--------------------------------------------------------------------------
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    return 60
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    return true
  end
  #--------------------------------------------------------------------------
  # * Include in Item List?
  #--------------------------------------------------------------------------
  def include?(item)
    case @category
    when :item
      item.is_a?(RPG::Item) && !item.kfbq_exclude?
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    $game_party.usable?(item)
  end
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = []
    subtract = 0
    for i in 1..$data_items.size - 1
      item = $data_items[i]
      if !item.kfbq_exclude?
        @data[i-1] = nil unless !@data[i-1].nil?
      else
        subtract += 1
        next
      end
      if $game_party.has_item?(item)
        item.note.split(/[\r\n]+/).each { |line|
          case line
          when /<position:[-_ ](\d+)>/i
            pos = $1.to_i
            @data[pos-1-subtract] = item
          end
        }
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_icon(item.icon_index, rect.x+3, rect.y+2, enable?(item))
      draw_item_number(rect, item) unless item.key_item?
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Number of Items
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item)
    make_font_bigger
    rect.y -= 10
    rect.x -= 10
    draw_text(rect, sprintf("%2d", $game_party.item_number(item)),1) if $game_party.item_number(item) > 1
    make_font_smaller
  end
  #--------------------------------------------------------------------------
  # * Item Rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = 60
    rect.height = 60
    rect.x = index % col_max * (60)
    rect.y = index / col_max * (60)
    rect
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
    @category = :item
    make_item_list
    create_contents
    draw_all_items
  end
end

#==============================================================================
# ** Scene_Item
#==============================================================================
class Scene_Item < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_item_window
    create_item_command
    create_spell_window2
    create_spell_count_window
  end
  #--------------------------------------------------------------------------
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_ItemHelp.new
    @help_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Create Item Command Text Window
  #--------------------------------------------------------------------------
  def create_item_command
    @command_window = Window_Item_Command.new
    @command_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    wh = Graphics.height - 148
    @item_window = Window_ItemList.new(0, 48, Graphics.width / 2, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:return_scene))
    @item_window.refresh
    @item_window.activate
    @item_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * Create Item Window2
  #--------------------------------------------------------------------------
  def create_spell_window2
    ww = Graphics.width / 2
    wh = Graphics.height - 208
    @spell_window2 = Window_SpellList.new(ww, 48, ww, wh)
    @spell_window2.actor = $game_party.members[1]
    @spell_window2.viewport = @viewport
    @spell_window2.help_window = @help_window
    @spell_window2.actor = $game_party.members[1]
    @spell_window2.set_handler(:ok,     method(:on_item_ok))
    @spell_window2.set_handler(:cancel, method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # * Confirm Item
  #--------------------------------------------------------------------------
  def determine_item
    if item.for_friend?
      show_sub_window(@actor_window)
      @actor_window.select_for_item(item)
    else
      use_item if SceneManager.scene_is?(Scene_Battle)
      @item_window.refresh
      activate_item_window
    end
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    @actor.last_skill.object = item
    determine_item if !item.nil?
    @item_window.refresh
    activate_item_window
  end
  #--------------------------------------------------------------------------
  # * Item [Cancel]
  #--------------------------------------------------------------------------
  def on_item_cancel
    return_scene
  end
  #--------------------------------------------------------------------------
  # * Play SE When Using Item
  #--------------------------------------------------------------------------
  def play_se_for_item
    Sound.play_use_item
  end
  #--------------------------------------------------------------------------
  # * Use Item
  #--------------------------------------------------------------------------
  def use_item
    super
    @item_window.redraw_current_item
  end
  #--------------------------------------------------------------------------
  # * Create Spell Count Window
  #--------------------------------------------------------------------------
  def create_spell_count_window
    @spell_count_window = Window_KFBQSpellCount.new(0, Graphics.height - 160, Graphics.width, 60)
    @spell_count_window.z = 60
  end
end
