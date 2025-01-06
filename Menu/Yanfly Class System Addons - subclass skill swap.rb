#==============================================================================
#
# ▼ Yanfly Engine Ace - Class v1.06 Addon for subclass - skillswap
# -- Last Updated: 2020.09.15
# -- Requires: Yanfly Class System 
#              Yanfly Class Specifics <- Optional
#              Estriole Subclass Addon
# -- addon created by: Roninator2
#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2020.09.14 - Started Script
# 2020.09.15 - Added forget skills option
# 2020.09.20 - fixed bug
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Allow Subclass to gain levels & skills and allows the option to
# have the actor forget skills from the class they were previously
# when changing classes.
#==============================================================================
module R2_yanfly_skills
  Forget_skills = true
end

class Game_Interpreter
  def command_316
   value = operate_value(@params[2], @params[3], @params[4])
   iterate_actor_var(@params[0], @params[1]) do |actor|
     actor.sublevelup = true
     actor.sublevelcnt = value
     actor.change_level(actor.level + value, @params[5])
   end
  end
end

class Game_Actor < Game_Battler
 
  attr_accessor   :sublevelup
  attr_accessor   :sublevelcnt
  attr_accessor   :subclass_id
  
  alias r2_game_actor_level_up level_up
  def level_up
    r2_game_actor_level_up
    return if @subclass_id == 0
    return if !@subclass_id
    if @sublevelup
      @exp[@subclass_id] = exp_for_level(class_level(@subclass_id).to_i + @sublevelcnt)
    elsif @exp[@subclass_id] == exp_for_level(class_level(@subclass_id).to_i + 1)
      @sublevelup = true
      class_level(@subclass_id).to_i + 1
      @sublevelcnt += 1
    end
    subclass_add_exp(@subclass_id,0)
    if @sublevelup
      @sublevelup = false
      @sublevelcnt = 0
    end
  end

  def forget_class_skills(class_id)
    return if class_id <= 0
    return if $data_classes[class_id].nil?
    $data_classes[class_id].learnings.each do |learning|
      forget_skill(learning.skill_id)
    end
  end
  
  def forget_subclass_skills(class_id)
    return if class_id <= 0
    return if $data_classes[class_id].nil?
    $data_classes[class_id].learnings.each do |learning|
      forget_skill(learning.skill_id)
    end
  end

  def learn_class_skills(class_id)
    return if class_id <= 0
    return if $data_classes[class_id].nil?
    $data_classes[class_id].learnings.each do |learning|
      learn_skill(learning.skill_id) if learning.level <= class_level(class_id)
    end
  end

  def subclass_add_exp(class_id,value)
    return if !@subclass_id
    return if @subclass_id == 0
    last_level = class_level(class_id).to_i
    last_skills = skills
    exprate = sub_exp_rate(class_id)
    expvalue = (value * exprate).to_i
    expvalue = [expvalue,1].max if ESTRIOLE::SUBCLASS_MIN_1_EXP && value != 0
    if !YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
      @exp[class_id] = @exp[class_id] + expvalue
      @exp[class_id] = [@exp[class_id],subclass.exp_for_level(subclass_max_level)].min
    end
    self.subclass.learnings.each do |learning|
      learn_skill(learning.skill_id) if learning.level <= class_level(class_id).to_i
      if @extra_features && class_level(class_id).to_i > last_level && learning.note =~ /<extratrait (.*)>/i
        @extra_features.features += $data_weapons[$1.to_i].features if EXTRA_FEATURES_SOURCE == 0
        @extra_features.features += $data_armors[$1.to_i].features if EXTRA_FEATURES_SOURCE == 1
        @extra_features.features += $data_states[$1.to_i].features if EXTRA_FEATURES_SOURCE == 2
      end
    end
    display_level_up_sub(skills - last_skills) if class_level(class_id).to_i > last_level
  end
end # Game_Actor
class Window_Base < Window
 
  if $imported["YEA-AceMenuEngine"]
    def draw_actor_simple_status(actor, dx, dy)
      dy -= line_height / 2
      draw_actor_name(actor, dx, dy)
      draw_actor_level(actor, dx, dy + line_height * 1)
      draw_actor_icons(actor, dx, dy + line_height * 2)
      dx = dx + 25
      dw = contents.width - dx - 124
      draw_actor_class(actor, dx + 120, dy, dw)
      draw_actor_hp(actor, dx + 120, dy + line_height * 1, dw)
      if YEA::MENU::DRAW_TP_GAUGE && actor.draw_tp? && !actor.draw_mp?
        draw_actor_tp(actor, dx + 120, dy + line_height * 2, dw)
      elsif YEA::MENU::DRAW_TP_GAUGE && actor.draw_tp? && actor.draw_mp?
        if $imported["YEA-BattleEngine"]
          draw_actor_tp(actor, dx + 120, dy + line_height * 2, dw/2 - 1)
          draw_actor_mp(actor, dx + 120 + dw/2, dy + (line_height * 2), dw/2 + 1)
        else
          draw_actor_mp(actor, dx + 120, dy + line_height * 2, dw/2 - 1)
          draw_actor_tp(actor, dx + 120 + dw/2, dy + line_height * 2, dw/2 + 1)
        end
      elsif YEA::MENU::DRAW_TP_GAUGE && actor.draw_mp?
        draw_actor_mp(actor, dx + 120, dy + line_height * 2, dw)
      end
    end
  end

  alias r2_draw_actor_class_924v  draw_actor_simple_status
  def draw_actor_simple_status(actor, dx, dy)
    r2_draw_actor_class_924v(actor, dx, dy)
    @class_id = actor.class_id
    @sublass_id = actor.subclass.nil? ? nil : actor.subclass.id
  end

end # Window_Base

class Scene_LearnSkill < Scene_Skill
  def on_cost_ok
    Sound.play_use_skill
    skill = @item_window.item
    @actor.learn_skill(skill.id)
    cost = skill.learn_cost[0]
    case skill.learn_cost[1]
    when :exp
      @actor.lose_exp_class(cost, @cost_front.skill_class)
    when :gold
      $game_party.lose_gold(cost)
    end
    on_cost_cancel
    refresh_windows
  end
end

class Scene_Class < Scene_MenuBase
  def on_class_ok
    Sound.play_equip
    class_old = @actor.class_id
    subclass_old = @actor.subclass_id
    class_id = @item_window.item.id
    maintain = YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
    hp = @actor.hp * 1.0 / @actor.mhp
    mp = @actor.mp * 1.0 / [@actor.mmp, 1].max
    case @command_window.current_symbol
    when :primary
      @actor.forget_class_skills(class_old) if R2_yanfly_skills::Forget_skills
      @actor.change_class(class_id, maintain)
      if @actor.subclass_id == 0
        @actor.forget_subclass_skills(subclass_old) if R2_yanfly_skills::Forget_skills
      end
    when :subclass
      @actor.forget_subclass_skills(subclass_old) if R2_yanfly_skills::Forget_skills
      @actor.change_subclass(class_id)
    else
      @item_window.activate
      return
    end
    @actor.hp = (@actor.mhp * hp).to_i
    @actor.mp = (@actor.mmp * mp).to_i
    @status_window.refresh
    @item_window.update_class
  end  
end
