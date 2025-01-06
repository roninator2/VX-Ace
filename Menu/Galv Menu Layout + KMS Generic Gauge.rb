#==============================================================================
# Compatibility Patch :                                         v1.0 (05/10/20)
#   Galv Menu Layout + KMS Generic Gauge
#==============================================================================
# Script by:
#     Mr. Bubble - recreated by Roninator2
#--------------------------------------------------------------------------
# Place this script below both Galv Menu Layout and KMS Generic Gauge
# in your script edtior.
#
#==============================================================================

$imported = {} if $imported.nil?
$kms_imported = {} if $kms_imported.nil?

#==============================================================================
# ■ Window_MainMenuStatus
#==============================================================================

if $imported["Galv_Menu_Layout"] && $kms_imported["GenericGauge"]
class Window_MenuStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Draw Gauge
  #     rate   : Rate (full at 1.0)
  #     color1 : Left side gradation
  #     color2 : Right side gradation
  #--------------------------------------------------------------------------
  def draw_gauge(x, y, width, rate, color1, color2)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 8
    contents.fill_rect(x, gauge_y, width, 6, gauge_back_color)
    contents.gradient_fill_rect(x, gauge_y, fill_w, 6, color1, color2)
  end

  def draw_actor_hp(actor, x, y, width = col_width)
    draw_actor_hp_gauge(actor, x, y, width)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::hp_a)
    draw_current_and_max_values(x, y, width, actor.hp, actor.mhp,
      hp_color(actor), normal_color)
  end
    
  def draw_actor_mp(actor, x, y, width = col_width)
    draw_actor_mp_gauge(actor, x, y, width)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::mp_a)
    draw_current_and_max_values(x, y + 3, width, actor.mp, actor.mmp,
      mp_color(actor), normal_color)
  end
    
  def draw_actor_tp(actor, x, y, width = col_width)
    draw_actor_tp_gauge(actor, x, y, width)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::tp_a)
    change_color(tp_color(actor))
    draw_text(x + width - 42, y, 42, line_height, actor.tp.to_i, 2)
  end

end
end # if $imported["Galv_Menu_Layout"]
