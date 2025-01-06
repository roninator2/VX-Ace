#==============================================================================
#
# ▼ EST - YEA - SUBCLASS ADD ON - Yanfly Engine Ace - Victory Aftermath - Patch
# -- Last Updated: 2019.10.12
# -- Requires: Yanfly Victory Aftermath
# -- addon created by: Roninator2
#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2019.10.12 - Started Script & finished
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Corrects a bug where the tick counter resets for the subclass
# Adds in position adjustments for the gauge and text
#==============================================================================

class Game_Actor < Game_Battler
  def sub_exp
    return @exp[@subclass_id]
  end
end
  
class Window_VictoryEXP_Back < Window_Selectable

  def draw_exp_gain(actor, rect)
    dw = rect.width - (rect.width - [rect.width, 96].min) / 2
    dy = rect.y + line_height * 3 + 96
    fmt = YEA::VICTORY_AFTERMATH::VICTORY_EXP
    text = sprintf(fmt, actor_exp_gain(actor).group)
    contents.font.size = YEA::VICTORY_AFTERMATH::FONTSIZE_EXP
    change_color(power_up_color)
    draw_text(rect.x, dy, dw, line_height, text, 2)
  end
  
  def draw_sub_exp_gain(actor, rect)
    return if !actor_sub_exp_gain(actor)
    return if YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
    dw = rect.width - (rect.width - [rect.width, 96].min) / 2
    dy = rect.y + line_height * 5 + 96
    fmt = ESTRIOLE::VICTORY_AFTERMATH::VICTORY_SUB_EXP
    text = sprintf(fmt, actor_sub_exp_gain(actor).group)
    contents.font.size = YEA::VICTORY_AFTERMATH::FONTSIZE_EXP
    change_color(power_up_color)
    draw_text(rect.x, dy, dw, line_height, text, 2)
  end
end

class Window_VictoryEXP_Front < Window_VictoryEXP_Back  

  def draw_actor_sub_exp(actor, rect)
    return if !actor.subclass
    return if YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
    rect.y += line_height * 2
    if actor.subclass_level == actor.subclass_max_level
      draw_sub_exp_gauge(actor, rect, 1.0)
      return
    end
    total_ticks = YEA::VICTORY_AFTERMATH::EXP_TICKS
    bonus_exp = actor_sub_exp_gain(actor) * @ticks / total_ticks
    now_exp = (actor.sub_exp - actor.subclass.exp_for_level(actor.subclass_level) + bonus_exp)
    next_exp = actor.subclass.exp_for_level(actor.subclass_level+1) - actor.subclass.exp_for_level(actor.subclass_level)
    rate = now_exp * 1.0 / next_exp
    draw_sub_exp_gauge(actor, rect, rate)
  end
  
  def draw_exp_gauge(actor, rect, rate)
    rate = [[rate, 1.0].min, 0.0].max
    dx = (rect.width - [rect.width, 96].min) / 2 + rect.x
    dy = rect.y + line_height * 2 + 96
    dw = [rect.width, 96].min
    colour1 = rate >= 1.0 ? lvl_gauge1 : exp_gauge1
    colour2 = rate >= 1.0 ? lvl_gauge2 : exp_gauge2
    draw_gauge(dx, dy, dw, rate, colour1, colour2)
    fmt = YEA::VICTORY_AFTERMATH::EXP_PERCENT
    text = sprintf(fmt, [rate * 100, 100.00].min)
    if [rate * 100, 100.00].min == 100.00
      text = YEA::VICTORY_AFTERMATH::LEVELUP_TEXT
      text = YEA::VICTORY_AFTERMATH::MAX_LVL_TEXT if actor.max_level?
    end
    draw_text(dx, dy, dw, line_height, text, 1)
  end
  
  def draw_sub_exp_gauge(actor, rect, rate)
    rate = [[rate, 1.0].min, 0.0].max
    dx = (rect.width - [rect.width, 96].min) / 2 + rect.x
    dy = rect.y + line_height * 2 + 96
    dw = [rect.width, 96].min
    colour1 = rate >= 1.0 ? lvl_gauge1 : exp_gauge1
    colour2 = rate >= 1.0 ? lvl_gauge2 : exp_gauge2
    draw_gauge(dx, dy, dw, rate, colour1, colour2)
    fmt = YEA::VICTORY_AFTERMATH::EXP_PERCENT
    text = sprintf(fmt, [rate * 100, 100.00].min)
    if [rate * 100, 100.00].min == 100.00
      text = YEA::VICTORY_AFTERMATH::LEVELUP_TEXT
      text = YEA::VICTORY_AFTERMATH::MAX_LVL_TEXT if actor.subclass_level == actor.subclass_max_level
    end
    draw_text(dx, dy, dw, line_height, text, 1)
  end

end
