# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Teleport with button press             ║  Version: 1.03R    ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Perform map movement                        ║    06 Oct 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Allow instant travel with a button                           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║  Do whatever you need to in order to call the command              ║
# ║  an event in parallel process on the map                           ║
# ║  a script that maps a button press, etc.                           ║
# ║                                                                    ║
# ║  Use script command to cause teleport                              ║
# ║  teleport(X)   or   teleport($game_variables[X])                   ║
# ║    will make the player move instantly the number given            ║
# ║    but only if safe to move on the space                           ║
# ║                                                                    ║
# ║  Use comment on event to prevent jumping over event                ║
# ║  Set the text below to what you will use in the event              ║
# ║                                                                    ║
# ║  Range option                                                      ║
# ║  This script will check the player position and all                ║
# ║  tiles in range to determine a safe jump.                          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 06 Oct 2023 - Script finished                               ║
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

module R2_Teleport_Actor_Fixed
  Switch = 1
  Terrain_Tag = 1
  Text = "Block Jump"
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Check Teleport and move
  #--------------------------------------------------------------------------
  def teleport(value = 0)
    return if $game_switches[R2_Teleport_Actor_Fixed::Switch] == false
    xj = 0
    yj = 0
    dir = $game_player.direction
    case dir
    when 2; yj = value
    when 4; xj = -value
    when 6; xj = value
    when 8; yj = -value
    end
    x = $game_player.x + xj
    y = $game_player.y + yj
    clean = $game_map.passable?(x, y, dir)
    safe = !$game_player.collide_with_events?(x, y)
    ceiling = $game_map.terrain_tag(x, y) != R2_Teleport_Actor_Fixed::Terrain_Tag
    block = !check_jump_block(xj, yj)
    if clean && safe && ceiling && block
      $game_player.transparent = true
      $game_player.reserve_transfer($game_map.map_id, x, y, dir)
      $game_player.perform_transfer
      $game_player.transparent = false
    end
  end
  def check_jump_block(xj, yj)
    evb = false
    start = 0
    if (xj < 0) || (yj < 0)
      sxj = xj * -1; syj = yj * -1
      move = sxj if sxj != 0
      move = syj if syj != 0
      move += 1
      move.times do 
        x = xj < 0 ? $game_player.x + start : $game_player.x
        y = yj < 0 ? $game_player.y + start : $game_player.y
        evb = true if check_event_block(x, y)
        start -= 1
      end
    else
      move = xj if xj != 0
      move = yj if yj != 0
      move += 1
      move.times do 
        x = xj > 0 ? $game_player.x + start : $game_player.x
        y = yj > 0 ? $game_player.y + start : $game_player.y
        evb = true if check_event_block(x, y)
        start += 1
      end
    end
    return evb
  end
  def check_event_block(x, y)
    clear = false
    event = $game_map.events_xy(x, y)
    return if event == []
    event[0].list.each do |comm|
      if comm.code == 108 && comm.parameters == [R2_Teleport_Actor_Fixed::Text]
        return true
      end
    end
    return false
  end
end
