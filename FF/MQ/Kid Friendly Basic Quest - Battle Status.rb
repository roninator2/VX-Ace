# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Battle Status Override  ║  Version: 1.01     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Battle Status Window   ║    12 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  none                                                    ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# ** Window_BattleStatus
#==============================================================================

class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :pending_index            # Pending position (for formation)
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, window_width, window_height)
    @pending_index = -1
    self.z = 3150
    self.back_opacity = 0
    self.openness = 0
    self.contents_opacity = 255
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    100
  end
  #--------------------------------------------------------------------------
  # * Column Maximum
  #--------------------------------------------------------------------------
  def col_max
    2
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    $game_party.members.size
  end
  #--------------------------------------------------------------------------
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    (height - standard_padding * 2)
  end
  #--------------------------------------------------------------------------
  # * Get Item Width
  #--------------------------------------------------------------------------
  def item_width
    window_width / col_max - spacing
  end
  #--------------------------------------------------------------------------
  # * Item Rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    rect.x = index % col_max * (item_width + spacing)
    rect.y = index / col_max * item_height
    rect
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    cursor_rect.empty
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = $game_party.members[index]
    enabled = $game_party.battle_members.include?(actor)
    rect = item_rect(index)
    draw_item_background(index)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Draw Background for Item
  #--------------------------------------------------------------------------
  def draw_item_background(index)
    if index == @pending_index
      contents.fill_rect(item_rect(index), pending_color)
    end
  end
  #--------------------------------------------------------------------------
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
    super
    $game_party.menu_actor = $game_party.members[index]
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select($game_party.menu_actor.index || 0)
  end
  #--------------------------------------------------------------------------
  # * Pending Colour
  #--------------------------------------------------------------------------
  def pending_color
    windowskin.get_pixel(116, 100)
  end
  #--------------------------------------------------------------------------
  # * Set Pending Position (for Formation)
  #--------------------------------------------------------------------------
  def pending_index=(index)
    last_pending_index = @pending_index
    @pending_index = index
    redraw_item(@pending_index)
    redraw_item(last_pending_index)
  end
end

#==============================================================================
# ** Window_MenuActor
#==============================================================================
class Window_BattleActor < Window_BattleStatus
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(info_viewport)
    super()
    self.y = Graphics.height - 100#info_viewport.rect.y
    self.visible = false
    self.openness = 255
    @info_viewport = info_viewport
  end
  #--------------------------------------------------------------------------
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
    $game_party.target_actor = $game_party.members[index] unless @cursor_all
    call_ok_handler
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select($game_party.target_actor.index || 0)
  end
  #--------------------------------------------------------------------------
  # * Set Position of Cursor for Item
  #--------------------------------------------------------------------------
  def select_for_item(item)
    @cursor_fix = item.for_user?
    @cursor_all = item.for_all?
    if @cursor_fix
      select($game_party.menu_actor.index)
    elsif @cursor_all
      select(0)
    else
      select_last
    end
  end
  #--------------------------------------------------------------------------
  # * Show Window
  #--------------------------------------------------------------------------
  def show
    if @info_viewport
      width_remain = Graphics.width - width
      self.x = width_remain
      @info_viewport.rect.width = width_remain
      select(0)
    end
    super
  end
  #--------------------------------------------------------------------------
  # * Hide Window
  #--------------------------------------------------------------------------
  def hide
    @info_viewport.rect.width = Graphics.width if @info_viewport
    super
  end
end
