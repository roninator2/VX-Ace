# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Transmute enemy into Gold              ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║    Alter enemy death                          ║    05 Sep 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Transmute enemy into gold for specific skill on death        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║   Specify which method to use for gaining gold                     ║
# ║   0 = enemy maximum hp                                             ║
# ║   1 = random number from amount specified                          ║
# ║   2 = exact amount specified                                       ║
# ║                                                                    ║
# ║   Specify the skill id that will be the transmute skill            ║
# ║                                                                    ║
# ║   Specify the variable to use (required)                           ║
# ║                                                                    ║
# ║   Specify the message to display                                   ║
# ║    "Turned Slime A into 100 Gold"                                  ║
# ║                                                                    ║
# ║   This script will cuyrrently only work for one skill              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 05 Sep 2022 - Script finished                               ║
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

module R2_Gain_Gold_Enemy_Bonus
  Method = 0 # 0 = enemy.hp, 1 = random amount, 2 = specific amount
  Amount = 1000 # for 1 & 2. 1 = random 1000, 2 = exactly 1000
  Skill = 128 # transmute skill
  Variable = 9
  Message = "Turned %s into " # %s = enemy name
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Game_Battler < Game_BattlerBase
  attr_accessor :gold_skill
  alias r2_enemy_gold_transmute die
  def die
    r2_enemy_gold_transmute
    return if @actions.empty?
    if self.is_a?(Game_Enemy)
      if $game_variables[R2_Gain_Gold_Enemy_Bonus::Variable] == R2_Gain_Gold_Enemy_Bonus::Skill
        add_gold
      end
    end
    $game_variables[R2_Gain_Gold_Enemy_Bonus::Variable] = 0
  end
  def current_action
    act = @actions[0]
    return if act.nil?
    $game_variables[R2_Gain_Gold_Enemy_Bonus::Variable] = @actions[0].item.id if self.is_a?(Game_Actor) && !@actions.empty?
    return act
  end
  def add_gold
    gold = 0
    case R2_Gain_Gold_Enemy_Bonus::Method
    when 0
      gold = self.mhp
    when 1
      gold = rand(R2_Gain_Gold_Enemy_Bonus::Amount)
    when 2
      gold = R2_Gain_Gold_Enemy_Bonus::Amount
    end
    $game_party.gain_gold(gold)
    text = sprintf(R2_Gain_Gold_Enemy_Bonus::Message,self.name) + gold.to_s + " \\G!"
    $game_message.add(text)
  end
end
