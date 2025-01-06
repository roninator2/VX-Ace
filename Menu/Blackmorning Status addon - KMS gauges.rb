#==============================================================================
# Compatibility Patch :                                        v1.01 (05/10/20)
#   BlackMorning Status Addon + KMS Generic Gauge
#==============================================================================
# Script by:
#     Mr. Bubble - recreated by Roninator2
#--------------------------------------------------------------------------
# Place this script below both BlackMorning Status Addon and KMS Generic Gauge
# in your script edtior.
#
#==============================================================================
# Updtae: 2020/10/08 Added option to use different images for stats
#==============================================================================

$imported = {} if $imported.nil?
$kms_imported = {} if $kms_imported.nil?

module Bubs
  module BMPatch
    # * Gauge File Names
    #  Images must be placed in the "Graphics/System" folder of your project
    BMSTATUS_STAT_IMAGE = "GaugeBlue"
    BMSTATUS_EXP_IMAGE = "GaugeEXP"
    # Use a different image for each stat?
    STAT_COLOR = true
    BMSTATUS_ATK_IMAGE = "GaugeBGM"
    BMSTATUS_MAT_IMAGE = "GaugeBGS"
    BMSTATUS_AGI_IMAGE = "GaugeGreen"
    BMSTATUS_DEF_IMAGE = "GaugeMP"
    BMSTATUS_MDF_IMAGE = "GaugeHP"
    BMSTATUS_LUK_IMAGE = "GaugeEXP"
    
    # * Gauge Position Offset [x, y]
    BMSTATUS_STAT_OFFSET = [-23, -2]

    # * Gauge Length Adjustment
    BMSTATUS_STAT_LENGTH = -4

    # * Gauge Length Adjustment
    BMSTATUS_EXP_LENGTH = -30
    # adjust the exp x gauge position
    BMSTATUS_EXP_XPOS = 5

    # * Gauge Slope
    #   Must be between -89 ~ 89 degrees
    BMSTATUS_STAT_SLOPE = 30
  end
end

#==============================================================================
# ■ Window_MainMenuStatus
#==============================================================================

if $imported[:bm_status] && $kms_imported["GenericGauge"]
class Window_StatusItem < Window_Base

  def draw_general_parameters(dx)
    actor = @actor
    dy = line_height * 3 / 2
    dw = (contents.width - dx) / 3 - 6    
    xpos = Bubs::BMPatch::BMSTATUS_EXP_XPOS
    draw_actor_level(dx + dw * 0, line_height * 0 + dy, dw)
    draw_actor_exp(dx + dw * 1 + 6, line_height * 0 + dy, (dw + 3)*2)
    draw_actor_exp_gauge(actor, dx + dw + xpos, line_height * 0.7 + dy, (dw+15)*2) if BM::STATUS::GAUGE[:exp]
    draw_actor_param(0, dx + dw * 0, line_height * 2 + dy, dw)
    draw_actor_hp_gauge(actor, dx + dw * 0, line_height * 2.7 + dy, dw) if BM::STATUS::GAUGE[:hp]
    draw_actor_param(1, dx + dw * 1 + 6, line_height * 2 + dy, dw)
    draw_actor_mp_gauge(actor, dx + dw * 1 + 6, line_height * 2.7 + dy, dw) if BM::STATUS::GAUGE[:mp]
    draw_actor_tp(@actor, dx + dw * 2 + 12, line_height * 2 + dy, dw)
    draw_actor_tp_gauge(actor, dx + dw * 2 + 12, line_height * 2.7 + dy, dw) if BM::STATUS::GAUGE[:tp]
    
    draw_actor_param(2, dx + dw * 0, line_height * 4 + dy, dw)
    draw_actor_param(4, dx + dw * 1 + 6, line_height * 4 + dy, dw)
    draw_actor_param(6, dx + dw * 2 + 12, line_height * 4 + dy, dw)
    dy += 6
    draw_actor_param(3, dx + dw * 0, line_height * 5 + dy, dw)
    draw_actor_param(5, dx + dw * 1 + 6, line_height * 5 + dy, dw)
    draw_actor_param(7, dx + dw * 2 + 12, line_height * 5 + dy, dw)
    if BM::STATUS::GAUGE[:param]
      if Bubs::BMPatch::STAT_COLOR == false
        file = Bubs::BMPatch::BMSTATUS_STAT_IMAGE
        offset = Bubs::BMPatch::BMSTATUS_STAT_OFFSET
        len_offset = Bubs::BMPatch::BMSTATUS_STAT_LENGTH
        slope = Bubs::BMPatch::BMSTATUS_STAT_SLOPE
        draw_generic_gauge(file, dx + dw * 0, line_height * 4.1 + dy, dw, param_ratio(@actor,2), offset, len_offset, slope)
        draw_generic_gauge(file, dx + dw * 1+6, line_height * 4.1 + dy, dw, param_ratio(@actor,4), offset, len_offset, slope)
        draw_generic_gauge(file, dx + dw * 2+12, line_height * 4.1 + dy, dw, param_ratio(@actor,6), offset, len_offset, slope)
        dy += 6
        draw_generic_gauge(file, dx + dw * 0, line_height * 5.1 + dy, dw, param_ratio(@actor,3), offset, len_offset, slope)
        draw_generic_gauge(file, dx + dw * 1+6, line_height * 5.1 + dy, dw, param_ratio(@actor,5), offset, len_offset, slope)
        draw_generic_gauge(file, dx + dw * 2+12, line_height * 5.1 + dy, dw, param_ratio(@actor,7), offset, len_offset, slope)
      else
        offset = Bubs::BMPatch::BMSTATUS_STAT_OFFSET
        len_offset = Bubs::BMPatch::BMSTATUS_STAT_LENGTH
        slope = Bubs::BMPatch::BMSTATUS_STAT_SLOPE
        draw_generic_gauge(Bubs::BMPatch::BMSTATUS_ATK_IMAGE, dx + dw * 0, line_height * 4.1 + dy, dw, param_ratio(@actor,2), offset, len_offset, slope)
        draw_generic_gauge(Bubs::BMPatch::BMSTATUS_MAT_IMAGE, dx + dw * 1+6, line_height * 4.1 + dy, dw, param_ratio(@actor,4), offset, len_offset, slope)
        draw_generic_gauge(Bubs::BMPatch::BMSTATUS_AGI_IMAGE, dx + dw * 2+12, line_height * 4.1 + dy, dw, param_ratio(@actor,6), offset, len_offset, slope)
        dy += 6
        draw_generic_gauge(Bubs::BMPatch::BMSTATUS_DEF_IMAGE, dx + dw * 0, line_height * 5.1 + dy, dw, param_ratio(@actor,3), offset, len_offset, slope)
        draw_generic_gauge(Bubs::BMPatch::BMSTATUS_MDF_IMAGE, dx + dw * 1+6, line_height * 5.1 + dy, dw, param_ratio(@actor,5), offset, len_offset, slope)
        draw_generic_gauge(Bubs::BMPatch::BMSTATUS_LUK_IMAGE, dx + dw * 2+12, line_height * 5.1 + dy, dw, param_ratio(@actor,7), offset, len_offset, slope)
      end
    end
  end 
  def draw_actor_exp_gauge(actor, x, y, width = 160)
    draw_generic_gauge(Bubs::BMPatch::BMSTATUS_EXP_IMAGE,
      x, y, width, actor.exp_rate,
      Bubs::BMPatch::BMSTATUS_STAT_OFFSET,
      Bubs::BMPatch::BMSTATUS_EXP_LENGTH,
      Bubs::BMPatch::BMSTATUS_STAT_SLOPE
    )
  end
end
end # if $imported["Galv_Menu_Themes"]
