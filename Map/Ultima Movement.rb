# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Ultima Movement                        ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Adjust movement                             ║    06 May 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Move 1 tile instantly, do not slide                          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Change the options below to what you want to use                 ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 06 May 2021 - Script finished                               ║
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

module R2_Input_Choice
  Single = true  # used if you want to press the button every time to move.
  Delay = 0.5   # use a range betwwen 0.1 & 1.0
  Sound = "Knock" # Sound effect. Must be an SE sound not BGM or ME.
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Game_CharacterBase
  def distance_per_frame
    32
  end
end

class Game_Player < Game_Character
  def move_by_input
    return if !movable? || $game_map.interpreter.running?
    if R2_Input_Choice::Single
      return unless Input.trigger?(:LEFT) || Input.trigger?(:RIGHT) || 
      Input.trigger?(:UP) || Input.trigger?(:DOWN)
    else
      @tct = Time.now if @tct.nil?
      return unless Time.now > @tct + R2_Input_Choice::Delay
      return unless Input.repeat?(:LEFT) || Input.repeat?(:RIGHT) || 
      Input.repeat?(:UP) || Input.repeat?(:DOWN)
      @tct = Time.now
    end
    move_straight(Input.dir4) if Input.dir4 > 0
    Audio.se_play("Audio/SE/#{R2_Input_Choice::Sound}")
  end
end
