# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Land Vehicle                           ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Use a land vehicle                          ║    20 Jul 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Create a vehicle to use on land                              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Change the values below for the vehicle location                 ║
# ║                                                                    ║
# ║   Put in a script call to transfer the vehicle                     ║
# ║   to another map.                                                  ║
# ║       script: set_land_vehicle(map id, x, y)                       ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 20 Jul 2023 - Script finished                               ║
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

module R2_LAND_VEHICLE
  LAND_MAP = 1      # Which map to have the vehicle start on
  LAND_X = 10       # X coordinate of the Land Vehicle on the map
  LAND_Y = 5        # Y coordinate of the Land Vehicle on the map
  LAND_INDEX = 5    # graphic index of the Land Vehicle in the spritesheet
  LAND_NAME = "Vehicle" # Name of graphic with the Land Vehicle
  LAND_BGM = RPG::BGM.new("Ship", 100, 100) # BGM to play while in Land Vehicle
  MOVE_SPEED = 4    # Movement speed of the Land Vehicle on the map
  AVOID_BATTLES = true # True = no battles while in land vehicle
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

#==============================================================================
# ** Game_Vehicle
#==============================================================================

class Game_Vehicle < Game_Character
  #--------------------------------------------------------------------------
  # * Initialize Move Speed
  #--------------------------------------------------------------------------
  alias :r2_land_vehicle_move_speed :init_move_speed
  def init_move_speed
    r2_land_vehicle_move_speed
    @move_speed = R2_LAND_VEHICLE::MOVE_SPEED if @type == :land
  end
  #--------------------------------------------------------------------------
  # * Get System Settings
  #--------------------------------------------------------------------------
  alias :r2_system_vehicle_land :system_vehicle
  def system_vehicle
    return land_vehicle    if @type == :land
    r2_system_vehicle_land
  end
  def land_vehicle
    if $game_system.land_vehicle == nil
      $game_system.land_vehicle = $data_system.boat.dup
      $game_system.land_vehicle.start_map_id = R2_LAND_VEHICLE::LAND_MAP
      $game_system.land_vehicle.start_x = R2_LAND_VEHICLE::LAND_X
      $game_system.land_vehicle.start_y = R2_LAND_VEHICLE::LAND_Y
      $game_system.land_vehicle.character_index = R2_LAND_VEHICLE::LAND_INDEX
      $game_system.land_vehicle.character_name = R2_LAND_VEHICLE::LAND_NAME
      $game_system.land_vehicle.bgm = R2_LAND_VEHICLE::LAND_BGM
    end
    return $game_system.land_vehicle
  end
end # Game_Vehicle

#==============================================================================
# ** Game_System
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :land_vehicle            # Land Vehicle
end # Game_System

#==============================================================================
# ** Game_Map
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # * Create Vehicles
  #--------------------------------------------------------------------------
  alias :r2_land_vehicle_create :create_vehicles
  def create_vehicles
    r2_land_vehicle_create
    @vehicles[3] = Game_Vehicle.new(:land)
  end
  #--------------------------------------------------------------------------
  # * Get Vehicle
  #--------------------------------------------------------------------------
  alias :r2_land_vehicle_type :vehicle
  def vehicle(type)
    return @vehicles[3] if type == :land
    r2_land_vehicle_type(type)
  end
  #--------------------------------------------------------------------------
  # * Get Boat
  #--------------------------------------------------------------------------
  def land
    @vehicles[3]
  end
  #--------------------------------------------------------------------------
  # * Determine if Passable by Boat
  #--------------------------------------------------------------------------
  def land_passable?(x, y, d)
    check_passage(x, y, (1 << (d / 2 - 1)) & 0x0f)
  end
end # Game_Map
  
#==============================================================================
# ** Game_Player
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Determine if Map is Passable
  #     d:  Direction (2,4,6,8)
  #--------------------------------------------------------------------------
  def map_passable?(x, y, d)
    case @vehicle_type
    when :land
      $game_map.land_passable?(x, y, d)
    when :boat
      $game_map.boat_passable?(x, y)
    when :ship
      $game_map.ship_passable?(x, y)
    when :airship
      true
    else
      super
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if on Boat
  #--------------------------------------------------------------------------
  def in_land?
    @vehicle_type == :land
  end
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
  #--------------------------------------------------------------------------
  # * Determine if Event Start Caused by Touch (Overlap)
  #--------------------------------------------------------------------------
  def check_touch_event
    return false if in_airship? || in_land?
    check_event_trigger_here([1,2])
    $game_map.setup_starting_event
  end
  #--------------------------------------------------------------------------
  # * Determine if Front Event is Triggered
  #--------------------------------------------------------------------------
  def check_event_exist(d)
    return if $game_map.interpreter.running?
    @direction = d
    x2 = $game_map.round_x_with_direction(@x, @direction)
    y2 = $game_map.round_y_with_direction(@y, @direction)
    return false if $game_map.events_xy(x2, y2).empty?
    return true
  end
  #--------------------------------------------------------------------------
  # * Move Straight
  #--------------------------------------------------------------------------
  def move_straight(d, turn_ok = true)
    return if (vehicle && check_event_exist(d))
    @followers.move if passable?(@x, @y, d)
    super
  end
  #--------------------------------------------------------------------------
  # * Execute Encounter Processing
  #--------------------------------------------------------------------------
  def encounter
    return false if $game_map.interpreter.running?
    return false if $game_system.encounter_disabled
    return false if R2_LAND_VEHICLE::AVOID_BATTLES && in_land?
    return false if @encounter_count > 0
    make_encounter_count
    troop_id = make_encounter_troop_id
    return false unless $data_troops[troop_id]
    BattleManager.setup(troop_id)
    BattleManager.on_encounter
    return true
  end
end # Game_Player

#==============================================================================
# ** Game_Interpreter
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Set Vehicle Location
  #--------------------------------------------------------------------------
  def set_land_vehicle(map, x, y)
    $game_map.vehicles[3].set_location(map, x, y)
  end
end # Game_Interpreter

#==============================================================================
# ** Spriteset_Battle
#==============================================================================

class Spriteset_Battle

  #--------------------------------------------------------------------------
  # * Get Filename of Field Battle Background (Floor)
  #--------------------------------------------------------------------------
  def overworld_battleback1_name
    $game_player.vehicle ? $game_player.in_land? ? normal_battleback1_name : ship_battleback1_name : normal_battleback1_name
  end
  #--------------------------------------------------------------------------
  # * Get Filename of Field Battle Background (Wall)
  #--------------------------------------------------------------------------
  def overworld_battleback2_name
    $game_player.vehicle ? $game_player.in_land? ? normal_battleback2_name : ship_battleback2_name : normal_battleback2_name
  end
end
