# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Party Swap for Default Vehicles        ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Save the party in order to swap             ╠════════════════════╣
# ║   for a land vehicle for the party            ║    21 Jul 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Roninator2 - Land Vehicle                                ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Allow swapping party for land vehicle                        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Change the values below for the vehicle actor                    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 22 Nov 2024 - Script finished                               ║
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
  BOAT_ACTOR = 11       # Actor that is used as the boat vehicle
  SHIP_ACTOR = 11       # Actor that is used as the ship vehicle
  AIRSHIP_ACTOR = 11    # Actor that is used as the airship vehicle
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
    if $game_player.in_boat? || $game_player.in_ship? || $game_player.in_airship?
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
  # * Update Boarding onto Vehicle 
  #--------------------------------------------------------------------------
  def update_vehicle_get_on
    if !@followers.gathering? && !moving?
      @direction = vehicle.direction
      @move_speed = vehicle.speed
      @vehicle_getting_on = false
      @transparent = true
      @through = true if in_airship?
      vehicle.get_on
      $game_party.vehicle_party = $game_party.members
      $game_party.members.each do |actor|
        $game_party.remove_actor(actor.id)
      end
      case @vehicle_type
      when :boat ; $game_party.add_actor(R2_LAND_VEHICLE::BOAT_ACTOR)
      when :ship ; $game_party.add_actor(R2_LAND_VEHICLE::SHIP_ACTOR)
      when :airship ; $game_party.add_actor(R2_LAND_VEHICLE::AIRSHIP_ACTOR)
      end
      if R2_LAND_VEHICLE::LEADER_LEVEL
        lvl = $game_party.vehicle_party[0].level.to_i
        $game_party.members[0].change_level(lvl, false)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Get Off Vehicle
  #    Assumes that the player is currently riding in a vehicle.
  #--------------------------------------------------------------------------
  def get_off_vehicle
    if vehicle.land_ok?(@x, @y, @direction)
      RPG::BGM.stop
      set_direction(2) if in_airship?
      @followers.synchronize(@x, @y, @direction)
      case @vehicle_type
      when :boat ; $game_party.remove_actor(R2_LAND_VEHICLE::BOAT_ACTOR)
      when :ship ; $game_party.remove_actor(R2_LAND_VEHICLE::SHIP_ACTOR)
      when :airship ; $game_party.remove_actor(R2_LAND_VEHICLE::AIRSHIP_ACTOR)
      end
      $game_party.vehicle_party.each do |actor|
        $game_party.add_actor(actor.id)
      end
      $game_party.vehicle_party = nil
      vehicle.get_off
      unless in_airship?
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
