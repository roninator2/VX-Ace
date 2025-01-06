#==============================================================================
#
# ▼ Yanfly Engine Ace - Learn Skill Engine v1.01 - addon
# -- Last Updated: 2012.01.08
# -- Level: Normal, Hard
# -- Requires: n/a
# # Mod by Roninator2
# scan code by TheoAllen
# scan check by Sixth
#==============================================================================
#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2019.04.16 - Mod addon
# 2019.04.18 - Completed
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# an alternative for actors to learn skills outside of leveling,
# Skills can be hidden until certain requirements are met
#==============================================================================
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skill notebox in the database.
# -----------------------------------------------------------------------------
# <learn require actor level: x, y>
# x = actor ID, y = actor level
# Sets the skill to require the actor x's current level to be y before the skill
# will show up in the actor's skill learning window.
#==============================================================================

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
   @learn_require_subclass_level = {}
   note.split(/[\r\n]+/).each do |line|
     if line =~ /<learn require actor level\s*:\s*(\d+)\s*,\s*(\d+)>/i
       @learn_require_actor_level[$1.to_i] = $2.to_i
     end
   end
  end
 
end # RPG::Skill

class Window_LearnSkillList < Window_SkillList
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
