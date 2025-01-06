# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Weapon Attack Replace Mod    ║  Version: 1.01     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║ Add on function to Yanfly's script  ║    18 Jan 2022     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Requires: Yanfly - Weapon Attack Replace                 ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions: Put below Yanfly's script                  ║
# ║                                                          ║
# ║ Adds options to select a random skill in either          ║
# ║ A range or from the list created in the note tags        ║
# ║                                                          ║
# ║ Also has the option to change the skill tp/mp cost       ║
# ║ But will not change it if the skill tp/mp cost is lower  ║
# ║ Does not have an affect on selecting skills              ║
# ║ If the actor does not have enough TP/MP to start with    ║
# ║ then the skill will not be selected.                     ║
# ║                                                          ║
# ║ Skill Range:                                             ║
# ║   <skill range: 5, 9>                                    ║
# ║    first skill, to last skill                            ║
# ║   a random one will be picked (5, 6, 7, 8, 9)            ║
# ║                                                          ║
# ║ Skill List:                                              ║
# ║   <skill list: 4, 8, 12, 22>                             ║
# ║   Randomly select one of the skills in the list          ║
# ║                                                          ║
# ║ Skill TP Cost:                                           ║
# ║   <skill tp: 5>                                          ║
# ║   will set the new skill used 5 tp cost                  ║
# ║   if the actor does not have enough tp or the skill tp   ║
# ║   cost is lower, this will not have any effect           ║
# ║                                                          ║
# ║ Skill MP Cost:                                           ║
# ║   <skill mp: 5>                                          ║
# ║   will set the new skill used 5 mp cost                  ║
# ║   if the actor does not have enough mp or the skill mp   ║
# ║   cost is lower, this will not have any effect           ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Updates:                                                 ║
# ║ 1.00 - 18 Jan 2022 - Initial publish                     ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Follow the Original Authors terms                        ║
# ╚══════════════════════════════════════════════════════════╝

module YEA
  module REGEXP
  module BASEITEM
    
    SKILL_RANGE = /<(?:SKILL_RANGE|skill range):[ ](\d+),[ ](\d+)>/i
    SKILL_LIST = /<(?:SKILL_LIST|skill list):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    SKILL_TP = /<(?:SKILL_TP|skill tp):[ ](\d+)>/i
    SKILL_MP = /<(?:SKILL_MP|skill mp):[ ](\d+)>/i
    
  end # BASEITEM
  module WEAPON
    
    SKILL_RANGE = /<(?:SKILL_RANGE|skill range):[ ](\d+),[ ](\d+)>/i
    SKILL_LIST = /<(?:SKILL_LIST|skill list):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    SKILL_TP = /<(?:SKILL_TP|skill tp):[ ](\d+)>/i
    SKILL_MP = /<(?:SKILL_MP|skill mp):[ ](\d+)>/i
    
  end # WEAPON
  end # REGEXP
end # YEA
class RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :skill_range_start
  attr_accessor :skill_range_end
  attr_accessor :skill_list_pick
  attr_accessor :skill_tp_r2
  attr_accessor :skill_mp_r2
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_war
  #--------------------------------------------------------------------------
  alias r2_load_war_92347fhb  load_notetags_war
  def load_notetags_war
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::SKILL_RANGE
        @skill_range_start = $1.to_i
        @skill_range_end = $2.to_i
      when YEA::REGEXP::BASEITEM::SKILL_LIST
        list = $1
        change = list.split(",")
        @skill_list_pick = change.map(&:to_i)
      when YEA::REGEXP::BASEITEM::SKILL_TP
        @skill_tp_r2 = $1.to_i
      when YEA::REGEXP::BASEITEM::SKILL_MP
        @skill_mp_r2 = $1.to_i
      #---
      end
    } # self.note.split
    #---
    r2_load_war_92347fhb
  end
  
end # RPG::BaseItem
class RPG::Weapon < RPG::EquipItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :skill_range_start
  attr_accessor :skill_range_end
  attr_accessor :skill_list_pick
  attr_accessor :skill_tp_r2
  attr_accessor :skill_mp_r2
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_war
  #--------------------------------------------------------------------------
  alias r2_load_notetags_war_9237u4bv   load_notetags_war
  def load_notetags_war
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::SKILL_RANGE
        @skill_range_start = $1.to_i
        @skill_range_end = $2.to_i
      when YEA::REGEXP::BASEITEM::SKILL_LIST
        list = $1
        change = list.split(",")
        @skill_list_pick = change.map(&:to_i)
      when YEA::REGEXP::BASEITEM::SKILL_TP
        @skill_tp_r2 = $1.to_i
      when YEA::REGEXP::BASEITEM::SKILL_MP
        @skill_mp_r2 = $1.to_i
      #---
      end
    } # self.note.split
    r2_load_notetags_war_9237u4bv
    #---
  end
  
end # RPG::Weapon
class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # new method: set_skill_tp_replace
  #--------------------------------------------------------------------------
  def set_skill_tp_replace
    tp = skill_tp_replace if actor?
    return tp
  end
  
  #--------------------------------------------------------------------------
  # new method: set_skill_mp_replace
  #--------------------------------------------------------------------------
  def set_skill_mp_replace
    mp = skill_mp_replace if actor?
    return mp
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: attack_skill_id
  #--------------------------------------------------------------------------
  def attack_skill_id
    skill = weapon_attack_skill_id if actor?
    range = weapon_range_attack_id if actor?
    sklist = weapon_list_skill_id if actor?
    attack = sklist.nil? ? (range.nil? ? (skill.nil? ? nil : skill) : range) : sklist
    if actor?
      skl = attack if !attack.nil? && (attack > 0)
      player = $game_actors[actor.id]
      skltp = $data_skills[attack]
      return skl if player.tp > skltp.tp_cost
    end
    return YEA::WEAPON_ATTACK_REPLACE::DEFAULT_ATTACK_SKILL_ID
  end
  
end # Game_BattlerBase
class Game_Actor < Game_Battler
  attr_accessor :skill_range_r2
  attr_accessor :skill_list_r2
 
  #--------------------------------------------------------------------------
  # new method: skill_tp_replace
  #--------------------------------------------------------------------------
  def skill_tp_replace
    for weapon in weapons
      next if weapon.nil?
      tp = weapon.skill_tp_r2
      return tp if !tp.nil?
      return nil
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: skill_mp_replace
  #--------------------------------------------------------------------------
  def skill_mp_replace
    for weapon in weapons
      next if weapon.nil?
      mp = weapon.skill_mp_r2
      return mp if !mp.nil?
      return nil
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: weapon_list_skill_id
  #--------------------------------------------------------------------------
  def weapon_list_skill_id
    @skill_list_r2 = false
    for weapon in weapons
      next if weapon.nil?
      sklist = weapon.skill_list_pick
      @skill_list_r2 = true if !sklist.nil?
      return nil if sklist.nil?
      num = sklist.size - 1
      pick = rand(num)
      skill = sklist[pick]
      return skill unless skill.nil?
      return nil
    end
  end

  #--------------------------------------------------------------------------
  # new method: weapon_range_attack_id
  #--------------------------------------------------------------------------
  def weapon_range_attack_id
    @skill_range_r2 = false
    for weapon in weapons
      next if weapon.nil?
      skstart = weapon.skill_range_start
      skend = weapon.skill_range_end
      skrange = skend.to_i - skstart.to_i
      sksel = rand(skrange) + skstart.to_i
      @skill_range_r2 = true if !sksel.nil?
      return sksel unless sksel.nil?
      return nil
    end
  end

end # Game_Actor

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # overwrite method: command_attack
  #--------------------------------------------------------------------------
  def command_attack
    @skill = $data_skills[BattleManager.actor.attack_skill_id]
    tp = BattleManager.actor.set_skill_tp_replace
    mp = BattleManager.actor.set_skill_mp_replace
    @skill.tp_cost = tp if !tp.nil? && (BattleManager.actor.tp > tp) && 
    (@skill.tp_cost > tp) && (BattleManager.actor.skill_range_r2 == true || 
    BattleManager.actor.skill_list_r2 == true)
    @skill.mp_cost = mp if !mp.nil? && (BattleManager.actor.mp > mp) && 
    (@skill.mp_cost > mp) && (BattleManager.actor.skill_range_r2 == true || 
    BattleManager.actor.skill_list_r2 == true)
    BattleManager.actor.input.set_skill(@skill.id)
    if $imported["YEA-BattleEngine"]
      status_redraw_target(BattleManager.actor)
      $game_temp.battle_aid = @skill
      if @skill.for_opponent?
        select_enemy_selection
      elsif @skill.for_friend?
        select_actor_selection
      else
        next_command
        $game_temp.battle_aid = nil
      end
    else
      if !@skill.need_selection?
        next_command
      elsif @skill.for_opponent?
        select_enemy_selection
      else
        select_actor_selection
      end
    end
  end
end

