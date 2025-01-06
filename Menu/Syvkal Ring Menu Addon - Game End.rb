# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Syvkal Ring Menu Addon - Game End      ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║        Add Ring Menu to Game End              ║    02 Jan 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Syvkal's Ring Menu                                       ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Allow Ring Menu for Game End                                 ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Using code from Syvkal's Ring Menu                               ║
# ║   I created the game end screen menu                               ║
# ║                                                                    ║
# ║   If other options are added, it will require changes.             ║
# ║   Icons must be in the format of ''choice' + space + icon'         ║
# ║   example                                                          ║
# ║    'yes icon'.png or 'no icon'.png  - without quotes               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 02 Jan 2021 - Initial publish                               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Syvkal                                                           ║
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
# ** Window_GameEnd
#------------------------------------------------------------------------------
#  This window is for selecting Go to Title/Shut Down on the game over screen.
#==============================================================================
class Window_GameEnd < Window_Command
  #--------------------------------------------------------------------------
  # * Includes The Ring_Menu Module
  #--------------------------------------------------------------------------
  include Ring_Menu
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    @cx = $game_player.screen_x - 16
    @cy = $game_player.screen_y - 28
    @icons = []
    @endcom = []
    @list.clear
    make_command_list
    make_game_end_icons
    select(0)
    self.opacity = 0
    @mode = :start
    open
    activate
    refresh
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    @cx = $game_player.screen_x - 16
    @cy = $game_player.screen_y - 28
    rect = Rect.new(@cx - 254, @cy - 20, self.contents.width, line_height)
    draw_text(rect, choice_name(index), 1)
  end
  #--------------------------------------------------------------------------
  # * Determines if is moving
  #--------------------------------------------------------------------------
  def animation?
    return @mode != :wait
  end
  #--------------------------------------------------------------------------
  # * make_title_icons
  #--------------------------------------------------------------------------
  def make_game_end_icons
    @endcom.each_with_index do |command, i|
      @icons.push(Cache::picture(command + ' Icon'))
      rect = Rect.new(self.x, self.y, @icons[i].width / 2, @icons[i].height / 2)
      draw_item(x, y, i)
    end
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    return Graphics.height
  end 
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    @endcom = []
    add_command(Vocab::to_title, :to_title)
    add_command(Vocab::shutdown, :shutdown)
    add_command(Vocab::cancel,   :cancel)
    @endcom.push(Vocab::to_title)
    @endcom.push(Vocab::shutdown)
    @endcom.push(Vocab::cancel)
  end
  #--------------------------------------------------------------------------
  # * Get Command Name
  #--------------------------------------------------------------------------
  def choice_name(index)
    return if @endcom == nil
    @endcom[index]
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     i     : item number
  #--------------------------------------------------------------------------
  def draw_item(x, y, i)
    return if @icons.nil?
    rect = Rect.new(0, 0, @icons[i].width, @icons[i].height)
    if i == index
      self.contents.blt(x - rect.width/2, y - rect.height/2, @icons[i], rect )
      unless command_enabled?(index)
        self.contents.blt(x - rect.width/2, y - rect.height/2, ICON_DISABLE, rect )
      end
    else
      self.contents.blt(x - rect.width/2, y - rect.height/2, @icons[i], rect, 128 )
    end
  end
end
