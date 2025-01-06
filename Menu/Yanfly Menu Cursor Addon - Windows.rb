#==============================================================================
# 
# ▼ Yanfly Engine Ace - Menu Cursor Addon v1.00
# -- Last Updated: 2023.12.10
# -- Level: Easy
# -- Requires: YEA Menu Cursor
# -- by Roninator2
#==============================================================================
#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2023.12.10 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is an addon to Yanfly's Menu Cursor script for Window Message 
# choice list, number input and select key item
# 
#==============================================================================

class Window_Message < Window_Base
  #--------------------------------------------------------------------------
  # * Create All Windows
  #--------------------------------------------------------------------------
  alias r2_create_curosr_all_windows    create_all_windows
  def create_all_windows
    r2_create_curosr_all_windows
    create_menu_cursors
  end
  #--------------------------------------------------------------------------
  # * Free All Windows
  #--------------------------------------------------------------------------
  alias r2_dispose_cursor_all_windows   dispose_all_windows
  def dispose_all_windows
    dispose_menu_cursors
    r2_dispose_cursor_all_windows
  end
  #--------------------------------------------------------------------------
  # * Update All Windows
  #--------------------------------------------------------------------------
  alias r2_update_cursor_all_windows    update_all_windows
  def update_all_windows
    r2_update_cursor_all_windows
    update_menu_cursors
  end
  #--------------------------------------------------------------------------
  # new method: create_menu_cursors
  #--------------------------------------------------------------------------
  def create_menu_cursors
    @menu_cursors ||= []
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      create_cursor_sprite(ivar) if ivar.is_a?(Window_ChoiceList)
      create_cursor_sprite(ivar) if ivar.is_a?(Window_NumberInput)
      create_cursor_sprite(ivar) if ivar.is_a?(Window_KeyItem)
    end
  end
  #--------------------------------------------------------------------------
  # new method: create_cursor_sprite
  #--------------------------------------------------------------------------
  def create_cursor_sprite(window)
    @menu_cursors.push(Sprite_MenuCursor.new(window))
  end
  #--------------------------------------------------------------------------
  # new method: dispose_menu_cursors
  #--------------------------------------------------------------------------
  def dispose_menu_cursors
    @menu_cursors.each { |cursor| cursor.dispose }
  end
  #--------------------------------------------------------------------------
  # new method: update_menu_cursors
  #--------------------------------------------------------------------------
  def update_menu_cursors
    @menu_cursors.each { |cursor| cursor.update }
  end
end
