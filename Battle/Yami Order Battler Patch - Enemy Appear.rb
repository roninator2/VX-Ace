# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Order Battler Patch - Enemy Appear     ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Patch for Yami order battlers enemy appear  ║    13 Sep 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Yanfly Battle Engine                                     ║
# ║           Yami Order Battlers                                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║     Order Battlers - Enemy Appear/Transform fix                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Detailed Processes                                               ║
# ║   Place below Order Battlers                                       ║
# ║                                                                    ║
# ║   Fixes the issue that the gauge doesn't update when an            ║
# ║   enemy is revealed, transformed, or revived                       ║
# ║                                                                    ║
# ║   if you get an error under Order Battlers Line 679                ║
# ║      put a # as shown here                                         ║
# ║    if @actor_command_window.current_symbol == :attack # &&         ║
# ║       !BattleManager.actor.input.attack?                           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 13 Sep 2022 - Script finished                               ║
# ║ 1.01 - 13 Sep 2022 - added fix for memory leaks                    ║
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
  SWITCH = 10 # Do not turn on. Used automatically to reset icons
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
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # overwrite method: create all windows
  #--------------------------------------------------------------------------
  def create_all_windows
    order_gauge_create_all_windows
    if @spriteset_order
      for order in @spriteset_order
        order.bitmap.dispose
        order.dispose
      end
      @spriteset_order = nil
    end
    @spriteset_order = []
    if $imported["YSA-PCTB"] && YSA::PCTB::CTB_MECHANIC[:predict] == 1
      @active_order_sprite = Sprite_OrderBattler.new(@spriteset.viewportOrder, nil, :pctb2) 
    end
    if $imported["YSA-PCTB"] && YSA::PCTB::CTB_MECHANIC[:predict] == 2
      num = YSA::PCTB::CTB_MECHANIC[:pre_turns]
      i = 0
      num.times {
        order = Sprite_OrderBattler.new(@spriteset.viewportOrder, nil, :pctb3, i) 
        @spriteset_order.push(order)
        i += 1
      }
      return
    end
    for battler in $game_party.members + $game_troop.members
      battle_type = :dtb
      battle_type = :pctb if BattleManager.btype?(:pctb)
      battle_type = :catb if BattleManager.btype?(:catb)
      order = Sprite_OrderBattler.new(@spriteset.viewportOrder, battler, battle_type) 
      @spriteset_order.push(order)
    end
  end
  #--------------------------------------------------------------------------
  # new method: update spriteset
  #--------------------------------------------------------------------------
  def update_spriteset_order
    if @spriteset_order
      for order in @spriteset_order
        order.bitmap.dispose
        order.dispose
      end
      @spriteset_order = nil
    end
    @spriteset_order = []
    if $imported["YSA-PCTB"] && YSA::PCTB::CTB_MECHANIC[:predict] == 1
      @active_order_sprite = Sprite_OrderBattler.new(@spriteset.viewportOrder, nil, :pctb2)
    end
    if $imported["YSA-PCTB"] && YSA::PCTB::CTB_MECHANIC[:predict] == 2
      num = YSA::PCTB::CTB_MECHANIC[:pre_turns]
      i = 0
      num.times {
        order = Sprite_OrderBattler.new(@spriteset.viewportOrder, nil, :pctb3, i)
        @spriteset_order.push(order)
        i += 1
      }
      return
    end
    for battler in $game_party.members + $game_troop.members
      battle_type = :dtb
      battle_type = :pctb if BattleManager.btype?(:pctb)
      battle_type = :catb if BattleManager.btype?(:catb)
      order = Sprite_OrderBattler.new(@spriteset.viewportOrder, battler, battle_type)
      @spriteset_order.push(order)
    end
  end
  #--------------------------------------------------------------------------
  # alias method: update
  #--------------------------------------------------------------------------
  alias update_order_guage update
  def update
    update_spriteset_order if $game_switches[R2_Turn_Gauge_Display::SWITCH] == true
    $game_switches[R2_Turn_Gauge_Display::SWITCH] = false
    update_order_guage
  end
end
class Game_Battler < Game_BattlerBase
  alias r2_enemy_revive_order_gauge   revive
  def revive
    r2_enemy_revive_order_gauge
    $game_switches[R2_Turn_Gauge_Display::SWITCH] = true
  end
end
