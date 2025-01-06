# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Checkpoint save                        ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Return actor to checkpoint                  ║    23 May 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║        Set a checkpoint system                                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║   Specify the default data                                         ║
# ║    X = map x position to return                                    ║
# ║    Y = map y position to return                                    ║
# ║    Map = Map id for the map to return                              ║
# ║    Direction = directional facing for the actor (2,4,6,8)          ║
# ║                                                                    ║
# ║   Use script command to change checkpoint                          ║
# ║     set_new_checkpoint(map,x,y,d)                                  ║
# ║       for example                                                  ║
# ║     set_new_checkpoint(5,7,2,4)                                    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 23 May 2023 - Script finished                               ║
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

#==============================================================================
# ** CheckPoint Save Variable
#==============================================================================
module R2_Checkpoint_Save
  # set default save checkpoint 
  Default = [5, 5, 5, 2] # map id, x, y, direction (2, 4, 6, 8)
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

#==============================================================================
# ** Game_Interpreter
#==============================================================================
class Game_Interpreter
  def set_new_checkpoint(map, x, y, d)
    $game_party.save_new_checkpoint(map,x,y,d)
  end
end

#==============================================================================
# ** Game_Party
#==============================================================================
class Game_Party
  attr_accessor :scp
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias r2_init_checkpoint_save initialize
  def initialize
    r2_init_checkpoint_save
    @scp = R2_Checkpoint_Save::Default
  end
  #--------------------------------------------------------------------------
  # * Defeat Processing
  #--------------------------------------------------------------------------
  def save_new_checkpoint(map, x, y, d)
    @scp = [map, x, y, d]
  end
end

#==============================================================================
# ** BattleManager
#==============================================================================
module BattleManager
  #--------------------------------------------------------------------------
  # * Defeat Processing
  #--------------------------------------------------------------------------
  def self.process_defeat
    $game_message.add(sprintf(Vocab::Defeat, $game_party.name))
    wait_for_message
    revive_battle_members
    SceneManager.return
    battle_end(2)
    $game_player.reserve_transfer(*$game_party.scp)
    $game_player.perform_transfer
    replay_bgm_and_bgs
    return true
  end
end
