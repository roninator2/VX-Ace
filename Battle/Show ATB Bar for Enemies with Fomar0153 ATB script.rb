# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Show ATB Bar for Enemies     ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   Show Enemy ATB Bar on battler     ║    06 Jun 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║   Adjust the settings below                              ║
# ║                                                          ║
# ║   Due to the positioning of the enemy,                   ║
# ║   you will likely need to adjust the bar position        ║
# ║   so that the adjustment numbers are negative.           ║
# ║   This is because I used the enemies screen position     ║
# ║   which causes the bar to be at the bottom of the        ║
# ║   enemy position. The window is also set to not          ║
# ║   overlap the status window.                             ║
# ║                                                          ║
# ║   Requires Fomar0153 ATB script                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except Nudity           ║
# ╚══════════════════════════════════════════════════════════╝

# ╔══════════════════════════════════════════════════════════╗
# ║ Customize below:                                         ║
# ╚══════════════════════════════════════════════════════════╝
module R2_AP_Gauge_Pos
  X_Adjust  = -70   # x position of the bar from the enemy position
  Y_Adjust  = -40   # y position of the bar from the enemy position
  AP_Width  = 100   # Bar width
  AP_Height = 24    # Bar height
  Draw_Name = false # Draw enemy name
  Colour_1 = 17     # Starting colour of bar
  Colour_2 = 29     # ending colour of bar
end
# ╔══════════════════════════════════════════════════════════╗
# ║ End of Customization                                     ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# Window Base
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # ○ Acquisition of various character colors
  #--------------------------------------------------------------------------
  def eap_gauge_color1;   text_color(R2_AP_Gauge_Pos::Colour_1);  end
  def eap_gauge_color2;   text_color(R2_AP_Gauge_Pos::Colour_2);  end
  #--------------------------------------------------------------------------
  # ○ AP Drawing
  #--------------------------------------------------------------------------
  def draw_enemy_ap(enemy, x, y, width = 100)
    draw_gauge(x, y, width, enemy.stamina_rate, eap_gauge_color1, eap_gauge_color2)
  end
end

#==============================================================================
# Enemy AP
#==============================================================================
class Window_Enemy_AP < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     info_viewport : Viewport for displaying information
  #--------------------------------------------------------------------------
  def initialize(status)
    super(0, 0, Graphics.width, Graphics.height - status)
    self.opacity = 0
    self.contents_opacity = 255
    self.back_opacity = 0
    self.z = 1
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Draw All Items
  #--------------------------------------------------------------------------
  def draw_all_items
    item_max.times {|i| draw_item(i) }
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    $game_troop.alive_members.size
  end
  #--------------------------------------------------------------------------
  # * Get Spacing for Items Arranged Side by Side
  #--------------------------------------------------------------------------
  def spacing
    return 32
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    enmy = $game_troop.alive_members[index]
    rect = Rect.new
    rect.width = R2_AP_Gauge_Pos::AP_Width
    rect.height = R2_AP_Gauge_Pos::AP_Height
    rect.x = enmy.screen_x + R2_AP_Gauge_Pos::X_Adjust
    rect.y = enmy.screen_y + R2_AP_Gauge_Pos::Y_Adjust
    rect
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items (for Text)
  #--------------------------------------------------------------------------
  def item_rect_for_text(index)
    rect = item_rect(index)
    rect.x += 4
    rect.width -= 8
    rect
  end
  #--------------------------------------------------------------------------
  # ○ Draw a basic area
  #--------------------------------------------------------------------------
  def draw_basic_area(rect, enemy)
    draw_enemy_ap(enemy, rect.x + 0, rect.y, 100)
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    change_color(normal_color)
    enemy = $game_troop.alive_members[index]
    draw_basic_area(basic_area_rect(index), enemy)
    name = $game_troop.alive_members[index].name
    draw_text(item_rect_for_text(index), name) if R2_AP_Gauge_Pos::Draw_Name
  end
  #--------------------------------------------------------------------------
  # * Get Basic Area Retangle
  #--------------------------------------------------------------------------
  def basic_area_rect(index)
    rect = item_rect_for_text(index)
    rect.width -= 210
    rect
  end
end

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Create Enemy Window
  #--------------------------------------------------------------------------
  alias r2_enemy_ap_window_create create_enemy_window
  def create_enemy_window
    r2_enemy_ap_window_create
    @enemy_ap = Window_Enemy_AP.new(@status_window.height)
  end
  #--------------------------------------------------------------------------
  # * Update Status Window Information
  #--------------------------------------------------------------------------
  alias r2_Fomar0153_stamina_process  process_stamina
  def process_stamina
    r2_Fomar0153_stamina_process
    @enemy_ap.refresh
  end
  #--------------------------------------------------------------------------
  # * Processing at End of Action
  #--------------------------------------------------------------------------
  alias r2_action_end_refresh_ap_gauge  process_action_end
  def process_action_end
    @enemy_ap.refresh
    r2_action_end_refresh_ap_gauge
  end
end
