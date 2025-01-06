=begin
===============================================================================
 DT's Difficulty New Game Plus Add-On v1.0 (13/12/2019)
-------------------------------------------------------------------------------
 Created By: Roninator2 
 Credit: Shadowmaster/Shadowmaster9000/Shadowpasta
 (www.crimson-castle.co.uk)
 Special Thanks: Yanfly (For Yanfly's New Game Plus)
 
===============================================================================
 Information
-------------------------------------------------------------------------------
 This script is an add-on for DT's Difficulty script and Yanfly's New
 Game Plus script which allows you to save the Difficulty to
 be carried over to a new save file.
 
===============================================================================
 How to Use
-------------------------------------------------------------------------------
 Place this script under Materials and below Yanfly's New Game Plus.
 
===============================================================================
 Required
-------------------------------------------------------------------------------
 DT's Difficulty
 http://rmrk.net/index.php?topic=46302.0

 Yanfly's New Game Plus (which also requires Yanfly's Save Engine)
 (http://yanflychannel.wordpress.com/rmvxa/menu-scripts/ace-save-engine/new-game/)
 
 This script is intended to be an add-on for DT's Difficulty and Yanfly's New
 Game Plus. This script is not a standalone script.

===============================================================================
=end
$imported = {} if $imported.nil?
$imported["TODDDIFFICULTYNGP"] = true

module TODDDIFFICULTY_NGP
  
#==============================================================================
# ** Carry Over Settings
#------------------------------------------------------------------------------
#==============================================================================
  
  Carry_Over_Difficulty = true
  
end

#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  This module manages the database and game objects. Almost all of the 
#  global variables used by the game are initialized by this module.
#==============================================================================

module DataManager
  #--------------------------------------------------------------------------
  # * Alias: ngp_reset_party
  #--------------------------------------------------------------------------
  class <<self; alias todddifficulty_ngp_reset_party ngp_reset_party; end
  def self.ngp_reset_party
    ngp_difficulty_level = $game_system.todd_difficulty
    todddifficulty_ngp_reset_party
    $game_system.todd_difficulty = ngp_difficulty_level if TODDDIFFICULTY_NGP::Carry_Over_Difficulty
		if $game_system.todd_difficulty < 3
			$game_system.todd_difficulty += 1
		end
  end
end
