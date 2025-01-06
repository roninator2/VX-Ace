# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: States do elemental damage             ║  Version: 1.03     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Script Function                             ║    11 Sep 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║        Add elemental damage over time                              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║ Use <element damage: id, dam, pcnt> on state that will             ║
# ║ perform damage to the battler in battle.                           ║
# ║ The dam is the amount of damage that will be applied.              ║
# ║ The pcnt is use percentage? 1 / 0                                  ║
# ║ 1 equals true                                                      ║
# ║   will use dam as a percentage value for calculation               ║
# ║ 0 equals false                                                     ║
# ║   will use dam as direct damage value                              ║
# ║                                                                    ║
# ║ Example:                                                           ║
# ║ <element damage: 3, 15, 1> or <element_damage:3 15 1>              ║
# ║     element 3 (fire), 15 damage in percentage                      ║
# ║             mhp * 15%                                              ║
# ║ <element damage: 3, 75, 0> or <element-damage: 3 75 0>             ║
# ║     element 3 (fire), 75 damage in flat value                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 11 Sep 2023 - Script finished                               ║
# ║ 1.01 - 11 Sep 2023 - Made Changes                                  ║
# ║ 1.02 - 15 Sep 2023 - Added support for enemies                     ║
# ║ 1.03 - 24 Mar 2024 - Updated terms                                 ║
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

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

module R2_Element_Battle_Damage
  Element_Rgx = /<element[ -_]damage: *(\d+),* *(\d+),* *(\d+)>/i
  Combine = false      # combine multipler or add them.
      # false will process each function separately
      # true will get total value before calculating
  Check_Enemy = true   # checks for Database enemy features
  Check_Actor = true   # checks for Database actor features
  Check_Class = true   # checks for Class features
  Check_Equip = true   # checks for Actor Equipment features
end
module DataManager
  class <<self 
    alias :load_database_original_r2_state_element_damage :load_database
  end
  def self.load_database
    load_database_original_r2_state_element_damage
    load_r2_state_element_damage
  end
  def self.load_r2_state_element_damage
    for obj in $data_states
      next if obj.nil?
      obj.load_r2_state_element_damage
    end
  end
end

class RPG::State
  attr_accessor :damele
  attr_accessor :dameleamt
  attr_accessor :damelepcnt
  
  def load_r2_state_element_damage
    @damele = 0 
    @dameleamt = 0 
    @damelepcnt = false
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when R2_Element_Battle_Damage::Element_Rgx
        @damele = $1.to_i
        @dameleamt = $2.to_i
        @damelepcnt = true if $3.to_i == 1
      end
    }
  end
end

class Game_Battler < Game_BattlerBase
  alias r2_regenerate_hp_and_element_damage   regenerate_hp
  def regenerate_hp
    r2_regenerate_hp_and_element_damage
    adjust_element_state if $game_party.in_battle
  end
  def adjust_element_state
    states.each do |st|
      if st.damele != (0 || nil)
        damage = st.dameleamt
        damage = (mhp * (st.dameleamt.to_f / 100)).to_i if st.damelepcnt == true
        damage = element_feature_resist(damage, st.damele)
        @result.hp_damage = [damage, max_slip_damage].min
        perform_map_damage_effect if $game_party.in_battle && damage > 0
        self.hp -= @result.hp_damage
      end
    end
  end
  def element_feature_resist(damage, ele)
    tmul = 0
    mul = 1
    dam = damage
    mod = 0
    if self.is_a?(Game_Enemy)
      if R2_Element_Battle_Damage::Check_Enemy
        $data_enemies[self.enemy_id].features.each do |ft|
          next if ft.nil?
          next if ft.code != 11
          next if ft.data_id != ele
          mod = ft.value - 1
          mul += mod
        end
        if R2_Element_Battle_Damage::Combine == true
          tmul += mod
        else
          dam = dam * mul
        end
      end
    else
      if R2_Element_Battle_Damage::Check_Actor
        $data_actors[self.id].features.each do |ft|
          next if ft.nil?
          next if ft.code != 11
          next if ft.data_id != ele
          mod = ft.value - 1
          mul += mod
        end
        if R2_Element_Battle_Damage::Combine == true
          tmul += mod
        else
          dam = dam * mul
        end
      end
      mul = 1
      mod = 0
      if R2_Element_Battle_Damage::Check_Class
        $data_classes[self.class_id].features.each do |ft|
          next if ft.nil?
          next if ft.code != 11
          next if ft.data_id != ele
          mod = ft.value - 1
          mul += mod
        end
        if R2_Element_Battle_Damage::Combine == true
          tmul += mod
        else
          dam = dam * mul
        end
      end
      mul = 1
      mod = 0
      if R2_Element_Battle_Damage::Check_Equip
        self.equips.each do |eq|
          next if eq.nil?
          eq.features.each do |ft|
            next if ft.class.nil?
            next if ft.code != 11
            next if ft.data_id != ele
            mod = ft.value - 1
            mul += mod
          end
        end
        if R2_Element_Battle_Damage::Combine == true
          tmul += mod
        else
          dam = dam * mul
        end
      end
    end
    if R2_Element_Battle_Damage::Combine == true
      tmul = 0 if tmul < 0
      dam = dam * tmul
    end
    return dam.to_i
  end
end
