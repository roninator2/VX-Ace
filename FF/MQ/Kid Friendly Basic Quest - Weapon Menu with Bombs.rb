# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Weapon Screen + Bombs   ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Weapon Screen          ║    09 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  When giving the player the bomb also use the            ║
# ║  script command: give_bombs(25)                          ║
# ║  then the player will be able to use bombs and the       ║
# ║  weapons screen will reflect the current amount left     ║
# ║  Same goes for the ninja stars for the second player     ║
# ║  use script command: give_ninja_stars(75)                ║
# ║                                                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔═════════════════════════════════════╗
# ║ Terms of use:                       ║
# ║ Free for all uses in RPG Maker      ║
# ╚═════════════════════════════════════╝

#==============================================================================
# ** Game_Party
#==============================================================================
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :bombs
  attr_reader   :ninja_stars
  #--------------------------------------------------------------------------
  # * Initialize All Item Lists
  #--------------------------------------------------------------------------
  alias r2_init_bombs_init_all  init_all_items
  def init_all_items
    r2_init_bombs_init_all
    @bomb_count = 0
    @ninja_stars = 0
  end
  #--------------------------------------------------------------------------
  # * Get Number of bomb in inventory
  #--------------------------------------------------------------------------
  def add_bombs(value)
    @bomb_count += value
  end
  #--------------------------------------------------------------------------
  # * Get Number of bomb in inventory
  #--------------------------------------------------------------------------
  def bombs?
    return @bomb_count
  end
  #--------------------------------------------------------------------------
  # * Remove 1 bomb from inventory
  #--------------------------------------------------------------------------
  def use_bomb(value = false)
    @bomb_count -= 1 if value
  end
  #--------------------------------------------------------------------------
  # * Get Number of ninja stars in inventory
  #--------------------------------------------------------------------------
  def add_ninja_stars(value)
    @ninja_stars += value
  end
  #--------------------------------------------------------------------------
  # * Get Number of ninja stars in inventory
  #--------------------------------------------------------------------------
  def ninja_stars?
    return @ninja_stars
  end
  #--------------------------------------------------------------------------
  # * Remove 1 ninja star from inventory
  #--------------------------------------------------------------------------
  def use_star(value = false)
    @ninja_stars -= 1 if value
  end
end

#==============================================================================
# ** Game_Interpreter
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Add Bombs to Party
  #--------------------------------------------------------------------------
  def add_bombs(value)
    $game_party.add_bombs(value)
  end
  #--------------------------------------------------------------------------
  # * Add Ninja Stars to Party
  #--------------------------------------------------------------------------
  def add_ninja_stars(value)
    $game_party.add_ninja_stars(value)
  end
end

#==============================================================================
# ** Window WeaponHelp
#==============================================================================
class Window_WeaponHelp < Window_Base
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
# ** Window Weapon Description
#==============================================================================
class Window_WeaponDescription < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(line_number = 3)
    super(0, 48, Graphics.width / 2 + 60, fitting_height(line_number))
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
    @item = nil
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #     item : Skills and items etc.
  #--------------------------------------------------------------------------
  def set_item(item)
    @item = item
    set_text(item ? item.description : "")
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_text_ex(4, 0, @text)
    draw_icons if @item
  end
  #--------------------------------------------------------------------------
  # * Draw Icons
  #--------------------------------------------------------------------------
  def draw_icons
    data = []
    list = @item.features
    list.each do |fet|
      if fet.code == 14
        state = $data_states[fet.data_id]
        data << state
      end
    end
    data.each do |st|
      num = st.id
      y = 24
      y = 48 if num >= 11
      num -= 11 if num >= 11
      draw_icon(st.icon_index, num * 24, y)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Bottom Padding
  #--------------------------------------------------------------------------
  def update_padding_bottom
    surplus = (height - standard_padding * 2) % item_height
    self.padding_bottom = padding + surplus - 20
  end
  #--------------------------------------------------------------------------
  # * Draw Icon
  #     enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_icon(icon_index, x, y, enabled = true)
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    contents.blt(x, y, bitmap, rect, enabled ? 255 : translucent_alpha)
  end
end

#==============================================================================
# ** Window_Item_Command
#==============================================================================
class Window_Weapon_Command < Window_Base
  #--------------------------------------------------------------------------
  # Initialize
  #--------------------------------------------------------------------------
  def initialize
    super(Graphics.width / 2, 0, Graphics.width / 2, fitting_height(1))
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
    name = "Weapons"
    draw_text(4, 0, 200, line_height, name, 1)
  end
end

#==============================================================================
# ** Window_ItemList
#==============================================================================
class Window_WeaponList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    @height = height
    super
    @category = :none
    @data = []
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 4
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
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
    when :weapon
      item.is_a?(RPG::Weapon) && !item.kfbq_exclude?
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    return true
  end
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = []
    subtract = 0
    for i in 1..$data_weapons.size - 1
      weapon = $data_weapons[i]
      if !weapon.kfbq_exclude?
        @data[i-1] = nil unless !@data[i-1].nil?
      else
        subtract += 1
        next
      end
      if $game_party.has_item?(weapon, true)
        weapon.note.split(/[\r\n]+/).each { |line|
          case line
          when /<position:[-_ ](\d+)>/i
            pos = $1.to_i
            @data[pos-1-subtract] = weapon
          end
        }
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Specified Item Is Included in Members' Equipment
  #--------------------------------------------------------------------------
  def members_equip_include?(item)
    members.any? {|actor| 
    return false if actor == members[1]
    return true if actor.equips.include?(item) }
  end
  #--------------------------------------------------------------------------
  # * Set Help Window
  #--------------------------------------------------------------------------
  def description_window=(help_window)
    @description_window = help_window
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select(@data.index($game_party.last_item.object) || 0)
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      pos = index % 4
      case pos
      when 0
        ox = 8
      when 1
        ox = 22
      when 2
        ox = 40
      when 3
        ox = 60
      end
      rect = item_rect(index)
      rect.width -= 4
      rect.x += ox
      draw_icon(item.icon_index, rect.x, rect.y, true)
      draw_item_number(rect, item) if item.bomb_item?
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Number of Items
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item)
    make_font_bigger
    rect.y -= 10
    rect.x -= 20
    draw_text(rect, sprintf("%2d", $game_party.bombs?),1) if $game_party.bombs? > 0
    make_font_smaller
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
    @description_window.set_item(item)
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
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    @actor == $game_party.members[0]
    @category = :weapon
    make_item_list
    contents.clear
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    ensure_cursor_visible
    cursor_rect.set(item_rect(@index))
    cursor_rect.height += 2
    cursor_rect.width += 8
    pos = index % 4
    case pos
    when 0
      ox = 1
    when 1
      ox = 16
    when 2
      ox = 32
    when 3
      ox = 52
    end
    cursor_rect.x += ox
    cursor_rect.y -= 2
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  def contents_height
    rows = row_max - 3
    rows = 0 if rows <= 0
    return @height - standard_padding * 2 + rows * 60 + 60
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  def standard_padding
    return 12
  end
  #--------------------------------------------------------------------------
  # * Update Bottom Padding
  #--------------------------------------------------------------------------
  def update_padding_bottom
    rows = row_max - 3
    rows = 0 if rows <= 0
    surplus = (@height - standard_padding * 2) % item_height
    self.padding_bottom = padding + surplus - 30
  end
end

#==============================================================================
# ** Bomb Count Window
#==============================================================================
class Bomb_Count_Window < Window_Base
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
 def initialize(x, y, width, height)
    super(x,y,width,height)
    self.z = 140
    self.windowskin = Cache.system("Window_Border")
    self.opacity = 0
    self.arrows_visible = false
    self.pause = false
    self.back_opacity = 0
    self.contents_opacity = 255
    refresh
  end
  #--------------------------------------------------------------------------
  # * Remove Padding
  #--------------------------------------------------------------------------
  def standard_padding
    return 0
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear unless disposed?
    return if disposed?
    draw_bombs
  end
  #--------------------------------------------------------------------------
  # * Draw Bombs in Inventory
  #--------------------------------------------------------------------------
  def draw_bombs
    change_color(crisis_color)
    if $game_party.has_item?($data_weapons[5])
      text = "Weapons Left............ " + ($game_party.bombs?).to_s
      draw_text(0,0,300, 24, text)
    end
  end
end

#==============================================================================
# ** Scene_Weapons
#==============================================================================
class Scene_Weapons < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_description_window
    create_weapon_window
    create_actor2_equip_window if $game_party.members[1]
    create_weapon_command
    create_bomb_window
  end
  #--------------------------------------------------------------------------
  # * Create Category Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_WeaponHelp.new
    @help_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Create Category Window
  #--------------------------------------------------------------------------
  def create_description_window
    @description_window = Window_WeaponDescription.new
    @description_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Create Item Command Text Window
  #--------------------------------------------------------------------------
  def create_weapon_command
    @command_window = Window_Weapon_Command.new
    @command_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_weapon_window
    ww = Graphics.width / 2 + 60
    wy = @description_window.y + @description_window.height
    wh = Graphics.height - wy - 100
    @weapon_window = Window_WeaponList.new(0, wy, ww, wh)
    @weapon_window.viewport = @viewport
    @weapon_window.help_window = @help_window
    @weapon_window.description_window = @description_window
    @weapon_window.set_handler(:ok,     method(:on_item_ok))
    @weapon_window.set_handler(:cancel, method(:return_scene))
    @weapon_window.refresh
    @weapon_window.activate
    @weapon_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * Create Item Command Text Window
  #--------------------------------------------------------------------------
  def create_bomb_window
    @bomb_window = Bomb_Count_Window.new(50, 350, 300, 48)
    @bomb_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_actor2_equip_window
    wx = Graphics.width / 2 + 60
    ww = Graphics.width - wx
    wh = Graphics.height - 148
    @armour_window2 = Window_ArmourList2.new(wx, 48, ww, wh)
    @armour_window2.viewport = @viewport
    @armour_window2.help_window = @help_window
    @armour_window2.set_handler(:cancel, method(:return_scene))
    @armour_window2.refresh
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    if @weapon_window.item.nil?
      Sound.play_buzzer
      @weapon_window.activate
      return
    end
    Sound.play_equip
    @actor.change_equip(0, @weapon_window.item)
    @weapon_window.activate
    @weapon_window.refresh
    @actor1_hud.refresh
    @actor2_hud.refresh if $game_party.members[1]
  end
end
