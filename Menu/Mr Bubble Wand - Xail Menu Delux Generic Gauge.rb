# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Xail Menu Delux Generic Gauge          ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Compatibility Patch                         ║    05 Oct 2020     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: XaiL System - Menu Delux                                 ║
# ║           KMS Generic Gauge                                        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║         Give Generic Gauge to Xail Menu - recreated by Roninator2  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Plug and play                                                    ║
# ║   Place this script below both XaiL System - Menu Delux            ║
# ║   and KMS Generic Gauge in your script edtior                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 05 Oct 2020 - Script finished                               ║
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

$imported ||= {}
$kms_imported ||= {}

if $imported["XAIL-XS-MENU_DELUX"] && $kms_imported["GenericGauge"]
class Window_MenuStatus < Window_Selectable
  def draw_menu_stats(actor, stat, x, y, color1, color2, width)
    # // Method to draw actor hp & mp.
    case stat
    when :hp
      rate = actor.hp_rate ; vocab = Vocab::hp_a ; values = [actor.hp, actor.mhp]
    # // Draw guage.
      draw_actor_hp_gauge(actor, x, y - 4, width = 100)
    when :mp
      rate = actor.mp_rate ; vocab = Vocab::mp_a ; values = [actor.mp, actor.mmp]
    # // Draw guage.
      draw_actor_mp_gauge(actor, x, y - 4, width = 100)
    when :tp
      rate = actor.tp_rate ; vocab = Vocab::tp_a ; values = [actor.tp, actor.max_tp]
    # // Draw guage.
      draw_actor_tp_gauge(actor, x, y - 4, width = 100)
    end
    contents.font.name = XAIL::MENU_DELUX::FONT[0]
    contents.font.size = 14 # // Override font size.
    contents.font.color = XAIL::MENU_DELUX::FONT[2]
    contents.font.bold = XAIL::MENU_DELUX::FONT[3]
    contents.font.shadow = XAIL::MENU_DELUX::FONT[4]
    # // Draw stats.
    draw_text(x + 2, y, width, line_height, values[0], 0)
    draw_text(x + 1, y, width, line_height, values[1], 2)
    # // Draw vocab.
    draw_text(x, y, width, line_height, vocab, 1) if XAIL::MENU_DELUX::BAR_VOCAB
    reset_font_settings
  end
end
end # if $imported
