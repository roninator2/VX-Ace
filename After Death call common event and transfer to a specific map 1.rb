# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Call CE Transfer without variables     ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Script Function                             ║    30 Sep 2020     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Call Common Event when death occurs                          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Configure settings below                                         ║
# ║   Set map id and position to return to after death                 ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 30 Sep 2020 - Script finished                               ║
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

module R2_nodie
	CEID = 1			# common event id
	UseCE = 2			# switch to call common event
	Rewards = 1		# switch to activate this script
	Map = 2				# map id to transfer to
	X_spot = 10		# player x position
	Y_spot = 20		# player y position
	Dir		 = 4		# player direction facing
end

module Vocab
	Livetext = "Barely made it out!"
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

module BattleManager
  def self.process_defeat
		if $game_switches[R2_nodie::Rewards] == true
			$game_message.add(sprintf(Vocab::Livetext, $game_party.name))
			wait_for_message
			revive_battle_members
			display_exp
			gain_gold
			gain_drop_items
			gain_exp
			replay_bgm_and_bgs
			SceneManager.return
			map_id = R2_nodie::Map
			x = R2_nodie::X_spot
			y = R2_nodie::Y_spot
			direction = R2_nodie::Dir
			$game_player.reserve_transfer(map_id, x, y, direction)
			$game_player.perform_transfer
			$game_temp.reserve_common_event(R2_nodie::CEID) if $game_switches[R2_nodie::UseCE] == true
			battle_end(0)
			return true
		else
			$game_message.add(sprintf(Vocab::Defeat, $game_party.name))
			wait_for_message
			if @can_lose
				revive_battle_members
				replay_bgm_and_bgs
				SceneManager.return
			else
				SceneManager.goto(Scene_Gameover)
			end
			battle_end(2)
			return true
		end
  end
end
