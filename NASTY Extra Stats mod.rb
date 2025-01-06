#===============================================================================
#	N.A.S.T.Y. Extra Stats
#	Nelderson's Awesome Scripts To You
# By: Nelderson
# Made On: 12/19/2011
# Last Updated : 3/27/2012
#===============================================================================
# Update History:
# - Version 1.1 - Cleaned up some sheep, and added enemies xstats for Enemies!
# - Version 1.0 - Initial release, made for the sheep of it  :p 
#===============================================================================
# *Notes:
# - This script can be used to make all sorts of stats that can derive from
# an actor's level, and base stats.
#
# - This thing can be a pain to set up, but once it's done, it can be a very
# powerful way to include new stats into your game!
#
# - Made a quick edit to the status screen to show up to 6 stats!
#
# *Usage
#
# -First is the STATS section. This is an array that holds all the new
# stats that everything else gets info from.
#
# - Next fill out the Default Level formula(Use Example Below as a guide)
# *ANYTHING that an actor has, you can base it off of (Except other XSTATS!)
#	(level, hp, mp, atk, spi, agi, maxhp, etc.)
#
# -You can use the ACTOR and ENEMY NOTETAGS to customize
# the formulas for each actor.
#
# Examples:
# Place the following in an actor's notebox(You must make one for each stat):
#	<xstat>
#	:str => '(level/3.5) + 16',
#	:con => '(level/5.6) + 12',
#	:dex => '(level/5.25) + 15 + agi',
#	:int => '(level/10.5) + 10',
#	:wis => '(level/10.5) + 10',
#	:cha => '(level/10.5) + 10',
#	<xstat_end>
#
# Or you can place this in an actor's/enemy's notebox
#	<xstat>
#	:str => 15,
#	:con => 14,
#	:dex => 13,
#	:int => 12,
#	:wis => 11,
#	:cha => 0,
#	<xstat_end>
#
# - This script also uses notetags for weapons and armors to increase xstats
# if you want. Just place in a notebox:
#
#	<weapon_xstat: STAT x> , where STAT is th name of the new stat
#
#	Ex. <weapon_xstat: str 5> , would raise the actor's str +5
#
# *For Scripters
#
# -If you want to access the stats, just use:
#	actor.xstat.STAT - Where STAT is the name of the new stat
#	
#	Ex. $game_actors[1].xstat.str , will return actor 1's str
# 
#===============================================================================
# Credits:
# -Nelderson and Zetu
# Original Script was made by Zetu, and I spiced the sheep out of it!
# 
# Multiple rows addon by Roninator2 with guidance from Night_Runner
# 
# Added increasing stats
# Script Calls:
# change_xstat(actor_id, stat, value) # Alter the specified stat by the specifed 
# value. Can be either positive or negative.
#	e.g. change_xstat(1, :str, 10)
#===============================================================================

module Z26

  STATS = [:str,:con,:dex,:int,:wis,:cha,:spd,:div,:hth]

  #Default xstat formulas for ACTORS
  DEFAULT_LEVEL_FORMULA =
  {
  :str => '(level/3.5) + 16 + atk',
  :con => '(level/5.6) + 12',
  :dex => '(level/5.25) + 15 + agi',
  :int => '(level/10.5) + 10',
  :wis => '(level/10.5) + 10',
  :cha => '(level/10.5) + 10',
  :spd => '(level/10.5) + 10',
  :div => '(level/10.5) + 10',
  :hth => '(level/10.5) + 10',
  }

  #Default xstat formulas for ENEMIES	
  DEFAULT_FOR_ENEMIES =
  {
  :str => 0,
  :con => 0,
  :dex => 0,
  :int => 0,
  :wis => 0,
  :cha => 0,
  }

  def self.actor_level_formulas(actor_id)
    jhh = ""
    strin = $data_actors[actor_id].get_start_end_cache
    strin.each do |i|
    jhh += i
    end
    return DEFAULT_LEVEL_FORMULA if strin == "" or strin == []
    return eval("{#{jhh}}")
  end

  def self.enemy_stats(enemy_id)
    jhh = ""
    strin = $data_enemies[enemy_id].get_start_end_cache
    strin.each do |i|
    jhh += i
    end
    return DEFAULT_FOR_ENEMIES if strin == "" or strin == []
    return eval("{#{jhh}}")
  end

#=============================================================================
  SYMBOLS = []
  for stat in STATS
    SYMBOLS.push(stat)
  end
  Xstats = Struct.new(*SYMBOLS)
end

##############################################################

class Game_Enemy < Game_Battler
  attr_accessor :xstat

  alias z26_enemy_set initialize unless $@
  def initialize(*args)
    z26_enemy_set(*args)
    @xstat = Z26::Xstats.new(*([0]*Z26::STATS.size))
    for stat in Z26::STATS
    z26variate_stats(stat)
    end
  end

  def z26variate_stats(stat)
    return if Z26.enemy_stats(@enemy_id)[stat].nil?
    if Z26.enemy_stats(@enemy_id)[stat].is_a?(String)
      set_in = eval(Z26.enemy_stats(@enemy_id)[stat]).to_i
      eval("@xstat.#{stat} += #{set_in}")
    else
      set_in = Z26.enemy_stats(@enemy_id)[stat]
      @xstat[stat] += set_in
    end
    end
  end

##############################################################

class Game_Actor < Game_Battler
  attr_accessor :xstat

  alias z26_s setup unless $@
  def setup(actor_id)
    z26_s(actor_id)
    @xstat = Z26::Xstats.new(*([0]*Z26::STATS.size))
    for item in equips.compact
      z26variate_equip(item)
    end
    for stat in Z26::STATS
      z26variate_stats(stat, @level)
    end
  end

  alias z26_change_equip change_equip
  def change_equip(equip_type, item, test = false)
    last_item = equips[equip_type]
    z26_change_equip(equip_type, item)
    z26variate_equip(item)
    z26variate_equip(last_item, false)
  end

#=====================#
##EDITED BY NELDERSON##
#=====================#
  def z26variate_equip(item, adding = true)
    return if item.nil?
    for line in item.note.split(/[\r\n]+/).each{ |a|
    case a
    when /<weapon_xstat:[ ](.*)[ ](\d+)>/i
    if Z26::STATS.include?(eval(":" + $1))
      if adding
        eval("@xstat.#{$1} += #{$2}")
      else
        eval("@xstat.#{$1} -= #{$2}")
      end
    end
    end
    }
    end
  end

  def z26variate_stats(stat, level, adding = true)
    return if Z26.actor_level_formulas(@actor_id)[stat].nil?
    if Z26.actor_level_formulas(@actor_id)[stat].is_a?(String)
      amount = eval(Z26.actor_level_formulas(@actor_id)[stat]).to_i
    else
      amount = Z26.actor_level_formulas(@actor_id)[stat]
    end
    if adding
      eval("@xstat.#{stat} += #{amount}")
    else
      eval("@xstat.#{stat} -= #{amount}")
    end
  end

  alias z26level_up level_up unless $@
  def level_up
    for stat in Z26::STATS
      z26variate_stats(stat, @level, false)
    end
    z26level_up
    for stat in Z26::STATS
      z26variate_stats(stat, @level)
    end
  end
end

##############################################################

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Modify an Extra Stat
  #--------------------------------------------------------------------------
  def change_xstat(id, stat, value)
    $game_actors[id].xstat[stat] += value
  end
end

##############################################################

class Window_Status < Window_Selectable
  
  def draw_block3(y)
    draw_parameters(0, y)
    draw_equipments(self.contents.width-172, y)
    draw_xstat_parameters(stat_widths / 0.9, y)
  end

  def draw_xstat_parameters(x, y)
    dy = 0
    @actor.xstat.size.times {|i|
    draw_actor_xstat_param(@actor, x, y + line_height * i, i) #}
    dy += line_height
    if  dy > 120
       dy = 0
       y -= line_height * (i + 1)
      x += stat_widths / 0.9
    end
    }
  end
  #--------------------------------------------------------------------------
  # * Draw Parameters
  #--------------------------------------------------------------------------
  def draw_actor_param(actor, x, y, param_id)
    change_color(system_color)
    draw_text(x, y, stat_widths, line_height, Vocab::param(param_id))
    change_color(normal_color)
    draw_text(x + stat_widths-36, y, 36, line_height, actor.param(param_id), 2)
  end
  
end

##############################################################

class Window_Base < Window
  
  def draw_actor_xstat_param(actor, x, y, param_id)
    id = Z26::STATS[param_id]
    change_color(system_color)
    draw_text(x, y, 120, line_height, id.capitalize)
    change_color(normal_color)
    draw_text(x + stat_widths-36, y, 36, line_height, eval("actor.xstat.#{id}"), 2)   
  end
  
  def stat_widths
    wind_wid = self.contents.width
    xstat_cols = (Z26::STATS.length + 5) / 6
    return (((wind_wid - 172) / (xstat_cols + 1))*0.9).to_i
  end

end

##############################################################

class RPG::BaseItem
  def get_start_end_cache
    record = false
    temp = []
    self.note.split(/[\r\n]+/).each do |line|
    if line =~ /<xstat>/i
      record = true
    elsif line =~ /<xstat_end>/i
      record = false
    end
    if record
      temp << line
    end
    end
    return nil if temp == ""
    temp.delete_at(0)
    temp
  end
end
