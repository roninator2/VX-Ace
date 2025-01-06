# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Party Swap for Vehicle                 ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Save the party in order to swap             ╠════════════════════╣
# ║   for a land vehicle for the party            ║    21 Jul 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Roninator2 Land Vehicle Script                           ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Switch party for vehicle                                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Change the values below for the vehicle actor                    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 21 Jul 2023 - Script finished                               ║
# ║                                                                    ║
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

#==============================================================================
# ** Edit Settings
#==============================================================================
module R2_LAND_VEHICLE
  VEHICLE_ACTOR = 11    # Actor that is used as the land vehicle
  LEADER_LEVEL = true   # If true will make the vehicle actor the 
                        # same level as the party leader
end
#==============================================================================
# ** End of Editable code
#==============================================================================

#==============================================================================
# ** BattleManager
#==============================================================================

module BattleManager
  #--------------------------------------------------------------------------
  # * EXP Acquisition and Level Up Display
  #--------------------------------------------------------------------------
  def self.gain_exp
    if $game_player.in_land?
      $game_party.vehicle_party.each do |actor|
        actor.gain_vehicle_exp($game_troop.exp_total)
      end
    else
      $game_party.all_members.each do |actor|
        actor.gain_exp($game_troop.exp_total)
      end
    end
    wait_for_message
  end
end # BattleManager

#==============================================================================
# ** Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Get EXP (Account for Experience Rate)
  #--------------------------------------------------------------------------
  def gain_vehicle_exp(exp)
    change_exp(self.exp + (exp * vehicle_exp_rate).to_i, false)
  end
  #--------------------------------------------------------------------------
  # * Calculate Final EXP Rate
  #--------------------------------------------------------------------------
  def vehicle_exp_rate
    exr * (vehicle_battle_member? ? 1 : reserve_members_exp_rate)
  end
  #--------------------------------------------------------------------------
  # * Determine Battle Members
  #--------------------------------------------------------------------------
  def vehicle_battle_member?
    $game_party.vehicle_members.include?(self)
  end
end # Game_Actor

#==============================================================================
# ** Game_Party
#==============================================================================

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :vehicle_party            # Land Vehicle Party saved
  #--------------------------------------------------------------------------
  # * Get All Members
  #--------------------------------------------------------------------------
  def driving_members
    @vehicle_party.collect {|act| $game_actors[act.id] }
  end
  #--------------------------------------------------------------------------
  # * Get Battle Members
  #--------------------------------------------------------------------------
  def vehicle_members
    driving_members[0, max_battle_members].select {|actor| actor.exist? }
  end
end # Game_Party

#==============================================================================
# ** Game_Player
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Board Vehicle
  #    Assumes that the player is not currently in a vehicle.
  #--------------------------------------------------------------------------
  def get_on_vehicle
    front_x = $game_map.round_x_with_direction(@x, @direction)
    front_y = $game_map.round_y_with_direction(@y, @direction)
    @vehicle_type = :boat    if $game_map.boat.pos?(front_x, front_y)
    @vehicle_type = :ship    if $game_map.ship.pos?(front_x, front_y)
    @vehicle_type = :airship if $game_map.airship.pos?(@x, @y)
    @vehicle_type = :land    if $game_map.land.pos?(@x, @y)
    if vehicle
      @vehicle_getting_on = true
      force_move_forward unless in_airship? or in_land?
      @followers.gather
    end
    if in_land?
      $game_party.vehicle_party = $game_party.members
      $game_party.members.each do |actor|
        $game_party.remove_actor(actor.id)
      end
      $game_party.add_actor(R2_LAND_VEHICLE::VEHICLE_ACTOR)
      if R2_LAND_VEHICLE::LEADER_LEVEL
        lvl = $game_party.vehicle_party[0].level.to_i
        $game_party.members[0].change_level(lvl, false)
      end
    end
    @vehicle_getting_on
  end
  #--------------------------------------------------------------------------
  # * Get Off Vehicle
  #    Assumes that the player is currently riding in a vehicle.
  #--------------------------------------------------------------------------
  def get_off_vehicle
    if vehicle.land_ok?(@x, @y, @direction)
      set_direction(2) if in_airship?
      @followers.synchronize(@x, @y, @direction)
      if in_land?
        $game_party.remove_actor(R2_LAND_VEHICLE::VEHICLE_ACTOR)
        $game_party.vehicle_party.each do |actor|
          $game_party.add_actor(actor.id)
        end
        $game_party.vehicle_party = nil
      end
      vehicle.get_off
      unless in_airship? || in_land?
        force_move_forward
        @transparent = false
      end
      @vehicle_getting_off = true
      @move_speed = 4
      @through = false
      make_encounter_count
      @followers.gather
    end
    @vehicle_getting_off
  end
end # Game_Player
