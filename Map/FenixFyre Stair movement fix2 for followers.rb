# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Followers on Stairs - alias            ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Script compatibility fix                      ║    31 Jan 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Neon Black Smart Followers                               ║
# ║           FenixFyre Stair Movement                                 ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Followers move with player on stairs                         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Put below both scripts                                           ║
# ║   Fixes glitch where followers do not follow the player on stairs  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 31 Jan 2021 - Script finished                               ║
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
  alias r2_stairs_followers_update  update
  def update
    if $game_player.on_stairs?
      @through = true
      if (Input.dir4 == 6) && (($game_map.region_id(x+1,y+1) != StairsRegionID) && ($game_map.region_id(x+1,y-1) != StairsRegionID))
        @through = false
      end
      if (Input.dir4 == 4) && (($game_map.region_id(x-1,y+1) != StairsRegionID) && ($game_map.region_id(x-1,y-1) != StairsRegionID))
        @through = false
      end
      move_by_input
      @followers.update
      @through = false 
    end
    r2_stairs_followers_update
  end
end
