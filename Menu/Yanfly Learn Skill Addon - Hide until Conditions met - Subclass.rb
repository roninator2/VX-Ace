#==============================================================================
#
# ▼ Yanfly Engine Ace - Learn Skill Engine v1.00 - addon
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
# 2020.04.24 - Added support for yanfly class
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
# <learn require subclass level: x, y> # yanfly class support
# x = actor ID, y = actor level
# Sets the skill to require the actor x's current level to be y before the skill
# will show up in the actor's skill learning window.
#==============================================================================

class RPG::Skill < RPG::UsableItem
 
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :learn_require_actor_level
  attr_accessor :learn_require_subclass_level
  attr_accessor :learn_require_actor_id
  attr_accessor :learn_require_subclass_id
 
  #--------------------------------------------------------------------------
  # common cache: load_notetags_lse
  #--------------------------------------------------------------------------
  alias r2_load_notetags_r2_skill_927   load_notetags_lse
  def load_notetags_lse
   r2_load_notetags_r2_skill_927
   @learn_require_actor_level = {}
   @learn_require_subclass_level = {}
   @learn_require_actor_id = {}
   @learn_require_subclass_id = {}
   note.split(/[\r\n]+/).each do |line|
     if line =~ /<learn require actor level\s*:\s*(\d+)\s*,\s*(\d+)>/i
       @learn_require_actor_level[$1.to_i] = $2.to_i
       @learn_require_actor_id[$1.to_i] = $1.to_i
     end
     if line =~ /<learn require subclass level\s*:\s*(\d+)\s*,\s*(\d+)>/i
       @learn_require_subclass_level[$1.to_i] = $2.to_i
       @learn_require_subclass_id[$1.to_i] = $1.to_i
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
    if $imported["YEA-ClassSystem"]
      actor = @actor
      if actor.subclass.nil?
        # actor alone
        return false if item.learn_require_actor_id.empty? &&
        !item.learn_require_subclass_id.empty?
        return true if item.learn_require_actor_id.empty? &&
        actor.class.learn_skills.include?(item.id) &&
        !item.learn_require_subclass_id.empty?
        return true if item.learn_require_actor_id.empty? &&
        actor.class.learn_skills.include?(item.id) && !item.learn_cost.empty?
        return false unless item.learn_require_actor_level[@actor.id]
        return @actor.level >= item.learn_require_actor_level[@actor.id]
      else
        # actor with subclass
        return true if item.learn_require_actor_id.empty? &&
        actor.class.learn_skills.include?(item.id) &&
        item.learn_require_subclass_id.empty?
        # subclass
        return true if item.learn_require_subclass_id.empty? &&
        actor.subclass.learn_skills.include?(item.id)
        return true if item.learn_require_subclass_id.empty? &&
        actor.subclass.learn_skills.include?(item.id) &&
        item.learn_require_actor_id.empty?
        return true if item.learn_require_actor_id.empty? &&
        item.learn_require_subclass_id.empty? && item.learn_cost.empty?
        sublevel = actor.class_level(actor.subclass.id)
        # combined
        if !item.learn_require_actor_level[@actor.id].nil?
          return @actor.level >= item.learn_require_actor_level[@actor.id]
        end
        if !item.learn_require_subclass_level[actor.subclass.id].nil?
          return sublevel >= item.learn_require_subclass_level[actor.subclass.id]
        end
      end
    end
  end
end
