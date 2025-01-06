# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Rotate Lock on State         ║  Version: 1.01     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║   Block rotation when inflicted     ╠════════════════════╣
# ║   with a specific state on actor    ║    06 Sep 2022     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║   Specify the states to block rotation function          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Updates:                                                 ║
# ║   2022-Sep-06 - Initial publish                          ║
# ║   2022-Sep-06 - Reversed script function                 ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker VX Ace - except nudity    ║
# ╚══════════════════════════════════════════════════════════╝

module R2_Rotate_Formation_Blocked_States
  States = [3,4]
end
# ╔══════════════════════════════════════════════════════════╗
# ║          End of Editable Region                          ║
# ╚══════════════════════════════════════════════════════════╝

class Game_Party < Game_Unit
  
  def rotate_formation_left
    j = [@actors.size, max_battle_members].min
    loop do
      actor = $game_actors[@actors[0]]
      clean = true
      actor.states.each do |st|
        clean = false if R2_Rotate_Formation_Blocked_States::States.include?(st.id)
      end
      if clean == true
        @actors = @actors[0...j].rotate.concat((@actors[j..-1] || []))
        break
      end
      break if clean == false
    end
    $game_player.refresh
  end
  
  def rotate_formation_right
    j = [@actors.size, max_battle_members].min
    loop do
      actor = $game_actors[@actors[0]]
      clean = true
      actor.states.each do |st|
        clean = false if R2_Rotate_Formation_Blocked_States::States.include?(st.id)
      end
      if clean == true
        @actors = @actors[0...j].rotate(-1).concat((@actors[j..-1] || []))
        break
      end
      break if clean == false
    end
    $game_player.refresh
  end
end
