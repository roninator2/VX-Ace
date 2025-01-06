#==============================================================================
#
# ▼ Yanfly Engine Ace - Save Engine Add-On: New Game+ for CSCA Encyclopedia v1.01
# -- Last Updated: 2011.12.26
# -- Level: Normal
# -- Requires: YEA - Ace Save Engine v1.01+
# -- Requires: YEA - Ace Save Engine Addon: New Game+ v1.00
#==============================================================================

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2020.05.13 - Started Script and Finished.
#
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# set the range of variables used for saving the csca data.
# This script is using by default variables
# 101, 101, 102, 103, 104, 105, 107, 108, 109 # a total of 9
# Also lets you specify what data to save.
# Change items to false to not save items, etc.
#==============================================================================
module YEA
  module NEW_GAME_PLUS
    CARRY_OVER_CSCA_VARIABLES = [101..109] # must be a range of 9 inclusive
    CSCA_ITEMS = true
    CSCA_WEAPONS = true
    CSCA_ARMOR = true
    CSCA_SKILLS = true
    CSCA_STATES = true
    CSCA_ENEMY = true
    CSCA_CUSTOM = true
    CSCA_DESCRIPTION = true
  end
end
if $imported["YEA-SaveEngine"]
  if $imported["YEA-NewGame+"]

module YEA
  module NEW_GAME_PLUS
    module_function
    def convert_integer_array(array)
      result = []
      array.each { |i|
        case i
        when Range; result |= i.to_a
        when Integer; result |= [i]
        end }
      return result
    end
    CARRY_OVER_CSCA_VARIABLES = convert_integer_array(CARRY_OVER_CSCA_VARIABLES)
  end
end

module DataManager
  def self.setup_new_game_plus(index)
    create_new_game_plus_objects(index)
    $game_map.setup($data_system.start_map_id)
    $game_player.moveto($data_system.start_x, $data_system.start_y)
    $game_player.refresh
    $game_party.csca_reset_encyclopedia
    Graphics.frame_count = 0
  end
  def self.create_new_game_plus_objects(index)
    load_game_without_rescue(index)
    ngp_reset_switches
    ngp_reset_variables
    ngp_reset_self_switches
        ngp_reset_csca_variables
    ngp_reset_actors
    ngp_reset_party
  end
  def self.ngp_reset_csca_variables
    $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[0]] = $game_party.csca_items
    $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[1]] = $game_party.csca_weapons
    $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[2]] = $game_party.csca_armors
    $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[3]] = $game_party.csca_states
    $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[4]] = $game_party.csca_skills
    $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[5]] = $game_party.csca_custom_enc
    $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[6]] = $game_party.csca_descriptions
    $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[7]] = $game_party.csca_enemies
    $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[8]] = $game_party.csca_defeated_number
  end
end

class Game_Party < Game_Unit
  def csca_reset_encyclopedia
    @csca_items = []
    @csca_weapons = []
    @csca_armors = []
    @csca_states = []
    @csca_skills = []
    @csca_custom_enc = []
    @csca_descriptions = []
    @csca_enemies = []
    @csca_defeated_number = []
    YEA::NEW_GAME_PLUS::CSCA_ITEMS ? @csca_items = $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[0]] : nil
    YEA::NEW_GAME_PLUS::CSCA_WEAPONS ? @csca_weapons = $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[1]] : nil
    YEA::NEW_GAME_PLUS::CSCA_ARMOR ? @csca_armors = $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[2]] : nil
    YEA::NEW_GAME_PLUS::CSCA_STATES ? @csca_states = $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[3]] : nil
    YEA::NEW_GAME_PLUS::CSCA_SKILLS ? @csca_skills = $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[4]] : nil
    YEA::NEW_GAME_PLUS::CSCA_CUSTOM ? @csca_custom_enc = $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[5]]: nil
    YEA::NEW_GAME_PLUS::CSCA_DESCRIPTION ? @csca_descriptions = $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[6]] : nil
    YEA::NEW_GAME_PLUS::CSCA_ENEMY ? @csca_enemies = $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[7]] : nil
    YEA::NEW_GAME_PLUS::CSCA_ENEMY ? @csca_defeated_number = $game_variables[YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES[8]] : nil
    for i in 0...$data_system.variables.size
      next if i <= 0
      next if !YEA::NEW_GAME_PLUS::CARRY_OVER_CSCA_VARIABLES.include?(i)
      $game_variables[i] = 0
    end
  end
end

  end
end
