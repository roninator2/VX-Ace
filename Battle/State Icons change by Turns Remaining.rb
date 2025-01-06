# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: State Icon turns                       ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Adjust Icon Display                         ║    18 Oct 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║    Display different icons for states that have more than 1 turn   ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Plug and Play                                                    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 18 Oct 2021 - Script finished                               ║
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
  def state_icons
    ic = 0
    icons = states.collect {|state| 
      @st_turn.each { |st|
        if st[0] == state.id
          a = st[1][state.id]
          tmp = state.icon_index
          if a > 1
            ic = tmp + a.to_i
          else
            ic = state.icon_index
          end
        end
      }
      ic
    }
    icons.delete(0)
    icons
  end
  
  def state_turns_r2(state, turns)
    @st_turn = [] if @st_turn.nil?
    @st_turn.push([state.id, turns])
  end
  
  alias r2_state_reset_count  reset_state_counts
  def reset_state_counts(state_id)
    r2_state_reset_count(state_id)
    state = $data_states[state_id]
    state_turns_r2(state, @state_turns)
  end
end
