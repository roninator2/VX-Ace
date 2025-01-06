#==============================================================================
#
# ▼ Yanfly Engine Ace - JP Manager v1.06 Addon for subclass
# -- Last Updated: 2019.10.13
# -- Requires: Yanfly Class System 
#              Estriole Subclass Addon
#              Yanfly JP Manager 
# -- addon created by: Roninator2
#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2019.10.05 - Started Script
# 2019.10.06 - Added support for subclass to earn battle jp
#            - Added name size cuting for long class names. Display issue
# 2019.10.07 - Fixed several bugs
# 2019.10.09 - Removed global variables
# 2019.10.10 - Fixed JP gain by subclass
# 2019.10.12 - Fixed maintain_levels no longer needs to be false
# 2019.10.13 - Fixed skill cost for Maintain_levels
# 2019.10.13 - Restored support for yanfly Menu system
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Allow Subclass to gain JP
#==============================================================================

module R2_subclass_battle_jp
  Gain_JP = true        # if you want subclasses to gain JP from battles
  JP_factor = 0.50      # JP earned to subclass (value * factor) 10 * 0.5 = 5
  Cut_text = true       # cut the class name if it is too long. Fixes display
  Name_length = 7       # first number of characters in the actors class name
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
  attr_accessor   :lostjp

  def init_jp
    @jp = {}
    @jp[@class_id] = 0
    @jp[@subclass_id] = 0
    @sublevelup = false
    @sublevelcnt = 0
    @lostjp = false
  end
     
  alias r2_game_actor_level_up_jp level_up
  def level_up
    r2_game_actor_level_up_jp
    lose_jp(YEA::JP::LEVEL_UP) if SceneManager.scene_is?(Scene_Class)
    return if !@subclass_id
    return if @subclass_id == 0
    return if YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
    if @sublevelup
      @exp[@subclass_id] = exp_for_level(class_level(@subclass_id).to_i + @sublevelcnt)
    elsif @exp[@subclass_id] == exp_for_level(class_level(@subclass_id).to_i + 1)
      @sublevelup = true
      class_level(@subclass_id).to_i + 1
      @sublevelcnt += 1
    end
    if @sublevelup
      @jp[@subclass_id] += YEA::JP::LEVEL_UP * @sublevelcnt
      @sublevelup = false
      @sublevelcnt = 0
    end
  end

  def gain_jp(jp, class_id = nil)
    init_jp if @jp.nil?
    class_id = @class_id if class_id.nil?
    battlejp = jp
    @jp[class_id] = 0 if @jp[class_id].nil?
    @jp[class_id] += jp.to_i
    @jp[class_id] = [[@jp[class_id], YEA::JP::MAX_JP].min, 0].max
    return if @lostjp
    if $game_party.in_battle && R2_subclass_battle_jp::Gain_JP
      jp = (jp * R2_subclass_battle_jp::JP_factor).round
      @jp[@subclass_id] += jp.to_i if (@subclass_id != nil || 0)
    elsif R2_subclass_battle_jp::Gain_JP && YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
      @jp[@subclass_id] = 0 if @jp[@subclass_id].nil? 
      @jp[@subclass_id] += jp.to_i
      @jp[@subclass_id] = [[@jp[@subclass_id], YEA::JP::MAX_JP].min, 0].max
    end
    @battle_jp_earned = 0 if @battle_jp_earned.nil? && $game_party.in_battle
    @battle_jp_earned += battlejp.to_i if $game_party.in_battle
  end

  alias r2_subclass_add_ecp_82v7b4  subclass_add_exp
  def subclass_add_exp(class_id,value)
    if @subclass_id != nil && @subclass_id != 0
      last_level = class_level(class_id).to_i
      last_skills = skills
      r2_subclass_add_ecp_82v7b4(class_id,value)
    else
        return if !@subclass_id
        return if @subclass_id == 0
        return if YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
        last_level = class_level(class_id).to_i
        last_skills = skills
        exprate = sub_exp_rate(class_id)
        expvalue = (value * exprate).to_i
        expvalue = [expvalue,1].max if ESTRIOLE::SUBCLASS_MIN_1_EXP && value != 0
        @exp[class_id] = @exp[class_id] + expvalue
        @exp[class_id] = [@exp[class_id],subclass.exp_for_level(subclass_max_level)].min
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
    if R2_subclass_battle_jp::Gain_JP
      sublevelcnt = class_level(class_id).to_i - last_level
      @jp[class_id] += YEA::JP::LEVEL_UP * sublevelcnt if last_level < class_level(class_id).to_i
    end
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
    dy = dy - 10
    draw_actor_jp_class(actor, @class_id, dx, dy + line_height * 2)
    if !actor.subclass.nil?
    draw_actor_jp_subclass(actor, @subclass_id, dx, dy + line_height * 3)
    end
  end

  def draw_actor_jp_class(actor, class_id, dx, dy, dw = 112)
    draw_icon(Icon.jp, dx + dw - 24, dy) if Icon.jp > 0
    dw -= 24 if Icon.jp > 0
    change_color(system_color)
    dw = dw - 10
    dy = dy + 5
    if R2_subclass_battle_jp::Cut_text
      text = actor.class.name
      text = text[0..(R2_subclass_battle_jp::Name_length - 1)]
      draw_text(dx, dy, dw, line_height, text, 3)
    else
      draw_text(dx, dy, dw, line_height, actor.class.name, 3)
    end
    dw = dw + 20
    dx = dx + 20 if $imported["YEA-AceMenuEngine"]
    draw_text(dx, dy, dw, line_height, Vocab::jp, 2)
    dw -= text_size(Vocab::jp).width
    change_color(normal_color)
    draw_text(dx, dy, dw, line_height, actor.jp(class_id).group, 2)
  end

  def draw_actor_jp_subclass(actor, subclass_id, dx, dy, dw = 112)
    draw_icon(Icon.jp, dx + dw - 24, dy) if Icon.jp > 0
    dw -= 24 if Icon.jp > 0
    change_color(system_color)
    dw = dw - 10
    if R2_subclass_battle_jp::Cut_text
      text = actor.subclass.name
      text = text[0..(R2_subclass_battle_jp::Name_length - 1)]
      draw_text(dx, dy, dw, line_height, text, 3)
    else
      draw_text(dx, dy, dw, line_height, actor.subclass.name, 3)
    end
    dw = dw + 20
    dx = dx + 20 if $imported["YEA-AceMenuEngine"]
    draw_text(dx, dy, dw, line_height, Vocab::jp, 2)
    dw -= text_size(Vocab::jp).width
    change_color(normal_color)
    draw_text(dx, dy, dw, line_height, actor.jp(actor.subclass.id).group, 2)
  end

end # Window_Base

class Scene_LearnSkill < Scene_Skill
  def on_cost_ok
    Sound.play_use_skill
    skill = @item_window.item
    @actor.learn_skill(skill.id)
    cost = skill.learn_cost[0]
    case skill.learn_cost[1]
    when :jp
        @actor.lostjp = true
        @actor.lose_jp(cost, @cost_front.skill_class) 
        @actor.lostjp = false
    when :exp
      @actor.lose_exp_class(cost, @cost_front.skill_class)
    when :gold
      $game_party.lose_gold(cost)
    end
    on_cost_cancel
    refresh_windows
  end
end
