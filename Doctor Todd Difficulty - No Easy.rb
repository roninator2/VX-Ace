#===============================================================================
#
# DT's Difficulty
# Author: DoctorTodd
# Date (15/12/2019)
# Version: (1.0.2) (VXA)
# Level: (Medium)
# Email: Todd@beacongames.com
#
#===============================================================================
#
# NOTES: 1)This script will only work with ace.
#        2)A difficulty must be selected before the first battle or the game WILL
#        CRASH.
#
#===============================================================================
#
# Description: Lets the player select the games difficulty.
#
# Credits: Me (DoctorTodd), D&P3 for saving bug fix.
# Additions by Roninator2
#    Easy option removed from 1.01 for request by SlickDeath97
#===============================================================================
#
# Instructions
# Paste above main.
#
#===============================================================================
#
# Free for any use as long as I'm credited.
#
#===============================================================================
#
# Editing begins 38 and ends on 81.
#
#===============================================================================
module TODDDIFFICULTY   
#Normal Text.  
NORMALT = "Normal"   
#Heroic Text.  
HEROICT = "Heroic"   
#Hard Text.  
HARDT = "Legendary"   
#Heroic enemy parameters multiplier (Normal is skipped since it's what put  
#you into the database).  
HEROICM = 1.25   
#Hard enemy parameters multiplier.  
HARDM = 1.5    
#Heroic enemy experience multiplier (Normal is skipped since it's what put  
#you into the database).  
HEROICEXPM = 1.25   
#Hard enemy experience multiplier.  
HARDEXPM = 1.5    
#Heroic enemy gold multiplier (Normal is skipped since it's what put  
#you into the database).  
HEROICGOLDM = 1.5   
#Hard enemy gold multiplier.  
HARDGOLDM = 2      
#Heroic enemy drop multiplier (Normal is skipped since it's what put  
#you into the database).  
HEROICDROPM = 1.25   
#Hard enemy drop multiplier.  
HARDDROPM = 1.5   
#The text above where the selection is made.  
TEXT = "Please select a difficulty:"   
#Menu command?  
MENU = true   
#Sound effect to play when difficulty is selected.  
SE = "Darkness8"   
#Switch to allow cancelling the difficulty selection.  
#MUST NOT BE ON WHEN SELECTING FOR THE FIRST TIME.  
SWITCH = 5 

end
#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies. It used within the Game_Troop class
# ($game_troop).
#============================================================================== 

class Game_Enemy < Game_Battler  
#--------------------------------------------------------------------------  
# * Get Base Value of Parameter  
#--------------------------------------------------------------------------  
	alias todd_difficulty_gmen_param_base param_base  
	def param_base(param_id, *args)  
		n1 = todd_difficulty_gmen_param_base(param_id, *args)  
		n2 = case $game_system.todd_difficulty  
		when 0 
			1  
		when 1 
			TODDDIFFICULTY::HEROICM  
		when 2 
			TODDDIFFICULTY::HARDM  
		end  
    return n1 * n2
	end  
	#--------------------------------------------------------------------------  
	# * Get Experience  
	#--------------------------------------------------------------------------  
	def exp    
		case $game_system.todd_difficulty    
		when 0 
			enemy.exp           
		when 1 
			enemy.exp * TODDDIFFICULTY::HEROICEXPM    
		when 2 
			enemy.exp * TODDDIFFICULTY::HARDEXPM  
		end
	end  
	#--------------------------------------------------------------------------  
	# * Get Gold  
	#--------------------------------------------------------------------------  
	def gold    
		case $game_system.todd_difficulty    
		when 0 
			enemy.gold    
		when 1 
			enemy.gold * TODDDIFFICULTY::HEROICGOLDM    
		when 2 
			enemy.gold * TODDDIFFICULTY::HARDGOLDM  
		end  
	end  
	#--------------------------------------------------------------------------  
	# * Create Array of Dropped Items  
	#--------------------------------------------------------------------------  
	def make_drop_items    
		case $game_system.todd_difficulty    
    when 0 
      @DropMulti = 1    
    when 1 
      @DropMulti = TODDDIFFICULTY::HEROICDROPM    
    when 2 
      @DropMulti = TODDDIFFICULTY::HARDDROPM  
		end    
		enemy.drop_items.inject([]) do |r, di|      
      if di.kind > 0 && rand * di.denominator < drop_item_rate * @DropMulti
        r.push(item_object(di.kind, di.data_id))      
      else 
        r      
      end    
		end  
	end
end 

#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  This class handles system data. It saves the disable state of saving and
# menus. Instances of this class are referenced by $game_system.
#============================================================================== 

class Game_System  
#--------------------------------------------------------------------------  
# * Public Instance Variables  
#--------------------------------------------------------------------------  
	attr_accessor :todd_difficulty # save forbidden  
#--------------------------------------------------------------------------  
# * Object Initialization  
#--------------------------------------------------------------------------  
	alias todd_difficulty_gamesystem_init initialize  
	def initialize    
		@todd_difficulty = 0    
		todd_difficulty_gamesystem_init 
	end
end 

#==============================================================================
# ** Window_DifficultySelection
#============================================================================== 

class Window_DifficultySelection < Window_HorzCommand  
#--------------------------------------------------------------------------  
# * Object Initialization  
#--------------------------------------------------------------------------  
	def initialize    
		super(0, 0) 
	end  
	#--------------------------------------------------------------------------  
	# * Get Window Width  
	#--------------------------------------------------------------------------  
	def window_width    
		Graphics.width/2 + 20  
	end  
	#--------------------------------------------------------------------------  
	# * Get Digit Count  
	#-------------------------------------------------------------------------- 
	def col_max    
		return 3  
	end  
	#--------------------------------------------------------------------------  
	# * Create Command List  
	#--------------------------------------------------------------------------  
	def make_command_list    
		add_command(TODDDIFFICULTY::NORMALT,   :normal)    
		add_command(TODDDIFFICULTY::HEROICT,    :heroic)    
		add_command(TODDDIFFICULTY::HARDT, :hard)  
	end
end
#==============================================================================
# ** Window_DifficultyName
#============================================================================== 

class Window_DifficultyName < Window_Base  
#--------------------------------------------------------------------------  
# * Object Initialization  
#--------------------------------------------------------------------------  
	def initialize    
		super(0, 0, window_width, fitting_height(1))    
		refresh  
	end  
	#--------------------------------------------------------------------------  
	# * Get Window Width  
	#--------------------------------------------------------------------------  
	def window_width    
		return Graphics.width/2 + 20  
	end  
	#--------------------------------------------------------------------------  
	# * Refresh  
	#--------------------------------------------------------------------------  
	def refresh    
		contents.clear    
		draw_text(15, -27, 400, 80, TODDDIFFICULTY::TEXT)  
	end
end
#==============================================================================
# ** Scene_Difficulty
#============================================================================== 

class Scene_Difficulty < Scene_MenuBase  
#--------------------------------------------------------------------------  
# * Start Processing  
#--------------------------------------------------------------------------  
	def start    
		super    
		create_command_window    
		create_name_window  
	end  
	#--------------------------------------------------------------------------  
	# * Create Command Window  
	#--------------------------------------------------------------------------  
	def create_command_window    
		@command_window = Window_DifficultySelection.new    
		@command_window.set_handler(:normal,     method(:command_normal))   
		@command_window.set_handler(:heroic,     method(:command_heroic))    
		@command_window.set_handler(:hard,    method(:command_hard))    
		@command_window.set_handler(:cancel,    method(:return_scene))if $game_switches[TODDDIFFICULTY::SWITCH] == true    
		@command_window.x = Graphics.width/2 - 170    
		@command_window.y = Graphics.height/2 - 50  
	end  
	#--------------------------------------------------------------------------  
	# * Create Difficulty Window  
	#--------------------------------------------------------------------------  
	def create_name_window    
		@name_window = Window_DifficultyName.new    
		@name_window.x = Graphics.width/2 - 170    
		@name_window.y = Graphics.height/2 - 97  
	end  
	#--------------------------------------------------------------------------  
	# * [normal] Command  
  #--------------------------------------------------------------------------  
	def command_normal    
		$game_system.todd_difficulty = 0   
		Audio.se_play("Audio/SE/" + TODDDIFFICULTY::SE, 100, 100)    
		return_scene   
	end  
	#--------------------------------------------------------------------------  
	# * [heroic] Command  
	#--------------------------------------------------------------------------  
	def command_heroic    
		$game_system.todd_difficulty = 1     
		Audio.se_play("Audio/SE/" + TODDDIFFICULTY::SE, 100, 100)    
		return_scene   
	end  
	#--------------------------------------------------------------------------  
	# * [hard] Command  
	#-------------------------------------------------------------------------- 
	def command_hard    
		$game_system.todd_difficulty = 2      
		Audio.se_play("Audio/SE/" + TODDDIFFICULTY::SE, 100, 100)   
		return_scene  
	end 
end 

if TODDDIFFICULTY::MENU == true
#==============================================================================
# ** Scene_Menu
#------------------------------------------------------------------------------
#  This class performs the menu screen processing.
#============================================================================== 

	class Scene_Menu < Scene_MenuBase  
	#--------------------------------------------------------------------------  
	# * Create Command Window  
	#--------------------------------------------------------------------------  
	alias todd_dif_menu_add_menu_command create_command_window  
	def create_command_window   
		todd_dif_menu_add_menu_command    
		@command_window.set_handler(:dif, method(:command_dif))  
	end
end  
	#--------------------------------------------------------------------------  
	# * [Difficulty] Command  
	#--------------------------------------------------------------------------  
	def command_dif  
		SceneManager.call(Scene_Difficulty) 
	end
end 

if TODDDIFFICULTY::MENU == true
#==============================================================================
# ** Window_MenuCommand
#------------------------------------------------------------------------------
#  This command window appears on the menu screen.
#============================================================================== 

	class Window_MenuCommand < Window_Command  
	#--------------------------------------------------------------------------  
	# * Add Main Commands to List  
	#--------------------------------------------------------------------------  
		alias todd_dif_menu_command_add_to_menu add_main_commands  
		def add_main_commands     
			todd_dif_menu_command_add_to_menu    
			add_command("Difficulty", :dif, main_commands_enabled)  
		end 
	end
end 
