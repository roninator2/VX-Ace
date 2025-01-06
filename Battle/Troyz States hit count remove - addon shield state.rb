# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Shield State Count Hit fix   ║  Version: 1.02     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:  Patch                    ║   Date Created     ║
# ║      Allow hit to not do damage     ╠════════════════════╣
# ║      when successful.               ║    05 Jan 2021     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Requires: TroyZ - States Hit Count Removal               ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║ Original script allowed a state to be removed when hit,  ║
# ║ but if the state is a shield to block all damage         ║
# ║ then the player still took damage, this fixes it.        ║
# ║                                                          ║
# ║ Add Shield States below:                                 ║
# ║ Each state number added will protect from type damage    ║
# ║ Can be a single number [28], or multiple [4, 18, 28]     ║
# ║                                                          ║
# ║ Each one has it's specific hit type                      ║
# ║ Shield_State = Physical hit type                         ║
# ║ Mind_Shield = Magical hit type                           ║
# ║ Certain_Shield = Certain hit type                        ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Updates:                                                 ║
# ║ 1.00 - 05 Jan 2021 - Initial publish                     ║
# ║ 1.01 - 06 Jan 2021 - Seperated damage to hit type        ║
# ║ 1.02 - 06 Jan 2021 - Created percentage damage option    ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Follow the Original Authors terms                        ║
# ╚══════════════════════════════════════════════════════════╝
module R2_State_Shield_Remove_On_Hit
	# states that give 100% protection from damage
  Physical_Shield = [1, 28] 
  # Physical hit type protection 
  Mind_Shield = [13, 29] 
  # Magic hit type protection 
  Certain_Shield = [4, 30] 
  # Certain hit type protection
	
	# states that give percentage protection
  Half_Physical = [2, 33] 
  # Physical hit type protection 
  Half_Mind = [14, 32] 
  # Magic hit type protection 
  Half_Certain = [5, 31] 
  # Certain hit type protection
	
	# Percentage values for half states 50 = 50%
  Physical_Rate = 50 
  # Physical hit type protection percentage value
  Mind_Rate = 70 
  # Magic hit type protection percentage value
  Certain_Rate = 30 
  # Certain hit type protection percentage value
	
end

class Game_Battler < Game_BattlerBase
  def make_damage_value(user, item)
    value = item.damage.eval(user, self, $game_variables)
    value *= item_element_rate(user, item)
    value *= pdr if item.physical?
    value *= mdr if item.magical?
    value *= rec if item.damage.recover?
    value = apply_critical(value) if @result.critical
    value = apply_variance(value, item.damage.variance)
    value = apply_guard(value)
    R2_State_Shield_Remove_On_Hit::Half_Physical.each { |st|
      if item.physical? && @states.include?(st)
        value = ((value * R2_State_Shield_Remove_On_Hit::Physical_Rate) / 100).to_i
      end
    }
    R2_State_Shield_Remove_On_Hit::Half_Certain.each { |st|
      if item.certain? && @states.include?(st)
        value = ((value * R2_State_Shield_Remove_On_Hit::Certain_Rate) / 100).to_i
      end
    }
    R2_State_Shield_Remove_On_Hit::Half_Mind.each { |st|
      if item.magical? && @states.include?(st)
        value = ((value * R2_State_Shield_Remove_On_Hit::Mind_Rate) / 100).to_i
      end
    }
    R2_State_Shield_Remove_On_Hit::Physical_Shield.each { |st|
      if item.physical? && @states.include?(st)
        value = 0
        update_states_hit_count
        remove_states_by_hit_count
      end
    }
    R2_State_Shield_Remove_On_Hit::Certain_Shield.each { |st|
      if item.certain? && @states.include?(st)
        value = 0
        update_states_hit_count
        remove_states_by_hit_count
      end
    }
    R2_State_Shield_Remove_On_Hit::Mind_Shield.each { |st|
      if item.magical? && @states.include?(st)
        value = 0
        update_states_hit_count
        remove_states_by_hit_count
      end
    }
    @result.make_damage(value.to_i, item)
  end
end
