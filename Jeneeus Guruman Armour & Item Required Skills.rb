#==============================================================================
# ** Armor and Item Required Skills
# by: Jeneeus Guruman
# Modded by: Roninator2
#   Added on using armor items not types <req_arm: n>
#------------------------------------------------------------------------------
#  This script allows to:
#     - Make some skills requires armor types to use it. It is the same as the 
#     weapon-required skill but in armors.
#     - Make some skills require items in the party's inventory to use it.
#
#   How to use:
#
#     * Plug-n-play
#     * Place this below default and non-aliased scripts.
#       
#       <req_atype: n>
#       n: the index number of the armor type 
#       required for the skill (which is beside the name in the "Terms" tab)
#
#     * Note: If you put more than 1, the skill can be used if EITHER 1 of 
#       the armor types is equiipped.
#       
#       <req_arm: n>
#       n: the index number of the armor
#
#       <req_item: n, amount, comnsumed?>
#       n: the index number of the item in the database
#       required for the skill (which is beside the name in the "Terms" tab)
#       amount: the amount of the specified item needed to use a skill.
#       consumed?: the item needed needed to be consumed or not (true or false).
#       Notetag examples: 
#         <req_item: 1, 2, true>    => A skill needs to have at least 2 "Potions"
#       in the inventory to use the skill and those will be consumed after use.
#
#     * Note: If you put more than 1, the skill can be used if ALL of 
#       the items is in the party's inventory.
#
#==============================================================================

#----------------------------------------------------------------------------
# * Do not edit anything below here. Or else, evil errors will be released 
# from the other dimension of evil.
#----------------------------------------------------------------------------

module Jene
  REQ_ATYPE = /<req_atype[:]?\s*(\d+)>/i
  REQ_AREQ = /<req_arm[:]?\s*(\d+)>/i
  REQ_IREQ = /<req_item[:]?\s*(\d+)\s*[,]?\s*(\d+)\s*[,]?\s*(true|false)>/i
end

class RPG::Skill
  
  def required_atype_ids
    bonus_arr = []
    self.note.each_line { |line|
      if line =~ Jene::REQ_ATYPE
        bonus_arr.push($1.to_i)
      end
    }
    return bonus_arr
  end
  
  def required_areq_ids
    bonus_arr = []
    self.note.each_line { |line|
      if line =~ Jene::REQ_AREQ
        bonus_arr.push($1.to_i)
      end
    }
    return bonus_arr
  end

  def required_items
    bonus_arr = []
    self.note.each_line { |line|
      if line =~ Jene::REQ_IREQ
        bonus_arr.push([$1.to_i, $2.to_i, $3 == "true"])
      end
    }
    return bonus_arr
  end
end

#==============================================================================
# ** Game_BattlerBase
#------------------------------------------------------------------------------
#  This base class handles battlers. It mainly contains methods for calculating
# parameters. It is used as a super class of the Game_Battler class.
#==============================================================================

class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Check Usability Conditions for Skill
  #--------------------------------------------------------------------------
  alias jene_req_skill_conditions_met? skill_conditions_met?
  def skill_conditions_met?(skill)
    return false unless skill_atype_ok?(skill) && skill_ireq_ok?(skill) && skill_areq_ok?(skill)
    jene_req_skill_conditions_met?(skill)
  end
  #--------------------------------------------------------------------------
  # * Determine if Skill-Required Armor Is Equipped
  #--------------------------------------------------------------------------
  def skill_atype_ok?(skill)
    return true
  end
  #--------------------------------------------------------------------------
  # * Determine if Skill-Required Armor Is Equipped
  #--------------------------------------------------------------------------
  def skill_areq_ok?(skill)
    return true
  end
  #--------------------------------------------------------------------------
  # * Determine if Skill-Required Item Is In Inventory
  #--------------------------------------------------------------------------
  def skill_ireq_ok?(skill)
    return true
  end
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It is used within the Game_Actors class
# ($game_actors) and is also referenced from the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Determine if Skill-Required Armor Is Equipped
  #--------------------------------------------------------------------------
  def skill_atype_ok?(skill)
    return true if skill.required_atype_ids.size == 0
    for i in skill.required_atype_ids
      return true if atype_equipped?(i)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Determine if Skill-Required Armor Is Equipped
  #--------------------------------------------------------------------------
  def skill_areq_ok?(skill)
    return true if skill.required_areq_ids.size == 0
    for i in skill.required_areq_ids
      return true if areq_equipped?(i)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Determine if Specific Type of Armor Is Equipped
  #--------------------------------------------------------------------------
  def atype_equipped?(atype_id)
    armors.any? {|armor| armor.atype_id == atype_id }
  end
  #--------------------------------------------------------------------------
  # * Determine if Specific Type of Armor Is Equipped
  #--------------------------------------------------------------------------
  def areq_equipped?(areq_id)
    armors.any? {|armor| armor.id == areq_id }
  end
  #--------------------------------------------------------------------------
  # * Determine if Skill-Required Item Is In Inventory
  #--------------------------------------------------------------------------
  def skill_ireq_ok?(skill)
    for i in skill.required_items
      item = $data_items[i[0]]
      return false unless $game_party.item_number(item) >= i[1]
    end
    return true
  end
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  A battler class with methods for sprites and actions added. This class 
# is used as a super class of the Game_Actor class and Game_Enemy class.
#==============================================================================

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Use Skill/Item
  #    Called for the acting side and applies the effect to other than the user.
  #--------------------------------------------------------------------------
  alias jene_ireq_use_item use_item
  def use_item(item)
    consume_item(item) if item.is_a?(RPG::Skill) && !item.required_items.empty?
    jene_ireq_use_item(item)
  end
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles parties. Information such as gold and items is included.
# Instances of this class are referenced by $game_party.
#==============================================================================

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * Consume Items
  #    If the specified object is a consumable item, the number in investory
  #    will be reduced by 1.
  #--------------------------------------------------------------------------
  alias jene_ireq_consume_item consume_item
  def consume_item(item)
    if item.is_a?(RPG::Skill)
      for i in item.required_items
        item2 = $data_items[i[0]]
        lose_item(item2, i[1]) if i[2]
      end
    end
    jene_ireq_consume_item(item)
  end
end
