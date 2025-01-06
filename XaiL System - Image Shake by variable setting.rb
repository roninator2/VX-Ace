#==============================================================================
#   XaiL System - Image Shake
#   Author: Nicke
#   Created: 25/08/2012
#   Edited: 03/09/2012
#   Version: 1.0a
#==============================================================================
# Instructions
# -----------------------------------------------------------------------------
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ? Materials but above ? Main. Remember to save.
#
# Small snippet to make your picture's shake when the screen is shaking.
# changes the script so that it uses a variable to control the shaking 
# and not the setting in the original script.
# *** Only for RPG Maker VX Ace. ***
#==============================================================================
($imported ||= {})["XAIL-IMAGE-SHAKE"] = true

module XAIL
  module IMG_SHAKE
  #--------------------------------------------------------------------------#
  # * Settings
  #--------------------------------------------------------------------------#
    # Use this to setup which direction the pictures should move when a shaking
    # occurs.
    # x = horizontal
    # y = vertical
    # xy = both
    # "" = none
    # SHAKE_DIRECTION = strng # variable
    # make the variable equal to one of the string options.
    SHAKE_DIRECTION = 1		#"xy"	Roninator2 edit
		# changed to allow changing the setting in game with a variable
		# if the variable is not set, the default is xy
    
    # Switch to manually enable/disable the script.
    # This will disable the script if switch_id is on/true.
    # DISABLE_PIC_SHAKE = switch_id
    DISABLE_PIC_SHAKE = 1
    
  end
end
# *** Don't edit below unless you know what you are doing. ***
#==============================================================================#
# ** Module Sound
#==============================================================================#
class Spriteset_Map
  
    alias xail_img_shake_spriteset_map_upd_viewports update_viewports
    def update_viewports(*args, &block)
      # // Method to when viewports are updating.
      xail_img_shake_spriteset_map_upd_viewports(*args, &block)
			if $game_variables[XAIL::IMG_SHAKE::SHAKE_DIRECTION] != "x" || "y" || "xy" || ""
			# roninator2 edit
				$game_variables[XAIL::IMG_SHAKE::SHAKE_DIRECTION] = "xy"
			end
      return if $game_switches[XAIL::IMG_SHAKE::DISABLE_PIC_SHAKE]
      case XAIL::IMG_SHAKE::SHAKE_DIRECTION
      when "x" 
        @viewport2.ox = $game_map.screen.shake
      when "y" 
        @viewport2.oy = $game_map.screen.shake
      when "xy"  
        @viewport2.ox = $game_map.screen.shake
        @viewport2.oy = $game_map.screen.shake
      end
    end
    
end # END OF FILE

#=*==========================================================================*=#
# ** END OF FILE
#=*==========================================================================*=#
