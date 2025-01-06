#==============================================================================
# Compatibility Patch :                                         v1.0 (05/10/20)
#   Neon Black Victory Grade + KMS Generic Gauge
#==============================================================================
# Script by:
#     Mr. Bubble - recreated by Roninator2
#--------------------------------------------------------------------------
# Place this script below both Neon Black Victory Grade and KMS Generic Gauge
# in your script edtior.
#
#==============================================================================

$imported ||= {}
$kms_imported ||= {} 

module Bubs
  module GGPatch
    # * Gauge File Names
    #  Images must be placed in the "Graphics/System" folder of your project
    GRADE_EXP_IMAGE = "GaugeHP"

    # * Gauge Position Offset [x, y]
    GRADE_EXP_OFFSET = [-25, -2]

    # * Gauge Length Adjustment
    GRADE_EXP_LENGTH = -40

    # * Gauge Slope
    #   Must be between -89 ~ 89 degrees
    GRADE_EXP_SLOPE = 30
  end
end

if $imported['CP_VICTORY'] && $kms_imported["GenericGauge"]
class Window_VictoryMain < Window_Selectable
  
  def draw_actor_exp_info(actor, x, y, width, aexp = 0)
    x += (width - 96) / 2
    width = [width, 96].min
    aexr = aexp * actor.exr
    cexp = actor.exp - actor.current_level_exp
    nexp = actor.next_level_exp - actor.current_level_exp
    if cexp - aexr >= 0
      rate = cexp.to_f / nexp
      rate = 1.0 if rate > 1.0
      gc1 = text_color(CP::VICTORY::EXP_ADDED)
      gc2 = text_color(CP::VICTORY::EXP_ADDED)
      draw_actor_exp_gauge(actor, x, y, width)
      cexp -= aexr
      rate = cexp.to_f / nexp
      rate = 1.0 if rate > 1.0
      rate = 1.0 if actor.level == actor.max_level
      gc1 = text_color(CP::VICTORY::EXP_GAUGE_1)
      gc2 = text_color(CP::VICTORY::EXP_GAUGE_2)
      draw_gauge_clear(x, y, width, rate, gc1, gc2)
    else
      rate = 1.0
      gc1 = text_color(CP::VICTORY::EXP_ADDED)
      gc2 = text_color(CP::VICTORY::EXP_ADDED)
      draw_actor_exp_gauge(actor, x, y, width)
      cexp = actor.exp - actor.last_level_exp - aexr
      nexp = actor.current_level_exp - actor.last_level_exp
      rate = cexp.to_f / nexp
      gc1 = text_color(CP::VICTORY::EXP_GAUGE_1)
      gc2 = text_color(CP::VICTORY::EXP_GAUGE_2)
      draw_gauge_clear(x, y, width, rate, gc1, gc2)
      change_color(normal_color)
      draw_text(x, y, width, line_height, CP::VICTORY::LEVEL_UP, 1)
      @leveled.push(actor)
    end
  end
  def draw_top_exp_gauge(file, x, y, width, ratio, offset, len_offset, slope,
                         gauge_type = :normal)
    img    = Cache.system(file)
    x     += offset[0]
    y     += offset[1]
    width += len_offset
    gw = (width * ratio).to_i
    draw_generic_gauge_bar(img, x, y, width, gw, slope, GAUGE_SRC_POS[gauge_type])
  end
  def draw_gauge_clear(x, y, width, rate, color1, color2)
    file = Bubs::GGPatch::GRADE_EXP_IMAGE
    offset = Bubs::GGPatch::GRADE_EXP_OFFSET
    len_offset = Bubs::GGPatch::GRADE_EXP_LENGTH
    slope = Bubs::GGPatch::GRADE_EXP_SLOPE
    draw_top_exp_gauge(file, x, y, width, rate, offset, len_offset, slope)
  end
  
end 
end # if $imported
