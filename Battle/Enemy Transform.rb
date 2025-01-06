# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Enemy Transform                        ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   multiple enemy staged transformation        ║    08 May 2020     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Provide animation for enemies to transform                   ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   This script allows enemies to transform into another monster     ║
# ║   when they reach a specified HP percentage remaining (or lower)   ║
# ║                                                                    ║
# ║   Enemy Notetags - These notetags go in the enemy notebox          ║
# ║      <staged transform: x>                                         ║
# ║      Sets the current enemy type to transform into                 ║
# ║      enemy x upon reaching hp%.                                    ║
# ║                                                                    ║
# ║      <staged transform hp percent: x%>                             ║
# ║      Sets the transform rate for the current enemy to be x%.       ║
# ║      If the previous tag is not used, this notetag has no effect.  ║
# ║                                                                    ║
# ║      <staged transform anim: x>                                    ║
# ║      Sets the animation to play on the enemy upon transforming.    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 08 May 2020 - Script finished                               ║
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

$imported = {} if $imported.nil?
$imported["R2-EnemyStagedTransform"] = true

module R2
  module REGEXP
  module ENEMY
    
    STAGED_TRANSFORM = /<(?:STAGED_TRANSFORM|staged transform):[ ](\d+)>/i
    STAGED_TRANSFORM_HP_PERCENT = 
      /<(?:STAGED_TRANSFORM_HP_PERCENT|staged transform hp percent):[ ](\d+)([%％])>/i
    STAGED_TRANSFORM_ANIM = /<(?:STAGED_TRANSFORM_ANIM|staged transform anim):[ ](\d+)>/i
    
  end # ENEMY
  end # REGEXP
end # R2

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_edtr2 load_database; end
  def self.load_database
    load_database_edtr2
    load_notetags_edtr2
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_edt
  #--------------------------------------------------------------------------
  def self.load_notetags_edtr2
    for obj in $data_enemies
      next if obj.nil?
      obj.load_notetags_edt
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Enemy
#==============================================================================

class RPG::Enemy < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :staged_transform
  attr_accessor :staged_transform_anim
  attr_accessor :staged_transform_hp_percent
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_edt
  #--------------------------------------------------------------------------
  def load_notetags_edt
    @staged_transform = 0
    @staged_transform_hp_percent = 1.0
    @staged_transform_anim = 0
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when R2::REGEXP::ENEMY::STAGED_TRANSFORM
        @staged_transform = $1.to_i
      when R2::REGEXP::ENEMY::STAGED_TRANSFORM_HP_PERCENT
        @staged_transform_hp_percent = $1.to_i * 0.01
      when R2::REGEXP::ENEMY::STAGED_TRANSFORM_ANIM
        @staged_transform_anim = $1.to_i
      end
    } # self.note.split
    #---
  end
  
end # RPG::Enemy

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: execute damage
  #--------------------------------------------------------------------------
  alias game_battler_damage_edt execute_damage
  def execute_damage(user)
    game_battler_damage_edt(user)
    return staged_transform if meet_staged_transform_requirements?
  end

  #--------------------------------------------------------------------------
  # new method: meet_death_transform_requirements?
  #--------------------------------------------------------------------------
  def meet_staged_transform_requirements?
    return false unless enemy?
    return false unless enemy.staged_transform > 0
    return false if $data_enemies[enemy.staged_transform].nil?
    return false if $data_enemies[enemy.staged_transform_hp_percent].nil?
    return (self.hp / enemy.params[0]) < enemy.staged_transform_hp_percent
  end
  
  #--------------------------------------------------------------------------
  # new method: death_transform
  #--------------------------------------------------------------------------
  def staged_transform
    self.animation_id = enemy.staged_transform_anim
    transform(enemy.staged_transform)
  end
  
end # Game_Battler

#==============================================================================
# ▼ End of File
#==============================================================================
