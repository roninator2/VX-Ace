# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Menu Command Help Text                 ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Show text for Commands in the Menu            ║    28 Dec 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Show Menu Text for Commands                                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║  Add the command symbol below and write the text to show           ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 22 Nov 2024 - Script finished                               ║
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

module R2_Menu_Help_Command_Text
  Commands = {
            :item       => "Use an Item",
            :skill      => "Choose a Skill",
            :equip      => "Put on Clothes",
            :status     => "Look in the Mirror",
            :formation  => "Who's the Boss",
            :save       => "Journaling are we?",
            :game_end   => "Too much for you?",
            }
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

#==============================================================================
# ** Sub Window for character selection adjustment
#==============================================================================
class Scene_ItemBase < Scene_MenuBase
  def show_sub_window(window)
    width_remain = Graphics.width - window.width
    window.x = cursor_left? ? width_remain : 0
    @viewport.rect.x = @viewport.ox = cursor_left? ? 0 : window.width
    @viewport.rect.width = width_remain
    window.height = Graphics.height
    window.show.activate
  end
end

#==============================================================================
# ** Window_Menu_Help
#==============================================================================
class Window_Menu_Help < Window_Help
  def initialize(x, y, width, height)
    super(fitting_height(1))
    self.x = x
    self.y = y
    self.width = width
    self.height = 48
  end
  def create_contents
    contents.dispose
    self.contents = Bitmap.new(self.width - 196, fitting_height(1) - 24)
  end
  def set_command_text(index, cur_sym)
    set_text(index > -1 ? R2_Menu_Help_Command_Text::Commands[cur_sym] : "")
  end
end

#==============================================================================
# ** Window_MenuStatus
#==============================================================================
class Window_MenuStatus < Window_Selectable
  def window_height
    Graphics.height - 48
  end
  def item_height
    (window_height - standard_padding * 2) / 3
  end
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height - 15
    rect.x = index % col_max * (item_width + spacing)
    rect.y = index / col_max * item_height
    rect
  end
end
#==============================================================================
# ** Window_MenuCommand
#==============================================================================
class Window_MenuCommand < Window_Command
  def update_help
    @help_window.set_command_text(index, current_symbol)
  end
end

#==============================================================================
# ** Scene_Menu
#==============================================================================
class Scene_Menu < Scene_MenuBase
  alias r2_menu_help_87fh_start start
  def start
    create_help_window
    r2_menu_help_87fh_start
  end
  def create_help_window
    y = Graphics.height - 48
    w = Graphics.width - 160
    @help_window = Window_Menu_Help.new(160, y, w, 48)
  end
  alias r2_command_help_window_92g7b  create_command_window
  def create_command_window
    r2_command_help_window_92g7b
    @command_window.help_window = @help_window
  end
end
