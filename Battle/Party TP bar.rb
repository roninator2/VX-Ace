# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: TP Bar for Party                       ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Draws a tp bar for the party                ╠════════════════════╣
# ║                                               ║    16 Mar 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: TheoAllen's Universal TP                                 ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║   Script provides a tp bar showing the tp for the                  ║
# ║   party. Uses battle member 0's tp                                 ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Configure Settings below                                         ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 16 Mar 2021 - Script finished                               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Theoallen                                                        ║
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

module R2_Group_TP
  BAR_WIDTH = 250
  BAR_HEIGHT = 10
  BAR_Y = 0
  BAR_POSITION = "top"   # Position of the tp bar. Can be "top" or "bottom"
  PARTY_BAR_COLORS = [4,11]
  PARTY_TP_TEXT = "Party TP"
  TEXT_Y = 0
  SHOW_NUMBERS = true
  # The following will work if preserving tp is off
  RANDOM_TP_START = true
  RANDOM_TP_AMOUNT = 20     # number to randomize the starting tp.
  # 20 means a number between 0 and 20 for the starting tp
  GUARANTEE_TP = true
  GUARANTEE_TP_AMOUNT = 10  # will always start with this amount of tp + random
end

#==============================================================================
# ** Game Unit
#------------------------------------------------------------------------------
#  Adding in tp for the party
#==============================================================================

class Game_Unit
  def tp_rate=(value)
    return tp_rate
  end
  def tp_rate
    self.tp.to_f / max_tp
  end
end

#==============================================================================
# ** Window Battle Status
#------------------------------------------------------------------------------
#  removing the tp drawn for each actor
#==============================================================================

class Window_BattleStatus < Window_Selectable
  def draw_gauge_area_with_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 0, rect.y, 72)
    draw_actor_mp(actor, rect.x + 82, rect.y, 64)
  end
end

#==============================================================================
# ** Window Group TP
#------------------------------------------------------------------------------
#  Draw the tp gauge for the party
#==============================================================================
class Window_GroupTP < Window_Base

  def initialize
    super(0, 0, Graphics.width, Graphics.height)
    update_location
    draw_tp_bar
    self.opacity = 0
    self.contents_opacity = 255
  end

  def bar_width
    return R2_Group_TP::BAR_WIDTH
  end

  def update
    self.refresh
  end

  def refresh
    contents.clear
    $game_party.tp = $game_party.battle_members[0].tp.to_i
    draw_tp_bar
  end

  def update_location
    case R2_Group_TP::BAR_POSITION
    when "top"
      self.y = 0
    when "bottom"
      self.y = Graphics.height - 170
    else
      self.opacity = 0
    end
    self.z = 0
  end

  def draw_tp_bar
    draw_party_tp(Graphics.width / 2 - bar_width / 2, 0, bar_width)
  end

  def draw_party_tp(x, y, width)
      draw_tp_gauge(x, y, width, $game_party.tp_rate, text_color(R2_Group_TP::PARTY_BAR_COLORS[0]), text_color(R2_Group_TP::PARTY_BAR_COLORS[1]))
      draw_text(x, y + R2_Group_TP::TEXT_Y, 100, contents.font.size, party_text, 2)
    if R2_Group_TP::SHOW_NUMBERS
      xr = x + width
      draw_text(xr - 100, y + R2_Group_TP::TEXT_Y, 100, contents.font.size, $game_party.tp.to_s, 2)
    end
  end

  def party_text
    R2_Group_TP::PARTY_TP_TEXT
  end

  def draw_tp_gauge(x, y, width, rate, color1, color2)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 8 + R2_Group_TP::BAR_Y
    contents.fill_rect(x, gauge_y, width, R2_Group_TP::BAR_HEIGHT, gauge_back_color)
    contents.gradient_fill_rect(x, gauge_y, fill_w, R2_Group_TP::BAR_HEIGHT, color1, color2)
  end

end # Window_GroupTP < Window_Base

#==============================================================================
# ** Scene Battle
#------------------------------------------------------------------------------
#  Create tp window
#==============================================================================
class Scene_Battle < Scene_Base

  alias r2_party_tp_start start
  def start
    set_initial_tp
    r2_party_tp_start
  end

  alias r2_party_tp_create_all_windows create_all_windows
  def create_all_windows
    r2_party_tp_create_all_windows
    @party_tp_window = Window_GroupTP.new
  end

  def set_initial_tp
    if !$game_party.battle_members[0].preserve_tp?
    if R2_Group_TP::RANDOM_TP_START
      $game_party.battle_members[0].tp = rand(R2_Group_TP::RANDOM_TP_AMOUNT)
    else
      $game_party.battle_members[0].tp = 0
    end
    if R2_Group_TP::GUARANTEE_TP
      $game_party.battle_members[0].tp += R2_Group_TP::GUARANTEE_TP_AMOUNT
    end
    end
    $game_party.tp = $game_party.battle_members[0].tp
    $game_party.tp_rate = $game_party.battle_members[0].tp_rate
  end

end # Scene_Battle < Scene_Base
