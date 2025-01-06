# State Remove by Weakness by Coelocanth
# Addon by Roninator2
# 
# This script alters the "remove by damage" flag on states by giving some
# extra options about what sort of damage removes the state.
# 
# Instructions
# 
# Install this script in the usual way by inserting below Materials in the
# script editor.
# 
# In the database, add the following note tags to states with the
# "remove by damage" flag set:
# 
# <remove by element damage: amount>
# e.g. <remove by element damage: 50>
#
# Damage will only remove the state if it is higher than the value specified.

class RPG::State < RPG::BaseItem
  attr_accessor :remove_by_element_damage
  def load_notetags_ccsrw
    @remove_by_weakness = false
    @remove_by_strength = false
    @remove_by_elements = []
    @remove_by_element_damage = 0
    self.note.split(/^/).each do |line|
      case line
      when /<remove by weakness>/i
        @remove_by_weakness = true
      when /<remove by strength>/i
        @remove_by_strength = true
      when /<remove by element:(\d+)/
        @remove_by_elements.push($1.to_i)
      when /<remove by element damage:[ _-](\d+)/
        @remove_by_element_damage = ($1.to_i)
      end
    end
  end
end

class Game_Battler
  def remove_states_by_damage
    states.each do |state|
      if state.remove_by_damage && rand(100) < state.chance_by_damage
        next if state.remove_by_weakness && @result.element_rate <= 1.0
        next if state.remove_by_strength && @result.element_rate >= 1.0
        if @result.hp_damage >= state.remove_by_element_damage
          remove_state(state.id)
          next
        end
        next unless state.remove_by_elements.empty? ||
                    state.remove_by_elements.include?(@result.element_id) ||
        remove_state(state.id)
      end
    end
  end
end
