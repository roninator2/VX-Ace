# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Battle Sequence                        ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Play Running Battles                          ║    10 Jun 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Battles will be done one after another until complete        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Set variable to the starting troop number                        ║
# ║   Depending on how you want to proceed,                            ║
# ║   You can either set the next troop number in the                  ║
# ║   variable or you can let this script do sequential.               ║
# ║                                                                    ║
# ║   When the switch is used, this script will prevent                ║
# ║   the battle music from stoping and carry on to                    ║
# ║   the next battle.                                                 ║
# ║                                                                    ║
# ║   Turn the switch off when you want to stop.                       ║
# ║   Configure settings below.                                        ║
# ║                                                                    ║
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

module R2_BSV
  SWITCH = 1 # switch number
  # switch that enables this script functions
  VARIABLE = 1 # variable number
  #variable used to determine which troop to use
  SEQUENTIAL = 2 # switch number
  # true means that the next battle will be 1 higher
  # Battle is troop 5, next troop will be 6
  # if not used, it will take the game variable
  # variable must be set to the starting troop
  # then you can change it in the troop page or let it do sequential
  SHOW_VICTORY = 3 # switch number
  # Display the Victory text and exp or not. True = yes
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

module BattleManager
  class << self
    alias r2_battle_sequence_victory  process_victory
  end
  def self.process_victory
    if $game_switches[R2_BSV::SWITCH] == true
      if $game_switches[R2_BSV::SHOW_VICTORY] == true
        $game_message.add(sprintf(Vocab::Victory, $game_party.name))
        display_exp
      end
      gain_gold
      gain_drop_items
      gain_exp
      if $game_switches[R2_BSV::SEQUENTIAL] == true
        $game_variables[R2_BSV::VARIABLE] += 1
      end
      $game_troop.setup($game_variables[R2_BSV::VARIABLE])
      continue_battle(true)
      battle_start
      return false
    else
      r2_battle_sequence_victory
    end
  end
  def self.continue_battle(value = false)
    @continue = value
  end
  def self.continue_battle_setup
    @continue
  end
end

class Scene_Battle < Scene_Base
  def update
    super
    if BattleManager.in_turn?
      process_event
      process_action
    end
    BattleManager.judge_win_loss
    if BattleManager.continue_battle_setup == true
      BattleManager.continue_battle(false)
      @spriteset.create_enemies
      @spriteset.update_enemies
    end
  end
end
