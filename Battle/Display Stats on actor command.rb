# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Stat display on Actor Command          ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║         Provide display option                ╠════════════════════╣
# ║                                               ║    03 Aug 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║      Display actor stats in window During actor command selection  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Change Params below for the stats you want to display            ║
# ║    0 = HP   ;   1 = MP                                             ║
# ║    2 = ATK  ;   3 = DEF                                            ║
# ║    4 = MAT  ;   5 = MDF                                            ║
# ║    6 = AGI  ;   7 = LUK                                            ║
# ║   Change window position and width                                 ║
# ║   Change Actor Name colour                                         ║
# ║   Change Stat Colours                                              ║
# ║   Stat colours must correcpond to the stats in the array           ║
# ║      e.g. Param = [2,3]                                            ║
# ║           Stat_Colours = [15,29]                                   ║
# ║  param 2 will be in colour 15, param 3 will be colour 29           ║
# ║    All Colours come from the windowskin graphic                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 03 Aug 2022 - Script finished                               ║
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

module R2_List_Param_display
  Params = [2,3,4,5]
  Window_X = 0
  Window_Y = 100
  Window_Width = 100
  Set_Actor_Name_Colour = true
  Actor_Colour = 21
  Set_Stat_Colour = false
  Stat_Colours = [3,8,18,31]
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Window_Status_Blank < Window_Base
  def initialize
    x = R2_List_Param_display::Window_X
    y = R2_List_Param_display::Window_Y
    w = R2_List_Param_display::Window_Width + standard_padding
    h = (R2_List_Param_display::Params.size + 1) * line_height + standard_padding * 2
    super(x, y, w, h)
    self.z = 20
    hide
    @actor = nil
    @param_data = ["HP", "MP", "ATK", "DEF", "MAT", "MDF", "AGI", "LUK"]
  end
  def setup(actor)
    @actor = actor
    create_contents
    show_data
    open
    show
  end
  def show_data
    y = 0
    x = 0
    w = R2_List_Param_display::Window_Width - standard_padding
    height = line_height
    if R2_List_Param_display::Set_Actor_Name_Colour == true
      change_color(text_color(R2_List_Param_display::Actor_Colour))
      draw_text(x, y, w, height, @actor.name, 0)
      change_color(normal_color)
    else
      draw_actor_name(@actor, x, y, w)
    end
    y += line_height# + standard_padding
    R2_List_Param_display::Params.each_with_index do |pp, i|
      stat = "#{@param_data[pp]}:"
      value = "#{@actor.param(pp)}"
      if R2_List_Param_display::Set_Stat_Colour == true
        change_color(text_color(R2_List_Param_display::Stat_Colours[i]))
      end
      draw_text(x, y, w, height, stat, 0)
      change_color(normal_color)
      draw_text(x, y, w, height, value, 2)
      y += line_height
    end
    change_color(normal_color)
  end
end

class Scene_Battle < Scene_Base
  alias r2_create_status_back_all_windows create_all_windows
  def create_all_windows
    r2_create_status_back_all_windows
    create_status_back_window
  end
  def create_status_back_window
    @status_back_window = Window_Status_Blank.new
  end
  alias r2_actor_command_show_status  start_actor_command_selection
  def start_actor_command_selection
    r2_actor_command_show_status
    @status_back_window.setup(BattleManager.actor)
  end
  alias r2_turn_start_display_actor_status_data turn_start
  def turn_start
    @status_back_window.close
    r2_turn_start_display_actor_status_data
  end
end
