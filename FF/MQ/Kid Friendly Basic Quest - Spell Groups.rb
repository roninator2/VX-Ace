# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Spell Groups & Uses     ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style spell use              ║    09 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  Set the note tag on spells to indicate what group       ║
# ║  the spell belongs in  <spell group: white>              ║
# ║      Other options include black and wizard              ║
# ║  Set the note tag on the actors to indicate the rate     ║
# ║  at which the player will gain new spell uses            ║
# ║      <spell growth: white, 5, 1, 2>                      ║
# ║  Numbers - 5 starting points, 1 gained every 2 levels    ║
# ║  So <spell growth: black, 2, 1, 3>                       ║
# ║     is start with 2 and gain 1 every 3 levels            ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝
#==============================================================================
# * Module R2 Spell
#==============================================================================

module R2_Spell_Group
  # Skill notetag
  # <spell group: white>
  SpellGroup = /<spell[ -_]group:[ -_](\w*)>/i
  
  # Actor notetag
  # <spell growth: spell group, starting number, gain amount, every # levels)
  # <spell growth:    white,           3,            1,            3)
  # <spell growth: white, 3, 1, 1)
  # <spell growth: black, 1, 1, 2)
  # <spell growth: wizard, 0, 1, 4)
  
  # non gaining characters can simply be set to 0 for the gain amount
  # <spell growth: white, 5, 0, 0)
  SpellGrowth = /<spell[ -_]growth:[ ](\w*),[ -_](\d+),[ -_](\d+),[ -_](\d+)>/i
end

#==============================================================================
# * DataManager
#==============================================================================
module DataManager
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_spellgroup load_database; end
  def self.load_database
    load_database_spellgroup
    initialize_spellgroup
  end
  #--------------------------------------------------------------------------
  # new method: initialize_spellgroup
  #--------------------------------------------------------------------------
  def self.initialize_spellgroup
    groups = [$data_actors, $data_skills]
    for group in groups
      for obj in group
        next if obj.nil?
          obj.initialize_spellgroup
      end
    end
  end
end

#==============================================================================
# * RPG::BaseItem
#==============================================================================
class RPG::BaseItem
  attr_reader :spellgroup
  attr_reader :actorspells
  attr_accessor :actorwhitecount
  attr_accessor :actorblackcount
  attr_accessor :actorwizardcount
  #--------------------------------------------------------------------------
  # new method: initialize_spellgroup
  #--------------------------------------------------------------------------
  def initialize_spellgroup
    @spellgroup = :none
    @actorspells = {}
    @actorwhitecount = 0
    @actorblackcount = 0
    @actorwizardcount = 0
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when R2_Spell_Group::SpellGroup
        @spellgroup = $1.to_sym
      when R2_Spell_Group::SpellGrowth
        @actorspells[$1.to_sym] = [$2.to_i, $3.to_i, $4.to_i]
        case $1.to_sym.downcase
        when :white
          @actorwhitecount = $2.to_i
        when :black
          @actorblackcount = $2.to_i
        when :wizard
          @actorwizardcount = $2.to_i
        end
      end
    }
  end
  #--------------------------------------------------------------------------
  # new method: is_spellgroup?
  #--------------------------------------------------------------------------
  def is_spellgroup?
    @spellgroup != :none
  end
end

#==============================================================================
# * Game_BattlerBase
#==============================================================================
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Determine if Cost of Using Skill Can Be Paid
  #--------------------------------------------------------------------------
  def skill_cost_payable?(skill)
    if self.is_a?(Game_Enemy)
      return true
    elsif skill.id == 0 || 1
      return true
    else
      spellgrp = skill.spellgroup
      case spellgrp
      when :white
        return true if self.whitespells > 0
      when :black
        return true if self.blackspells > 0
      when :wizard
        return true if self.wizardspells > 0
      else
        return false
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Pay Cost of Using Skill
  #--------------------------------------------------------------------------
  def pay_skill_cost(skill)
    if self.is_a?(Game_Enemy)
      return
    else
      spellgrp = skill.spellgroup
      self.pay_spells(spellgrp)
    end
  end
end

#==============================================================================
# * Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Determine if Cost of Using Skill Can Be Paid
  #--------------------------------------------------------------------------
  def skill_cost_payable?(skill)
    if self.is_a?(Game_Actor)
      case skill.stype_id
      when 1
        return true if self.whitespells > 0
        return false
      when 2
        return true if self.blackspells > 0
        return false
      when 3
        return true if self.wizardspells > 0
        return false
      else
        return true
      end
    else
      tp >= skill_tp_cost(skill) && mp >= skill_mp_cost(skill)
    end
  end
  #--------------------------------------------------------------------------
  # * Pay Cost of Using Skill
  #--------------------------------------------------------------------------
  def pay_skill_cost(skill)
    if self.is_a?(Game_Actor)
      case skill.stype_id
      when 1
        self.pay_spells(:white)
      when 2
        self.pay_spells(:black)
      when 3
        self.pay_spells(:wizard)
      else
        self.mp -= skill_mp_cost(skill)
        self.tp -= skill_tp_cost(skill)
      end
    else
      self.mp -= skill_mp_cost(skill)
      self.tp -= skill_tp_cost(skill)
    end
  end
end

#==============================================================================
# ** Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :actorspells
  attr_reader :whitespells
  attr_reader :blackspells
  attr_reader :wizardspells
  #--------------------------------------------------------------------------
  # * Alias Actor Initialize
  #--------------------------------------------------------------------------
  alias r2_actor_setup  setup
  def setup(i)
    r2_actor_setup(i)
    add_spells
  end
  #--------------------------------------------------------------------------
  # * Add Actor Spell Counts
  #--------------------------------------------------------------------------
  def add_spells
    @actorspells = actor.actorspells
    @whitespells = actor.actorwhitecount
    @blackspells = actor.actorblackcount
    @wizardspells = actor.actorwizardcount
  end
  #--------------------------------------------------------------------------
  # * Add Actor Spell Counts
  #--------------------------------------------------------------------------
  def pay_spells(type)
    case type
    when :white
      @whitespells -= 1
    when :black
      @blackspells -= 1
    when :wizard
      @wizardspells -= 0
    end
  end
  #--------------------------------------------------------------------------
  # * Recover All
  #--------------------------------------------------------------------------
  alias r2_actor_spells_recover recover_all
  def recover_all
    r2_actor_spells_recover
    refresh_spells
  end
  #--------------------------------------------------------------------------
  # * Add Actor Spell Counts
  #--------------------------------------------------------------------------
  def refresh_spells
    @whitespells = actor.actorwhitecount
    @blackspells = actor.actorblackcount
    @wizardspells = actor.actorwizardcount
  end
  #--------------------------------------------------------------------------
  # * Level Up
  #--------------------------------------------------------------------------
  alias r2_spell_level_up level_up
  def level_up
    r2_spell_level_up
    spells_up
  end
  #--------------------------------------------------------------------------
  # * Increase Spell Count
  #--------------------------------------------------------------------------
  def spells_up
    white = @actorspells[:white]
    black = @actorspells[:black]
    wizard = @actorspells[:wizard]
    @actorspells.each do |group|
      sym = group[0]
      base = group[1][0]
      incr = group[1][1]
      levl = group[1][2]
      gain = ((@level - 1) / levl).to_i
      spell_up = (gain * incr) + base
      spell_up - 1 if levl == 1
      case sym
      when :white
        actor.actorwhitecount = spell_up
      when :black
        actor.actorblackcount = spell_up
      when :wizard
        actor.actorwizardcount = spell_up
      end
    end
  end
end
