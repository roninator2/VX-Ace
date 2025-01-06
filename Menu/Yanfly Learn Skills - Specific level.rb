# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Learn Skill at this level    ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║ Yanfly Learn Skills -               ╠════════════════════╣
# ║ Learn skill at specific level       ║    18 Apr 2019     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ A mod for Yanfly's Learn Skills script* Required         ║
# ║ Lets you specify what skills each actor can learn,       ║
# ║ and at which levels to learn them.                       ║
# ║                                                          ║
# ║ Use notetag on skills <learn require actor level: x, y>  ║
# ║ Sets the skill to require the actor x's current          ║
# ║ level to be y before the skill will show up in the       ║
# ║ actor's skill learning window.                           ║
# ║ x = actor ID, y = actor level                            ║
# ╚══════════════════════════════════════════════════════════╝
# ╔═════════════════════════════════════╗
# ║ Terms of use:                       ║
# ║ Follow the Original Authors terms   ║
# ╚═════════════════════════════════════╝

class RPG::Skill < RPG::UsableItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :learn_require_actor_level
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_lse
  #--------------------------------------------------------------------------
  alias r2_load_notetags_r2_skill_927   load_notetags_lse
  def load_notetags_lse
    r2_load_notetags_r2_skill_927
    @learn_require_actor_level = {}
    note.split(/[\r\n]+/).each do |line|
      if line =~ /<learn require actor level\s*:\s*(\d+)\s*,\s*(\d+)>/i
        @learn_require_actor_level[$1.to_i] = $2.to_i
      end
    end
  end
end # RPG::Skill

class Window_LearnSkillList < Window_SkillList

  attr_accessor :learn_require_actor_level
  #--------------------------------------------------------------------------
  # meet_requirements?
  #--------------------------------------------------------------------------
  def meet_requirements?(item)
    return false if @actor.nil?
    return false unless meet_level_requirements?(item)
    return false unless meet_actor_level_requirements?(item)
    return false unless meet_skill_requirements?(item)
    return false unless meet_switch_requirements?(item)
    return false unless meet_eval_requirements?(item)
    return true
  end
  
  #--------------------------------------------------------------------------
  # meet_level_requirements?
  #--------------------------------------------------------------------------
  def meet_actor_level_requirements?(item)
    return false unless item.learn_require_actor_level[@actor.id]
    return @actor.level >= item.learn_require_actor_level[@actor.id]
  end  
end
