# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Actor Command Adjust                   ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Require Item to use Target Info             ║    17 Feb 2024     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires:                                                          ║
# ║        nil                                                         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║         add command lines                                          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Change the number for how many lines you will add                ║
# ║   to the actor command window                                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 17 Feb 2024 - Script finished                               ║
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

module R2_command_size
  Command_lines = 1
  # number of commands added on. Normally 4 commands are shown
  # setting this to 1 will add a fifth line
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Window_ActorCommand < Window_Command
  def visible_line_number
    value = R2_command_size::Command_lines
    value += 4
    return value
  end
end

class Scene_Battle < Scene_Base
  alias r2_create_status_win_92bv   create_status_window
  def create_status_window
    r2_create_status_win_92bv
    @status_window.y += (R2_command_size::Command_lines * 24)
  end
  alias r2_create_info_view_92vne    create_info_viewport
  def create_info_viewport
    r2_create_info_view_92vne
    @info_viewport.rect.y = Graphics.height - @status_window.height - (R2_command_size::Command_lines * 24)
    @info_viewport.rect.height = @status_window.height + (R2_command_size::Command_lines * 24)
  end
  alias r2_create_party_win_29bfu   create_party_command_window
  def create_party_command_window
    r2_create_party_win_29bfu
    @party_command_window.y += (R2_command_size::Command_lines * 24)
  end
  alias r2_create_enemy_win_924vb   create_enemy_window
  def create_enemy_window
    r2_create_enemy_win_924vb
    @enemy_window.y += (R2_command_size::Command_lines * 24)
  end
end
