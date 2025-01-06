# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Enemy Gold Bag                         ║  Version: 1.04     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Allows the enemy to store gold              ╠════════════════════╣
# ║   when stolen from the player                 ║    14 Aug 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Enemy holds gold stolen until killed.                        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║   Put note tag on enemy skill note box in order to                 ║
# ║   allow the enemy to steal gold from the player                    ║
# ║     <gold steal>                                                   ║
# ║                                                                    ║
# ║   Every enemy will have a gold bag.                                ║
# ║   Every enemy you want to steal needs the steal skill              ║
# ║   with the note tag                                                ║
# ║                                                                    ║
# ║   When the enemy is killed, it's gold is taken back                ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 14 Aug 2023 - Script finished                               ║
# ║ 1.01 - 15 Aug 2023 - Set messages to show Party word               ║
# ║ 1.02 - 15 Aug 2023 - Set messages to show actor name               ║
# ║ 1.03 - 20 Aug 2023 - Optimized Code                                ║
# ║ 1.04 - 27 Mar 2024 - Combined actor and party options              ║
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

module R2_Enemy_Gold_Bag
  Gold_Steal = "<gold steal>" # tag required on skill to steal gold
  
  Use_Actor = true # must be actor or party not both
  Actor_Text  = "%s lost %s gold!" # Actor, value. e.g. Eric lost 180 gold!
  Actor_Saved = "%s recovered %s gold!" # Actor, value. e.g. Eric recovered 180 gold!
  
  # party will be used if actor is false
  Party_Text  = "Party lost %s gold!" # Actor, value. e.g. Eric lost 180 gold!
  Party_Saved = "Party recovered %s gold!" # Actor, value. e.g. Eric recovered 180 gold!
end
 
# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

#==============================================================================
# ** Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  attr_accessor :gold_bag
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias r2_enemy_gold_bag_initialize  initialize
  def initialize(index, enemy_id)
    r2_enemy_gold_bag_initialize(index, enemy_id)
    @gold_bag = 0
  end
end

#==============================================================================
# ** Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Calculate Damage
  #--------------------------------------------------------------------------
  alias r2_make_gold_stole_damage    make_damage_value
  def make_damage_value(user, item)
    ovars = Marshal.load(Marshal.dump($game_variables))
    oswitchs = $game_switches.clone
    value = item.damage.eval(user, self, $game_variables)
    $game_variables = ovars
    $game_switches = oswitchs
    r2_make_gold_stole_damage(user, item)
    if user.is_a?(Game_Enemy)
      if item.note.include?(R2_Enemy_Gold_Bag::Gold_Steal)
        @result.clear_hit_flags
        if $game_party.gold < value
          value = $game_party.gold
        end
        user.gold_bag += value.to_i
        $game_party.gain_gold(-value.to_i)
        value = 0
        @result.make_damage(value.to_i, item)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Knock Out
  #--------------------------------------------------------------------------
  alias r2_enemy_gold_bag_return_die  die
  def die
    r2_enemy_gold_bag_return_die
    if self.is_a?(Game_Enemy)
      if self.gold_bag > 0
        $game_party.gain_gold(self.gold_bag)
        SceneManager.scene.recover_gold(self.gold_bag) if SceneManager.scene_is?(Scene_Battle)
        self.gold_bag = 0
      end
    end
  end
end

#==============================================================================
# ** Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Use Skill/Item
  #--------------------------------------------------------------------------
  alias r2_use_item_gold_stolen use_item
  def use_item
    item = @subject.current_action.item
    targets = @subject.current_action.make_targets.compact
    r2_use_item_gold_stolen
    if item.note.include?(R2_Enemy_Gold_Bag::Gold_Steal)
      @log_window.draw_gold_stolen(targets[0].name, @subject.gold_bag)
    end
  end
  def recover_gold(gold)
    name = @subject.name
    @log_window.draw_recover_gold(name, gold)
  end
end

#==============================================================================
# ** Window_BattleLog
#==============================================================================
class Window_BattleLog < Window_Selectable
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║ Draw Gold Stolen                                             [NEW METHOD] ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
  def draw_gold_stolen(target, value)
    if value > 0
      ww = window_width
      if COOLIE::LOG::SHOW_DAMAGE
        show_log
        back_to(1)
        if R2_Enemy_Gold_Bag::Use_Actor
          text = sprintf(R2_Enemy_Gold_Bag::Actor_Text, target, value)
        else
          text = sprintf(R2_Enemy_Gold_Bag::Party_Text, target, value)
        end
        draw_text(0, 0, ww - 24, line_height, text, v_align)
        wait
        clear
      end
    end
  end
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║ Draw Gold Recovered                                          [NEW METHOD] ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
  def draw_recover_gold(actor, value)
    if value > 0
      ww = window_width
      if COOLIE::LOG::SHOW_DAMAGE
        show_log
        back_to(1)
        if R2_Enemy_Gold_Bag::Use_Actor
          text = sprintf(R2_Enemy_Gold_Bag::Actor_Saved, actor, value)
        else
          text = sprintf(R2_Enemy_Gold_Bag::Party_Saved, actor, value)
        end
        draw_text(0, 0, ww - 24, line_height, text, v_align)
        wait
        clear
      end
    end
  end
end
