#==============================================================================
# ** Earthbound-Ish Battle Core
#------------------------------------------------------------------------------
# Version: 1.1
# Author: cozziekuns 
# Fixed by Roninator2
# Date: February 17, 2013
#==============================================================================
# Description:
#------------------------------------------------------------------------------
# This script attempts to mimic the battle system of the Earthbound/Mother 
# series; most notably Earthbound and Earthbound 2 (Mother 2 and 3).
#==============================================================================
# Instructions:
#------------------------------------------------------------------------------
# Paste this script into its own slot in the Script Editor, above Main but 
# below Materials. Edit the modules to your liking.
#==============================================================================

#==============================================================================
# ** Cozziekuns
#==============================================================================

module Cozziekuns
  
  module Earthboundish
    
    ActorIcons ={
      # Command Name => IconID
      "Attack" => 116, 
      "Magic" => 152, 
      "Special" => 128, 
      "Guard" => 161,
      "Items" => 260,
      "Escape" => 474,
    }
    
  end
  
end

include Cozziekuns

#==============================================================================
# ** Sprite Battler
#==============================================================================

class Sprite_Battler

  alias coz_ebish_spbtlr_update_effect update_effect
  def update_effect(*args)
    update_select_whiten if @effect_type == :select_white
    if @battler.sprite_effect_type == :select_white_to_normal
      revert_to_normal
      @battler.sprite_effect_type = nil
    end
    coz_ebish_spbtlr_update_effect(*args)
  end

  def update_select_whiten
    self.color.set(255, 255, 255, 0)
    self.color.alpha = 128
  end
  
end

#==============================================================================
# ** Window_ActorCommand
#==============================================================================

class Window_ActorCommand

  def visible_line_number
    return 1
  end

  def col_max
    return 6
  end

  def contents_height
    item_height
  end

  def top_col
    ox / (item_width + spacing)
  end

  def top_col=(col)
    col = 0 if col < 0
    col = col_max - 1 if col > col_max - 1
    self.ox = col * (item_width + spacing)
  end

  def bottom_col
    top_col + col_max - 1
  end

  def bottom_col=(col)
    self.top_col = col - (col_max - 1)
  end

  def ensure_cursor_visible
    self.top_col = index if index < top_col
    self.bottom_col = index if index > bottom_col
  end

  def item_rect(index)
    rect = super
    rect.x = index * (item_width + spacing)
    rect.y = 0
    rect
  end

  def window_width
    Graphics.width - 224
  end
  
  def open
    @help_window.open
    super
  end
  
  def close
    @help_window.close
    super
  end
  
  def update
    super
    @help_window.update
  end
  
  def draw_item(index)
    rect = item_rect_for_text(index)
    x = rect.x + rect.width / 2 - 12
    y = item_rect_for_text(index).y
    draw_icon(Earthboundish::ActorIcons[command_name(index)], x, y, command_enabled?(index))
  end
  
  alias coz_ebish_waccmd_make_command_list make_command_list
  def make_command_list(*args)
    coz_ebish_waccmd_make_command_list(*args)
    add_escape_command
  end
  
  def add_escape_command
    add_command(Vocab::escape, :escape, BattleManager.can_escape?)
  end
  
  def update_help
    @help_window.set_text(command_name(index))
  end
  
end

#==============================================================================
# ** Window_BattleStatus
#==============================================================================

class Window_BattleStatus
  
  [:basic_area_rect, :gauge_area_rect].each { |method|
    define_method(method) { |index|
      rect = item_rect(index)
      rect
    }
  }
  
  def col_max
    $game_party.members.size
  end
  
  def window_width
    if $game_party.members.size == 1
      Graphics.width / ( 3.5 / $game_party.members.size.to_f )
    elsif $game_party.battle_members.size == 2
      Graphics.width / ( 3.8 / $game_party.members.size.to_f )
    elsif $game_party.battle_members.size == 3
      Graphics.width / ( 4 / $game_party.members.size.to_f )
    else
      Graphics.width
    end
  end
#~   def window_width
#~     (Graphics.width / ( 4 / $game_party.members.size.to_f )) + 12
#~   end
  
  def window_height
    fitting_height($data_system.opt_display_tp ? 5 : 4)
  end
  
  def item_width
    (window_width - standard_padding * 2) / $game_party.members.size
  end
  
  def item_height
    (window_height - standard_padding * 2)
  end
  
  def draw_basic_area(rect, actor)
    draw_actor_name(actor, rect.x, rect.y, rect.width)
    draw_actor_icons(actor, rect.x + 4, rect.y + line_height, rect.width)
  end

  def draw_gauge_area_with_tp(rect, actor)
    draw_gauge_area_without_tp(rect, actor)
    draw_actor_tp(actor, rect.x + 4, rect.y + line_height * 4, rect.width - 8)
  end

  def draw_gauge_area_without_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 4, rect.y + line_height * 2, rect.width - 8)
    draw_actor_mp(actor, rect.x + 4, rect.y + line_height * 3, rect.width - 8)
  end
  
  def draw_actor_name(actor, x, y, width = 112)
    change_color(hp_color(actor))
    draw_text(x, y, width, line_height, actor.name, 1)
  end
  
  alias coz_ebish_wbtlsts_item_rect item_rect
  def item_rect(index, *args)
    rect = coz_ebish_wbtlsts_item_rect(index, *args)
    rect.x = index % col_max * item_width
    rect
  end
  
  def update
    super
    update_position
  end
  
  def update_position
    self.x = (Graphics.width - window_width) / 2 + 128
  end
  
end

#==============================================================================
# ** Window_BattleActor
#==============================================================================

class Window_BattleActor 
  
  def update_position
    self.x = (Graphics.width - window_width) / 2 
  end
  
end

#==============================================================================
# ** Window_BattleEnemy
#==============================================================================

class Window_BattleEnemy 
  
  def cursor_left(wrap)
    select((index - 1 + item_max) % item_max)
  end
  
  def cursor_right(wrap)
    select((index + 1) % item_max)
  end
  
  def cursor_up(wrap)
    cursor_left(true)
  end
  
  def cursor_down(wrap)
    cursor_right(true)
  end

  def show
    select(0)
    self
  end
  
  def update_help
    @help_window.set_text(enemy.name)
  end

end

#==============================================================================
# ** Window_BattleSkill + Window_BattleItem
#==============================================================================

[:Window_BattleSkill, :Window_BattleItem].each { |klass|
  Object.const_get(klass).send(:define_method, :show) {
    select_last
    super()
  }
  Object.const_get(klass).send(:define_method, :hide) { super() }
}

#==============================================================================
# ** Window_ActorHelp
#==============================================================================

class Window_ActorHelp < Window_Help
  
  def initialize
    super(1)
    self.openness = 0
    update_position
  end
  
  def update_position
    self.x = Graphics.width - 224
    self.width = 224
    create_contents
  end
  
  def refresh
    contents.clear
    draw_text(4, 0, 224 - standard_padding * 2, line_height, @text, 1)
  end
  
end

#==============================================================================
# ** Scene_Battle
#==============================================================================

class Scene_Battle
  
  def start_party_command_selection
    unless scene_changing?
      @status_window.open
      @status_window.refresh
      if BattleManager.input_start
        next_command
        start_actor_command_selection
      else
        @party_command_window.deactivate
        turn_start
      end
    end
  end
  
  def create_actor_command_window
    @actor_command_window = Window_ActorCommand.new
    @actor_command_window.set_handler(:attack, method(:command_attack))
    @actor_command_window.set_handler(:skill,  method(:command_skill))
    @actor_command_window.set_handler(:guard,  method(:command_guard))
    @actor_command_window.set_handler(:item,   method(:command_item))
    @actor_command_window.set_handler(:escape, method(:command_escape))
    @actor_command_window.set_handler(:cancel, method(:prior_command))
    @actor_command_window.help_window = @actor_help_window = Window_ActorHelp.new
  end
  
  def create_help_window
    @help_window = Window_Help.new(1)
    @help_window.visible = false
  end
  
  alias coz_ebish_scbtl_create_enemy_window create_enemy_window
  def create_enemy_window(*args)
    coz_ebish_scbtl_create_enemy_window(*args)
    @enemy_window.help_window = @actor_command_window.help_window
  end
  
  alias coz_ebish_scbtl_update_basic update_basic
  def update_basic(*args)
    old_enemy = @enemy_window.active ? @enemy_window.enemy : nil
    @old_enemy.sprite_effect_type = nil if !@old_enemy.nil? && !@enemy_window.active
    @old_enemy = @enemy_window.active ? @enemy_window.enemy : nil
    coz_ebish_scbtl_update_basic(*args)
    update_enemy_whiten(old_enemy)
  end
  
  def update_enemy_whiten(old_enemy)
    if @old_enemy.nil?
      @enemy_window.enemy.sprite_effect_type = :whiten if @enemy_window.active
    elsif @enemy_window.active
      @old_enemy.sprite_effect_type = nil if @old_enemy != @enemy_window.enemy
      @enemy_window.enemy.sprite_effect_type = :whiten
    elsif !@enemy_window.active
      @old_enemy.sprite_effect_type = nil if !@old_enemy.dead?
    end
  end
  
  def update_info_viewport
    move_info_viewport(128)
  end

end
