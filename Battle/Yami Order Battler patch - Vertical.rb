# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Order Battler patch for Yanfly Battle  ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Script fix for order battlers               ║    14 Sep 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Yanfly Battle Engine                                     ║
# ║           Yami Order Battlers                                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Fix that allows vertical display                             ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Set the number of battlers to show below                         ║
# ║   Place below Order Battlers                                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 14 Sep 2022 - Script finished                               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Yami                                                             ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Terms of use:                                                      ║
# ║  Follow the original Authors terms of use where applicable         ║
# ║    - When not made by me (Roninator2)                              ║
# ║  Free for all uses in RPG Maker except nudity                      ║
# ║  Anyone using this script in their project before these terms      ║
# ║  were changed are allowed to use this script even if it conflicts  ║
# ║  with these new terms. New terms effective 03 Apr 2024             ║
# ║  No part of this code can be used with AI programs or tools        ║
# ║  Credit must be given                                              ║
# ╚════════════════════════════════════════════════════════════════════╝

module R2_Order_Gauge_limit
  Size = 8
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Sprite_OrderBattler < Sprite_Base
  def update_dtb_style
    #---
    actor_window = SceneManager.scene.actor_window
    enemy_window = SceneManager.scene.enemy_window
    if actor_window.active
      battler = actor_window.actor
      if battler == @battler
        @move_x = 36
      else
        @move_x = 24
      end
    end
    if enemy_window.active
      battler = enemy_window.enemy
      if battler == @battler
        @move_x = 36
      else
        @move_x = 24
      end
    end
    if !actor_window.active && !enemy_window.active
      @move_x = 24
    end
    #---
    return if !@move_x && !@move_y
    if @battler.hidden? || (!@show_dead && @battler.dead?)
      self.opacity = -20
    end
    if self.y != @move_y && @move_y
      if @move_y > self.y
        @move_x = 16
      elsif @move_y < self.y
        @move_x = 34
      else
        @move_x = 20
      end
      self.z = (@move_y < self.y) ? 7500 : 8500
      if @move_y >= self.y
        self.y += [@move_rate_y, @move_y - self.y].min
      else
        self.y -= [@move_rate_y, - @move_y + self.y].min
      end
    end
    if self.x != @move_x && @move_x
      self.x += (self.x > @move_x) ? -@move_rate_x : @move_rate_x
    end
    if self.y == @move_y && @move_y
      @first_time = false if @first_time
      @move_y = nil
    end
    if self.x == @move_x && @move_x
      @move_x = nil
    end
  end
 
  alias r2_update_opacity update
  def update
    r2_update_opacity
    self.opacity = 0 if self.y < 0
    self.opacity = 255 if self.y >= 0
  end
 
  def make_dtb_destination
    #---
    BattleManager.performed_battlers = [] if !BattleManager.performed_battlers
    array = BattleManager.performed_battlers.reverse
    action = BattleManager.action_battlers.reverse - BattleManager.performed_battlers.reverse
    array += action
    action.uniq!
    array.uniq!
    #---
    result = []
    for member in array
      next if member.hidden?
      result.push(member) unless member.dead?
      action.delete(member) if member.dead? and !@show_dead
    end
    if @show_dead
      for member in array
        next if member.hidden?
        result.push(member) if member.dead?
      end
    end
    #---
    size = R2_Order_Gauge_limit::Size
    limit = result.size
    move_limit = limit - size
    index = result.index(@battler).to_i
    index = index - move_limit if limit > size
    index = -4 if @battler.dead?
    index = -4 if @battler.hidden?
    @move_y = index * 24
    if BattleManager.in_turn?
      @move_y += 6 if action.include?(@battler)
      @move_y += 6 if (index + 1 == result.size) and action.size > 1
    end
    den = @first_time ? 12 : 24
    @move_rate_y = [((@move_y - self.y)/den).abs, 1].max
  end
 
end
class Scene_Battle < Scene_Base
  alias order_gauge_party_update update
  def update
    order_gauge_party_update
    if @party_command_window.active
      @update_ordergauge = true
    end
  end
end
