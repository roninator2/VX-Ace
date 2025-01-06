# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Vehicle Event Interaction              ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║       Provide Vehicle Interaction             ║    28 Apr 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Tsukihime - Event Interaction script                     ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Allow vehicles to interact with events                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   This script will let you interact with events while              ║
# ║   on board a vehicle. It was written with the airship              ║
# ║   in mind.                                                         ║
# ║                                                                    ║
# ║   Make the event Above Characters                                  ║
# ║   Set to Action Button                                             ║
# ║   Put a comment like this on the event                             ║
# ║       comment: land                                                ║
# ║   Then to make your airship land use a script call                 ║
# ║     $game_player.land_airship                                      ║
# ║                                                                    ║
# ║   Then when you are over the event, press the action               ║
# ║   button and the event will run.                                   ║
# ║                                                                    ║
# ║ Change the word:                                                   ║
# ║   If you don't want to use land go down to the section             ║
# ║   that says 'land' and change it.                                  ║
# ║                                                                    ║
# ║ Multiple uses:                                                     ║
# ║   The script was written to work for airships.                     ║
# ║   If you have other purposes, modifications are needed.            ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 28 Apr 2023 - Initial publish                               ║
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

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Get Off Vehicle
  #    Assumes that the player is currently riding in a vehicle.
  #--------------------------------------------------------------------------
  def land_airship
    set_direction(2)
    @followers.synchronize(@x, @y, @direction)
    vehicle.get_off
    @vehicle_getting_off = true
    @move_speed = 4
    @through = false
    make_encounter_count
    @followers.gather
    @vehicle_getting_off
  end
end

class Game_Vehicle < Game_Character
  #--------------------------------------------------------------------------
  # * Determine if Docking/Landing Is Possible
  #     d:  Direction (2,4,6,8)
  #--------------------------------------------------------------------------
  alias r2_vehicle_land_movement land_ok?
  def land_ok?(x, y, d)
    if @type == :airship
      #return true if 
      vehicle_port(x, y)
    end
    r2_vehicle_land_movement(x, y, d)
  end
  def vehicle_port(x, y)
    if $game_map.events_xy(x, y).empty?
      return
    end
    $game_map.events_xy(x, y).each do |evt| 
      evt.list.each do |cmt|
        if cmt.code == 108
          if cmt.parameters = ["land"]
            $game_player.start_airship_event(x, y, [0,1,2])
          end
        end
      end
    end
  end
end
