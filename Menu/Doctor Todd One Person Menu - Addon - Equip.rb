#===============================================================================
#
# R2's One Person Equip Menu - Addon to DT OPM
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

module DTOPME

  #Window skin to use, place in system.
  WINDOW = ('Window')

  #Equip Command Window X
  ECX = 50

  #Equip Command Window Y
  ECY = 0

  #Equip Command Window Width
  ECW = 300

  #Equip Command Window Height
  ECH = 50

  #Equip Status Window X
  ESX = 350

  #Equip Status Window Y
  ESY = 120

  #Status Window Width
  ESW = 250

  #Status Window Height
  ESH = 200

  #Equip Item Window X
  EIX = 50

  #Equip Item Window Y
  EIY = 320

  #Equip Item Window Width
  EIW = 550

  #Equip Item Window Height
  EIH = 140

  #Equip Slot Window X
  ETX = 50

  #Equip Slot Window Y
  ETY = 120

  #Equip Slot Window Width
  ETW = 300

  #Equip Slot Window Height
  ETH = 200

end

class Scene_Equip < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_status_window
    create_command_window
    create_slot_window
    create_item_window
  end
  #--------------------------------------------------------------------------
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_EquipStatus.new((DTOPME::ESX), (DTOPME::ESY))
    @status_window.viewport = @viewport
    @status_window.actor = @actor
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @help_window.x = (DTOPMI::HX)
    @help_window.y = (DTOPMI::HY)
    @command_window = Window_EquipCommand.new((DTOPME::ECX), (DTOPME::ECY), (DTOPME::ECW))
    @command_window.height = (DTOPME::ECH)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    @command_window.set_handler(:equip,    method(:command_equip))
    @command_window.set_handler(:optimize, method(:command_optimize))
    @command_window.set_handler(:clear,    method(:command_clear))
    @command_window.set_handler(:cancel,   method(:return_scene))
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
  end
  #--------------------------------------------------------------------------
  # * Create Slot Window
  #--------------------------------------------------------------------------
  def create_slot_window
    @slot_window = Window_EquipSlot.new((DTOPME::ETX), (DTOPME::ETY), (DTOPME::ETW))
    @slot_window.viewport = @viewport
    @slot_window.help_window = @help_window
    @slot_window.status_window = @status_window
    @slot_window.actor = @actor
    @slot_window.set_handler(:ok,       method(:on_slot_ok))
    @slot_window.set_handler(:cancel,   method(:on_slot_cancel))
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    @item_window = Window_EquipItem.new((DTOPME::EIX), (DTOPME::EIY), (DTOPME::EIW), (DTOPME::EIH))
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.status_window = @status_window
    @item_window.actor = @actor
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @slot_window.item_window = @item_window
  end
end

class Window_EquipStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, window_height)
    @actor = nil
    @temp_actor = nil
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    (DTOPME::ESW)
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    (DTOPME::ESH)
  end
end

class Window_EquipSlot < Window_Selectable
  def window_height
    (DTOPME::ETH)
  end
end
