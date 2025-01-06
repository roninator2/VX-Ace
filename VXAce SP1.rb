#==============================================================================
# ■ VXAce_SP1
#------------------------------------------------------------------------------
# Fixed a bug in the preset script. User-defined script material
# As a general rule, place it below this section.
#==============================================================================

#------------------------------------------------------------------------------
# [Fixes]
#------------------------------------------------------------------------------
# ● Add and remove the same state at the same time using the 
#   event command [Change state].
#   Fixed a bug where the second and subsequent additions would fail when
# ● The currently displayed animation is mapped using the 
#   event command [Display animation].
#   Fixed a bug that did not synchronize with the screen scroll.
# ● Fixed an issue where automatic battle actions were not selected correctly.
# ● Because the equipment that can no longer be equipped is removed, 
#   another equipment cannot be equipped.
#   Fixed an issue where the equipment would multiply when
# ● Fixed an issue where an extra load was required after executing 
#   the event command [Erase Picture]. Fixed
# ● With the movement route option [Skip if unable to move] checked.
#   When you touch an event with a trigger [Contacted by player], 
#   the event is running.
#   Fixed a bug where a startup reservation was made even if the
# ● Fixed an issue where state effectiveness was not reflected for 
#   magic reflected skills.
# ● Fixed a bug where even if bold or italic was enabled in the default font 
#   settings, it would return to the disabled state when switching the 
#   status screen.
#------------------------------------------------------------------------------
class Game_Battler
  attr_accessor :magic_reflection
  #--------------------------------------------------------------------------
  # ● Judgment of hostility
  #--------------------------------------------------------------------------
  alias vxace_sp1_opposite? opposite?
  def opposite?(battler)
    vxace_sp1_opposite?(battler) || battler.magic_reflection
  end
end
#------------------------------------------------------------------------------
class Game_Actor
  #--------------------------------------------------------------------------
  # ● Remove equipment that cannot be equipped
  #     item_gain : Return the removed equipment to the party
  #--------------------------------------------------------------------------
  alias vxace_sp1_release_unequippable_items release_unequippable_items
  def release_unequippable_items(item_gain = true)
    loop do
      last_equips = equips.dup
      vxace_sp1_release_unequippable_items(item_gain)
      return if equips == last_equips
    end
  end
  #--------------------------------------------------------------------------
  # ● Create combat actions for automatic battles
  #--------------------------------------------------------------------------
  def make_auto_battle_actions
    @actions.size.times do |i|
      @actions[i] = make_action_list.max_by {|action| action.value }
    end
  end
end
#------------------------------------------------------------------------------
class Game_Player
  #--------------------------------------------------------------------------
  # ● Triggering a map event
  #     triggers : Array of triggers
  #     normal   : Priority [same as normal character] or something else?
  #--------------------------------------------------------------------------
  alias vxace_sp1_start_map_event start_map_event
  def start_map_event(x, y, triggers, normal)
    return if $game_map.interpreter.running?
    vxace_sp1_start_map_event(x, y, triggers, normal)
  end
end
#------------------------------------------------------------------------------
class Game_Picture
  #--------------------------------------------------------------------------
  # ● Erase picture
  #--------------------------------------------------------------------------
  alias vxace_sp1_erase erase
  def erase
    vxace_sp1_erase
    @origin = 0
  end
end
#------------------------------------------------------------------------------
class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● Change state
  #--------------------------------------------------------------------------
  alias vxace_sp1_command_313 command_313
  def command_313
    vxace_sp1_command_313
    $game_party.clear_results
  end
end
#------------------------------------------------------------------------------
class Sprite_Character
  #--------------------------------------------------------------------------
  # ● Update location
  #--------------------------------------------------------------------------
  alias vxace_sp1_update_position update_position
  def update_position
    move_animation(@character.screen_x - x, @character.screen_y - y)
    vxace_sp1_update_position
  end
  #--------------------------------------------------------------------------
  # ● moving animation
  #--------------------------------------------------------------------------
  def move_animation(dx, dy)
    if @animation && @animation.position != 3
      @ani_ox += dx
      @ani_oy += dy
      @ani_sprites.each do |sprite|
        sprite.x += dx
        sprite.y += dy
      end
    end
  end
end
#------------------------------------------------------------------------------
class Sprite_Picture
  #--------------------------------------------------------------------------
  # ● Update source bitmap
  #--------------------------------------------------------------------------
  alias vxace_sp1_update_bitmap update_bitmap
  def update_bitmap
    if @picture.name.empty?
      self.bitmap = nil
    else
      vxace_sp1_update_bitmap
    end
  end
end
#------------------------------------------------------------------------------
class Window_Base
  #--------------------------------------------------------------------------
  # ● Resetting font settings
  #--------------------------------------------------------------------------
  alias vxace_sp1_reset_font_settings reset_font_settings
  def reset_font_settings
    vxace_sp1_reset_font_settings
    contents.font.bold = Font.default_bold
    contents.font.italic = Font.default_italic
  end
end
#------------------------------------------------------------------------------
class Scene_Battle
  #--------------------------------------------------------------------------
  # ● Activation of magic reflex
  #--------------------------------------------------------------------------
  alias vxace_sp1_invoke_magic_reflection invoke_magic_reflection
  def invoke_magic_reflection(target, item)
    @subject.magic_reflection = true
    vxace_sp1_invoke_magic_reflection(target, item)
    @subject.magic_reflection = false
  end
end
