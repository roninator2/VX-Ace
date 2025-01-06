# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Ventwig Enemy HP Selection             ║  Version: 1.07     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Show hp only for enemy selected             ║    03 Jan 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Ventwig Enemy HP Bars Script                             ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Script adjusts Ventwigs script to make the Bars shown to     ║
# ║       only be visible on the enemy when that enemy is selected     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Configure setting below                                          ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 03 Jan 2021 - Script Finished                               ║
# ║ 1.01 - 03 Jan 2021 - Fixed glitch in battle processing             ║
# ║ 1.02 - 03 Jan 2021 - show hp when enemy is attacked                ║
# ║ 1.03 - 03 Jan 2021 - Fixed HP showing when enemy attacked          ║
# ║ 1.04 - 05 Jan 2021 - Corrected for hidden enemies & bug            ║
# ║ 1.05 - 06 Jan 2021 - Added show hp for all enemies skills          ║
# ║ 1.06 - 08 Jan 2022 - New - Show hp when skill allows               ║
# ║ 1.07 - 08 Jan 2022 - Combine last with 1.05                        ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Ventwig                                                          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Terms of use:                                                      ║
# ║  Follow the original Authors terms of use where applicable         ║
# ║    - When not made by me (Roninator2)                              ║
# ║  Free for all uses in RPG Maker except nudity                      ║
# ║  Anyone using this script in their project before these terms      ║
# ║  were changed are allowed to use this script even if it conflicts  ║
# ║  with these new terms. New terms effective 03 Apr 2024             ║
# ║  No part of this code can be used with AI programs or tools        ║
# ║  Credit must be given                                              ║
# ╚════════════════════════════════════════════════════════════════════╝

module R2_Enemy_Hud_Hold_Time
  Hold_Time = 120        # time bar will show when enemy is hit
  Skill = [80,105]    # skills that will show the HP bar
    Switch = 88    # switch that will enable showing for skills
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Window_Enemy_Hud < Window_Base
  attr_accessor :damage_time
  alias r2_init_enemy_hp initialize
  def initialize
    r2_init_enemy_hp
    show_hp(false)
    show_hp_all(false)
  end
  
  def show_hp(value = false)
    @show_hp = value
  end
  
  def show_hp_all(value = false)
    @show_hp_all = value
  end

  def enemy_id(value = -1)
    @enemy_id = value
  end
  
  def hold_hp
    @show_hp = false if @damage_time == 0
    for i in 0..@etroop.alive_members.size-1
      e = @enemy[i]
      next if e.nil? # for hidden enemies
      if $game_switches[EHUD::HIDE_MINIONS] != true && @show_hp == true && @damage_time != 0 && e.index == @enemy_id
        draw_actor_hp(e,e.screen_x-50,e.screen_y+EHUD::Y_MOVE-50+e.personal_y,width=96) unless @damage_time == 0
      end
    end
  end
  
  def damage_time(value = 0)
    @damage_time = value
  end

  def update
    if @damage_time != nil
      @damage_time -= 1 if @damage_time != 0
    end
    hold_hp
    refresh_okay = false
    $game_troop.alive_members.each do |enemy|
      if enemy.hp != enemy.old_hp || enemy.mp != enemy.old_mp
        refresh_okay = true
        enemy.old_hp = enemy.hp
        enemy.old_mp = enemy.mp
      end
    end
   
    if $game_troop.alive_members.size != @old_size
      refresh_okay = true
    end
   
    if refresh_okay
      refresh
    end
  end

  def enemy_hud
    troop_fix
    for i in 0..@etroop.alive_members.size-1
      e = @enemy[i]
      if i <= 1 and e.boss_bar == true and e == @boss_enemy[i]
        draw_actor_name(e,EHUD::BOSS_GAUGEX,5+50*i)
        draw_actor_hp(e,EHUD::BOSS_GAUGEX,20+50*i,width=EHUD::BOSS_GAUGEW) unless e.hide_hp == true
        draw_actor_mp(e,EHUD::BOSS_GAUGEX,30+50*i,width=EHUD::BOSS_GAUGEW) unless e.show_mp == false
        draw_actor_icons(e,EHUD::BOSS_GAUGEX+200,5+50*i, width = 96)
      elsif ($game_switches[EHUD::HIDE_MINIONS] != true && @show_hp_all == true)
        draw_actor_hp(e,e.screen_x-50,e.screen_y+EHUD::Y_MOVE-50+e.personal_y,width=96) unless e.hide_hp == true
        draw_actor_mp(e,e.screen_x-50,e.screen_y+EHUD::Y_MOVE-40+e.personal_y,width=96) unless e.show_mp == false
        draw_actor_icons(e,e.screen_x-50,e.screen_y+EHUD::Y_MOVE-70+e.personal_y,width=96)
      elsif ($game_switches[EHUD::HIDE_MINIONS] != true && @show_hp == true) && e.index == @enemy_id
        draw_actor_hp(e,e.screen_x-50,e.screen_y+EHUD::Y_MOVE-50+e.personal_y,width=96) unless e.hide_hp == true
        draw_actor_mp(e,e.screen_x-50,e.screen_y+EHUD::Y_MOVE-40+e.personal_y,width=96) unless e.show_mp == false
        draw_actor_icons(e,e.screen_x-50,e.screen_y+EHUD::Y_MOVE-70+e.personal_y,width=96)
      end
    end
  end
end

class Scene_Battle < Scene_Base
  
  alias r2_update_basic_hp  update_basic
  def update_basic
    @skill_check = -1 unless @enemy_window.active
    @skill_check = @skill_window.item.id if @skill_window.active
    if @enemy_window.active && $game_switches[R2_Enemy_Hud_Hold_Time::Switch] == true
      enemy_hp_shown(true) if R2_Enemy_Hud_Hold_Time::Skill.include?(@skill_check)
    elsif @enemy_window.active && $game_switches[R2_Enemy_Hud_Hold_Time::Switch] == false
      enemy_hp_shown(true)
    else
      enemy_hp_shown(false) if (!@subject && @enemy_hud_window.damage_time = 0) && !@enemy_window.active
      enemy_hp_shown_all(false)
    end
    r2_update_basic_hp
  end
  
  alias r2_execute_hp_show  execute_action
  def execute_action
    skill_check = false
    @skill = @skill_window.item
    targets = @subject.current_action.make_targets.compact
    targets.each { |e| 
    e.is_a?(Game_Actor) ? next : @skill.nil? ? enemy_hp_shown(true) : skill_check = true
    @enemy_hud_window.enemy_id(e.index)
    @enemy_hud_window.damage_time(R2_Enemy_Hud_Hold_Time::Hold_Time)
    if skill_check == true
      case @skill.scope
      when 1
        @enemy_hud_window.enemy_id(e.index)
        if $game_switches[R2_Enemy_Hud_Hold_Time::Switch] == true
          enemy_hp_shown(true) if R2_Enemy_Hud_Hold_Time::Skill.include?(@skill_check)
        else
          enemy_hp_shown(true)
        end
      when 2..6
        if $game_switches[R2_Enemy_Hud_Hold_Time::Switch] == true
          enemy_hp_shown_all(true) if R2_Enemy_Hud_Hold_Time::Skill.include?(@skill_check)
          @enemy_hud_window.damage_time(R2_Enemy_Hud_Hold_Time::Hold_Time * 2)
        else
          enemy_hp_shown_all(true)
          @enemy_hud_window.damage_time(R2_Enemy_Hud_Hold_Time::Hold_Time * 2)
        end
      else
        enemy_hp_shown(false)
        enemy_hp_shown_all(false)
      end
      skill_check = false
    end
    }
    r2_execute_hp_show
    enemy_hp_shown_all(false)
  end
  
  alias r2_skill_enemy_select   select_enemy_selection
  def select_enemy_selection
    @skill = @skill_window.item
    if !@skill.nil?
      case @skill.scope
      when 1
        @enemy_hud_window.enemy_id(@enemy_window.index)
        if $game_switches[R2_Enemy_Hud_Hold_Time::Switch] == true
          enemy_hp_shown(true) if R2_Enemy_Hud_Hold_Time::Skill.include?(@skill_check)
          enemy_hp_shown_all(false)
        else
          enemy_hp_shown(true)
        end
      when 2..6
        if $game_switches[R2_Enemy_Hud_Hold_Time::Switch] == true
          enemy_hp_shown_all(true) if R2_Enemy_Hud_Hold_Time::Skill.include?(@skill_check)
          enemy_hp_shown(false)
        else
          enemy_hp_shown_all(true)
        end
        @enemy_hud_window.damage_time(R2_Enemy_Hud_Hold_Time::Hold_Time * 2)
      else
        enemy_hp_shown(false)
        enemy_hp_shown_all(false)
      end
    end
    r2_skill_enemy_select
  end

  def enemy_hp_shown(value = false)
    @enemy_hud_window.show_hp(value)
    if @enemy_window.enemy != nil
      @enemy_hud_window.enemy_id(@enemy_window.enemy.index)
    end
    @enemy_window.refresh
    @enemy_hud_window.refresh
  end

  def enemy_hp_shown_all(value = false)
    @enemy_hud_window.show_hp_all(value)
    @enemy_window.refresh
    @enemy_hud_window.refresh
  end
end
