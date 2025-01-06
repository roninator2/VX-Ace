# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Battle log input pause wait            ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Battle log pause for button input             ║    14 Feb 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║        Make the Battle Log pause for Input                         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Plug & play                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 14 Feb 2022 - Script finished                               ║
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

module R2_BattleLog_Wait
	PAUSE_SWITCH = 12 # turn on to use
	PRESS_KEY = :C	# Button to press to continue log
	# :C = Z, :B = X, :A = SHIFT, :X = A, :Y = S, :Z = D, :L = Q, :R = W
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Window_BattleLog < Window_Selectable
  def clear
		if $game_switches[R2_BattleLog_Wait::PAUSE_SWITCH] == true
    if @lines.size > 0
      loop do
        Input.update
        if Input.press?(R2_BattleLog_Wait::PRESS_KEY)
          break
        end
      end
    end
		end
    @num_wait = 0
    @lines.clear
    refresh
  end
  def back_one
		if $game_switches[R2_BattleLog_Wait::PAUSE_SWITCH] == true
    if @lines.size > 0
      loop do
        Input.update
        if Input.press?(R2_BattleLog_Wait::PRESS_KEY)
          break
        end
      end
    end
		end
    @lines.pop
    refresh
  end
end
