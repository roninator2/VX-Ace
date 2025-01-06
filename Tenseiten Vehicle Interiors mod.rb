#===============================================================================
# * Vehicle Additions
#   Version 0.41b
#-------------------------------------------------------------------------------
# * Authored by: tenseiten/seitensei
# * With help from: shaz
# * Updated by Roninator2
#===============================================================================

#===============================================================================
# * Change log
#-------------------------------------------------------------------------------
=begin

0.41b - 2020-12-10 18:05 CST
  - added switches to turn feature on or off
  
0.4b - 2020-12-10 18:00 CST
  - Added support for ship interior
  
0.35b - 2011-12-27 1:19 JST
  - Replaced cloned methods with alias to fix possible compatibility issues.
    This script should be placed below any other that modified the default
    vehicle behavior.

0.35a - 2011-12-22, 19:16 JST
  - Fixed Boat and Ship not being passed through

0.30a - 2011-12-21, 19:20 JST
  - First Public Release
  - Fixed Teleport on Unlandable Spaces
  
0.20a - Internal Version

0.10a - Internal Version

0.00a - Internal Version

=end
#===============================================================================

#===============================================================================
=begin

.:Introduction:.
This Vehicle Additions script adds the ability to access an additional map as
the interior of the vehicle. So far, only the airship has been implemented. This
script overwrites the get_on_vehicle and the get_off_vehicle methods, so it is
not compatible with anything that edits those. However, since it uses a the
default code when the system is not enabled for a vehicle, created a patch to
solve incompatibilities is not within the real of impossibility.

.:Instruction:.
Set the map ID and X/Y coordinates of for the map that will serve as the
interior of the vehicle. Create an event that brings the player back to the
overmap and forces them to pilot the vehicle by by creating and event that
calls the following code:

$game_player.pilot_vehicle

To exit the vehicle's interior, and return to the overmap (on foot), call
the following:

$game_player.exit_vehicle

=end
#===============================================================================

#-------------------------------------------------------------------------------
# * Config Section
#-------------------------------------------------------------------------------
module Tenseiten
  module Vehicle
    AIRSHIP_ENABLED = 2 # switch # Whether or not we want to invoke additions
    AIRSHIP_MAP = 3 # interior map id
    AIRSHIP_MAP_X = 10 # interior x
    AIRSHIP_MAP_Y = 10 # interior y
    
    SHIP_ENABLED = 3 # switch # Whether or not we want to invoke additions
    SHIP_MAP = 4 # interior map id
    SHIP_MAP_X = 10 # interior x
    SHIP_MAP_Y = 10 # interior y
  end
end
#-------------------------------------------------------------------------------
# * Config End
#-------------------------------------------------------------------------------
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Get on Vehicle (From Overmap)
  #   Intercept the player, and send them inside.
  #--------------------------------------------------------------------------
  alias control_vehicle get_on_vehicle
  def get_on_vehicle
    front_x = $game_map.round_x_with_direction(@x, @direction)
    front_y = $game_map.round_y_with_direction(@y, @direction)
    # check if player is allowed to get onto the airship
    if $game_map.airship.pos?(@x, @y)
      if $game_switches[Tenseiten::Vehicle::AIRSHIP_ENABLED] == true
        #Save world map information
        @player_w_map = $game_map.map_id
        @player_w_x = @x
        @player_w_y = @y
        @used_vehicle = :airship
        #Now Teleport to the map set in config
        reserve_transfer(Tenseiten::Vehicle::AIRSHIP_MAP, Tenseiten::Vehicle::AIRSHIP_MAP_X, Tenseiten::Vehicle::AIRSHIP_MAP_Y, @direction) # transfer to new map
      else
        #Continue to normal function when not enabled
        @vehicle_type = :airship
        control_vehicle
      end
    end
    if $game_map.boat.pos?(front_x, front_y)
      @vehicle_type = :boat
      control_vehicle
    end
    if $game_map.ship.pos?(front_x, front_y)
      if $game_switches[Tenseiten::Vehicle::SHIP_ENABLED] == true
        #Save world map information
        @player_w_map = $game_map.map_id
        @player_w_x = @x
        @player_w_y = @y
        @player_w_d = @direction
        @used_vehicle = :ship
        #Now Teleport to the map set in config
        reserve_transfer(Tenseiten::Vehicle::SHIP_MAP, Tenseiten::Vehicle::SHIP_MAP_X, Tenseiten::Vehicle::SHIP_MAP_Y, @direction) # transfer to new map
      else
        #Continue to normal function when not enabled
        @vehicle_type = :ship
        control_vehicle
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Pilot Vehicle (From Interior)
  #   Brings player back to the overmap to control the ship
  #--------------------------------------------------------------------------
  def pilot_vehicle
    # Save Interior Map Location
    @player_int_map = $game_map.map_id
    @player_int_x = @x
    @player_int_y = @y
    # Transfer to World Map
    if @used_vehicle == :ship
      @direction = @player_w_d
      if @player_w_d == 2
        @player_w_y += 1
      elsif @player_w_d == 4
        @player_w_x -= 1
      elsif @player_w_d == 6
        @player_w_x += 1
      elsif @player_w_d == 8
        @player_w_y -= 1
      end
    end
    reserve_transfer(@player_w_map, @player_w_x, @player_w_y, @direction)
    @vehicle_type = @used_vehicle
    control_vehicle
  end
  #--------------------------------------------------------------------------
  # * Leave Vehicle (From Overmap)
  #   Intercept the player, and end them inside
  #--------------------------------------------------------------------------
  alias abandon_vehicle get_off_vehicle
  def get_off_vehicle
    if @vehicle_type == :airship
      if $game_switches[Tenseiten::Vehicle::AIRSHIP_ENABLED] == true
        if vehicle.land_ok?(@x, @y, @direction)
        set_direction(1) if in_airship?
        @followers.synchronize(@x, @y, @direction)
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
      if vehicle.land_ok?(@x, @y, @direction)
        @player_w_map = $game_map.map_id
        @player_w_x = @x
        @player_w_y = @y
        reserve_transfer(@player_int_map, @player_int_x, @player_int_y, @direction) # transfer to new map
      end
      else
		  abandon_vehicle
      end
    elsif @vehicle_type == :ship
      if $game_switches[Tenseiten::Vehicle::SHIP_ENABLED] == true
        vehicle.get_off
        force_move_forward
        @transparent = false
        @vehicle_getting_off = true
        @move_speed = 4
        @through = false
        make_encounter_count
        @followers.gather
        @vehicle_getting_off
        @player_w_map = $game_map.map_id
        @player_w_x = @x
        @player_w_y = @y
        reserve_transfer(@player_int_map, @player_int_x, @player_int_y, @direction) # transfer to new map
      else
		  abandon_vehicle
      end
    else
      abandon_vehicle
    end
  end
  #--------------------------------------------------------------------------
  # * Exit Vehicle (From Interior)
  #   Returns the party to the overmap
  #--------------------------------------------------------------------------
  def exit_vehicle
    reserve_transfer(@player_w_map, @player_w_x, @player_w_y, @direction) 
  end
end

