# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Non Combat Actor                       ║  Version: 1.09     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Specify actors to never be in combat          ║    03 Jul 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Have Actors that do not fight                                ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║ Place note tag on actor note box. <non combat>                     ║
# ║ Change number below to Max battle members                          ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 03 Jul 2021 - Script finished                               ║
# ║ 1.01 - 04 Jul 2021 - updated                                       ║
# ║ 1.02 - 02 Jan 2025 - fixed a bug, allow having non members visible ║
# ║ 1.03 - 03 Jan 2025 - finally fixed the display order               ║
# ║ 1.04 - 03 Jan 2025 - Added Support to have non combat not gain exp ║
# ║ 1.05 - 03 Jan 2025 - Added Support hidden followers                ║
# ║ 1.06 - 03 Jan 2025 - Cleaned up unneeded code                      ║
# ║ 1.07 - 03 Jan 2025 - Fixed gaining exp for non battle actors       ║
# ║ 1.08 - 03 Jan 2025 - Attempt to fix issues reported                ║
# ║ 1.09 - 04 Jan 2025 - Fix for Yanfly Battle Engine                  ║
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

module R2_Max_Battle_Members
  MAX = 4
  SHOW_NON_COMBAT = true
  GAIN_EXP_NON_COMBAT = true
  EXP_RATE = 1.0
end

# ╔══════════════════════════════════════════════════════════╗
# ║      No more editing                                     ║
# ╚══════════════════════════════════════════════════════════╝

class Game_Follower
  def set_character(character_name, character_index)
    @character_name = character_name
    @character_index = character_index
  end
end

class Game_Followers
  def initialize(leader)
    @visible = $data_system.opt_followers
    @gathering = false 
    @data = []
    @data.push(Game_Follower.new(1, leader))
    (2...$game_party.max_battle_members.size).each do |index|
      @data.push(Game_Follower.new(index, @data[-1]))
    end
  end
  def setup_non_battle_members
    return unless R2_Max_Battle_Members::SHOW_NON_COMBAT
    return if $game_party.non_battle_members == []
    $game_party.non_battle_members.each do |i|
      @data.push(Game_Follower.new(@data.size, @data[-1]))
    end
  end
end

class Game_Party < Game_Unit
  attr_reader :non_battle_members
  
  alias :r2_game_party_initialize_na :initialize
  def initialize
    r2_game_party_initialize_na
    @non_battle_members = nil
  end

  def battle_members
    array = []
    for act in @actors
      nonact = $data_actors[act]
      next if nonact.note =~ /<non combat>/i
      actor = $game_actors[act]
      next if !actor.exist?
      next if array.size >= R2_Max_Battle_Members::MAX
      array << actor
    end
    return array
  end
  
  def not_battle_members
    @non_battle_members = []
    for act in @actors
      nonact = $data_actors[act]
      if nonact.note =~ /<non combat>/i
        actor = $game_actors[act]
        next if !actor.exist?
        @non_battle_members << actor
      end
    end
    return @non_battle_members
  end
  
  def max_battle_members
    if $imported["YEA-BattleEngine"] == true
      return R2_Max_Battle_Members::MAX
    else
      in_battle ? battle_members.size : battle_members.size + not_battle_members.size
    end
  end

  alias :r2_setup_starting_members_nb :setup_starting_members
  def setup_starting_members
    r2_setup_starting_members_nb
    not_battle_members
    $game_player.followers.setup_non_battle_members
  end
  
  alias :r2_swap_order_non_combat :swap_order
  def swap_order(index1, index2)
    r2_swap_order_non_combat(index1, index2)
    $game_player.refresh
  end
  
  alias :r2_add_actor_non_combat  :add_actor
  def add_actor(actor_id)
    r2_add_actor_non_combat(actor_id)
    not_battle_members
    $game_player.refresh
    $game_map.need_refresh = true
  end

  alias :r2_remove_actor_non_combat  :remove_actor
  def remove_actor(actor_id)
    r2_remove_actor_non_combat(actor_id)
    not_battle_members
    $game_player.refresh
    $game_map.need_refresh = true
  end
end

class Scene_Map < Scene_Base
  
  alias :r2_not_battle_member_update :update
  def update
    r2_not_battle_member_update
    call_not_battle_member_graphic if $game_player.followers.visible
  end

  def call_not_battle_member_graphic
    return if R2_Max_Battle_Members::SHOW_NON_COMBAT == false
    pos = 0
    cnt = 0
    $game_party.members.each_with_index do |actor, index|
      next if actor == nil
      next if index == 0
      nonact = $data_actors[actor.id]
      if nonact.note =~ /<non combat>/i
        follower = $game_player.followers[index - 1 - pos]
        next unless follower
        follower.set_character(actor.character_name, actor.character_index)
      else
        if cnt < $game_party.battle_members.size
          follower = $game_player.followers[index - 1 - pos]
          next unless follower
          follower.set_character(actor.character_name, actor.character_index)
        else
          pos += 1
        end
      end
      cnt += 1
    end
  end
end

class Game_Actor < Game_Battler
  def reserve_members_exp_rate
    if $game_party.non_battle_members.include?(self) && 
      R2_Max_Battle_Members::GAIN_EXP_NON_COMBAT
        return R2_Max_Battle_Members::EXP_RATE
    else
      $data_system.opt_extra_exp ? 1 : 0
    end
  end
end
