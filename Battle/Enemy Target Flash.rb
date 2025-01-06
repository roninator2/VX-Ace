# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Enemy Target Flash                     ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Alter spriteset effect on enemy             ║    07 Jan 2024     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Flash Enemy sprite when selecting the enemy                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Plug and play                                                    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 07 Jan 2024 - Script finished                               ║
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

#==============================================================================
# ■ Window_BattleEnemy
#------------------------------------------------------------------------------
# 　This is the window where you select the enemy character 
#    to act on on the battle screen.
#==============================================================================

class Window_BattleEnemy < Window_Selectable

  #--------------------------------------------------------------------------
  # ● window display
  #--------------------------------------------------------------------------
  alias show2 show
  def show
    @target_anim_on = true
    @old_index = nil
    show2
  end
  #--------------------------------------------------------------------------
  # ● Hiding a window
  #--------------------------------------------------------------------------
  alias hide2 hide
  def hide
    old_enemy.sprite_effect_type = :whiten_loop_stop if @old_index != nil
    enemy.sprite_effect_type = :whiten_loop_stop
    @target_anim_on = false
    @old_index = nil
    hide2
  end
  #--------------------------------------------------------------------------
  # ● Window update
  #--------------------------------------------------------------------------
  def update
    super
    update_target_anim
  end
  #--------------------------------------------------------------------------
  # ● Target anime update
  #--------------------------------------------------------------------------
  def update_target_anim
    return if @target_anim_on == nil
    if @target_anim_on && @index != @old_index
      old_enemy.sprite_effect_type = :whiten_loop_stop if @old_index != nil
      enemy.sprite_effect_type = :whiten_loop
    end
    @old_index = @index    
  end
  #--------------------------------------------------------------------------
  # ● Get previous enemy character object
  #--------------------------------------------------------------------------
  def old_enemy
    $game_troop.alive_members[@old_index]
  end

end

#==============================================================================
# ■ Sprite_Battler
#------------------------------------------------------------------------------
# This is a sprite for displaying a battler. 
# Game_Battler monitor instances of a class,
# Automatically change the sprite's state.
#==============================================================================
class Sprite_Battler < Sprite_Base

  #--------------------------------------------------------------------------
  # ● Start of effect
  #--------------------------------------------------------------------------
  def start_effect(effect_type)
    @effect_type = effect_type
    case @effect_type
    when :appear
      @effect_duration = 16
      @battler_visible = true
    when :disappear
      @effect_duration = 32
      @battler_visible = false
    when :whiten
      @effect_duration = 16
      @battler_visible = true
    when :blink
      @effect_duration = 20
      @battler_visible = true
    when :collapse
      @effect_duration = 48
      @battler_visible = false
    when :boss_collapse
      @effect_duration = bitmap.height
      @battler_visible = false
    when :instant_collapse
      @effect_duration = 16
      @battler_visible = false
    when :whiten_loop
      @whiten_cnt = 0.0
      @effect_duration = -1
      @battler_visible = true
    when :whiten_loop_stop
      @effect_duration = -1
    end
    revert_to_normal
  end
  #--------------------------------------------------------------------------
  # ● Effect update
  #--------------------------------------------------------------------------
  alias update_effect2 update_effect
  def update_effect
    update_effect2
    if @effect_duration < 0
      case @effect_type
      when :whiten_loop
        update_whiten_loop
      when :whiten_loop_stop
        update_whiten_loop_stop
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● Effect on selection
  #--------------------------------------------------------------------------
  def update_whiten_loop
    d=(-90+@whiten_cnt/180)*Math::PI
    col = 255 * Math.sin(d)
    @whiten_cnt += 6
    @whiten_cnt %= 180        
    self.color.set(col, col, col, col)
  end
  #--------------------------------------------------------------------------
  # ● Effect ends when selected
  #--------------------------------------------------------------------------
  def update_whiten_loop_stop
    @whiten_cnt = 0.0
    self.color.set(0, 0, 0, 0)
    @effect_duration = 0
    @effect_type = nil
  end

end
