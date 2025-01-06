#===============================================================================
#
# R2's One Person Skill Menu - Addon to DT OPM
# Author: Roninator2
# Date (31/05/2022)
# Type: (Menu)
# Version: (1.0.0) (VXA)
# Level: (Simple)
#
#===============================================================================
#
# NOTES: 1)This script will only work with ace, you may find my VX version on
# RMRK.net and the rpg maker web forums.
#
#===============================================================================
#
# Description: A menu that is modified to work as if you are only using one
# actor.
#
# Credits: Me (Roninator2)
#
#===============================================================================
#
# Instructions
# Paste above main.
#
#===============================================================================

module DTOPMS

  #Window skin to use, place in system.
  WINDOW = ('Window')

  #Skill Command Window X
  SCX = 50

  #Skill Command Window Y
  SCY = 120

  #Skill Command Window Width
  SCW = 150

  #Skill Command Window Height
  SCH = 160

  #Status Window X
  SSX = 200

  #Status Window Y
  SSY = 120

  #Status Window Width
  SSW = 400

  #Status Window Height
  SSH = 120

  #Skill Item Window X
  SIX = 50

  #Skill Item Window Y
  SIY = 240

  #Skill Item Window Width
  SIW = 550

  #Skill Item Window Height
  SIH = 200

end

class Scene_Skill < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_command_window
    create_status_window
    create_item_window
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @help_window.x = (DTOPMI::HX)
    @help_window.y = (DTOPMI::HY)
    @command_window = Window_SkillCommand.new((DTOPMS::SCX), (DTOPMS::SCY))
    @command_window.windowskin = Cache.system(DTOPMS::WINDOW)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    @command_window.actor = @actor
    @command_window.set_handler(:skill,    method(:command_skill))
    @command_window.set_handler(:cancel,   method(:return_scene))
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
  end
  #--------------------------------------------------------------------------
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_SkillStatus.new((DTOPMS::SSX), (DTOPMS::SSY))
    @status_window.viewport = @viewport
    @status_window.actor = @actor
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    @item_window = Window_SkillList.new((DTOPMS::SIX), (DTOPMS::SIY), (DTOPMS::SIW), (DTOPMS::SIH))
    @item_window.actor = @actor
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @command_window.skill_window = @item_window
  end
end

class Window_SkillCommand < Window_Command
  def window_width
    return (DTOPMS::SCW)
  end
end

class Window_SkillStatus < Window_Base
  def initialize(x, y)
    super(x, y, window_width, (DTOPMS::SSH))
    @actor = nil
  end
  def window_width
    (DTOPMS::SSW)
  end
end
