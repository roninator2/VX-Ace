# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Transfer on Game Over                  ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Alter Game Over                             ║    06 Feb 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║      Save game on death and transfer player to another map         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Turn switch on to disable script                                 ║
# ║   Set the data for the variable with script data entry             ║
# ║   in the format of [map id, x, y, direction]                       ║
# ║   e.g. [4, 6, 22, 8]                                               ║
# ║   This allows you to change it at any time in the game             ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 06 Feb 2022 - Script finished                               ║
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

module R2_Game_Over_Transfer
  Transfer_Var = 10 # variable hold data in format [map id, x, y, d]
  Transfer_Switch = 10 # turn script on/off, switch on = script off
  Title_Switch = 9 # if true will return to title screen
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Scene_Gameover < Scene_Base
  
  alias r2_gameover_start_transfer  start
  def start
    r2_gameover_start_transfer
    Graphics.freeze
    revive_for_transfer
  end

  def update
    super
    if $game_switches[R2_Game_Over_Transfer::Title_Switch] == false
      dispose_background if Input.trigger?(:C)
      SceneManager.goto(Scene_Map) if Input.trigger?(:C)
    else
      goto_title if Input.trigger?(:C)
    end
  end
  
  def revive_for_transfer
    return if $game_switches[R2_Game_Over_Transfer::Transfer_Switch] == true
    return if $game_variables[R2_Game_Over_Transfer::Transfer_Var] == 0
    $game_party.battle_members.each { |actor| 
      actor.hp = actor.mhp
      actor.mp = actor.mmp
      actor.remove_state(1)
    }
    set_transfer
    transfer_save
  end
  
  def set_transfer
    map = $game_variables[R2_Game_Over_Transfer::Transfer_Var][0]
    x = $game_variables[R2_Game_Over_Transfer::Transfer_Var][1]
    y = $game_variables[R2_Game_Over_Transfer::Transfer_Var][2]
    d = $game_variables[R2_Game_Over_Transfer::Transfer_Var][3]
    $game_player.reserve_transfer(map, x, y, d)
    $game_player.perform_transfer
  end
  
  def transfer_save
    DataManager.save_game_without_rescue(DataManager.last_savefile_index)
  end
  
end
