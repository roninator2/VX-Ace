#--------------------------------------------------------------------------
# Ticking HP
# by Fomar0153
# Version 1.0
# ----------------------
# Notes
# ----------------------
# No requirements
# Plug and play
# not compatible with side view battle systems
# ----------------------
# Instructions
# ----------------------
# Just copy into your scripts in the Materials section.
# ----------------------
# Roninator2 fixes
# Fixed healing not working outside battle
# Fixed poison damage in battle
#--------------------------------------------------------------------------

class Scene_Battle < Scene_Base
#--------------------------------------------------------------------------
# * Update Frame (Basic)
#--------------------------------------------------------------------------
	alias eb_update update
	def update
		eb_update
		update_hp
	end
#--------------------------------------------------------------------------
# * Update Frame (Basic)
#--------------------------------------------------------------------------
	alias eb_update_basic update_basic
	def update_basic
		eb_update_basic
		update_hp
	end
#--------------------------------------------------------------------------
# * Update HP
#--------------------------------------------------------------------------
	def update_hp
		@last_check = 0 if @last_check == nil
		return if @last_check == Graphics.frame_count
		if Graphics.frame_count % 1 == 0 # change 60 to speed up or slow down
			@last_check = Graphics.frame_count
			for member in $game_party.members
			member.roll_hp
		end
		@status_window.refresh
		end
	end
end

class Game_Actor < Game_Battler
#--------------------------------------------------------------------------
# * Public Instance Variables
#--------------------------------------------------------------------------
	attr_accessor :hp_target
#--------------------------------------------------------------------------
# * Setup
#--------------------------------------------------------------------------
	alias eb_setup setup
	def setup(actor_id)
		eb_setup(actor_id)
		@hp_target = 0
	end
#--------------------------------------------------------------------------
# * Roll HP
#--------------------------------------------------------------------------
	def roll_hp
		return if @hp_target == 0
		@hp = [@hp + (@hp_target / @hp_target.abs), 0].max
		@hp_target -= (@hp_target / @hp_target.abs)
		@hp_target = 0 if @hp_target > 0 && @hp == mhp
		refresh
	end
#--------------------------------------------------------------------------
# * Dying?
#--------------------------------------------------------------------------
	def dying?
		@hp + @hp_target <= 0
	end
#--------------------------------------------------------------------------
# * Crisis?
#--------------------------------------------------------------------------
	def crisis?
		@hp + @hp_target <= mhp / 4
	end
#--------------------------------------------------------------------------
# * Damage Processing
# @result.hp_damage @result.mp_damage @result.hp_drain
# @result.mp_drain must be set before call.
#--------------------------------------------------------------------------
	def execute_damage(user)
		on_damage(@result.hp_damage) if @result.hp_damage > 0
    if SceneManager.scene_is?(Scene_Battle)
      self.hp_target -= @result.hp_damage # ticking hp
    else
      self.hp -= @result.hp_damage
    end
    if self.hp < @result.hp_damage 
      self.hp = 0
      @hp_target = 0
    end
 		self.mp -= @result.mp_damage
    user.hp += @result.hp_drain
		user.mp += @result.mp_drain
		refresh
	end
#--------------------------------------------------------------------------
# * Regenerate Processing
#--------------------------------------------------------------------------
  def regenerate_hp
    damage = -(mhp * hrg).to_i
    perform_map_damage_effect if $game_party.in_battle && damage > 0
    @result.hp_damage = [damage, max_slip_damage].min
    if SceneManager.scene_is?(Scene_Battle)
      self.hp_target -= @result.hp_damage # ticking hp
    else
      self.hp -= @result.hp_damage
    end
  end
#--------------------------------------------------------------------------
# * Processing at End of Battle
#--------------------------------------------------------------------------
	def on_battle_end
		super
		@hp_target = 0
	end
end

class Game_Enemy < Game_Battler
#--------------------------------------------------------------------------
# * Damage Processing
# @result.hp_damage @result.mp_damage @result.hp_drain
# @result.mp_drain must be set before call.
#--------------------------------------------------------------------------
	def execute_damage(user)
		on_damage(@result.hp_damage) if @result.hp_damage > 0
		self.hp -= @result.hp_damage
		self.mp -= @result.mp_damage
		user.hp_target += @result.hp_drain
		user.mp += @result.mp_drain
	end
end

class Window_Base < Window
  def critical_color;      text_color(18);  end;    # Critical
  def wounded_color;      text_color(14);  end;    # Wounded
  def crisis_color;      text_color(2);  end;    # Crisis 17
  def knockout_color;      text_color(7);  end;    # Knockout 18
#--------------------------------------------------------------------------
# * Get HP Text Color
#--------------------------------------------------------------------------
	def hp_color(actor)
		return knockout_color if actor.hp == 0
		return critical_color if actor.hp < actor.mhp / 10 || actor.dying?
		return crisis_color if actor.hp < actor.mhp / 4 || actor.crisis?
		return wounded_color if actor.hp < actor.mhp / 2 || actor.crisis?
		return normal_color
	end
end
