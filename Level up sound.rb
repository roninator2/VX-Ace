# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Level Up Sounds                        ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Play a sound on level up                    ║    20 Oct 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Change the name of the sound file to play                        ║
# ║   Supports what file type you make VXA support                     ║
# ║                                                                    ║
# ║   Change the option to play the file or not                        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 20 Oct 2020 - Script finished                               ║
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

module R2_Level_Up_Sound
 
  #Name of the ME to play.
  ME = "Item"
  PLAY_ME = false
  
  #Name of the SE to play.
  SE = "Laser"
  PLAY_SE = true
  
  #Switch used to control playing the sound once
  SWITCH = 1
  
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

#==============================================================================
# ** BattleManager
#==============================================================================
module BattleManager
  #--------------------------------------------------------------------------
  # * EXP Acquisition and Level Up Display
  #--------------------------------------------------------------------------
  class << self
    alias r2_gain_exp_sound gain_exp
  end
  def self.gain_exp
    $game_switches[R2_Level_Up_Sound::SWITCH] = true
    r2_gain_exp_sound
    $game_switches[R2_Level_Up_Sound::SWITCH] = false
  end
end

#==============================================================================
# ** Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Level Up
  #--------------------------------------------------------------------------
  alias r2_level_up_sounds_actor level_up
  def level_up
    if $game_switches[R2_Level_Up_Sound::SWITCH] == true
      Audio.se_play("Audio/SE/" + R2_Level_Up_Sound::SE, 100, 100) if R2_Level_Up_Sound::PLAY_SE
      Audio.me_play("Audio/ME/" + R2_Level_Up_Sound::ME, 100, 100) if R2_Level_Up_Sound::PLAY_ME
    end
    $game_switches[R2_Level_Up_Sound::SWITCH] = false
    r2_level_up_sounds_actor
  end
end

#==============================================================================
# ** Game_Interpreter
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Change EXP
  #--------------------------------------------------------------------------
  alias r2_gain_exp_315 command_315
  def command_315
    $game_switches[R2_Level_Up_Sound::SWITCH] = true
    r2_gain_exp_315
    $game_switches[R2_Level_Up_Sound::SWITCH] = false
  end
end
