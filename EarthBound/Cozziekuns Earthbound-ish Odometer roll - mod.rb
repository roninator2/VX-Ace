#==============================================================================
# ** Earthbound-Ish Odometer Roll
#------------------------------------------------------------------------------
# Version: 1.2
# Author: cozziekuns 
# fix by roninator2
# Date: February 17, 2013
#==============================================================================
# Description:
#------------------------------------------------------------------------------
# This script attempts to emulate the battle system of the Earthbound/Mother 
# series; most notably Earthbound and Earthbound 2 (Mother 2 and 3). This 
# certain addon addresses the infamous HP/MP scrolling system that made battles
# that much more intense.
#==============================================================================
# Instructions:
#------------------------------------------------------------------------------
# Paste this script into its own slot in the Script Editor, above Main but 
# below Materials. Edit the modules to your liking.
#==============================================================================
# Graphics:
#------------------------------------------------------------------------------
# You must have two Odometer pictures in your Graphics/System folder. One of 
# them must be named "Odometer_HP", and the other one must be named 
# "Odometer_MP". Obviously, they represent the odometer for HP and MP values,
# respectively
#==============================================================================

#==============================================================================
# ** Cozziekuns
#==============================================================================

module Cozziekuns
  
  module Earthboundish
    
    Odometer_Roll_Speed = 4 # Smaller speeds are faster than larger speeds.
    Four_Digits = true
  end
  
end

include Cozziekuns

#==============================================================================
# ** Game_Actor
#==============================================================================

class Game_Actor
  
  attr_accessor :odometer_hp
  attr_accessor :odometer_mp
  attr_accessor :odometer_tp
  
  alias coz_ebisohd_gmactr_setup setup
  def setup(actor_id, *args)
    coz_ebisohd_gmactr_setup(actor_id, *args)
    @odometer_hp = 0
    @odometer_mp = 0
    @odometer_tp = 0
  end
  
  alias coz_ebishod_gmactr_execute_damage execute_damage
  def execute_damage(user, *args)
    if $game_party.in_battle
      on_damage(@result.hp_damage) if @result.hp_damage > 0
      @odometer_hp += @result.hp_damage
      @odometer_mp += @result.mp_damage
      user.hp += @result.hp_drain
      user.mp += @result.mp_drain
    else
      coz_ebishod_gmactr_execute_damage(user, *args)
    end
  end
  
  [:hp, :mp].each { |stat|
    alias_method("coz_ebishod_gmactr_item_effect_recover_#{stat}".to_sym, "item_effect_recover_#{stat}".to_sym)
    define_method("item_effect_recover_#{stat}".to_sym) { |user, item, effect|
      if $game_party.in_battle
        value = (send("m#{stat}".to_sym) * effect.value1 + effect.value2) * rec
        value *= user.pha if item.is_a?(RPG::Item)
        value = value.to_i
        @result.send("#{stat}_damage=".to_sym, @result.send("#{stat}_damage".to_sym) - value)
        @result.success = true
        send("odometer_#{stat}=".to_sym, send("odometer_#{stat}".to_sym) - value)
      else
        send("coz_ebishod_gmactr_item_effect_recover_#{stat}".to_sym, user, item, effect)        
      end
    }
  }

end

#==============================================================================
# ** Game_Enemy
#==============================================================================

class Game_Enemy
  
  def execute_damage(user)
    on_damage(@result.hp_damage) if @result.hp_damage > 0
    self.hp -= @result.hp_damage
    self.mp -= @result.mp_damage
    user.odometer_hp -= @result.hp_drain
    user.odometer_mp -= @result.mp_drain
  end
  
end

#==============================================================================
# ** Window_BattleStatus
#==============================================================================

class Window_BattleStatus
  
  def refresh_hpmp(actor, index)
    rect = item_rect(index)
    if gauge_area_rect(index) == item_rect(index) 
      rect.y += line_height * 2
      rect.height -= line_height * 2
      contents.clear_rect(rect)
    else
      contents.clear_rect(gauge_area_rect(index))
    end
    draw_gauge_area(gauge_area_rect(index), actor)
  end
  
  [:hp, :mp, :tp].each { |stat|
    define_method("draw_actor_#{stat}".to_sym) { |actor, x, y, width|
      change_color(system_color)
      draw_text(x, y, 30, line_height, Vocab.send("#{stat}_a"))
      od_x = x + contents.text_size(Vocab.send("#{stat}_a")).width + 4
      actor_hp = actor.send("#{stat}".to_sym).to_i
      actor_od_hp = actor.send("odometer_#{stat}".to_sym)
      draw_odometer(od_x, y, stat, actor_hp, actor_od_hp)
    }
  }
  
  if Cozziekuns::Earthboundish::Four_Digits
  def draw_odometer(x, y, type, value, od_value)
    bitmap = Cache.system("Odometer_#{type.upcase}")
    places = [1000, 100, 10, 1]
    od_ary = value.to_s.split("").collect { |str| str.to_i }
    (4 - od_ary.size).times { od_ary.unshift(0) }
    od_ary.each_index { |i|
      src_y = (9 - od_ary[i]) * 20
      if (od_ary.join.to_i) % places[i] == 0 and od_value != 0
        src_y += 20 / Earthboundish::Odometer_Roll_Speed * (Graphics.frame_count % Earthboundish::Odometer_Roll_Speed)
      end
      contents.blt(x + i * 24, y + 2, bitmap, Rect.new(0, src_y, 24, 20))
    }
  end
  else
  def draw_odometer(x, y, type, value, od_value)
    bitmap = Cache.system("Odometer_#{type.upcase}")
    places = [100, 10, 1]
    od_ary = value.to_s.split("").collect { |str| str.to_i }
    (3 - od_ary.size).times { od_ary.unshift(0) }
    od_ary.each_index { |i|
      src_y = (9 - od_ary[i]) * 20
      if (od_ary.join.to_i) % places[i] == 0 and od_value != 0
        src_y += 20 / Earthboundish::Odometer_Roll_Speed * (Graphics.frame_count % Earthboundish::Odometer_Roll_Speed)
      end
      contents.blt(x + i * 24, y + 2, bitmap, Rect.new(0, src_y, 24, 20))
    }
  end
  end
  
end

#==============================================================================
# ** Scene_Battle
#==============================================================================

class Scene_Battle
  
  alias coz_ebishod_scbtl_update_basic update_basic
  def update_basic(*args)
    coz_ebishod_scbtl_update_basic(*args)
    update_odometer
  end
  
  def update_odometer
    $game_party.members.each { |actor|
      if actor.odometer_hp != 0 or actor.odometer_mp != 0
        if actor.odometer_hp != 0 and Graphics.frame_count % Earthboundish::Odometer_Roll_Speed == 0
          damage = actor.odometer_hp > 0 ? 1 : - 1
          actor.hp -= damage
          actor.odometer_hp -= damage
        end
        if actor.odometer_mp != 0 and Graphics.frame_count % Earthboundish::Odometer_Roll_Speed == 0
          damage = actor.odometer_mp > 0 ? 1 : - 1
          actor.mp -= damage
          actor.odometer_mp -= damage
        end
        @status_window.refresh_hpmp(actor, actor.index)
        if actor.hp == 0 or (actor.hp == actor.mhp) and damage != nil
          damage = 0
          actor.odometer_hp = 0
        end
        if actor.mp == 0 or (actor.mp == actor.mmp) and damage != nil
          damage = 0
          actor.odometer_mp = 0
        end
        @status_window.refresh_hpmp(actor, actor.index)
      end
    }
  end
  
end
