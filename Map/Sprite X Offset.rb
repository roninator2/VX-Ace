# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Sprite X offset                        ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Make sprites move on x axis                   ║    10 Sep 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Adjust sprite X position                                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║   Add a { ("curly bracket") to the filename                        ║
# ║   Add a + ("plus sign") to the filename                            ║
# ║                                                                    ║
# ║   The script will move the sprite if it finds the {                ║
# ║   The sprite will move 16 pixels to the right for                  ║
# ║   every + that is in the filename                                  ║
# ║                                                                    ║
# ║   e.g. !${+_filename.png                                           ║
# ║     this will move the sprite 16 pixels to the right               ║
# ║        !${++_filename.png                                          ║
# ║     this will move the sprite 32 pixels to the right               ║
# ║                                                                    ║
# ║   Also supports - sign                                             ║
# ║   e.g. !${-_filename.png                                           ║
# ║     this will move the sprite 16 pixels to the left                ║
# ║        !${--_filename.png                                          ║
# ║     this will move the sprite 32 pixels to the left                ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 10 Sep 2023 - Script finished                               ║
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

module R2_Sprite_Offset_X_Adjust
  Value = 16 # how many pixels it will move for each sign
end

class Game_CharacterBase
  #--------------------------------------------------------------------------
  # * Get Number of Pixels to Shift Up from Tile Position
  #--------------------------------------------------------------------------
  def shift_x
    @character_name[/{/] ? shift_plus_x * R2_Sprite_Offset_X_Adjust::Value : 0
  end
  #--------------------------------------------------------------------------
  # * Determine Object Character
  #--------------------------------------------------------------------------
  def shift_plus_x
    sx = 0
    for x in @character_name.split("+")
      sx += 1
    end
    for x in @character_name.split("-")
      sx -= 1
    end
    return sx
  end
  #--------------------------------------------------------------------------
  # * Get Screen X-Coordinates
  #--------------------------------------------------------------------------
  def screen_x
    $game_map.adjust_x(@real_x) * 32 + 16 + shift_x
  end
end
