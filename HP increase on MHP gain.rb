# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: HP increase on MHP Gain                ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║  HP goes up when level goes up                ║    18 Sep 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Keep Hp in line with MHP growth                              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║   Plug and play                                                    ║
# ║   When MHP goes up 50 points, so will HP                           ║
# ║   Same for MP                                                      ║
# ║                                                                    ║
# ║   Also includes states                                             ║
# ║   State should be set to expire                                    ║
# ║                                                                    ║
# ║   Now supports buffs causing HP & MP increase                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 22 Nov 2024 - Script finished                               ║
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

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Level Up
  #--------------------------------------------------------------------------
  alias r2_hp_up_on_level level_up
  def level_up
    old_hp = self.mhp
    old_mp = self.mmp
    r2_hp_up_on_level
    new_hp = self.mhp
    new_mp = self.mmp
    hp_up = new_hp - old_hp
    mp_up = new_mp - old_mp
    self.hp += hp_up
    self.mp += mp_up
  end
end

class Game_Battler < Game_BattlerBase
  alias r2_add_new_state_hp_up  add_new_state
  #--------------------------------------------------------------------------
  # * Add New State
  #--------------------------------------------------------------------------
  def add_new_state(state_id)
    old_hp = self.mhp
    old_mp = self.mmp
    r2_add_new_state_hp_up(state_id)
    if self.is_a?(Game_Actor)
      st = $data_states[state_id]
      st.features.each do |ft|
        if ft.code == 21
          if ft.data_id == 0 && ft.value > 1
            new_hp = self.mhp
            chg_hp = new_hp - old_hp
            self.hp += chg_hp
          end
          if ft.data_id == 1 && ft.value > 1
            new_mp = self.mmp
            chg_mp = new_mp - old_mp
            self.mp += chg_mp
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Add Buff
  #--------------------------------------------------------------------------
  alias r2_add_buff_hp_gain   add_buff
  def add_buff(param_id, turns)
    return unless alive?
    old_hp = self.mhp if self.is_a?(Game_Actor)
    old_mp = self.mmp if self.is_a?(Game_Actor)
    hp_buff = @buffs[0] if self.is_a?(Game_Actor)
    mp_buff = @buffs[1] if self.is_a?(Game_Actor)
    r2_add_buff_hp_gain(param_id, turns)
    if self.is_a?(Game_Actor)
      hp_buff2 = @buffs[0]
      mp_buff2 = @buffs[1]
      if hp_buff2 > hp_buff
        new_hp = self.mhp
        chg_hp = new_hp - old_hp
        self.hp += chg_hp
      end
      if mp_buff2 > mp_buff
        new_mp = self.mmp
        chg_mp = new_mp - old_mp
        self.mp += chg_mp
      end
    end
  end
end
