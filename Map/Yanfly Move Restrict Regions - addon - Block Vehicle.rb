# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Yanfly Move Restrict patch   ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║ Stop vehicle landing if not able to ║    14 Apr 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:  None                                      ║
# ║                                                          ║
# ║    The script simple fixes an issue that a player        ║
# ║    can get off a ship or airship onto a region that      ║
# ║    is configured to block the player.                    ║
# ║                                                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Updates:                                                 ║
# ║   2023-May-16 - Initial publish                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker VX Ace except nudity      ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# ** Game CharacterBase
#==============================================================================
class Game_CharacterBase
  #--------------------------------------------------------------------------
  # new method: vehicle dismount
  #--------------------------------------------------------------------------
  def vehicle_dismount(x, y)
    return false if debug_through?
    region = 0
    region = $game_map.region_id(x, y)
    return true if $game_map.all_restrict_regions.include?(region)
    return true if $game_map.player_restrict_regions.include?(region)
    return true if $game_map.player_block_regions.include?(region)
    return false
  end
  #--------------------------------------------------------------------------
  # new method: airship dismount
  #--------------------------------------------------------------------------
  def airship_dismount(x, y)
    return false if debug_through?
    region = 0
    region = $game_map.region_id(x, y)
    return true if $game_map.all_restrict_regions.include?(region) && @in_air
    return true if $game_map.player_restrict_regions.include?(region)
    return true if $game_map.player_block_regions.include?(region)
    return false
  end
end

#==============================================================================
# ** Game Vehicle
#==============================================================================
class Game_Vehicle
  def land_ok?(x, y, d)
    if @type == :airship
      return false unless $game_map.airship_land_ok?(x, y)
      return false unless $game_map.events_xy(x, y).empty?
      return false if airship_dismount(x, y)
    else
      x2 = $game_map.round_x_with_direction(x, d)
      y2 = $game_map.round_y_with_direction(y, d)
      return false unless $game_map.valid?(x2, y2)
      return false unless $game_map.passable?(x2, y2, reverse_dir(d))
      return false if vehicle_dismount(x2, y2)
      return false if collide_with_characters?(x2, y2)
    end
    return true
  end
end
