# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Pre Skill Animation                    ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║  Show an animation before the skill           ║    09 Jun 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Display additional animation on skills                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║    Add note tag to skills that will show an                        ║
# ║    animation before the skill is done                              ║
# ║       <pre anim: x>                                                ║
# ║                                                                    ║
# ║    Add note for changing the subject target                        ║
# ║    of the animation                                                ║
# ║       <pre target: user>                                           ║
# ║     Options are user, ally or enemy                                ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 09 Jun 2022 - Initial publish                               ║
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

module R2_Pre_Skill_Animation
  PREANIM = /<pre anim:[ ](\d+)>/i
  TARGET = /<pre target:[ ](\w*)>/i
end

module DataManager
  class <<self; alias load_database_pre_anim load_database; end
  def self.load_database
    load_database_pre_anim
    load_notetags_pre_anim
  end
  def self.load_notetags_pre_anim
    for obj in $data_skills
      next if obj.nil?
      obj.load_notetags_pre_anim
    end
  end
end

class RPG::Skill < RPG::UsableItem
  attr_accessor :pre_animation
  attr_accessor :pre_target
  def load_notetags_pre_anim
    @pre_animation = 0
    @pre_target = 'user'
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when R2_Pre_Skill_Animation::PREANIM
        @pre_animation = $1.to_i
      when R2_Pre_Skill_Animation::TARGET
        @pre_target = $1.to_s.downcase
      end
    }
  end
end
class Scene_Battle
  def use_item
    item = @subject.current_action.item
    @log_window.display_use_item(@subject, item)
    if item.pre_animation != 0
      pre_target = item.pre_target
      total = []
      target = @subject.current_action.make_targets.compact
      clear = target.size - 1
      if clear > 1
        for i in 1..clear
          target[i].pop
        end
      end
      case pre_target
      when 'user'
        target[0] = @subject
      when 'ally'
        target[0] = @subject.friends_unit.random_target
      when 'enemy'
        target[0] = @subject.opponents_unit.random_target
      end
      show_animation(target, item.pre_animation)
    end
    @subject.use_item(item)
    refresh_status
    targets = @subject.current_action.make_targets.compact
    show_animation(targets, item.animation_id)
    targets.each {|target| item.repeats.times { invoke_item(target, item) } }
  end
end
