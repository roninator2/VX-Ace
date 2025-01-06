#===============================================================================
#
# Enemy HUD (1.3)
# 15/4/2012
# By Pacman (ported to VXA from a VX script also by Pacman)
# patch by Roninator2
# Fixes hidden enemies
#===============================================================================

class Window_EnemyHUD < Window_BattleStatus
  #--------------------------------------------------------------------------
  # * Get item max
  #--------------------------------------------------------------------------
  def item_max
    @troop_hidden = 0
    $game_troop.members.each do |enemy|
      if enemy.hidden?
        @troop_hidden += 1
      end
    end
    return $game_troop.members.size - @troop_hidden - $game_troop.dead_members.size
  end
  #--------------------------------------------------------------------------
  # * Get enemy
  #--------------------------------------------------------------------------
  def enemy
    $game_troop.alive_members[@index]
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item to be drawn
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    rect.x += 4
    rect.width -= 8
    contents.clear_rect(rect)
    contents.font.color = normal_color
    enemy = $game_troop.alive_members[index]
    return if enemy.hidden?
    draw_basic_area(basic_area_rect(index), enemy)
    draw_gauge_area(gauge_area_rect(index), enemy)
  end
end
