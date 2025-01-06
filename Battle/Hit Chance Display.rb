# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Message for Hit Chance                 ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Show hit chance percentage                    ║    12 May 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Display a message for change to hit                          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Configure settings below                                         ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 22 Nov 2024 - Script finished                               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Vlue & Tsukihime                                                 ║
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

module R2_HIT
  #Whether to place the hit chance text above or below the enemy
  ABOVE_MONSTER = false
  #Text to display next to hit chance number
  HIT_TEXT = "Chance to hit"
  #The width of the text
  TEXT_WIDTH = 150
  #The height of the text
  TEXT_HEIGHT = 20
  #Offset the hit rate along the x-axis(left,right)
  TEXT_OFFSET_X = -50
  #Offset the hit rate along the y-axis(up,down)
  TEXT_OFFSET_Y = 2
  
  #The width of the text placement make larger if text is cut off
  LOC_WIDTH = 100
  #The height of the text placement
  LOC_HEIGHT = 15

  #Size of the displayed text
  TEXT_SIZE = Font.default_size
  #Font of the displayed text
  TEXT_FONT = Font.default_name
 
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Sprite_Battler
  alias hitrate_update update
  def update
    hitrate_update
    return unless @battler.is_a?(Game_Enemy)
    if @battler
      update_hitrate
    end
  end
  def update_hitrate
    setup_hitrate if @hit_rate.nil?
    if @hit_display.nil?
      @hit_display = Sprite_Base.new(self.viewport)
      @hit_display.bitmap = Bitmap.new(R2_HIT::TEXT_WIDTH,R2_HIT::TEXT_SIZE)
      @hit_display.bitmap.font.size = R2_HIT::TEXT_SIZE
      @hit_display.bitmap.font.name = R2_HIT::TEXT_FONT
      @hit_display.x = @hit_rate.x + R2_HIT::TEXT_OFFSET_X
      @hit_display.y = @hit_rate.y + R2_HIT::TEXT_OFFSET_Y
      @hit_display.z = 111
    end
    determine_text_visible
    return unless @hit_rate.visible
    if @hit_rate.opacity != self.opacity
      @hit_rate.opacity = self.opacity
    end
    @hit_rate.bitmap.clear
    @hit_display.opacity = @hit_rate.opacity if @hit_display.opacity != @hit_rate.opacity
    @hit_display.bitmap.clear
    text = draw_hit_rate(@hit_display.x,@hit_display.y)
    return if text.nil?
    @hit_display.bitmap.draw_text(0,0,R2_HIT::TEXT_WIDTH,@hit_display.height,text)
  end
  
  def setup_hitrate
    @hit_rate = Sprite_Base.new(self.viewport)
    width = R2_HIT::LOC_WIDTH
    height = R2_HIT::LOC_HEIGHT
    @hit_rate.bitmap = Bitmap.new(width,height)
    @hit_rate.x = self.x + @hit_rate.width / 2 + R2_HIT::TEXT_OFFSET_X
    @hit_rate.y = self.y + R2_HIT::TEXT_OFFSET_Y - self.bitmap.height - @hit_rate.height
    @hit_rate.y = self.y + R2_HIT::TEXT_OFFSET_Y unless R2_HIT::ABOVE_MONSTER
    @hit_rate.x = 0 if @hit_rate.x < 0
    @hit_rate.y = 0 if @hit_rate.y < 0
    @hit_rate.z = 104
  end
  
  def determine_text_visible
    if !@battler.alive?
      @hit_rate.visible = false
      @hit_display.visible = false
      return if !@battler.alive?
    end
    @hit_rate.visible = true
    return unless SceneManager.scene.is_a?(Scene_Battle)
    return unless SceneManager.scene.enemy_window
    @hit_rate.visible = SceneManager.scene.target_window_index == @battler.index
    @hit_rate.visible = false if !SceneManager.scene.enemy_window.active
    @hit_display.visible = false if !@hit_rate.visible
    @hit_display.visible = true if @hit_rate.visible
  end
  
  alias hitrate_dispose dispose
  def dispose
    @hit_rate.dispose if @hit_rate
    @hit_display.dispose if @hit_display
    hitrate_dispose
  end

  #-----------------------------------------------------------------------------
  # New
  #-----------------------------------------------------------------------------
  def draw_hit_rate(dx, dy)
    return unless SceneManager.scene_is?(Scene_Battle)
    return unless SceneManager.scene.enemy_window
    reveal(SceneManager.scene.enemy_window.enemy)
    hitdata = (get_hit_rate * 100).to_i
    text = "#{R2_HIT::HIT_TEXT} #{hitdata}%"
    return text
  end
  
  def reveal(battler)
    return if @battler == battler
    @battler = battler
  end
  
  def actor; return BattleManager.actor; end

  def get_hit_rate
    hit_rate = @battler.item_hit(actor, actor.current_action.item)
    evade_rate = @battler.item_eva(actor, actor.current_action.item)
    return (hit_rate) * (1 - evade_rate)
  end
end

class Scene_Battle
  attr_reader  :enemy_window
  def target_window_index
    begin
    @enemy_window.enemy.index
    rescue
      return -1
    end
  end
end
