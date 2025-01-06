# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Armour Menu Functions   ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Armour Screens         ║    09 Mar 2023     ║
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
# ** Window ArmourHelp
#==============================================================================
class Window_ArmourHelp < Window_Base
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
# ** Window Armour Description
#==============================================================================
class Window_ArmourDescription < Window_Base
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
class Window_Armour_Command < Window_Base
  #--------------------------------------------------------------------------
  # initialize
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
    name = "Armour"
    draw_text(4, 0, 200, line_height, name, 1)
  end
end

#==============================================================================
# ** Window_ItemList
#==============================================================================
class Window_ArmourList < Window_Selectable
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
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    return 60
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
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
    when :armor
      item.is_a?(RPG::Armor)# && !item.kfbq_exclude?
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
    for i in 1..$data_armors.size - 1
      armour = $data_armors[i]
      if !armour.kfbq_exclude?
        @data[i-1] = nil unless !@data[i-1].nil?
      else
        subtract += 1
        next
      end
      if $game_party.has_item?(armour, true)
        armour.note.split(/[\r\n]+/).each { |line|
          case line
          when /<position:[-_ ](\d+)>/i
            pos = $1.to_i
            @data[pos-1-subtract] = armour
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
      rect.x += ox
      draw_icon(item.icon_index, rect.x, rect.y+30, enable?(item))
    end
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
    @category = :armor
    make_item_list
    create_contents
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    ensure_cursor_visible
    cursor_rect.set(item_rect(@index))
    cursor_rect.height += 4
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
    cursor_rect.y += 24
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  def contents_height
    rows = row_max - 3
    rows = 0 if rows <= 0
    return @height - standard_padding * 2 + rows * 60 + 30
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
    surplus = (height - standard_padding * 2) % item_height
    self.padding_bottom = padding + surplus - 30
  end
end

#==============================================================================
# ** Window_ItemList
#==============================================================================
class Window_ArmourList2 < Window_Selectable
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
    return 1
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    return 5
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Include in Item List?
  #--------------------------------------------------------------------------
  def include?(item)
    case @category
    when :armor
      item.is_a?(RPG::Armor)
    when :weapon
      item.is_a?(RPG::Weapon)
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    return true
    $game_party.usable?(item)
  end
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    for i in 1..4
      item = $game_party.members[1].equips[i]
      if !item.nil?
        @data[i-1] = item
      else
        @data[i-1] = nil
      end
    end
    @data[4] = $game_party.members[1].equips[0]
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    if $game_party.members[1].equips[0] == $data_weapons[16]
      text = ($game_party.ninja_stars?).to_s
      draw_text(130,240,50, 24, text)
    end
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_icon(item.icon_index, rect.x+60, rect.y, enable?(item))
    end
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
    @actor = $game_party.members[1]
    return if @actor == nil
    make_item_list
    create_contents
    draw_all_items
  end
end

#==============================================================================
# ** Armour Total Window
#==============================================================================
class Armour_Total_Window < Window_Base
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
    draw_total
  end
  #--------------------------------------------------------------------------
  # * Draw Total Defense
  #--------------------------------------------------------------------------
  def draw_total
    change_color(crisis_color)
    text = "Defense Total " + ($game_party.members[0].def).to_s
    draw_text(0,0,200, 24, text)
  end
end

#==============================================================================
# ** Scene_Item
#==============================================================================
class Scene_Armour < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_description_window
    create_armour_window
    create_actor2_equip_window
    create_armour_command
    create_armour_total
  end
  #--------------------------------------------------------------------------
  # * Create Category Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_ArmourHelp.new
    @help_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Create Category Window
  #--------------------------------------------------------------------------
  def create_description_window
    @description_window = Window_ArmourDescription.new
    @description_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Create Item Command Text Window
  #--------------------------------------------------------------------------
  def create_armour_command
    @command_window = Window_Armour_Command.new
    @command_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_armour_window
    ww = Graphics.width / 2 + 60
    wy = @description_window.y + @description_window.height
    wh = Graphics.height - wy - 100
    @armour_window = Window_ArmourList.new(0, wy, ww, wh)
    @armour_window.viewport = @viewport
    @armour_window.help_window = @help_window
    @armour_window.description_window = @description_window
    @armour_window.set_handler(:ok,     method(:on_item_ok))
    @armour_window.set_handler(:cancel, method(:return_scene))
    @armour_window.refresh
    @armour_window.activate
    @armour_window.select(0)
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
  # * Create Item Command Text Window
  #--------------------------------------------------------------------------
  def create_armour_total
    @total_window = Armour_Total_Window.new(50, 150, 200, 24)
    @total_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    if @armour_window.item.nil?
      Sound.play_buzzer
      @armour_window.activate
      return
    end
    slot_id = @armour_window.item.etype_id
    Sound.play_equip
    @actor.change_equip(slot_id, @armour_window.item)
    @armour_window.refresh
    @armour_window.activate
  end
end
