#==============================================================================
#
# ▼ Yanfly Engine Ace - Class System v1.10 - addon
# -- Last Updated: 2021.02.19
# -- Requires: Yanfly Class System
# -- addon created by: Roninator2
#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2021.02.17 - Started Script
# 2021.02.19 - Finished Script
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# for showing class equip types in the class scene
#==============================================================================
class Window_ClassList < Window_Selectable
  alias r2_equip_update_help    update_help
  def update_help
    r2_equip_update_help
    draw_equip_class
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    return if index == 0
    if index >= col_max || (wrap && col_max == 1)
      select((index - col_max + item_max) % item_max)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    return if index == item_max - 1
    if index == 7
      cursor_pagedown_list
      @index = 8
      cursor_rect.set(item_rect(@index))
      select(8)
    else
    if index < item_max - col_max || (wrap && col_max == 1)
      select((index + col_max) % item_max)
    end
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Down
  #--------------------------------------------------------------------------
  def cursor_pagedown
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Up
  #--------------------------------------------------------------------------
  def cursor_pageup
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Down
  #--------------------------------------------------------------------------
  def cursor_pagedown_list
    if top_row + page_row_max < row_max
      self.top_row += page_row_max
      select([@index + page_item_max, item_max - 1].min)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Up
  #--------------------------------------------------------------------------
  def cursor_pageup_list
    if top_row > 0
      self.top_row -= page_row_max
      select([@index - page_item_max, 0].max)
    end
  end
  #--------------------------------------------------------------------------
  # * Get Number of Rows Displayable on 1 Page
  #--------------------------------------------------------------------------
  def page_row_max
    return 8
  end
  #--------------------------------------------------------------------------
  # * Get Row Count
  #--------------------------------------------------------------------------
  def row_max
    return 16
  end
  #--------------------------------------------------------------------------
  # * Draw Equipment For The Class
  #--------------------------------------------------------------------------
  def draw_equip_class
    class_equip = []
    actor_class = @data[index]
    actor_class.features.each do |set|
      next if set.data_id == 0
      case set.code
      when 51 # weapon
        class_equip.push($data_system.weapon_types[set.data_id])
      when 52 # armour
        class_equip.push($data_system.armor_types[set.data_id])
      else
        next
      end
    end
    change_color(normal_color)
    contents.clear_rect(110, 0, 150, 400)
    if class_equip != []
      y = 0
      case @index
      when 0..6
      when 7
        spot = @index
        cursor_pageup_list
        @index = spot
        cursor_rect.set(item_rect(@index))
      when 8..16
        y = 8 * 24
      end
      draw_text(110, y, 150, 24, "Can Equip", 1)
      y += 24
      for equip_id in class_equip
        draw_text(110, y, 150, 24, equip_id, 1)
        y += 24
      end
    end
  end
end
