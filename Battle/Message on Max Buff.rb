# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Message on Max Buff                    ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Show BattleLog Message                        ║    06 May 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Show Message when at max buff                                ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║ Change the message below to what you want displayed                ║
# ║ When a battler has reached max buff or debuff.                     ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 06 May 2021 - Script finished                               ║
# ║ 1.01 - 06 May 2021 - error fixed                                   ║
# ║ 1.02 - 06 May 2021 - show when state does not affect the battler   ║
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

module Vocab

Buff_Max = "%s is already at the max!"
Debuff_Max = "%s is already at the bottom!"
No_State = "%s is not affected by %s!"

end

class Game_ActionResult
  attr_accessor :max_buffs              # added buffs
  attr_accessor :max_debuffs            # added debuffs
  attr_accessor :blocked_state          # blocked states
	alias r2_clear_max_buff	clear_status_effects
  def clear_status_effects
		r2_clear_max_buff
		@max_buffs = []
		@max_debuffs = []
    @blocked_state = []
	end
end

class Game_Battler < Game_BattlerBase

  #--------------------------------------------------------------------------
  # * Add State
  #--------------------------------------------------------------------------
  def add_state(state_id)
    if state_addable?(state_id)
      add_new_state(state_id) unless state?(state_id)
      reset_state_counts(state_id)
      @result.added_states.push(state_id).uniq!
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if States Are Addable
  #--------------------------------------------------------------------------
  def state_addable?(state_id)
    res = alive? && $data_states[state_id] && !state_resist?(state_id) &&
      !state_removed?(state_id) && !state_restrict?(state_id)
    if res == false && state_resist?(state_id)
      @result.blocked_state.push(state_id).uniq!
    else
      @result.blocked_state.delete(state_id)
    end
    return res
  end
  #--------------------------------------------------------------------------
  # * Add Buff
  #--------------------------------------------------------------------------
  def add_buff(param_id, turns)
    return unless alive?
    @result.max_buffs.delete(param_id) if @result.max_buffs.include?(param_id)
    if @buffs[param_id] == 2
      @result.max_buffs.push(param_id)
    end
    @buffs[param_id] += 1 unless buff_max?(param_id)
    erase_buff(param_id) if debuff?(param_id)
    overwrite_buff_turns(param_id, turns)
    @result.added_buffs.push(param_id).uniq!
    refresh
  end
  #--------------------------------------------------------------------------
  # * Add Debuff
  #--------------------------------------------------------------------------
  def add_debuff(param_id, turns)
    return unless alive?
    @result.max_debuffs.delete(param_id) if @result.max_debuffs.include?(param_id)
    if @buffs[param_id] == -2
      @result.max_debuffs.push(param_id)
    end
    @buffs[param_id] -= 1 unless debuff_max?(param_id)
    erase_buff(param_id) if buff?(param_id)
    overwrite_buff_turns(param_id, turns)
    @result.added_debuffs.push(param_id).uniq!
    refresh
  end

end

class Window_BattleLog < Window_Selectable
  def display_buffs(target, buffs, fmt)
    buffs.each do |param_id|
			if fmt == Vocab::BuffAdd
				if target.result.max_buffs.include?(param_id)
					replace_text(sprintf(Vocab::Buff_Max, target.name, Vocab::Buff_Max))
          wait
          wait
        else
          replace_text(sprintf(fmt, target.name, Vocab::param(param_id)))
				end
			elsif fmt == Vocab::DebuffAdd
				if target.result.max_debuffs.include?(param_id)
					replace_text(sprintf(Vocab::Debuff_Max, target.name, Vocab::Debuff_Max))
          wait
          wait
        else
          replace_text(sprintf(fmt, target.name, Vocab::param(param_id))) 
				end
      else
        replace_text(sprintf(fmt, target.name, Vocab::param(param_id))) 
			end
      wait
    end
  end
  #--------------------------------------------------------------------------
  # * Display Affected Status
  #--------------------------------------------------------------------------
  def display_affected_status(target, item)
    if target.result.status_affected?
      add_text("") if line_number < max_line_number
      display_changed_states(target)
      display_changed_buffs(target)
      back_one if last_text.empty?
    end
    if !target.result.blocked_state.nil?
      display_blocked_states(target)
    end
  end
  #--------------------------------------------------------------------------
  # * Display blocked State
  #--------------------------------------------------------------------------
  def display_blocked_states(target)
    target.result.blocked_state.each do |state|
      next if state.nil?
      name = $data_states[state].name
      msg = Vocab::No_State
      replace_text(sprintf(msg, target.name, name)) 
      wait
      wait
    end
  end
end
