# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Game Over with State on Death          ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Overwrite Game Over Processes               ║    31 Dec 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Call Game Over when state is inflicted                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Configure settings below                                         ║
# ║   Specify the state that will call a game over                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 31 Dec 2021 - Script finished                               ║
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

module R2_State_GameOver
  States = [4, 7]
  Message = "died in a frenzie."
  Act_Name = true  # use actor name in message
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

module BattleManager
  def self.turn_end
    @phase = :turn_end
    @preemptive = false
    @surprise = false
    call_dead_msg
  end
  def self.call_dead_msg
    actbat = nil
    actname = nil
    dthmsg = nil
    @msgcnt = 0 if @msgcnt == nil
    $game_party.battle_members.each do |act|
      if act.dead?
        actbat = $game_actors[act.id]
        actname = act.name
        dthmsg = R2_State_GameOver::Message
        dthmsg = "#{actname} " + R2_State_GameOver::Message if R2_State_GameOver::Act_Name == true
        @msgcnt += 1
      end
      if actbat != nil
        if actbat.dead? && (actbat.states.any? { |st| R2_State_GameOver::States.include?(st.id) } )
          $game_message.add(sprintf(dthmsg, actname)) if @msgcnt >= 1
          wait_for_message
          @msgcnt = 0
          SceneManager.goto(Scene_Gameover) 
        end
      end
    end
  end
end
