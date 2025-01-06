# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Generic Gauge for Galv Menu Theme      ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Compatibility Patch                         ║    05 Nov 2020     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Galv Menu Theme                                          ║
# ║           KMS Generic Gauge                                        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Provide generic gauge bars for Galv Menu Theme               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Plug and play                                                    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 05 Nov 2020 - Script finished                               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Mr. Bubble                                                       ║
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

$imported = {} if $imported.nil?
$kms_imported = {} if $kms_imported.nil?

#==============================================================================
# ■ Window_MainMenuStatus
#==============================================================================

if $imported["Galv_Menu_Themes"] && $kms_imported["GenericGauge"]
class Window_MainMenuStatus < Window_MenuStatus
  #--------------------------------------------------------------------------
  # * Draw Gauge
  #     rate   : Rate (full at 1.0)
  #     color1 : Left side gradation
  #     color2 : Right side gradation
  #--------------------------------------------------------------------------
  def draw_gauge(x, y, width, rate, color1, color2)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 8
    contents.fill_rect(x, gauge_y, width, 6, gauge_back_color)
    contents.gradient_fill_rect(x, gauge_y, fill_w, 6, color1, color2)
  end
end

class Window_Base < Window
  def draw_gtp(actor, x, y, width = 124)
    draw_actor_tp_gauge(actor, x, y, width)
    change_color(system_color)
    draw_text(x - 30, y + 7, 30, line_height, Vocab::tp_a,2)
    change_color(tp_color(actor))
    draw_text(x + width - 42, y + 3, 42, line_height, actor.tp.to_i, 2)
  end

  def draw_ghp(actor, x, y, width = 124)
    draw_actor_hp_gauge(actor, x, y, width)
    change_color(system_color)
    draw_text(x - 30, y + 7, 30, line_height, Vocab::hp_a,2)
    draw_current_and_max_values(x, y + 3, width, actor.hp, actor.mhp,
      hp_color(actor), normal_color)
  end
    
  def draw_gmp(actor, x, y, width = 124)
    draw_actor_mp_gauge(actor, x, y, width)
    change_color(system_color)
    draw_text(x - 30, y + 7, 30, line_height, Vocab::mp_a,2)
    draw_current_and_max_values(x, y + 3, width, actor.mp, actor.mmp,
      mp_color(actor), normal_color)
  end
end
end # if $imported["Galv_Menu_Themes"]
["Galv_Menu_Themes"]
