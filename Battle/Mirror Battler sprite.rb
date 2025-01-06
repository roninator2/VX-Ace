# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Mirror sprite                          ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║    Flip battler image if inflicted            ╠════════════════════╣
# ║    with a specific state                      ║    26 Nov 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║     Flip battler sprite while inflicted with a state               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Add the states that will flip the battler image                  ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 26 Nov 2021 - Script finished                               ║
# ║ 1.00 - 26 Nov 2021 - Added check for multiple states               ║
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

module R2_Mirror_State
  # enter the states that will cause the battler image to reverse
	# can be multiple [5,9,14]
  STATES = [5,9]
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Game_Battler < Game_BattlerBase
  attr_accessor :mirror        # flip horizontal flag
  #--------------------------------------------------------------------------
  # * Alias Add State
  #--------------------------------------------------------------------------
  alias r2_state_mirror_add  add_state
  def add_state(state_id)
    r2_state_mirror_add(state_id)
    if state_addable?(state_id)
      if R2_Mirror_State::STATES.include?(state_id)
        @mirror = true
      end
    end
  end
  #--------------------------------------------------------------------------
  # * alias Remove State
  #--------------------------------------------------------------------------
  alias r2_remove_mirror_state  remove_state
  def remove_state(state_id)
    if state?(state_id)
      if R2_Mirror_State::STATES.include?(state_id)
        clear = true
        @states.each do |st|
          next if st == state_id
          if R2_Mirror_State::STATES.include?(st)
            clear = false
          end
        end
        @mirror = false if clear == true
      end
    end
    r2_remove_mirror_state(state_id)
  end
end
class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # * alias Start Effect
  #--------------------------------------------------------------------------
  alias r2_start_effect_mirror  start_effect
  def start_effect(effect_type)
    update_mirror
    r2_start_effect_mirror(effect_type)
  end
  #--------------------------------------------------------------------------
  # * Update Effect
  #--------------------------------------------------------------------------
  alias r2_update_mirror_effect   update_effect
  def update_effect
    update_mirror
    r2_update_mirror_effect
  end
  #--------------------------------------------------------------------------
  # * Update Mirror
  #--------------------------------------------------------------------------
  def update_mirror
    if @battler.mirror == true
      self.mirror = true 
    else
      self.mirror = false
    end
  end
end
