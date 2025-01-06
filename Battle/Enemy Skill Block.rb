# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Enemy Skill Block                      ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Block skills when state inflicted             ║    26 Apr 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║   For each skill in the enemy setting that is marked with          ║
# ║   a state restricting the enemy from using the skill,              ║
# ║   placing <skill block> will reverse this, so that when            ║
# ║   inflicted with the state, the skill cannot be used.              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Place <skill block> in the enemy notebox                         ║
# ║   Mark each skill with the state that will be used to              ║
# ║   block the skill when the state is inflicted.                     ║
# ║                                                                    ║
# ║ For example:                                                       ║
# ║   Ice II skill. when the state ice block is inflicted              ║
# ║   the skill will not be used.                                      ║
# ║                                                                    ║
# ║ You must make a state for blocking                                 ║
# ║ You must also make a skill for the player to inflict               ║
# ║   the state with.                                                  ║
# ║                                                                    ║
# ║ You cannot mix skills.                                             ║
# ║   If you have skills that you want to block with a state,          ║
# ║   and you have skills that you want to be available only           ║
# ║   when the state is inflicted, then there will be issues           ║
# ║   This script will make all state conditions a block               ║
# ║   if the state is inflicted and the skill is marked                ║
# ║   for that state.                                                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 26 Apr 2021 - Script finished                               ║
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

class Game_Enemy < Game_Battler
  def conditions_met_state?(param1, param2)
    # <skill block>
    if enemy.note.scan(/<skill block>/i) 
      if state?(param1)
        return false
      else
        return true
      end
    else
      state?(param1)
    end
  end
end
