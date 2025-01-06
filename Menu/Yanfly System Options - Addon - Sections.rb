# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Yanfly System Options - Sections       ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Separate items into sections                ║    17 Nov 2024     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Yanfly System Options                                    ║
# ║ Supports: Yanfly System Options Full screen addon                  ║
# ║ Supports: Roninator2 System Options Lists addon                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Create categories for the options to separate them           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Edit the categories below to suit your game                      ║
# ║   Items used need to match Yanfly System Options list              ║
# ║     as this script will overwrite options not selected if          ║
# ║     they have been entered in here                                 ║
# ║ Script Order:                                                      ║
# ║    Yanfly System Options                                           ║
# ║    Roninator2 System Options Lists addon (if used)                 ║
# ║    This script                                                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 17 Nov 2024 - Script finished                               ║
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

module YEA
  module SYSTEM
    SECTIONS =[
      :window_settings,
      :sound_settings,
      :switches, # comment out if not using switches
      :variables, # comment out if not using variables
#~       :lists,  # only for my list expansion script
      :custom1,
      :custom2,
    ] # Do not remove this.
    
    CUSTOM_LISTS ={} # delete this line if you use my list expansion script
    
    SECTIONS_COMMANDS ={
      :window_settings  => [:window_red,
                            :window_grn,
                            :window_blu,
                           ],
      :sound_settings   => [:volume_bgm,
                            :volume_bgs,
                            :volume_sfx,
                            ],
      :switches         => [:switch_1,
                            :switch_2,
                            ],
      :lists            => [:list_1,
                            :list_2,
                            ],
      :variables        => [:variable_1,
                            :variable_2,
                            ],
      :custom1          => [:autodash,
                            :instantmsg,
                            :animations,
                            ],
      :custom2          => [:to_title,
                            :shutdown,
                            ],
    } # Do not remove this.
    
    SECTION_VOCAB ={
    # -------------------------------------------------------------------------
    # :command    => ["Command Name"],
    # -------------------------------------------------------------------------
      :window_settings      => ["Window"],
    # -------------------------------------------------------------------------
      :sound_settings       => ["Sound"],
    # -------------------------------------------------------------------------
      :switches             => ["Switches"],
    # -------------------------------------------------------------------------
      :variables            => ["Variables"],
    # -------------------------------------------------------------------------
      :lists                => ["Lists"],
    # -------------------------------------------------------------------------
      :custom1              => ["Marvelous"],
    # -------------------------------------------------------------------------
      :custom2              => ["Last One"],
    # -------------------------------------------------------------------------
    } # Do not remove this.
    
    SWAP_MESSAGE = "Press Q or W to switch <- category ->"
  end
end
# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

#==============================================================================
# ■ Window_SystemOptions
#==============================================================================

class Window_SystemOptions < Window_Command
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(help_window, section_window)
    @section = 0
    @help_window = help_window
    @section_window = section_window
    super(0, @help_window.height + @section_window.height)
    refresh
    change_color(system_color)
    draw_text(0,height - 56,Graphics.width,24, YEA::SYSTEM::SWAP_MESSAGE, 0)
  end
  
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height; return Graphics.height - @help_window.height - @section_window.height; end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    @help_descriptions = {}
    sym = YEA::SYSTEM::SECTIONS[@section]
    for command in YEA::SYSTEM::SECTIONS_COMMANDS[sym]
      case command
      when :blank
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :window_red, :window_grn, :window_blu
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :volume_bgm, :volume_bgs, :volume_sfx
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :autodash, :instantmsg, :animations
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :to_title, :shutdown
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      #--------------------------------------------------------------------------
      #  Fullscreen++ Add-on
      #--------------------------------------------------------------------------
      when :fullscreen, :ratio
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      #--------------------------------------------------------------------------
      #  Fullscreen++ Add-on
      #--------------------------------------------------------------------------
      else
        process_custom_list(command) if !YEA::SYSTEM::CUSTOM_LISTS.empty?
        process_custom_switch(command)
        process_custom_variable(command)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # find group to contol
  #--------------------------------------------------------------------------
  def swap(index)
    @section = index
    select(0)
    refresh
    change_color(system_color)
    draw_text(0,height - 56,Graphics.width,24, YEA::SYSTEM::SWAP_MESSAGE, 0)
  end

end

#==============================================================================
# ■ Window_SystemSections
#==============================================================================

class Window_SystemSections < Window_HorzCommand
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(help_window)
    @help_window = help_window
    super(0, @help_window.height)
    self.deactivate
    refresh
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return Graphics.width; end
  
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height; return fitting_height(1); end

  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    for command in YEA::SYSTEM::SECTIONS
      add_command(YEA::SYSTEM::SECTION_VOCAB[command][0], command)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Down
  #--------------------------------------------------------------------------
  def cursor_pagedown(wrap = false)
    if col_max >= 2 && (index < item_max - 1 || (wrap && horizontal?))
      select((index + 1) % item_max)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Up
  #--------------------------------------------------------------------------
  def cursor_pageup(wrap = false)
    if col_max >= 2 && (index > 0 || (wrap && horizontal?))
      select((index - 1 + item_max) % item_max)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Move Cursor Right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
  end
  
  #--------------------------------------------------------------------------
  # * Move Cursor Left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
  end
  
end

class Scene_System < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # start
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_section_window
    create_command_window
  end
  
  #--------------------------------------------------------------------------
  # create_command_window
  #--------------------------------------------------------------------------
  def create_section_window
    @section_window = Window_SystemSections.new(@help_window)
    @section_window.deactivate
  end
  
  #--------------------------------------------------------------------------
  # create_command_window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_SystemOptions.new(@help_window, @section_window)
    @command_window.set_handler(:cancel, method(:return_scene))
    @command_window.set_handler(:to_title, method(:command_to_title))
    @command_window.set_handler(:shutdown, method(:command_shutdown))
    @command_window.set_handler(:pagedown, method(:swap_left))
    @command_window.set_handler(:pageup, method(:swap_right))
  end
  
  #--------------------------------------------------------------------------
  # swap_left
  #--------------------------------------------------------------------------
  def swap_left
    @section_window.activate
    @section_window.cursor_pagedown
    @command_window.swap(@section_window.index)
    @section_window.deactivate
    @command_window.activate
  end
  
  #--------------------------------------------------------------------------
  # swap_right
  #--------------------------------------------------------------------------
  def swap_right
    @section_window.activate
    @section_window.cursor_pageup
    @command_window.swap(@section_window.index)
    @section_window.deactivate
    @command_window.activate
  end
  
end
