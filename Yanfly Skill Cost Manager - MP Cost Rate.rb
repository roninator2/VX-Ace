#==============================================================================
# 
# ▼ Yanfly Engine Ace - Skill Cost Manager v1.03.1     add on
# -- Last Updated: 2019.06.06
# -- Level: Normal, Hard, Lunatic
# -- Requires: n/a
# -- add on by Roninator2
#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2019.06.06 - added on mp cost rate
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# -----------------------------------------------------------------------------
# Actor Notetags - These notetags go in the actors notebox in the database.
# -----------------------------------------------------------------------------
# <mp cost rate: x%>
# Allows the actor to drop the MP cost of skills to x%.
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <mp cost rate: x%>
# Allows the class to drop the MP cost of skills to x%.
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <mp cost rate: x%>
# Allows the weapon to drop the MP cost of skills to x% when worn.
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armours notebox in the database.
# -----------------------------------------------------------------------------
# <mp cost rate: x%>
# Allows the armour to drop the MP cost of skills to x% when worn.
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the states notebox in the database.
# -----------------------------------------------------------------------------
# <mp cost rate: x%>
# Allows the state to drop the MP cost of skills to x% when afflicted.

module YEA
  module REGEXP
  module BASEITEM
    MP_COST_RATE = /<(?:MP_COST_RATE|mp cost rate):[ ](\d+)([%％])>/i
  end
  end
end

class RPG::BaseItem
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :mp_cost_rate
  #--------------------------------------------------------------------------
  # common cache: load_notetags_scm
  #--------------------------------------------------------------------------
  alias r2_load_notetags_scm_8237fg   load_notetags_scm
  def load_notetags_scm
    r2_load_notetags_scm_8237fg
    @mp_cost_rate = 1.0
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::MP_COST_RATE
        @mp_cost_rate = $1.to_i * 0.01
      end
    }
  end
end

class Game_BattlerBase
  def mcr#;  sparam(4);  end               # MCR  Mp Cost Rate
    n = 1.0
    if actor?
      n *= self.actor.mp_cost_rate
      n *= self.class.mp_cost_rate
      for equip in equips
        next if equip.nil?
        n *= equip.mp_cost_rate
      end
    else
      n *= self.enemy.mp_cost_rate
      if $imported["YEA-Doppelganger"] && !self.class.nil?
        n *= self.class.mp_cost_rate
      end
    end
    for state in states
      next if state.nil?
      n *= state.mp_cost_rate
    end
    return n
  end
end
