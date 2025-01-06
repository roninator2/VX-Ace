# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Show ATB Bar for Enemies               ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Show Enemy ATB Bar                          ║    06 Jun 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Above script                                             ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║          Show the ATB Bar for ATB system above                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Adjust the settings below                                        ║
# ║                                                                    ║
# ║   Due to the positioning of the enemy,                             ║
# ║   you will likely need to adjust the bar position                  ║
# ║   so that the adjustment numbers are negative.                     ║
# ║   This is because I used the enemies screen position               ║
# ║   which causes the bar to be at the bottom of the                  ║
# ║   enemy position. The window is also set to not                    ║
# ║   overlap the status window.                                       ║
# ║                                                                    ║
# ║   Requires Circle Cross AP script                                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 22 Nov 2024 - Script finished                               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Terms of use:                                                      ║
# ║  Free for all uses in RPG Maker except nudity                      ║
# ║  Anyone using this script in their project before these terms      ║
# ║  were changed are allowed to use this script even if it conflicts  ║
# ║  with these new terms. New terms effective 03 Apr 2024             ║
# ║  No part of this code can be used with AI programs or tools        ║
# ║  Credit must be given                                              ║
# ╚════════════════════════════════════════════════════════════════════╝

module R2_AP_Gauge_Pos
  X_Adjust  = -70         # x position of the bar from the enemy position
  Y_Adjust  = -20         # y position of the bar from the enemy position
  EAP_Width  = 100        # Enemy Bar width
  EAP_Height = 12         # Enemy Bar height
  Enemy_Colour_1 = 17     # Starting colour of bar
  Enemy_Colour_2 = 29     # Ending colour of bar
  Draw_Enemy_Name = false # Draw enemy name
  EAP_Name_Below = true   # Draw Enemy Name below gauge
  AAP_Width  = 100        # Actor Bar width
  AAP_Height = 10         # Actor Bar height
  Actor_Colour_1 = 30     # Starting colour of bar
  Actor_Colour_2 = 31     # Ending colour of bar
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

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
  # ○ Assigning gauge colors
  #--------------------------------------------------------------------------
  def eap_gauge_color1;   text_color(R2_AP_Gauge_Pos::Enemy_Colour_1);  end
  def eap_gauge_color2;   text_color(R2_AP_Gauge_Pos::Enemy_Colour_2);  end
  #--------------------------------------------------------------------------
  # ○ AP Drawing
  #--------------------------------------------------------------------------
  def draw_enemy_ap(enemy, x, y, width = 124)
    draw_e_gauge(x, y, width, enemy.ap_rate, eap_gauge_color1, eap_gauge_color2)
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    enmy = $game_troop.alive_members[index]
    rect = Rect.new
    rect.width = R2_AP_Gauge_Pos::EAP_Width
    rect.height = R2_AP_Gauge_Pos::EAP_Height
    rect.height += 30 if R2_AP_Gauge_Pos::EAP_Name_Below
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
    rect.y -= 8
    rect.width -= 8
    rect.height += 8
    rect
  end
  #--------------------------------------------------------------------------
  # ○ Draw a basic area
  #--------------------------------------------------------------------------
  def draw_basic_area(rect, enemy)
    width = R2_AP_Gauge_Pos::EAP_Width
    draw_enemy_ap(enemy, rect.x + 0, rect.y, width)
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    change_color(normal_color)
    enemy = $game_troop.alive_members[index]
    draw_basic_area(basic_area_rect(index), enemy)
    name = $game_troop.alive_members[index].name
    draw_text(item_rect_for_text(index), name) if R2_AP_Gauge_Pos::Draw_Enemy_Name
  end
  #--------------------------------------------------------------------------
  # * Get Basic Area Retangle
  #--------------------------------------------------------------------------
  def basic_area_rect(index)
    rect = item_rect_for_text(index)
    rect.width -= 210
    rect
  end
  #--------------------------------------------------------------------------
  # * Draw Gauge
  #     rate   : Rate (full at 1.0)
  #     color1 : Left side gradation
  #     color2 : Right side gradation
  #--------------------------------------------------------------------------
  def draw_e_gauge(x, y, width, rate, color1, color2)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 8 - R2_AP_Gauge_Pos::EAP_Height
    gauge_h = R2_AP_Gauge_Pos::EAP_Height
    contents.fill_rect(x, gauge_y, width, gauge_h, gauge_back_color)
    contents.gradient_fill_rect(x, gauge_y, fill_w, gauge_h, color1, color2)
  end
end

#==============================================================================
# ** Window_BattleStatus
#==============================================================================

class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Draw Basic Area
  #--------------------------------------------------------------------------
  alias r2_atb_draw_basic_area draw_basic_area
  def draw_basic_area(rect, actor)
    width = R2_AP_Gauge_Pos::AAP_Width
    draw_actor_ap(actor, rect.x + 0, rect.y, width)
    r2_atb_draw_basic_area(rect, actor)
  end
  #--------------------------------------------------------------------------
  # ○ Assigning gauge colors
  #--------------------------------------------------------------------------
  def ap_gauge_color1;   text_color(R2_AP_Gauge_Pos::Actor_Colour_1);  end
  def ap_gauge_color2;   text_color(R2_AP_Gauge_Pos::Actor_Colour_2);  end
  #--------------------------------------------------------------------------
  # ○ AP Gauge
  #--------------------------------------------------------------------------
  def draw_actor_ap(actor, x, y, width = 124)
    draw_ap_gauge(x, y, width, actor.ap_rate, ap_gauge_color1, ap_gauge_color2)
  end
  #--------------------------------------------------------------------------
  # * Draw Gauge
  #     rate   : Rate (full at 1.0)
  #     color1 : Left side gradation
  #     color2 : Right side gradation
  #--------------------------------------------------------------------------
  def draw_ap_gauge(x, y, width, rate, color1, color2)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 4 - R2_AP_Gauge_Pos::AAP_Height
    gauge_h = R2_AP_Gauge_Pos::AAP_Height
    contents.fill_rect(x, gauge_y, width, gauge_h, gauge_back_color)
    contents.gradient_fill_rect(x, gauge_y, fill_w, gauge_h, color1, color2)
  end
end

#==============================================================================
# Scene_Battle
#==============================================================================

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
  # ○ Redraw the information in the status window
  #--------------------------------------------------------------------------
  alias r2_redraw_ap_status redraw_status
  def redraw_status
    r2_redraw_ap_status
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
  #--------------------------------------------------------------------------
  # * [Skill] Command
  #--------------------------------------------------------------------------
  alias r2_show_ap_enemy_skill_command  command_skill
  def command_skill
    r2_show_ap_enemy_skill_command
    @enemy_ap.hide
  end
  #--------------------------------------------------------------------------
  # * Skill [OK]
  #--------------------------------------------------------------------------
  alias r2_skill_ok_ap_hide   on_skill_ok
  def on_skill_ok
    @enemy_ap.show
    r2_skill_ok_ap_hide
  end
  #--------------------------------------------------------------------------
  # * Skill [Cancel]
  #--------------------------------------------------------------------------
  alias r2_on_skill_ap_cancel_window   on_skill_cancel
  def on_skill_cancel
    @enemy_ap.show
    r2_on_skill_ap_cancel_window
  end
end
