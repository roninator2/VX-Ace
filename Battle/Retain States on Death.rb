# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Retain States                          ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Prevent states from being removed             ║    18 Aug 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Prevent death from removing all states                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Add <no recover> to the states you want to not be                ║
# ║   removed when the actor is recovered.                             ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 18 Aug 2023 - Script finished                               ║
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

#==============================================================================
# ** Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Recover All
  #--------------------------------------------------------------------------
  def recover_all
    clean_states
    @hp = mhp
    @mp = mmp
  end
  #--------------------------------------------------------------------------
  # * Clear State Information
  #--------------------------------------------------------------------------
  def clean_states
    if self.is_a?(Game_Actor) && @states != nil
      @states.each_with_index do |st, i|
        stnb = $data_states[st]
        next if stnb.note.include?("<no recover>")
        @states[i] = nil
      end
      @states.compact!
    else
      @states = []
      @state_turns = {}
      @state_steps = {}
    end
  end
end

#==============================================================================
# ** Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  alias r2_actor_setup  setup
  def setup(actor_id)
    r2_actor_setup(actor_id)
    clear_states
  end
end
