# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Victory Aftermath Subclass Patch       ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Script Function                             ║    22 Mar 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Yanfly Victory Aftermath                                 ║
# ║           EST - YEA - SUBCLASS ADD ON                              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Fix bug with scripts                                         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Plug and play                                                    ║
# ║   Corrects a bug where the tick counter resets for the subclass    ║
# ║   Adds in position adjustments for the gauge and text              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 22 Mar 2022 - Script finished                               ║
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

class Game_Actor < Game_Battler
  def sub_exp
    return @exp[@subclass_id]
  end
end
 
class Window_VictoryEXP_Front < Window_VictoryEXP_Back 

  def draw_actor_sub_exp(actor, rect)
    return if !actor.subclass
    return if YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
    rect.y += line_height * 2
    if actor.subclass_level == actor.subclass_max_level
      draw_sub_exp_gauge(actor, rect, 1.0)
      return
    end
    total_ticks = YEA::VICTORY_AFTERMATH::EXP_TICKS
    bonus_exp = actor_sub_exp_gain(actor) * @ticks / total_ticks
    now_exp = (actor.sub_exp - actor.subclass.exp_for_level(actor.subclass_level) + bonus_exp)
    next_exp = actor.subclass.exp_for_level(actor.subclass_level+1) - actor.subclass.exp_for_level(actor.subclass_level)
    rate = now_exp * 1.0 / next_exp
    draw_sub_exp_gauge(actor, rect, rate)
  end
 
end
