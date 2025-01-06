# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Battle Timer to Game Over              ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Adjust Battle End call                      ║    22 Nov 2024     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Use switches to call a game over when timer reaches zero     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Set switches numbers that will be used.                          ║
# ║   When the switch is on and the timer reaches zero,                ║
# ║   a game over will be initiated                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 22 Nov 2024 - Script finished                               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Heirukichi                                                       ║
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

module R2_Battle_Timer_End
  Map_Switch    = 47
  Battle_Switch = 48
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Scene_Map < Scene_Base
  alias hrk_update_no_timer_old update
  def update
    hrk_update_no_timer_old
    if (($game_switches[R2_Battle_Timer_End::Map_Switch] == true) && ($game_timer.sec == 0))
      $game_message.add("Death Comes For You.")
      wait_for_message while $game_message.busy?
      SceneManager.call(Scene_Gameover) 
    end
  end
  def wait_for_message
    Graphics.update
    Input.update
    update_all_windows
  end
end

class Scene_Battle < Scene_Base
  alias hrk_update_no_timer_old update
  def update
    hrk_update_no_timer_old
    if (($game_switches[R2_Battle_Timer_End::Battle_Switch] == true) && ($game_timer.sec == 0))
      $game_message.add("Death Comes For You.")
      wait_for_message
      SceneManager.call(Scene_Gameover)
    end
  end
end

module BattleManager
  class << self; alias :r2_switch_off_victory  :process_victory; end
  def self.process_victory
    $game_switches[R2_Battle_Timer_End::Battle_Switch] = false
    $game_timer.stop if $game_timer.working? && $game_switches[R2_Battle_Timer_End::Battle_Switch] == true
    r2_switch_off_victory
  end
end

class Game_Timer
  def on_expire
  end
end
