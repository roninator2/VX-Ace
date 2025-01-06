# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Reset Self Switch for Events           ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Reset Self switch on events                 ╠════════════════════╣
# ║   to have events come back                    ║    02 Jun 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Remove event self switch                                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Change the Text used to stop resetting                           ║
# ║     Text = "Your text"                                             ║
# ║                                                                    ║
# ║   Place a comment on the event page when the event is              ║
# ║   not to reset. Must be on the active event page.                  ║
# ║   For example. first page of event is an enemy                     ║
# ║     Second page is self switch A - when enemy defeated             ║
# ║     Second page is treasure or something else                      ║
# ║     Third page is self switch B - when finished                    ║
# ║     Third page has the comment listed below                        ║
# ║                                                                    ║
# ║     If the event is currently on the third page                    ║
# ║     with the comment below, it will not reset                      ║
# ║     but it if is on the second page, it will reset                 ║
# ║     if the third page does not have the comment                    ║
# ║     it will reset.                                                 ║
# ║                                                                    ║
# ║   Some coded copied from CSCA Dungeon Tools script                 ║
# ║                                                                    ║
# ║   Put in a script call on the event that will transfer             ║
# ║   the player before the transfer command.                          ║
# ║     script: map_reset                                              ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 02 Jun 2023 - Script finished                               ║
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

#==============================================================================
# Configure Message
#==============================================================================
module R2_Skip_Event
  Text = "SKIP_EVENT"
 end
#==============================================================================
# End Configuration
#==============================================================================


#==============================================================================
# Game_Interpreter
#==============================================================================
class Game_Interpreter
  def map_reset
    if SceneManager.scene_is?(Scene_Map)
      $game_map.map_reset
    end
  end
end

#==============================================================================
# Game_Map
#==============================================================================
class Game_Map
  def map_reset
    event_amount = events.size
    for i in 1..event_amount
      next if event_skip(i)
      switches = ["A","B","C","D"]
      for j in switches
        key = [@map_id, i, j]
        $game_self_switches[key] = false
      end
    end
  end
  def event_skip(id)
    events.each do |i, event|
      next if event.nil?
      if event.id == id
        event.list.each do |comm|
          if comm.code == 108 && comm.parameters == [R2_Skip_Event::Text]
            return true
          end
        end
      end
    end
    return false
  end
end
