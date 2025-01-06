# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Mr. Trivel - Crafting Simple - Popup   ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Play sound on Crafting                      ║    16 May 2020     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Mr. Trivel - Crafting Simple                             ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Adds a popup when the item is successfully crafted           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   I designed this for my own game Path of Life                     ║
# ║   The sound was changed to prevent the play_ok from happening      ║
# ║   every single time you pressed a button                           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 16 May 2020 - Script finished                               ║
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
module R2_Trivel_craft_message
  CONFIRM = " crafted!"
end
class Window_Craft_ConfirmPopup < Window_Selectable
  def initialize
    super(320, 300, window_width, window_height)
    self.openness = 0
  end
  def window_width; 320; end
  def window_height; 48; end
  def refresh; end
  def craft_item(item)
    contents.clear
    text1, text2 = item.name, R2_Trivel_craft_message::CONFIRM
    width = contents.text_size(text1 + text2).width + 30
    create_contents
    draw_text(24,1,contents.width,24,text1)
    change_color(normal_color)
    draw_text(24+contents.text_size(text1).width,1,contents.width,24,text2)
    draw_icon(item.icon_index,0,0)
    open
  end
  def process_ok
    if current_item_enabled?
      Input.update
      deactivate
      call_ok_handler
    end
  end
end

class MrTS_Scene_Crafting < Scene_Base
  def create_all_windows
    create_help_window
    create_main_command_window
    create_discipline_info_window
    create_item_list_window
    create_requirements_window
    create_disciplines_command_window
    create_craft_success_window
    @command_window.deactivate
    @discipline_command_window.open
    @discipline_command_window.activate
  end
  def create_craft_success_window
    @craft_success = Window_Craft_ConfirmPopup.new
    @craft_success.set_handler(:ok, method(:craft_ok))
    @craft_success.set_handler(:cancel, method(:craft_ok))
    @craft_success.deactivate
  end
  def craft_ok
    @craft_success.deactivate
    @craft_success.close
    @item_window.activate
  end
  def item_list_ok_on
    check = @requirements_window.check_item
    if !check
      Sound.play_buzzer
      @item_window.activate
    else
      @requirements_window.craft_item
      @requirements_window.refresh
      @discipline_info_window.refresh
      @item_window.refresh
      item = @requirements_window.find_item
      @item_window.deactivate
      @craft_success.craft_item(item)
      @craft_success.activate
      Sound.play_use_item
    end
  end
end

class MrTS_Requirements_Window < Window_Base
  def find_item
    geto = get_true_item(MrTS::Crafting::RECIPES[@recipe][:item])
    return geto[0]
  end
  def check_item
    @item_list.each do |il|
      if $game_party.item_number(il[0]) < il[1]
        return false
      end
    end
    return true
  end
end

class MrTS_Item_Window < Window_Selectable
  def process_ok
    if current_item_enabled?
      Input.update
      deactivate
      call_ok_handler
    end
  end
end
