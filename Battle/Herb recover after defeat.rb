# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Herb Recover After Defeat              ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Battle Manager                              ╠════════════════════╣
# ║   Adjust process defeat                       ║    16 Dec 2020     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Come back to life if you have the herb                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Simple script to adjust the proces defeat                        ║
# ║   Party will recover when the party has the item indicated         ║
# ║   If not then normal defeat is processed                           ║
# ║   Only for when the party is able to lose                          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 16 Dec 2020 - Script finished                               ║
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

module Herb_Recover
	SWITCH_ID = 1		# Change to your desired switch
	HERB_ITEM = 7		# item that will recovery party.
	HEAL = 50		  	# specify value to recover health. % value
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

module BattleManager

  class << self
    alias_method :process_herb, :process_defeat
  end     

  def self.process_defeat
    @herb = "#{$game_party.leader.name} used Medicinal Herbs, \n#{Herb_Recover::HEAL}%% HP was restored"
    if $game_switches[Herb_Recover::SWITCH_ID] && !@can_lose
			if $game_party.has_item?($data_items[Herb_Recover::HERB_ITEM], false)
				$game_message.add(sprintf(@herb, $game_party.name))
				wait_for_message
				revive_battle_members
				$game_party.battle_members.each do |actor|
					actor.hp += [(actor.mhp * Herb_Recover::HEAL).to_i / 100 - 1, actor.mhp].min
				end
				$game_party.lose_item($data_items[Herb_Recover::HERB_ITEM], 1, false)
				return false
			else
				process_herb
			end
		else
			process_herb
		end
	end
end
