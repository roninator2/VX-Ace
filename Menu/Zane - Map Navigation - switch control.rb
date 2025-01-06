#==============================================================================
#  Script      : Map Navigation
#  Author      : Xane
#  Build       : v1.5
#  Created On  : 12.17.2020
#  Last Update : 12.19.2020
#------------------------------------------------------------------------------
#  Terms and Conditions:
#  Retain this header at all times and do not release any new revisions online
#  without prior consent. You may modify the code below at your own discretion
#  but only for private usage. This script may be used both Non Commercially
#  and Commercially with credit provided.
#------------------------------------------------------------------------------
#  Bugs, Compatibility, and Reporting:
#   Report all bugs to me on the RM forums. Any version prior to the current
#   version is not supported. All bugs steaming from user changes such as
#   modification of code will not be supported. Any compatibility patches
#   will be provided at my own accord and are not guaranteed in any way.
#------------------------------------------------------------------------------
#  Update Log (U - Unreleased | R - Released):
#  1.0(R) - Wrote original version of script.
#  1.1(U) - Added map effects and sprite viewings back in.
#  1.2(U) - Fixed a few bugs.
#  1.3(R) - Rewrote script to use data already provided by RM rather then
#           trying to collect new data. Script will now properly update
#           event data, weather effects, and any pictures display originally
#           in Scene_Map.
#  1.4(R) - Fixed typo error with variable. Added check for display coordinate
#           to check for map edges when maps do not loop.
#  1.5(R) - Fixed some more syntax typos and fixed the check for the display coordinates
#  1.51(U)- Roninator2 edit. Added check for switch to call map
#------------------------------------------------------------------------------
#  Usage:
#  This script is plug-in-play. If you want to access the scene, use the script
#  call "(SceneManager.call(Scene_MapNav)" without quotes in an event or via
#  the main menu if you have another script installed that allows custom
#  commands such as Yanfly's Menu.
#==============================================================================

#==============================================================================
#  ** Xane_MapNavSettings
#------------------------------------------------------------------------------
#  This module handles various settings. New versions may add more settings.
#==============================================================================

module Xane_MapNavSettings

  # Controls how fast you want to move around the map.

  # Use a float point to adjust this setting. The max speed is 1.0
  Nav_Speed = 0.4

  # Set the text to be displayed on the screen.

  # You'll have a max width of 272 pixels to show a string. Consider this
  # when choosing what the message will display.
  Display_Text = 'Press ESC to return'

  # Displays arrows on screen for visual feedback.

  # Arrows use a single image stored inside your 'Graphics/System' folder.
  # The script will then create copies and map them to the edges of the game
  # window. You can also turn off visual feedback if you wish as well as set
  # the value for a 'blink' effect if you want more flare.
  Use_Nav_Arrows = true
  Use_Nav_Blink_Effect = true
  Nav_Arrow_Image = 'Nav_Arrow'

	# Use button to call map
	Map_Button_Switch = 1
	Map_Button = :ALT

end

#==============================================================================
# ** Scene_MapNav
#------------------------------------------------------------------------------
#  This scene allows the player to have a viewing of the map as well as its
# events across the map by scrolling around.
#==============================================================================

class Scene_MapNav < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Included Modules
  #--------------------------------------------------------------------------
  include Xane_MapNavSettings
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    @last_display_x = $game_map.display_x
    @last_display_y = $game_map.display_y
    @display_x = @last_display_x
    @display_y = @last_display_y
    @blink_count = 0
    @speed = [[Nav_Speed, 1.0].min, 0].max
    create_all_sprites
    $game_map.refresh
  end
  #--------------------------------------------------------------------------
  # * Create All Sprites
  #--------------------------------------------------------------------------
  def create_all_sprites
    @spriteset = Spriteset_Map.new
    @text_display = Sprite.new
    @text_display.bitmap = Bitmap.new(272, 48)
    @text_display.bitmap.draw_text(@text_display.bitmap.rect, Display_Text, 1)
    return unless Use_Nav_Arrows
    @nav_arrows = Sprite.new
    @nav_arrows.bitmap = Cache.system(Nav_Arrow_Image)
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    $game_map.update
    update_navigation
    update_all_sprites
    if Input.trigger?(:B) or Input.trigger?(:C)
      SceneManager.return
    end
  end
  #--------------------------------------------------------------------------
  # * Update Navigation
  #--------------------------------------------------------------------------
  def update_navigation
    @display_x -= @speed if Input.press?(:LEFT) && !Input.press?(:RIGHT)
    @display_x += @speed if Input.press?(:RIGHT) && !Input.press?(:LEFT)
    @display_y -= @speed if Input.press?(:UP) && !Input.press?(:DOWN)
    @display_y += @speed if Input.press?(:DOWN) && !Input.press?(:UP)
    @display_x = [0, [@display_x, $game_map.width - $game_map.screen_tile_x].min].max unless $game_map.loop_horizontal?
    @display_y = [0, [@display_y, $game_map.height - $game_map.screen_tile_y].min].max unless $game_map.loop_vertical?
    $game_map.set_display_pos(@display_x, @display_y)
  end
  #--------------------------------------------------------------------------
  # * Update Sprites
  #--------------------------------------------------------------------------
  def update_all_sprites
    @spriteset.update
    @text_display.update
    return unless Use_Nav_Arrows
    @nav_arrows.update
    return unless Use_Nav_Blink_Effect
    @blink_count = (@blink_count + 1) % 40
    @nav_arrows.opacity = 255 if @blink_count < 20
    @nav_arrows.opacity = 0 if @blink_count >= 20
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_all_sprites
    $game_map.set_display_pos(@last_display_x, @last_display_y)
    dispose_variables
  end
  #--------------------------------------------------------------------------
  # * Dispose All Sprites
  #--------------------------------------------------------------------------
  def dispose_all_sprites
    @spriteset.dispose
    @text_display.bitmap.dispose unless @text_display.bitmap.disposed?
    @text_display.dispose
    return unless Use_Nav_Arrows
    @nav_arrows.bitmap.dispose unless @nav_arrows.bitmap.disposed?
    @nav_arrows.dispose
  end
  #--------------------------------------------------------------------------
  # * Dispose Variables * Good Coding Practice *
  #   Any @ variable is always stored in ram. This will free it.
  #--------------------------------------------------------------------------
  def dispose_variables
    @last_display_x = nil
    @last_display_y = nil
    @display_x = nil
    @display_y = nil
    @blink_count = nil
    @speed = nil
    @spriteset = nil
    @text_display = nil
    @nav_arrows = nil
  end
end
class Scene_Map < Scene_Base
  alias test_update update
  def update
    test_update
		if Xane_MapNavSettings::Map_Button_Switch == true
      if Input.trigger?(Xane_MapNavSettings::Map_Button)
        SceneManager.call(Scene_MapNav)
      end
		end
  end
end
