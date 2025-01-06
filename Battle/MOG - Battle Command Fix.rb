class Window_ActorCommand < Window_Command

  def refresh
		return if @actor == nil
		if battle_hud_ex_position?
		self.viewport = nil
    return if @actor.index == nil # roninator2 added for removing actor in battle
		@bex = [$game_temp.hud_pos[@actor.index][0] + MOG_BATTLE_HUD_EX::ACTOR_COMMAND_POSITION[0] - (self.window_width / 2),
		$game_temp.hud_pos[@actor.index][1] + MOG_BATTLE_HUD_EX::ACTOR_COMMAND_POSITION[1] - @stwh[1] ]
		end
		clear_command_list ; make_command_list ; create_contents
		contents.clear
		self.index = 0 if self.index > @list.size
		set_window_position
		refresh_layout_bt if @actor_old != @actor 
		dispose_sprite_command if @actor_old != @actor
		@actor_old = @actor ; refresh_layout_bt; create_sprite_icons ; draw_all_items
		set_slide_effect
		update_sprite_battle_command   
  end

  def update_command_name
    return if @sprite_command_name == nil || @sprite_command_name.disposed?
    refresh_command_name if @old_name_index != self.index   
    @sprite_command_name.visible = @sprite_commands[0].visible   
  end
    
  def update_battle_command(bc_sprite,index)
    return if bc_sprite.disposed? # roninator2 added for error with Ring Commands
		bc_sprite.visible = bc_visible?
		update_bc_zoom_effect(bc_sprite,index)
		update_bc_slide_effect(bc_sprite,index)
		update_ring_position(bc_sprite,index) if COMMAND_TYPE == 4
  end
	
  def create_sprite_icons
		return if ![2,3,4].include?(COMMAND_TYPE)
		@sprite_commands = [] ;  @sprite_zoom_phase = [] ; @sprite_command_org = []
		@sprite_command_cwh = []
		for index in 0...@list.size
			@sprite_commands.push(Sprite.new)
			if CUSTOM_ICONS_COMMANDS
				bitmap = Cache.battle_hud("Com_" + @list[0][:name].to_s)
				@sprite_commands[index].bitmap = Bitmap.new(bitmap.width,bitmap.height)
			else 
				@sprite_commands[index].bitmap = Bitmap.new(24,24)
			end  
			@sprite_commands[index].z = self.z - 1
			@sprite_commands[index].opacity = 255
			@sprite_commands[index].angle = COMMAND_ICON_ANGLE
			@sprite_zoom_phase[index] = 0 ; @sprite_command_org[index] = [0,0]
			@sprite_command_cwh[index] = [0,0]
			refresh_sprite_command(index)
		end
		if COMMAND_TYPE == 4
			refresh_layout_bt # roninator2 added for adding actor in battle
			@sprite_commands[index].x = DEFAULT_COMMAND_POSITION[0] + @nxy[0] + @bex[0]
			@sprite_commands[index].y = DEFAULT_COMMAND_POSITION[1] + @nxy[1] + @bex[1]
			@layout_bt.ox = @layout_bt.bitmap.width / 2
			@layout_bt.oy = @layout_bt.bitmap.height / 2
		end        
		create_sprite_command_name
		@layout_bt.x = @sprite_command_org[0][0] + LAYOUT_POSITION[0]
		@layout_bt.y = @sprite_command_org[0][1] + LAYOUT_POSITION[1] 
		@layout_bt_org = [@layout_bt.x,@layout_bt.y]
  end

end
