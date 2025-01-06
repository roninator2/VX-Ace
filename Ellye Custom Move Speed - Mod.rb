#-------------------------------------------------------------------
# Custom Movement Speed
# A simple script made by Ellye.
# This is a free and unencumbered script, provided "as is", no warranties.
# Modified by Roninator2
# Now allows to specify which maps have different speeds. 
#-------------------------------------------------------------------
module R2_Map_Speed
	# change the number to include the maps where your speed needs to be changed
MAP_SPEED = { :crawl => [19, 20],
							:slow  => [1, 3, 4, 5, 6],
							:normal => [7, 8, 9, 10],
							:fast  => [2, 11,12,13,14,15,16],
							:ultra => [17, 18]
            }
SPEED_OFF = 4  # switch used to turn on map speed control above
# turn switch on to use the map id for speed control.
#-------------------------------------------------------------------
# * Options:
#-------------------------------------------------------------------

# Base speed for every moving character. Default RPG Maker value is 4.
Base_character_speed = 4

# Player movement speed. Default RPG Maker value is 4. Use either 3, 4 or 5.
Player_speed = 4

# Player dashing speed bonus. Default RPG Maker value is 1.
# You can also set a negative value, so that you'd have a
# "Walk / Sneaky Button" instead of a "Dash Button".
Dash_speed = 1

# Vehicules movement speed. Default RPG Maker values are 5, 6 and 7.
Boat_speed = 4
Ship_speed = 5
Airship_speed = 6

# when switch is on this will add to the speed when in a vehicle. 
# Optional
Vehicle_bonus = 0
end
#-------------------------------------------------------------------
#-------------------------------------------------------------------
#-------------------------------------------------------------------


class Game_CharacterBase
  #Add custom movement speed to characters Init
  alias :old_init_public_members :init_public_members
  def init_public_members
    old_init_public_members
    @move_speed = R2_Map_Speed::Base_character_speed
  end

  #Add custom dash bonus speed
  alias :old_real_move_speed :real_move_speed
  def real_move_speed
    old_real_move_speed
    return @move_speed + (dash? ? R2_Map_Speed::Dash_speed : 0)
  end

end

class Game_Player
  #Add custom movement speed to player Init
  alias :old_initialize :initialize
  def initialize
    old_initialize
    @move_speed = R2_Map_Speed::Player_speed
  end
  #--------------------------------------------------------------------------
  # * Execute Player Transfer
  #--------------------------------------------------------------------------
  def perform_transfer
    if transfer?
      set_direction(@new_direction)
      if @new_map_id != $game_map.map_id
        $game_map.setup(@new_map_id)
        $game_map.autoplay
      end
      moveto(@new_x, @new_y)
      @move_speed = R2_Map_Speed::Player_speed
      if $game_switches[R2_Map_Speed::SPEED_OFF] == true
        if R2_Map_Speed::MAP_SPEED[:crawl].include?($game_map.map_id)
          @move_speed -= 2
        elsif R2_Map_Speed::MAP_SPEED[:slow].include?($game_map.map_id)
          @move_speed -= 1
        elsif R2_Map_Speed::MAP_SPEED[:normal].include?($game_map.map_id)
          @move_speed = 4
        elsif R2_Map_Speed::MAP_SPEED[:fast].include?($game_map.map_id)
          @move_speed += 1
        elsif R2_Map_Speed::MAP_SPEED[:ultra].include?($game_map.map_id)
          @move_speed += 2
        end
      else
      end
      clear_transfer_info
    end
  end
  
  #The default get_off_vehicle method sets the player speed to 4...
  alias :old_get_off_vehicule :get_off_vehicle
  def get_off_vehicle
      old_get_off_vehicule
      @move_speed = R2_Map_Speed::Player_speed
      if $game_switches[R2_Map_Speed::SPEED_OFF] == true
        if R2_Map_Speed::MAP_SPEED[:crawl].include?($game_map.map_id)
          @move_speed -= 2
        elsif R2_Map_Speed::MAP_SPEED[:slow].include?($game_map.map_id)
          @move_speed -= 1
        elsif R2_Map_Speed::MAP_SPEED[:normal].include?($game_map.map_id)
          @move_speed = 4
        elsif R2_Map_Speed::MAP_SPEED[:fast].include?($game_map.map_id)
          @move_speed += 1
        elsif R2_Map_Speed::MAP_SPEED[:ultra].include?($game_map.map_id)
          @move_speed += 2
        end
      end
  end
end

class Game_Vehicle
  #Set custom Vehicle speeds
  alias r2_move_get_on_speed  get_on
  def get_on
    r2_move_get_on_speed
    @move_speed = R2_Map_Speed::Boat_speed if @type == :boat
    @move_speed = R2_Map_Speed::Ship_speed if @type == :ship
    @move_speed = R2_Map_Speed::Airship_speed if @type == :airship
		if $game_switches[R2_Map_Speed::SPEED_OFF] == true
			if R2_Map_Speed::MAP_SPEED[:crawl].include?(@map_id)
				@move_speed += R2_Map_Speed::Vehicle_bonus 
			elsif R2_Map_Speed::MAP_SPEED[:slow].include?(@map_id)
				@move_speed += R2_Map_Speed::Vehicle_bonus 
			elsif R2_Map_Speed::MAP_SPEED[:normal].include?(@map_id)
				@move_speed += R2_Map_Speed::Vehicle_bonus 
			elsif R2_Map_Speed::MAP_SPEED[:fast].include?(@map_id)
				@move_speed += R2_Map_Speed::Vehicle_bonus 
			elsif R2_Map_Speed::MAP_SPEED[:ultra].include?(@map_id)
				@move_speed += R2_Map_Speed::Vehicle_bonus 
			else
				@move_speed += R2_Map_Speed::Vehicle_bonus 
			end
		else
		end
  end
end
