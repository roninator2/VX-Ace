# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Skills applies a user state            ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Add a state to the user on skill hit          ║    09 Sep 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Allow states to be applied through skills upon hit           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Use <self_state: id, X> on skill that will add a state           ║
# ║   The skill used will then add the state (id) when used            ║
# ║   The X is the percentage of change that it will work.             ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 09 Sep 2023 - Script finished                               ║
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

module R2_Skill_State_Apply_Self
  Self_State = /<self[ _-]state:[ _-](\d+),[ -_](\d+*.\d+*)>/i
end

module DataManager
  class <<self 
    alias :load_database_original_r2_skill_state_self_apply :load_database
  end
  def self.load_database
    load_database_original_r2_skill_state_self_apply
    load_r2_skill_state_self_apply
  end
  def self.load_r2_skill_state_self_apply
    for obj in $data_skills
      next if obj.nil?
      obj.load_r2_skill_state_self_apply
    end
  end
end

class RPG::Skill
  attr_accessor :sass
  attr_accessor :sassc

  def load_r2_skill_state_self_apply
    @sass = 0 # skill apply self state
    @sassc = 0 # skill apply self state chance
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when R2_Skill_State_Apply_Self::Self_State
        @sass = $1.to_i
        @sassc = $2.to_f
      end
    }
  end
end

class Game_BattlerBase
  alias :r2_pay_skill_cost_self_state_apply   :pay_skill_cost
  def pay_skill_cost(skill)
    r2_pay_skill_cost_self_state_apply(skill)
    if skill.sass != (0 || nil)
      rdnum = ((rand(1000) + 1) / 10).to_f
      self.add_state(skill.sass) if rdnum <= skill.sassc
    end
  end
end
