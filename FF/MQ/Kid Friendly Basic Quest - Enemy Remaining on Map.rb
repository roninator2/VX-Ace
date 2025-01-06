# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Enemy remaining on Map  ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Battle Count           ║    14 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  Configure hash with data for battle on the map.         ║
# ║  Battle_Data = { :1 => [ [4,6],[8,12]  ],                ║
# ║                  :2 => [ [17,5],32,8] ], }               ║
# ║                                                          ║
# ║  Works like this -> :1 = map id                          ║
# ║                     [4,6] = [event id, battles]          ║
# ║                                                          ║
# ║  Data is copied to the Current_Data variable specified   ║
# ║  The variable data is modified not the module data       ║
# ║                                                          ║
# ║  This is because module data does not change.            ║
# ║                                                          ║
# ║  Second variable is used to pass current data to the     ║
# ║  battle in progress.                                     ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# * Module R2 Enemy Count Data
#==============================================================================
module R2_Enemy_Count_Data
# { Map id => [ [event_id, number], [event_id, number] ], <- don't forget comma
  Battle_Data = { 1 => [ [10,5], [9, 1] ],
                  2 => [ [3,1] ],
                }
        # {} = curly bracket.  [] = square bracket
  # entire data for the map is in one array. i.e. [ ]
  # secondary [ ] is the event data
  Current_Data = 20 # variable that copies the Battle Data and is
                    # changed curing game play.
  Remaining = 21    # variable that holds the current event enemy count remaining
  Data_Transfer = 22 # variable used to set current values to battle system
end

#==============================================================================
# ** Scene Map
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Start
  #--------------------------------------------------------------------------
  alias r2_battle_data_hud_start  start
  def start
    r2_battle_data_hud_start
    $game_variables[R2_Enemy_Count_Data::Current_Data] = 
    R2_Enemy_Count_Data::Battle_Data if $game_variables[R2_Enemy_Count_Data::Current_Data] == 0
  end
  #--------------------------------------------------------------------------
  # * Update Scene Transition
  #--------------------------------------------------------------------------
  def update_scene
    check_gameover
    update_transfer_player unless scene_changing?
    update_encounter unless scene_changing?
    update_call_menu unless scene_changing?
    update_call_debug unless scene_changing?
  end
  #--------------------------------------------------------------------------
  # * Update Encounter
  #--------------------------------------------------------------------------
  def update_encounter
    SceneManager.call(Scene_Battle) if $game_player.encounter
  end
  #--------------------------------------------------------------------------
  # * Preprocessing for Battle Screen Transition
  #--------------------------------------------------------------------------
  def pre_battle_scene
    map = $game_map.map_id
    event = $game_map.event_id_xy($game_player.x, $game_player.y)
    id = -1
    if !R2_Enemy_Count_Data::Battle_Data[map].nil?
      R2_Enemy_Count_Data::Battle_Data[map].each_with_index do |chk, ind|
        id = ind if chk[0] == event
      end
      if id != -1
        $game_variables[R2_Enemy_Count_Data::Remaining] = 
        $game_variables[R2_Enemy_Count_Data::Current_Data][map][id][1]
        $game_variables[R2_Enemy_Count_Data::Data_Transfer] = [map, id]
      end
    end
    # test
    Graphics.update
    Graphics.freeze
    BattleManager.save_bgm_and_bgs
    BattleManager.play_battle_bgm
    Sound.play_battle_start
  end
end
