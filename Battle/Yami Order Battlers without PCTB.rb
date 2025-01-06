# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Order Battlers Fix                     ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Fix for Yanfly Battle with                  ╠════════════════════╣
# ║   Yami Order Battlers without PCTB            ║    25 Nov 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Yanfly Battle Engine                                     ║
# ║           Yami Order Battlers                                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║   Makes the Order Battlers work without PCTB script                ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Set the Switch to use for updating the gauge                     ║
# ║   if you get an error under Order Battlers Line 679 put a # there  ║
# ║     if @actor_command_window.current_symbol == :attack             ║
# ║     #&& !BattleManager.actor.input.attack?                         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 22 Nov 2024 - Script finished                               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║                                                                    ║
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

module R2_Turn_Gauge_Display
  SWITCH = 10
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Enemy Appear
  #--------------------------------------------------------------------------
  def command_335
    iterate_enemy_index(@params[0]) do |enemy|
      enemy.appear
      $game_switches[R2_Turn_Gauge_Display::SWITCH] = true
      $game_troop.make_unique_names
    end
  end
  #--------------------------------------------------------------------------
  # * Enemy Transform
  #--------------------------------------------------------------------------
  def command_336
    iterate_enemy_index(@params[0]) do |enemy|
      enemy.transform(@params[1])
      $game_switches[R2_Turn_Gauge_Display::SWITCH] = true
      $game_troop.make_unique_names
    end
  end
end
module BattleManager
  #--------------------------------------------------------------------------
  # alias method: turn_start
  #--------------------------------------------------------------------------
  def self.sort_battlers(cache = false)
    battlers = []
    for battler in ($game_party.members + $game_troop.members)
      next if battler.dead? || battler.hidden?
      battlers.push(battler)
    end
    battlers.sort! { |a,b|
      if a.agi != b.agi
        b.agi <=> a.agi
      else
        a.name <=> b.name
      end
    }
    return battlers
  end
end
class Scene_Battle < Scene_Base
  alias r2_order_gauge_create_all_windows create_all_windows
  def create_all_windows
    r2_order_gauge_create_all_windows
    update_spriteset
  end
  #--------------------------------------------------------------------------
  # new method: update spriteset
  #--------------------------------------------------------------------------
  def update_spriteset
    @spriteset_order = []
    h = []
    $game_troop.members.each do |enemy|
      h << enemy if enemy.hidden?
    end
    for battler in $game_party.members + $game_troop.members
      battle_type = :dtb
      battle_type = :pctb if BattleManager.btype?(:pctb)
      battle_type = :catb if BattleManager.btype?(:catb)
      next if h.include?(battler)
      order = Sprite_OrderBattler.new(@spriteset.viewportOrder, battler, battle_type) 
      @spriteset_order.push(order)
    end
  end
  #--------------------------------------------------------------------------
  # alias method: update
  #--------------------------------------------------------------------------
  alias update_order_guage update
  def update
    update_order_guage
    update_spriteset if $game_switches[R2_Turn_Gauge_Display::SWITCH] == true
    $game_switches[R2_Turn_Gauge_Display::SWITCH] = false
  end
end
