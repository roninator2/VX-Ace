#==============================================================================
# ★ RGSS3_TurnWindowDisplayforBattle Ver1.05
#==============================================================================
=begin
 
  Author:ぷり娘 (prico)
web site:Sister's Eternal 4th(Ancient)
     URL:http://pricono.whitesnow.jp/
Permission to use: Not required, but please mention in the game, Readme, etc.
 
Displays the current amount of turns on the battle screen.
The number of turns is displayed up to 3 digits (limit 999 turns)
 
By default, it'll appear in semi-transparent window.
Position of Turn Window can be change through script setting.
 
Also, it will hidden during battle events.
 
 
 
2012.06.21 Ver1.00 Public release
2012.06.23 Ver1.01 Fixed a bug where an enemy action does not match # turn display.

Mods by Roninator2
2018.09.07 Ver1.02 Made the turn window disappear when selecting skills and items
2018.09.11 Ver1.03 Made minor changes to fix a bug in the cancel selection. 
2018.09.30 Ver1.04 Made minor changes to fix a bug in the ok selection.
2018.09.30 Ver1.05 Added Icon.
2019.01.06 Ver1.06 Made option to use window background
=end
 
 
#==============================================================================
# Setting
#==============================================================================
module Prico

  #X coordinate of Turn Window
  WindowX = 440
 
  #Y coordinate of Turn Window
  WindowY = 0
 
  #Turn Window width
  WindowW = 104

  #Turn Window Opacity
  View = 255
  
  #Turn Window Icon
  Use_Icon = true
  
  #Turn Window Icon Index
  Icon = 280
  
  #Turn window background. true is windowed, false is shadow (requires Window_blank.png file)
  WindowBack = true
end

#==============================================================================
# ■ Scene_Battle
#------------------------------------------------------------------------------
# 　Class that performs battle screen processing
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● Create all windows(alias)
  #--------------------------------------------------------------------------
  alias create_all_windows_org create_all_windows
  def create_all_windows
    create_all_windows_org
    create_turn_window
  end
  #--------------------------------------------------------------------------
  # ● Creating turn number window(new)
  #--------------------------------------------------------------------------
  def create_turn_window
    @turn_window = Window_Turn.new(Prico::WindowX,Prico::WindowY)
    @turn_window.visible = false
    $turn_back = false
  end
  #--------------------------------------------------------------------------
  # * Battle Start
  #--------------------------------------------------------------------------
  alias battle_start_org battle_start
  def battle_start
    battle_start_org
    @turn_window.opacity = Prico::View
    @turn_window.visible = true
    $turn_back = true
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Process event
  #--------------------------------------------------------------------------
  alias process_event_org process_event
  def process_event
    process_event_org
    @turn_window.visible = false
    $turn_back = false
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # * [Skill] Command
  #--------------------------------------------------------------------------
  alias command_skill_oth command_skill
  def command_skill
    command_skill_oth
    @turn_window.visible = false
    $turn_back = false
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Skill [OK]
  #--------------------------------------------------------------------------
  alias on_skill_ok_oth on_skill_ok
  def on_skill_ok
    on_skill_ok_oth
    @turn_window.visible = false
    $turn_back = false
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Skill [Cancel]
  #--------------------------------------------------------------------------
  alias on_skill_cancel_oth on_skill_cancel
  def on_skill_cancel
    on_skill_cancel_oth
    @turn_window.visible = true
    $turn_back = true
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # * [Item] Command
  #--------------------------------------------------------------------------
  alias command_item_oth command_item
  def command_item
    command_item_oth
    @turn_window.visible = false
    $turn_back = false
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  alias on_item_ok_oth on_item_ok
  def on_item_ok
    on_item_ok_oth
    @turn_window.visible = false
    $turn_back = false
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Item [Cancel]
  #--------------------------------------------------------------------------
  alias on_item_cancel_oth on_item_cancel
  def on_item_cancel
    on_item_cancel_oth
    @turn_window.visible = true
    $turn_back = true
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Start Actor Command Selection
  #--------------------------------------------------------------------------
  def start_actor_command_selection_oth start_actor_command_selection
    start_actor_command_selection_oth 
    @turn_window.visible = true
    $turn_back = true
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Start Actor Selection
  #--------------------------------------------------------------------------
  alias select_actor_selection_oth select_actor_selection
  def select_actor_selection
    select_actor_selection_oth
    @turn_window.visible = false
    $turn_back = false
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Actor [OK]
  #--------------------------------------------------------------------------
  alias on_actor_ok_oth on_actor_ok
  def on_actor_ok
    on_actor_ok_oth
    @turn_window.visible = true
    $turn_back = true
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Actor [Cancel]
  #--------------------------------------------------------------------------
  alias on_actor_cancel_oth on_actor_cancel
  def on_actor_cancel
    on_actor_cancel_oth
    @turn_window.visible = false
    $turn_back = false
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Start Enemy Selection
  #--------------------------------------------------------------------------
  alias select_enemy_selection_oth select_enemy_selection
  def select_enemy_selection
    select_enemy_selection_oth
    @turn_window.visible = false
    $turn_back = false
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Enemy [Cancel]
  #--------------------------------------------------------------------------
  alias on_enemy_cancel_oth on_enemy_cancel
  def on_enemy_cancel
    on_enemy_cancel_oth
    @turn_window.visible = false
    $turn_back = false
    if @actor_command_window.active
      $turn_back = true
      @turn_window.visible = true
    end
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Enemy [OK]
  #--------------------------------------------------------------------------
  alias on_enemy_ok_oth on_enemy_ok
  def on_enemy_ok
    on_enemy_ok_oth
    @turn_window.visible = false
    $turn_back = false
    if @actor_command_window.active
      $turn_back = true
      @turn_window.visible = true
    end
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # * [Attack] Command
  #--------------------------------------------------------------------------
  alias command_attack_oth command_attack
  def command_attack
    command_attack_oth
    @turn_window.visible = false
    $turn_back = false
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● Turn start(alias)
  #--------------------------------------------------------------------------
  alias turn_start_org turn_start
  def turn_start
    turn_start_org
    @turn_window.visible = false
    $turn_back = false
    @turn_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● Turn end(alias)
  #--------------------------------------------------------------------------
  alias turn_end_org turn_end
  def turn_end
    turn_end_org
    @turn_window.visible = true
    $turn_back = true
    @turn_window.refresh
  end
  
end
#==============================================================================
# ■ Window_Turn
# 　 Window that displays the current number of turns
#==============================================================================

class Window_Turn < Window_Base

  if Prico::WindowBack == true
	  #--------------------------------------------------------------------------
	  # ● Object initialization
	  #--------------------------------------------------------------------------
	  def initialize(x, y)
		super(Prico::WindowX,Prico::WindowY,(Prico::Use_Icon ? Prico::WindowW - 25 : Prico::WindowW),line_height * 2)
		self.contents = Bitmap.new(self.width - 24, self.height - 28)
		self.opacity = Prico::View
		refresh
	  end
	  #--------------------------------------------------------------------------
	  # ● Refresh
	  #--------------------------------------------------------------------------
	  def refresh
		self.contents.clear
		self.contents.font.size = 23
		@text = sprintf("%2d%s", $game_troop.turn_count+1,Prico::Use_Icon ? draw_icon(Prico::Icon,0 + 25,0) : " TURN")
		draw_text_ex(0, 0, @text)
		reset_font_settings
	  end 
  else
	  #--------------------------------------------------------------------------
	  # ● Object initialization
	  #--------------------------------------------------------------------------
	  def initialize(x, y)
		super(Prico::WindowX,Prico::WindowY,(Prico::Use_Icon ? Prico::WindowW - 25 : Prico::WindowW),line_height * 2)
		self.contents = Bitmap.new(self.width - 24, self.height - 28)
		self.windowskin = Cache.system("Window_blank")
		self.opacity = Prico::View
		create_back_bitmap_turn
		create_back_sprite_turn
		refresh
	  end
	  #--------------------------------------------------------------------------
	  # * Dispose Background Bitmap
	  #--------------------------------------------------------------------------
	  def dispose
		super
		dispose_back_bitmap_turn
		dispose_back_sprite_turn
	  end
	  #--------------------------------------------------------------------------
	  # * Create Background Bitmap
	  #--------------------------------------------------------------------------
	  def create_back_bitmap_turn
		@back_bitmap_turn = Bitmap.new(width, height)
		rect1 = Rect.new(0, 0, width, 12)
		rect2 = Rect.new(0, 12, width, height - 24)
		rect3 = Rect.new(0, height - 12, width, 12)
		@back_bitmap_turn.gradient_fill_rect(rect1, back_color2, back_color1, true)
		@back_bitmap_turn.fill_rect(rect2, back_color1)
		@back_bitmap_turn.gradient_fill_rect(rect3, back_color1, back_color2, true)
	  end
	  #--------------------------------------------------------------------------
	  # * Get Background Color 1
	  #--------------------------------------------------------------------------
	  def back_color1
		Color.new(0, 0, 0, Prico::View)
	  end
	  #--------------------------------------------------------------------------
	  # * Get Background Color 2
	  #--------------------------------------------------------------------------
	  def back_color2
		Color.new(0, 0, 0, Prico::View)
	  end
	  #--------------------------------------------------------------------------
	  # * Create Background Sprite
	  #--------------------------------------------------------------------------
	  def create_back_sprite_turn
		@back_sprite_turn = Sprite.new
		@back_sprite_turn.bitmap = @back_bitmap_turn
		@back_sprite_turn.z = z - 1
		@back_sprite_turn.y = Prico::WindowY
		@back_sprite_turn.x = Prico::WindowX
	  end
	  #--------------------------------------------------------------------------
	  # * Update Background Sprite
	  #--------------------------------------------------------------------------
	  def update_back_sprite_turn
		@back_sprite_turn.visible = $turn_back
		@back_sprite_turn.update
	  end
	  #--------------------------------------------------------------------------
	  # ● Refresh
	  #--------------------------------------------------------------------------
	  def refresh
		update_back_sprite_turn
		self.contents.clear
		self.contents.font.size = 23
		@text = sprintf("%2d%s", $game_troop.turn_count+1,Prico::Use_Icon ? draw_icon(Prico::Icon,0 + 25,0) : " TURN")
		draw_text_ex(0, 0, @text)
		reset_font_settings
	  end
	  #--------------------------------------------------------------------------
	  # * Free Background Bitmap
	  #--------------------------------------------------------------------------
	  def dispose_back_bitmap_turn
		@back_bitmap_turn.dispose
	  end
	  #--------------------------------------------------------------------------
	  # * Free Background Sprite
	  #--------------------------------------------------------------------------
	  def dispose_back_sprite_turn
		@back_sprite_turn.dispose
	  end
  end
end
