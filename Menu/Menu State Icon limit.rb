# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: State Icon Adjustment                  ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Alter State Icon Display                    ║    13 Apr 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Adjust how many icons to see on menu                         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Change Settings below                                            ║
# ║   Specify how many state icons can show on the menu                ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 13 Apr 2022 - Script finished                               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║                                                                    ║
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

module R2_State_Icon_Adjust
  Count = 2 # how many states to show in a row. Use either 2 or 3.
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Window_Base < Window
 
  alias r2_draw_icons_battle  draw_actor_icons
  def draw_actor_icons(actor, x, y, width = 96)
    if SceneManager.scene.is_a?(Scene_Battle)
      r2_draw_icons_battle(actor, x, y, width = 96)
    else
      icons = (actor.state_icons + actor.buff_icons)[0, width / 24]
      icons.each_with_index {|n, i|
      if (i % R2_State_Icon_Adjust::Count == 0 && i > 0) || i > R2_State_Icon_Adjust::Count
        i -= R2_State_Icon_Adjust::Count
        y += line_height if i % R2_State_Icon_Adjust::Count == 0
      end
      draw_icon(n, (x + 90 - 10 * R2_State_Icon_Adjust::Count.to_i) + 24 * i, y - 40) }
    end
  end
 
end
