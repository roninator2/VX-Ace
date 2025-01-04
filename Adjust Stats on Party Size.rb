# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Adjust Stats on Party Size             ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Adjust params for actors                    ║    21 Dec 2024     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║        More battle memebrs causes battlers to lose ATK             ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Turn Value below to true to have it get applied                  ║
# ║      LOWER_ATK = true                                              ║
# ║   Set value that will be changed for stat                          ║
# ║                                                                    ║
# ║   Add more ad you desire                                           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 21 Dec 2024 - Script finished                               ║
# ║ 1.01 - 23 Dec 2024 - For Yanfly Party System                       ║
# ║ 1.02 - 24 Dec 2024 - fixed code error for yanfly party             ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║                                                                    ║
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

module R2_Modify_Battle_Stats_Large_Party
  LOWER_ATK = true
  ATK_AMOUNT = 10
  # add more here as you need
  # LOWER_DEF = true
  # DEF_AMOUNT = 5
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * Initial Party Setup
  #--------------------------------------------------------------------------
  alias :r2_setup_starting_members :setup_starting_members
  def setup_starting_members
    r2_setup_starting_members
    remove_actor_stats_by_member
  end
  #--------------------------------------------------------------------------
  # * Add an Actor
  #--------------------------------------------------------------------------
  alias :r2_change_stats_add :add_actor
  def add_actor(actor_id)
    reset_actor_stats_by_member
    r2_change_stats_add(actor_id)
    remove_actor_stats_by_member
  end
  #--------------------------------------------------------------------------
  # * remove stats
  #--------------------------------------------------------------------------
  def reset_actor_stats_by_member
    if $imported && $imported["YEA-PartySystem"] && !$BTEST
      @battle_members_array.each do |act|
        next if act == 0
        mem = $game_actors[act]
        mem.raise_battle_stat(2) if R2_Modify_Battle_Stats_Large_Party::LOWER_ATK
        # add more here as you need
        # act.raise_battle_stat(3) if R2_Modify_Battle_Stats_Large_Party::LOWER_DEF
      end
    else
      battle_members.each do |act|
        act.raise_battle_stat(2) if R2_Modify_Battle_Stats_Large_Party::LOWER_ATK
        # add more here as you need
        # act.raise_battle_stat(3) if R2_Modify_Battle_Stats_Large_Party::LOWER_DEF
      end
    end
  end
  #--------------------------------------------------------------------------
  # * remove stats
  #--------------------------------------------------------------------------
  def remove_actor_stats_by_member
    if $imported && $imported["YEA-PartySystem"] && !$BTEST
      @battle_members_array.each do |act|
        next if act == 0
        mem = $game_actors[act]
        mem.lower_battle_stat(2) if R2_Modify_Battle_Stats_Large_Party::LOWER_ATK
        # add more here as you need
      end
    else
      battle_members.each do |act|
        act.lower_battle_stat(2) if R2_Modify_Battle_Stats_Large_Party::LOWER_ATK
        # add more here as you need
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Remove Actor
  #--------------------------------------------------------------------------
  alias :r2_change_stats_remove :remove_actor
  def remove_actor(actor_id)
    reset_actor_stats_by_member
    r2_change_stats_remove(actor_id)
    remove_actor_stats_by_member
  end
end

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Change Param Plus Value
  #--------------------------------------------------------------------------
  def lower_battle_stat(param)
    if $imported && $imported["YEA-PartySystem"]
      ps = $game_party.battle_members_array.select { |d| d != 0 }
      adj = -((ps.size - 1) * 
        R2_Modify_Battle_Stats_Large_Party::ATK_AMOUNT) if param == 2
    # add more here as you need
    # params [mhp, mmp, atk, def, mat, mdf, agi, luk]
    # params [ 0 ,  1 ,  2 ,  3 ,  4 ,  5 ,  6 ,  7 ]
    else
      adj = -(($game_party.battle_members.size - 1) * 
        R2_Modify_Battle_Stats_Large_Party::ATK_AMOUNT) if param == 2
    # add more here as you need
    # params [mhp, mmp, atk, def, mat, mdf, agi, luk]
    # params [ 0 ,  1 ,  2 ,  3 ,  4 ,  5 ,  6 ,  7 ]
    end
    add_param(param, adj)
  end
  #--------------------------------------------------------------------------
  # * Change Param Plus Value
  #--------------------------------------------------------------------------
  def raise_battle_stat(param)
    if $imported && $imported["YEA-PartySystem"]
      ps = $game_party.battle_members_array.select { |d| d != 0 }
      adj = ((ps.size - 1) * 
        R2_Modify_Battle_Stats_Large_Party::ATK_AMOUNT) if param == 2
    # add more here as you need
    # params [mhp, mmp, atk, def, mat, mdf, agi, luk]
    # params [ 0 ,  1 ,  2 ,  3 ,  4 ,  5 ,  6 ,  7 ]
    else
      adj = (($game_party.battle_members.size - 1) * 
        R2_Modify_Battle_Stats_Large_Party::ATK_AMOUNT) if param == 2
    # add more here as you need
    # params [mhp, mmp, atk, def, mat, mdf, agi, luk]
    # params [ 0 ,  1 ,  2 ,  3 ,  4 ,  5 ,  6 ,  7 ]
    end
    add_param(param, adj)
  end
end

class Scene_Party < Scene_MenuBase
  #--------------------------------------------------------------------------
  # on_party_ok
  #--------------------------------------------------------------------------
  def on_party_ok
    case @command_window.current_symbol
    when :change
      @list_window.activate
    when :remove
      $game_party.reset_actor_stats_by_member
      index = @party_window.index
      actor = $game_actors[$game_party.battle_members_array[index]]
      Sound.play_equip
      $game_party.battle_members_array[index] = 0
      $game_party.remove_actor_stats_by_member
      window_refresh
      @party_window.activate
    end
  end
  #--------------------------------------------------------------------------
  # on_list_ok
  #--------------------------------------------------------------------------
  def on_list_ok
    $game_party.reset_actor_stats_by_member
    Sound.play_equip
    replace = $game_actors[@party_window.item]
    actor = $game_actors[@list_window.item]
    index1 = @party_window.index
    actor_id1 = actor.nil? ? 0 : actor.id
    if actor.nil?
      $game_party.battle_members_array[index1] = 0
      window_refresh
      @party_window.activate
      return
    end
    actor_id2 = replace.nil? ? 0 : replace.id
    if $game_party.battle_members_array.include?(actor_id1)
      index2 = $game_party.battle_members_array.index(actor_id1)
      $game_party.battle_members_array[index2] = actor_id2
    end
    $game_party.battle_members_array[index1] = actor_id1
    $game_party.remove_actor_stats_by_member
    window_refresh
    @status_window.refresh
    @party_window.activate
  end
end
