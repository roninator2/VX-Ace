#=============================================================================
#
#  Compatibility Patch for Galv's Character Effects and
#    Victor Sant's Multiframes and Diagonal Movement 
#       also appears to work for Khas Awesome lights - Roninator2
#  Version 0.1 (28th June, 2018)
#  By Another Fen <forums.rpgmakerweb.com>
#
#  (Consists in large parts of code copied from the aforementioned scripts)
#
# Contents: ------------------------------------------------------------------
#  This Script modifies the Sprite part of Galv's Character Effects to make
#  them compatible to Victor Sant's Multiframes and Diagonal Movement.
#
# Usage: ---------------------------------------------------------------------
#  Requires Victor Sant's Multiframes (1.03) and Diagonal Movement (1.09)
#  Should be placed below Galv's Character Effects (2.1).
#  
#=============================================================================

#=============================================================================
#  Sprite_Character
#=============================================================================
class Sprite_Character
 
  #---------------------------------------------------------------------------
  # Sprite_Character#update_src_rect  (Modified)
  #   Extracted character index. Includes Multiframes / Diagonal Movement.
  #---------------------------------------------------------------------------
  def update_src_rect
    if @tile_id == 0
      index = character_index
      sx = (index % 4 * horizontal_frames + pattern_index) * @cw
      sy = (index / 4 * vertical_frames + direction_index) * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
    end
  end
 
  #---------------------------------------------------------------------------
  # Sprite_Character#character_index
  #   Displayed character set index.
  #---------------------------------------------------------------------------
  def character_index
    @character.character_index
  end
 
  #---------------------------------------------------------------------------
  # Sprite_Character#horizontal_frames
  #   Number of horizontal frames per character set
  #---------------------------------------------------------------------------
  def horizontal_frames
    @character_name[/\[F(\d+)\]/i] ? @character.frames : 3
  end
 
  #---------------------------------------------------------------------------
  # Sprite_Character#vertical_frames
  #   Number of vertical frames per character set
  #---------------------------------------------------------------------------
  def vertical_frames
    4
  end
 
  #---------------------------------------------------------------------------
  # Sprite_Character#pattern_index
  #   Displayed character pattern index
  #---------------------------------------------------------------------------
  def pattern_index
    pattern = @character.pattern
    return (pattern < 3 || @character_name[/\[F(\d+)\]/i]) ? pattern : 1
  end
 
  #---------------------------------------------------------------------------
  # Sprite_Character#direction_index
  #   Displayed character direction index
  #---------------------------------------------------------------------------
  def direction_index
    if @character.diagonal?
      return { 1 => 0, 7 => 1, 3 => 2, 9 => 3 }[@diagonal]
    else
      return (@character.direction - 2) / 2
    end
  end
 
  #---------------------------------------------------------------------------
  # Sprite_Character#extended_bitmap_name
  #   Extended alternate bitmap names for subclasses (see Diagonal Movement)
  #---------------------------------------------------------------------------
  def extended_bitmap_name(name)
    extended_name = name + ($imported[:ve_visual_equip] ? "" : diagonal_sufix)
    return character_exist?(extended_name) ? extended_name : name
  end
end


#=============================================================================
#  Sprite_Reflect
#=============================================================================
class Sprite_Reflect
 
  #---------------------------------------------------------------------------
  # Sprite_Reflect#set_character_bitmap  (Modified)
  #   Moved changes to other methods designated by the VE Basic Module.
  #---------------------------------------------------------------------------
  def set_character_bitmap
    super
  end
 
  #---------------------------------------------------------------------------
  # Sprite_Reflect#set_bitmap_name  (Overridden)
  #   See Sprite_Reflect#set_character_bitmap
  #---------------------------------------------------------------------------
    def set_bitmap_name
    reflect = @character.reflect_sprite
    return (reflect) ? extended_bitmap_name(reflect[0]) : super
  end
 
  #---------------------------------------------------------------------------
  # Sprite_Reflect#set_bitmap_position  (Overridden)
  #   See Sprite_Reflect#set_character_bitmap
  #---------------------------------------------------------------------------
  def set_bitmap_position
    self.mirror = true
    self.angle = 180
    self.opacity = 220
    self.z = Galv_CEffects::REFLECT_Z
    self.wave_amp = $game_map.reflect_options[0]
    super
  end
 
  #---------------------------------------------------------------------------
  # Sprite_Reflect#character_index  (Overridden)
  #   Specify reflection character index
  #---------------------------------------------------------------------------
  def character_index
    @character.reflect_sprite ? @character.reflect_sprite[1] : super
  end
end


#=============================================================================
#  Sprite_Mirror
#=============================================================================
class Sprite_Mirror
 
  #---------------------------------------------------------------------------
  # Sprite_Mirror#set_character_bitmap  (Modified)
  #   Move changes to methods designated by the VE basic module
  #---------------------------------------------------------------------------
  def set_character_bitmap
    super
  end
 
  #---------------------------------------------------------------------------
  # Sprite_Mirror#set_bitmap_name  (Overridden)
  #   See Sprite_Mirror#set_character_bitmap
  #---------------------------------------------------------------------------
  def set_bitmap_name
    reflect = @character.reflect_sprite
    return (reflect) ? extended_bitmap_name(reflect[0]) : super
  end
 
  #---------------------------------------------------------------------------
  # Sprite_Mirror#set_bitmap_position  (Overridden)
  #   See Sprite_Mirror#set_character_bitmap
  #---------------------------------------------------------------------------
  def set_bitmap_position
    self.mirror = true
    self.opacity = 255
    self.z = Galv_CEffects::REFLECT_Z
    super
  end

  #---------------------------------------------------------------------------
  # Sprite_Mirror#character_index  (Overridden)
  #   Specify reflection character index
  #---------------------------------------------------------------------------
  def character_index
    @character.reflect_sprite ? @character.reflect_sprite[1] : super
  end
 
  #---------------------------------------------------------------------------
  # Sprite_Mirror#direction_index  (Overridden)
  #   Mirror direction
  #---------------------------------------------------------------------------
  def direction_index
    return vertical_frames - 1 - super
  end
end


#=============================================================================
#  Sprite_Shadow
#=============================================================================
class Sprite_Shadow < Sprite_Character

  #---------------------------------------------------------------------------
  # Sprite_Shadow#set_character_bitmap  (Modified)
  #   Move changes to methods designated by the VE basic module
  #---------------------------------------------------------------------------
  def set_character_bitmap
    super
  end
 
  #---------------------------------------------------------------------------
  # Sprite_Shadow#set_bitmap_position  (Overridden)
  #   See Sprite_Mirror#set_character_bitmap
  #---------------------------------------------------------------------------
  def set_bitmap_position
    self.color = Color.new(0, 0, 0, 255)
    self.z = Galv_CEffects::SHADOW_Z
    self.wave_amp = 1 if $game_map.shadow_options[2]
    self.wave_speed = 1000
    super
  end
end
class Sprite_Shadow
 
  #---------------------------------------------------------------------------
  # Sprite_Shadow#blend_update  (Overridden)
  #   Remove the color change introduced by Vlue's Eventing Fine Tuning
  #---------------------------------------------------------------------------
  def blend_update
  end
end
