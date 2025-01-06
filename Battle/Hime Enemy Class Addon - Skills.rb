# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Include class skills to enemy║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   Add class skills to enemy skills  ║    31 May 2022     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Addon for Hime Enemy Classes script                      ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║   Plug and play                                          ║
# ║                                                          ║
# ║   Script will add any skills in the class to the         ║
# ║   enemies skill list                                     ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker except nudity             ║
# ╚══════════════════════════════════════════════════════════╝

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Create Battle Action
  #--------------------------------------------------------------------------
  def make_class_actions
    $data_classes[enemy.class_id].learnings.each { |s|
      skl = RPG::Enemy::Action.new
      skl.skill_id = s.skill_id
      enemy.actions.push(skl)
    }
  end
	if $imported['ARC-AdvAIConditions']
		#--------------------------------------------------------------------------
		# ● Select an action
		#--------------------------------------------------------------------------
		def make_actions
			super
			return if @actions.empty?
			if enemy.class_id != 0
				make_class_actions
			end
			action_list = enemy.actions.select {|a| action_valid?(a) }
			# Process turn patterns
			unless enemy.t_patterns.keys.empty?
				if turn_patterns_ok?
					action_list = make_turn_patterns_list.select {|a| action_valid?(a)}
				end
			end
			# End Process turn patterns
			return if action_list.empty?
			# Process absolute rating
			absolute_list = action_list.reject {|a| a.rating != ARC::ABSOLUTE_RATING}
			unless absolute_list.empty?
				@actions.each do |action|
					action.set_enemy_action(absolute_list[rand(absolute_list.size)])
				end
				return
			end
			# Normal method end
			rating_max = action_list.collect {|a| a.rating }.max
			rating_zero = rating_max - 3
			action_list.reject! {|a| a.rating <= rating_zero }
			@actions.each do |action|
				action.set_enemy_action(select_enemy_action(action_list, rating_zero))
			end
		end
	else
		def make_actions
			super
			return if @actions.empty?
			if enemy.class_id != 0
				make_class_actions
			end
			action_list = enemy.actions.select {|a| action_valid?(a) }
			return if action_list.empty?
			rating_max = action_list.collect {|a| a.rating }.max
			rating_zero = rating_max - 3
			action_list.reject! {|a| a.rating <= rating_zero }
			@actions.each do |action|
				action.set_enemy_action(select_enemy_action(action_list, rating_zero))
			end
		end
	end
end
