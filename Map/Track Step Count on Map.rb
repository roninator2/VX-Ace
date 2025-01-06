# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Map Step Count                         ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║     Track Step Count                          ║    21 Feb 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Allows to keep track of steps taken on any given map         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Specify the variable to use below.                               ║
# ║                                                                    ║
# ║   The data is saved in the variable and can be pulled out          ║
# ║   anytime you need to get the value saved.                         ║
# ║                                                                    ║
# ║   Use the following commands                                       ║
# ║   add_step_count(map_id, value) # <- will add the number           ║
# ║     specified to the map count                                     ║
# ║                                                                    ║
# ║   reset_step_count(map_id) # <- will reset map count to 0          ║
# ║                                                                    ║
# ║   get_step_count(map_id) # <- will get the map step count          ║
# ║                                                                    ║
# ║   subtract_step_count(map_id, value) # <- will subtract the        ║
# ║     number from the map step count                                 ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 21 Feb 2023 - Script finished                               ║
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

module R2_Map_Steps
  Variable = 10
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

#==============================================================================
# ** Game_Map
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # * alias Setup = set value to variable if nil
  #--------------------------------------------------------------------------
  alias r2_map_step_count_setup setup
  def setup(map_id)
    r2_map_step_count_setup(map_id)
    $game_variables[R2_Map_Steps::Variable] = [] if $game_variables[R2_Map_Steps::Variable] == 0
    $game_variables[R2_Map_Steps::Variable][map_id] ||= 0
  end
end

#==============================================================================
# ** Game_Player = add steps to variable
#==============================================================================
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * alias Increase Steps
  #--------------------------------------------------------------------------
  alias r2_increase_map_step_count  increase_steps
  def increase_steps
    r2_increase_map_step_count
    $game_variables[R2_Map_Steps::Variable][$game_map.map_id] += 1
  end
end

#==============================================================================
# ** Game_Interpreter = commands
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Add Step Count
  #--------------------------------------------------------------------------
  def add_step_count(id, i)
    $game_variables[R2_Map_Steps::Variable][id] += i
  end
  #--------------------------------------------------------------------------
  # * Reset Step Count
  #--------------------------------------------------------------------------
  def reset_step_count(id)
    $game_variables[R2_Map_Steps::Variable][id] = 0
  end
  #--------------------------------------------------------------------------
  # * Subtract Step Count
  #--------------------------------------------------------------------------
  def subtract_step_count(id, i)
    $game_variables[R2_Map_Steps::Variable][id] -= i
    $game_variables[R2_Map_Steps::Variable][id] = 0 if $game_variables[R2_Map_Steps::Variable][id] < 0
  end
  #--------------------------------------------------------------------------
  # * Get Step Count
  #--------------------------------------------------------------------------
  def get_step_count(id)
    return $game_variables[R2_Map_Steps::Variable][id]
  end  
end
