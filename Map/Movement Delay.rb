# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Movement Delay                         ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   The player is slow to start                 ╠════════════════════╣
# ║   moving and slow to stop                     ║    16 Sep 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Player gradually speeds up and slows down                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Plug and play                                                    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 16 Sep 2022 - Script finished                               ║
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

module R2_MOVE_DELAY
  Delay_Move = 60
  Delay_Rate = 30
 #-----------------------------------------------------------
 # Note: works best when kept over 5 and under 10.
 #-----------------------------------------------------------
 SWITCH = 1 # turn script function on/off. Switch on == script on
end

class Game_Player
  alias :init_r2_public_data_movement :initialize
  def initialize
    init_r2_public_data_movement
    @move_original = @move_speed
    @slow_time = R2_MOVE_DELAY::Delay_Move
    @fast_time = 0
  end
  alias :update_r2_delay_move :update
  def update
    update_r2_delay_move
    update_delay_move if $game_switches[R2_MOVE_DELAY::SWITCH] == true
    @slow_time -= 1 unless @slow_time <= 0
    @fast_time += 1 unless @fast_time >= R2_MOVE_DELAY::Delay_Move
  end
  def update_delay_move
    if moving? && @slow_time > 0
      @move_speed = @move_original - (@slow_time / R2_MOVE_DELAY::Delay_Rate) unless @slow_time == 0
    elsif !moving? && @fast_time < R2_MOVE_DELAY::Delay_Move
      @move_speed = @move_original - (@fast_time / R2_MOVE_DELAY::Delay_Rate) unless @fast_time == R2_MOVE_DELAY::Delay_Move
    end
    if @slow_time <= 0 && Input.dir4 == 0 && @fast_time >= R2_MOVE_DELAY::Delay_Move
      @fast_time = 0
      @slow_time = R2_MOVE_DELAY::Delay_Move
    end
  end
  def update_original
    @move_original = @move_speed
  end
end
