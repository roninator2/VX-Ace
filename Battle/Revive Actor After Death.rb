# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Revive Actor After Death               ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║     Battle Manager & Game_Battler             ╠════════════════════╣
# ║     Adjust process die                        ║    27 Dec 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Revive after death in battle                                 ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   A script to revive an actor that has fallen - X times            ║
# ║   When correct armour is equipped the actor is revived             ║
# ║  FYI                                                               ║
# ║   Variable array is formatted like this                            ║
# ║   [0,0] = [revives left, reached 0 (1 = true)]                     ║
# ║   array is reset at the start of battle                            ║
# ║                                                                    ║
# ║   This can be customized, but I've designed it to revive           ║
# ║   in stages. First death = 100%, second death = 50%                ║
# ║   Third death = 10%, Fourth death = dead                           ║
# ║   The actor can still be revived by revive spell after this        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 27 Dec 2021 - Script finished                               ║
# ║ 1.01 - 27 Dec 2021 - Fixed issue                                   ║
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

# just set and forget
module R2_Recover_Death
    Revive_Equip = 6        		# equipment that will recover party member
    Equip_Type = 1         		  # 0 = weapon, 1 = armor
    Reset_After_Battle = false  # will start fresh on the next battle
    Lose_Item = true       			# remove item after last revive
    Repeat = 3              		# specify how many times to use
    # repeats     0   1   2   3
    # repeat 3 = [1, 10, 50, 75]
    #          Stage 0   1   2   3
    Stage_Percent = [5, 25, 50, 75] # Percent of HP recovered each time
    # stage 3 = 75%, stage 2 = 50% etc
    Revive_Var = 19         # variable used to track uses
    Preserve_Buffs = true   # will save buffs from getting removed on death
    Preserve_States = true  # will save states from getting removed on death
    # these will be cleared when the actor has 0 recovers left
    # unless you have another script to preserve them.
    # no guarantees that they will be compatible
    Message = "The Amulet revived " # message + actors name
    Lost_Item = "The Amulet Broke"  # when item is expired
end

class Game_Battler < Game_BattlerBase
  def die
    @hp = 0
    if SceneManager.scene_is?(Scene_Battle)
      chkact = enemy? ? false : true
      if chkact == true
        reset_revive_count if $game_variables[R2_Recover_Death::Revive_Var] == 0
        i = actor.id
        array = $game_variables[R2_Recover_Death::Revive_Var]
        item = array[i]
        if !item.nil?
          if item[1] != 1
            remove_state(death_state_id)
            perc = (R2_Recover_Death::Stage_Percent[item[0]].to_f / 100)
            $game_party.battle_members.each do |act|
              next if act.id != i
              $game_message.add(sprintf(R2_Recover_Death::Message + actor.name, actor.name))
              act.hp += [(act.mhp * perc).to_i - 1, act.mhp].min
            end
            item[0] -= 1
            item[1] = 1 if item[0] < 0
            if item[1] == 1
              if R2_Recover_Death::Lose_Item
								litem = r2_equip_type_check
                actor_index = $game_actors[actor.id]
                actor_index.equips.each_with_index do |eq, slot|
                  next if eq.nil?
                  etype_id = eq.etype_id ? eq.etype_id : eq.itype_id
                  case etype_id
                  when 0
                    li = $data_weapons[eq.id]
                  else
                    li = $data_armors[eq.id]
                  end
                  actor_index.discard_equip(li) if li == litem
                end
                $game_message.add(sprintf(R2_Recover_Death::Lost_Item, actor.name))
              end
            end
            array[i] = item
            $game_variables[R2_Recover_Death::Revive_Var] = array
          end
        end
        clear_states if R2_Recover_Death::Preserve_States == false && item[1] != 1 && !item.nil?
        clear_buffs if R2_Recover_Death::Preserve_Buffs == false && item[1] != 1 && !item.nil?
      else
        clear_states
        clear_buffs
      end
    else
      clear_states
      clear_buffs
    end
  end
  def r2_equip_type_check
		case R2_Recover_Death::Equip_Type
		when 0
			item = $data_weapons[R2_Recover_Death::Revive_Equip]
		when 1
			item = $data_armors[R2_Recover_Death::Revive_Equip]
		end
		return item
	end
  def reset_revive_count
    array = []
    $game_party.battle_members.each do |actor|
      i = actor.id
			item = r2_equip_type_check
      if actor.equips.include?(item)
        array[i] = [0,0]
        array[i][0] = R2_Recover_Death::Repeat
        array[i][1] = 0
      end
      $game_variables[R2_Recover_Death::Revive_Var] = array
    end
  end
end

module BattleManager
  class << self
    alias :reset_recover_armor_victory  :process_victory
    alias :reset_recover_armor_escape   :process_escape
    alias :reset_recover_armor_abort    :process_abort
    alias :reset_recover_armor_defeat   :process_defeat
  end
  def self.process_victory
    $game_variables[R2_Recover_Death::Revive_Var] = 0 unless R2_Recover_Death::Reset_After_Battle == false
    reset_recover_armor_victory
  end
  def self.process_escape
    $game_variables[R2_Recover_Death::Revive_Var] = 0 unless R2_Recover_Death::Reset_After_Battle == false
    reset_recover_armor_escape
  end
  def self.process_abort
    $game_variables[R2_Recover_Death::Revive_Var] = 0 unless R2_Recover_Death::Reset_After_Battle == false
    reset_recover_armor_abort
  end
  def self.process_defeat
    $game_variables[R2_Recover_Death::Revive_Var] = 0 unless R2_Recover_Death::Reset_After_Battle == false
    reset_recover_armor_defeat
  end
end
