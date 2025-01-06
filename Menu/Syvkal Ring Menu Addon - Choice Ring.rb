# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Syvkal Ring Menu Addon - Choice Ring   ║  Version: 1.03     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║    Add ring menu to choice window             ╠════════════════════╣
# ║    Adjusts to choice size                     ║    31 Dec 2020     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Syvkal Ring Menu Script                                  ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Allow ring menu for choices                                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Script will automatically place icons for each choice            ║
# ║   option that is provided. Requires Syvkal's Ring Menu             ║
# ║   Tested with Hime Large choices                                   ║
# ║   Icons are placed in the pictures folder.                         ║
# ║   Icons must be in the format of ''choice' + space + icon'         ║
# ║   example                                                          ║
# ║    'yes icon'.png or 'no icon'.png  - without quotes               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.01 - 01 Jan 2021 - Added Background blur                         ║
# ║ 1.02 - 02 Jan 2021 - Changed to overwrite ChoiceList               ║
# ║ 1.03 - 02 Jan 2021 - Centered ChoiceList on Player                 ║
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

module Ring_Menu
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(*args)
    super(*args)
    @cx = $game_player.screen_x - 16
    @cy = $game_player.screen_y - 28
    self.opacity = 0
    @startup = STARTUP_FRAMES
    @icons = []
    @mode = :start
    @steps = @startup
  end
end

class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    @cx = $game_player.screen_x - 16
    @cy = $game_player.screen_y - 28
    rect = Rect.new(@cx - 254, @cy, self.contents.width, line_height)
    draw_text(rect, command_name(index), 1)
  end
end

#==============================================================================
# ** Window_ChoiceList_Ring
#------------------------------------------------------------------------------
#  This window is used for the event command [Show Choices].
#==============================================================================
class Window_ChoiceList < Window_Command
  #--------------------------------------------------------------------------
  # * Includes The Ring_Menu Module
  #--------------------------------------------------------------------------
  include Ring_Menu
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(message_window)
    @message_window = message_window
    super(0, 0)
    self.openness = 0
    deactivate
    @mode = :wait
  end
  #--------------------------------------------------------------------------
  # * Start Input Processing
  #--------------------------------------------------------------------------
  def start
    @cx = $game_player.screen_x - 16
    @cy = $game_player.screen_y - 28
    @icons = []
    @choices = []
    make_command_list
    make_choice_list
    select(0)
    open
    activate
    create_background
    refresh
  end
  #--------------------------------------------------------------------------
  # * Make_choice_list
  #--------------------------------------------------------------------------
  def make_choice_list
    $game_message.choices.each_with_index do |choice, i|
      @icons.push(Cache::picture(choice + ' Icon'))
      @choices.push(choice)
      @cx = $game_player.screen_x - 16
      @cy = $game_player.screen_y - 28
      rect = Rect.new(@cx, @cy, @icons[i].width / 2, @icons[i].height / 2)
      draw_item(rect.x, rect.y, i)
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    @cx = $game_player.screen_x - 16
    @cy = $game_player.screen_y - 28
    rect = Rect.new(@cx - 254, @cy, self.contents.width, line_height)
    draw_text(rect, choice_name(index), 1)
  end
  #--------------------------------------------------------------------------
  # * Make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
     $game_message.choices.each do |choice|
      add_command(choice, :choice)
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
  # * Get Maximum Width of Choices
  #--------------------------------------------------------------------------
  def max_choice_width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  def contents_height
    Graphics.height
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Cancel Processing
  #--------------------------------------------------------------------------
  def cancel_enabled?
    $game_message.choice_cancel_type > 0
  end
  #--------------------------------------------------------------------------
  # * Get Command Name
  #--------------------------------------------------------------------------
  def choice_name(index)
    return if @choices == nil
    @choices[index]
  end
  #--------------------------------------------------------------------------
  # * Call OK Handler
  #--------------------------------------------------------------------------
  def call_ok_handler
    $game_message.choice_proc.call(index)
    close
    clean_choices
  end
  #--------------------------------------------------------------------------
  # * Call Cancel Handler
  #--------------------------------------------------------------------------
  def call_cancel_handler
    $game_message.choice_proc.call($game_message.choice_cancel_type - 1)
    close
    clean_choices
  end
  #--------------------------------------------------------------------------
  # * Clear choice lists
  #--------------------------------------------------------------------------
  def clean_choices
    $game_message.choices.clear
    @list.clear
    dispose_background
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     i     : item number
  #--------------------------------------------------------------------------
  def draw_item(x, y, i)
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
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    SceneManager.snapshot_for_background
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  #--------------------------------------------------------------------------
  # * Free Background
  #--------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose
  end
end
