# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Skill BGM                              ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Allow skills to use their own BGM             ║    01 Dec 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║ For each skill set the note tag for the BGM to play                ║
# ║ Will do nothing if there is no tag                                 ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Place <skill bgm: theme1> in the skill notebox                   ║
# ║   The BGM is played when the skill is used                         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 01 Dec 2021 - Script finished                               ║
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

module R2_BGM_Skill_Play
  Regex = /<skill[-_ ]bgm(?::\s*(\w+))?>/i
end

module RPG
  class Skill
    def bgm_skill_play
      load_skill_bgm unless @bgm_skill != nil
      return @bgm_skill
    end
    def load_skill_bgm
      @bgm_skill = nil
      res = self.note.scan(R2_BGM_Skill_Play::Regex)
      res.each do
        @bgm_skill = $1.to_s
      end
      return @bgm_skill
    end
  end
end

class Game_Battler < Game_BattlerBase
  
  def change_skill_bgm(item)
    return unless item.is_a?(RPG::Skill)
    return item.bgm_skill_play
  end
end

class Scene_Battle < Scene_Base
  alias r2_use_item_bgm_skill use_item
  def use_item
    item = @subject.current_action.item
    song = @subject.change_skill_bgm(item)
    curr_bgm = RPG::BGM.last
    pos = curr_bgm.pos
    if song != nil
      RPG::BGM.stop
      new_bgm = RPG::BGM.new("#{song}", 100, 100)
      new_bgm.play
    end
    r2_use_item_bgm_skill
    if song != nil
      RPG::BGM.stop
      curr_bgm.play(pos)
    end
  end
end
