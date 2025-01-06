#==============================================================================
# Compatibility Patch :                                         v1.0 (09/10/23)
#   Survival System by Apellonyx + KMS Generic Gauge
#==============================================================================
# Script by:
#     Roninator2
#--------------------------------------------------------------------------
# Place this script below both Survival System by Apellonyx 
# and KMS Generic Gauge in your script edtior.
#
# Due to the nature of both scripts, several methods 
# in Survival System by Apellonyx were overwritten.
#
# All Generic Gauge images must be placed in the "Graphics/System" 
# folder of your project.
#--------------------------------------------------------------------------
#   ++ Changelog ++
#--------------------------------------------------------------------------
# v1.0 : Initial release. (09/10/2023)
#==============================================================================

module KMS_GenericGauge
  # * Gauge File Names
  #   Images must be placed in the "Graphics/System" folder of your project
  LIFE_IMAGE  = "GaugeLIFE"   # Life
  FOOD_IMAGE  = "GaugeFOOD"   # Food
  WATER_IMAGE = "GaugeWATER"  # WATER
  REST_IMAGE  = "GaugeREST"   # REST
  TOXIN_IMAGE = "GaugeTOXIN"  # TOXIN

  # * Gauge Position Offset [x, y]
  LIFE_OFFSET  = [-23, -2]  # LIFE
  FOOD_OFFSET  = [-23, -2]  # FOOD
  WATER_OFFSET = [-23, -2]  # WATER
  REST_OFFSET  = [-23, -2]  # REST
  TOXIN_OFFSET = [-23, -2]  # TOXIN

  # * Gauge Length Adjustment
  LIFE_LENGTH  = -4  # LIFE
  FOOD_LENGTH  = -4  # FOOD
  WATER_LENGTH = -4  # WATER
  REST_LENGTH  = -4  # REST
  TOXIN_LENGTH = -4  # TOXIN

  # * Gauge Slope
  #   Must be between -89 ~ 89 degrees
  LIFE_SLOPE  = 30  # LIFE
  FOOD_SLOPE  = 30  # FOOD
  WATER_SLOPE = 30  # WATER
  REST_SLOPE  = 30  # REST
  TOXIN_SLOPE = 30  # TOXIN
end

class Window_Survival < Window_Base
  def draw_life(actor, x, y, width = Anyx::WINWIDTH - 22)
    life_25 = Anyx::LIFEMAX / 4
    life_26 = life_25 + 0.001
    life_50 = life_25 * 2
    life_51 = life_50 + 0.001
    life_75 = life_25 * 3
    life_76 = life_75 + 0.001
    life_99 = Anyx::LIFEMAX - 0.001
    life_color = dep_color if 1 > $survival_v[1]
    life_color = dan_color if (1..life_25) === $survival_v[1]
    life_color = low_color if (life_26..life_50) === $survival_v[1]
    life_color = ave_color if (life_51..life_75) === $survival_v[1]
    life_color = sat_color if (life_76..life_99) === $survival_v[1]
    life_color = exc_color if Anyx::LIFEMAX <= $survival_v[1]
    life_rate = $survival_v[1] / Anyx::LIFEMAX.to_f
    draw_generic_gauge(KMS_GenericGauge::LIFE_IMAGE,
            x, y, width, life_rate, 
            KMS_GenericGauge::LIFE_OFFSET,
            KMS_GenericGauge::LIFE_LENGTH,
            KMS_GenericGauge::LIFE_SLOPE
    )
    change_color(system_color)
    draw_text(x, y, 100, line_height, Anyx::LIFEVOCAB)
    draw_current_and_max_values(x, y, width, $survival_v[1].round.to_i, Anyx::LIFEMAX, life_color, life_color)
  end # def draw_life(actor, x, y, width = Anyx::WINWIDTH - 22)
  def draw_food(actor, x, y, width = Anyx::WINWIDTH - 22)
    food_25 = Anyx::FOODMAX / 4
    food_26 = food_25 + 0.001
    food_50 = food_25 * 2
    food_51 = food_50 + 0.001
    food_75 = food_25 * 3
    food_76 = food_75 + 0.001
    food_99 = Anyx::FOODMAX - 0.001
    food_color = dep_color if 1 > $survival_v[2]
    food_color = dan_color if (1..food_25) === $survival_v[2]
    food_color = low_color if (food_26..food_50) === $survival_v[2]
    food_color = ave_color if (food_51..food_75) === $survival_v[2]
    food_color = sat_color if (food_76..food_99) === $survival_v[2]
    food_color = exc_color if Anyx::FOODMAX <= $survival_v[2]
    food_rate = $survival_v[2] / Anyx::FOODMAX.to_f
    draw_generic_gauge(KMS_GenericGauge::FOOD_IMAGE,
            x, y, width, food_rate, 
            KMS_GenericGauge::FOOD_OFFSET,
            KMS_GenericGauge::FOOD_LENGTH,
            KMS_GenericGauge::FOOD_SLOPE
    )
    change_color(system_color)
    draw_text(x, y, 100, line_height, Anyx::FOODVOCAB)
    draw_current_and_max_values(x, y, width, $survival_v[2].round.to_i, Anyx::FOODMAX, food_color, food_color)
  end # def draw_food(actor, x, y, width = Anyx::WINWIDTH - 22)
  def draw_water(actor, x, y, width = Anyx::WINWIDTH - 22)
    water_25 = Anyx::WATERMAX / 4
    water_26 = water_25 + 0.001
    water_50 = water_25 * 2
    water_51 = water_50 + 0.001
    water_75 = water_25 * 3
    water_76 = water_75 + 0.001
    water_99 = Anyx::WATERMAX - 0.001
    water_color = dep_color if 1 > $survival_v[3]
    water_color = dan_color if (1..water_25) === $survival_v[3]
    water_color = low_color if (water_26..water_50) === $survival_v[3]
    water_color = ave_color if (water_51..water_75) === $survival_v[3]
    water_color = sat_color if (water_76..water_99) === $survival_v[3]
    water_color = exc_color if Anyx::WATERMAX <= $survival_v[3]
    water_rate = $survival_v[3] / Anyx::WATERMAX.to_f
    draw_generic_gauge(KMS_GenericGauge::WATER_IMAGE,
            x, y, width, water_rate, 
            KMS_GenericGauge::WATER_OFFSET,
            KMS_GenericGauge::WATER_LENGTH,
            KMS_GenericGauge::WATER_SLOPE
    )
    change_color(system_color)
    draw_text(x, y, 100, line_height, Anyx::WATERVOCAB)
    draw_current_and_max_values(x, y, width, $survival_v[3].round.to_i, Anyx::WATERMAX, water_color, water_color)
  end # def draw_water(actor, x, y, width = Anyx::WINWIDTH - 22)
  def draw_rest(actor, x, y, width = Anyx::WINWIDTH - 22)
    rest_25 = Anyx::WATERMAX / 4
    rest_26 = rest_25 + 0.001
    rest_50 = rest_25 * 2
    rest_51 = rest_50 + 0.001
    rest_75 = rest_25 * 3
    rest_76 = rest_75 + 0.001
    rest_99 = Anyx::RESTMAX - 0.001
    rest_color = dep_color if 1 > $survival_v[4]
    rest_color = dan_color if (1..rest_25) === $survival_v[4]
    rest_color = low_color if (rest_26..rest_50) === $survival_v[4]
    rest_color = ave_color if (rest_51..rest_75) === $survival_v[4]
    rest_color = sat_color if (rest_76..rest_99) === $survival_v[4]
    rest_color = exc_color if Anyx::RESTMAX <= $survival_v[4]
    rest_rate = $survival_v[4] / Anyx::RESTMAX.to_f
    draw_generic_gauge(KMS_GenericGauge::REST_IMAGE,
            x, y, width, rest_rate, 
            KMS_GenericGauge::REST_OFFSET,
            KMS_GenericGauge::REST_LENGTH,
            KMS_GenericGauge::REST_SLOPE
    )
    change_color(system_color)
    draw_text(x, y, 100, line_height, Anyx::RESTVOCAB)
    draw_current_and_max_values(x, y, width, $survival_v[4].round.to_i, Anyx::RESTMAX, rest_color, rest_color)
  end # def draw_rest(actor, x, y, width = Anyx::WINWIDTH - 22)
  def draw_toxin(actor, x, y, width = Anyx::WINWIDTH - 22)
    toxin_25 = Anyx::TOXINMAX / 4
    toxin_26 = toxin_25 + 0.001
    toxin_50 = toxin_25 * 2
    toxin_51 = toxin_50 + 0.001
    toxin_75 = toxin_25 * 3
    toxin_76 = toxin_75 + 0.001
    toxin_99 = Anyx::TOXINMAX - 0.001
    toxin_color = exc_color if 1 > $survival_v[5]
    toxin_color = sat_color if (1..toxin_25) === $survival_v[5]
    toxin_color = ave_color if (toxin_26..toxin_50) === $survival_v[5]
    toxin_color = low_color if (toxin_51..toxin_75) === $survival_v[5]
    toxin_color = dan_color if (toxin_76..toxin_99) === $survival_v[5]
    toxin_color = dep_color if Anyx::TOXINMAX <= $survival_v[5]
    toxin_rate = $survival_v[5] / Anyx::TOXINMAX.to_f
    draw_generic_gauge(KMS_GenericGauge::TOXIN_IMAGE,
            x, y, width, toxin_rate, 
            KMS_GenericGauge::TOXIN_OFFSET,
            KMS_GenericGauge::TOXIN_LENGTH,
            KMS_GenericGauge::TOXIN_SLOPE
    )
    change_color(system_color)
    draw_text(x, y, 100, line_height, Anyx::TOXINVOCAB)
    draw_current_and_max_values(x, y, width, $survival_v[5].round.to_i, Anyx::TOXINMAX, toxin_color, toxin_color)
  end # def draw_toxin(actor, x, y, width = Anyx::WINWIDTH - 22)
end # class
