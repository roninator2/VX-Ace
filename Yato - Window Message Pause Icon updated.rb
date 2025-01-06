# -*- coding: utf-8 -*-
#==============================================================================
# Window Message Pause Icon
# Created: 11/11/2013 by Yato (Racheal)
# Updated: 27/06/2018 by Leonardo Ark (ArkDG)
# Modded: 25/06/2019 by roninator2
# Instructions:
# * Insert in the Materials section
# * Configure to your liking below
#==============================================================================
# Compatibility:
# This script is for RPG Maker VX Ace
#==============================================================================
=begin
Originally designed by Yato(Racheal) and modified by me (Leonardo Ark)
Release Date: 06/27/2018

Yato's profile at RPGMakerWeb.com: https://forums.rpgmakerweb.com/index.php?members/yato.587/
PLEASE, Credit her in your game, not me.

Set the variable you wish to use for the position and the variable name.
Change the icon by changing the variable. Must be in quotes

Terms of Use
* Contact Yato for commercial use
* No real support. The script is provided as-is
* No bug fixes, no compatibility patches
* Preserve this header

=end

class Window_Message < Window_Base

####### CUSTOMIZATION HERE #######
@@sprite_name = "pauseicon" #should be in /Graphics/System - Must be in quotes "pauseicon"
@@sprite_var = 11 #variable used to change the graphic file
@@sprite_cell_width = 16 #the original is 16, but you can make a img with any cell size
@@sprite_cell_height = 16 #the original is 16, but you can make a img with any cell size
@@pause_pos_x = 12 #start at right corner of the screen. The higher the number, more to the left
@@pause_pos_y = 4 #start at bottom of the screen. The higher the number, more to the top
@@pause_var = 10 #variable to set position. 0 = right, 1 = center, 2 = left
#### END OF THE CUSTOMIZATION ####
@@sprite_pause = nil

#--------------------------------------------------------------------------
# * Initialize
#--------------------------------------------------------------------------
  alias move_pause_graphic_initialize initialize
  def initialize
    if $game_variables[@@sprite_var] != @@sprite_pause
      $game_variables[@@sprite_var] = @@sprite_name
      @@sprite_pause = @@sprite_name
    end
    move_pause_graphic_initialize
    make_pause_sprite
  end
#--------------------------------------------------------------------------
# * Free
#--------------------------------------------------------------------------
  alias move_pause_graphic_dispose dispose
  def dispose
    move_pause_graphic_dispose
    @pause_sprite.dispose
  end
#--------------------------------------------------------------------------
# * Make Pause Sprite
#--------------------------------------------------------------------------
  def make_pause_sprite
    @pause_sprite = Sprite.new
    @pause_sprite.bitmap = Cache.system(@@sprite_pause)
    @pause_sprite.src_rect = Rect.new(0, 0, @@sprite_cell_width, @@sprite_cell_height)
    @pause_sprite.z = self.z + 10
    @pause_sprite.visible = false
  end
#--------------------------------------------------------------------------
# * Frame Update
#--------------------------------------------------------------------------
  alias move_pause_graphic_update update
  def update
    if $game_variables[@@sprite_var] != @@sprite_pause
      @@sprite_pause = $game_variables[@@sprite_var]
      @pause_sprite.dispose
      make_pause_sprite
    end
    move_pause_graphic_update
    update_pause_sprite if @pause_sprite.visible
  end
#--------------------------------------------------------------------------
# * Frame Update
#--------------------------------------------------------------------------
  def update_pause_sprite
    frame = Graphics.frame_count % 60 / 15
    @pause_sprite.src_rect.x = 0 + @@sprite_cell_width * (frame % 2)
    @pause_sprite.src_rect.y = 0 + @@sprite_cell_height * (frame / 2)
  end
#--------------------------------------------------------------------------
# * Set Pause
#--------------------------------------------------------------------------
  def pause=(pause)
    if $game_variables[@@pause_var] == 0
      @pause_sprite.x = self.x + self.width - padding - @@pause_pos_x
      @pause_sprite.y = self.y + self.height - padding - @@pause_pos_y
      @pause_sprite.visible = pause
    elsif $game_variables[@@pause_var] == 1
      @pause_sprite.x = Graphics.width / 2
      @pause_sprite.y = self.y + self.height - padding - @@pause_pos_y
      @pause_sprite.visible = pause
    else
      @pause_sprite.y = self.y + self.height - padding - @@pause_pos_y
      @pause_sprite.visible = pause
    end
  end
end
