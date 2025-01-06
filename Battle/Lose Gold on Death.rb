# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Lose gold on Death                     ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║    Date Created    ║
# ║                                               ╠════════════════════╣
# ║ permanently lose gold on death                ║    03 Dec 2020     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Simulate games that cost you gold when death occurs          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Set option to use party gold before death or                     ║
# ║   use the party gold from the save file                            ║
# ║   Specify value to determine how much gold to lose (%)             ║
# ║   Specify to allow player to press a button on Game Over           ║
# ║   screen. If true, this will allow player to close the game        ║
# ║   in order to prevent this script from cutting the gold            ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 03 Dec 2020 - Script finished                               ║
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

module R2
  module Gameover
    Goldcut = 0.75 # 75% of current gold in party is kept
    Use_Party_Gold = true
    # will use the current party gold not the saved gold if true
    Wait_for_Button = true
  end
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Scene_Gameover < Scene_Base
  def update
    super
    if R2::Gameover::Wait_for_Button == true
      goto_gold_cut if Input.trigger?(:C) || Input.trigger?(:B)
    else
      goto_gold_cut
    end
  end
  def fadeout_speed
    return 60
  end
  def fadein_speed
    return 30
  end
  #--------------------------------------------------------------------------
  # * Transition to saved game
  #--------------------------------------------------------------------------
  def goto_gold_cut
    if DataManager.save_file_exists?
      if R2::Gameover::Use_Party_Gold == true
        current = $game_party.gold
        DataManager.load_game(DataManager.last_savefile_index)
      else
        DataManager.load_game(DataManager.last_savefile_index)
        current = $game_party.gold
      end
      Sound.play_load
      fadeout_all
      $game_system.on_after_load
      SceneManager.goto(Scene_Map)
      cut = (current * R2::Gameover::Goldcut).to_i
      $game_party.lose_gold(current)
      $game_party.gain_gold(cut)
      $game_system.on_before_save
      DataManager.save_game(DataManager.last_savefile_index)
    else
      goto_title
    end
  end
end
