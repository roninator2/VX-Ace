# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Display Damage Values                  ║  Version: 1.07     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Show potential damage values                ║    13 May 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Displays text on battler to show damage range                ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Configure settings below                                         ║
# ║ Updates:                                                           ║
# ║   - When selecting a skill, the window will now hide               ║
# ║   - Corrected damage value checking every frame                    ║
# ║   - fixed error when first battler is defeated                     ║
# ║   - Added Color Settings                                           ║
# ║   - Fixed formula processing for variable use                      ║
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

module R2_DAM
  #Whether to place the hp bar above or below the enemy
  ABOVE_MONSTER = true
  #The width of the hp bar
  TEXT_WIDTH = 150
  #The height of the hp bar
  TEXT_HEIGHT = 20
  #Offset the hit rate along the x-axis(left,right)
  TEXT_OFFSET_X = -50
  #Offset the hit rate along the y-axis(up,down)
  TEXT_OFFSET_Y = 2

  #The width of the hp bar
  LOC_WIDTH = 100
  #The height of the hp bar
  LOC_HEIGHT = 15

  #Size of the displayed text
  TEXT_SIZE = Font.default_size
  #Font of the displayed text
  TEXT_FONT = Font.default_name

  TEXT_RED = 255
  TEXT_GREEN = 255
  TEXT_BLUE = 255

  TEXT = "damage"
 
  DAMAGE_SWITCH = 2
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

$imported = {} if $imported.nil?

class Sprite_Battler
  alias dam_value_update update
  def update
    dam_value_update
    return unless @battler.is_a?(Game_Enemy)
    if @battler
      update_dam_value
    end
  end
  def update_dam_value
    setup_dam_value if @dam_value.nil?
    if @dam_display.nil?
      @dam_display = Sprite_Base.new(self.viewport)
      @dam_display.bitmap = Bitmap.new(R2_DAM::TEXT_WIDTH,R2_DAM::TEXT_SIZE)
      @dam_display.bitmap.font.color.set(R2_DAM::TEXT_RED, R2_DAM::TEXT_GREEN, R2_DAM::TEXT_BLUE)
      @dam_display.bitmap.font.size = R2_DAM::TEXT_SIZE
      @dam_display.bitmap.font.name = R2_DAM::TEXT_FONT
      @dam_display.x = @dam_value.x + R2_DAM::TEXT_OFFSET_X
      @dam_display.y = @dam_value.y + R2_DAM::TEXT_OFFSET_Y
      @dam_display.z = 110
    end
    determine_dam_visible
    return unless @dam_value.visible
    if @dam_value.opacity != self.opacity
      @dam_value.opacity = self.opacity
    end
    @dam_value.bitmap.clear
    @dam_display.opacity = @dam_value.opacity if @dam_display.opacity != @dam_value.opacity
    @dam_display.bitmap.clear
    text = draw_dam_value(@dam_display.x,@dam_display.y)
    return if text.nil?
    @dam_display.bitmap.draw_text(0,0,R2_DAM::TEXT_WIDTH,@dam_display.height,text)
  end

  def setup_dam_value
    @dam_value = Sprite_Base.new(self.viewport)
    width = R2_DAM::LOC_WIDTH
    height = R2_DAM::LOC_HEIGHT
    @dam_value.bitmap = Bitmap.new(width,height)
    @dam_value.x = self.x + @dam_value.width / 2 + R2_DAM::TEXT_OFFSET_X
    @dam_value.y = self.y + R2_DAM::TEXT_OFFSET_Y - self.bitmap.height - @dam_value.height
    @dam_value.y = self.y + R2_DAM::TEXT_OFFSET_Y unless R2_DAM::ABOVE_MONSTER
    @dam_value.x = 0 if @dam_value.x < 0
    @dam_value.y = 0 if @dam_value.y < 0
    @dam_value.z = 109
  end

  def determine_dam_visible
    if !@battler.alive?
      @dam_value.visible = false
      @dam_display.visible = false
      return if !@battler.alive?
    end
    @dam_value.visible = true
    return unless SceneManager.scene.is_a?(Scene_Battle)
    return unless SceneManager.scene.enemy_window
    @dam_value.visible = SceneManager.scene.target_window_index == @battler.index
    @dam_value.visible = false if !SceneManager.scene.enemy_window.active
    @dam_display.visible = false if !@dam_value.visible
    @dam_display.visible = true if @dam_value.visible
  end

  alias dam_display_dispose dispose
  def dispose
    @dam_value.dispose if @dam_value
    @dam_display.dispose if @dam_display
    dam_display_dispose
  end

  def reveal(battler)
    return if @battler == battler
    @battler = battler
    $game_switches[R2_DAM::DAMAGE_SWITCH] = false
  end

  def draw_dam_value(dx, dy)
    return unless SceneManager.scene_is?(Scene_Battle)
    return unless SceneManager.scene.enemy_window
    reveal(SceneManager.scene.enemy_window.enemy)
    enemy = $game_troop.members[SceneManager.scene.enemy_window.enemy.index]
    user = $game_actors[BattleManager.actor.id]
    item = $data_skills[BattleManager.actor.input.item.id]
    @dam_data = [] if $game_switches[R2_DAM::DAMAGE_SWITCH] == false
    @dam_data = find_dam_value(enemy, user, item) if $game_switches[R2_DAM::DAMAGE_SWITCH] == false
    text = "#{@dam_data[0]} to #{@dam_data[1]} #{R2_DAM::TEXT}"
    $game_switches[R2_DAM::DAMAGE_SWITCH] = true
    return text
  end

  def actor; return BattleManager.actor; end
 
  def enemy; return SceneManager.scene.enemy_window.enemy; end

  def find_dam_value(enemy, user, item)
    damage = actor.find_damage_value(enemy, user, item)
    amp = [damage.abs * item.damage.variance / 100, 0].max.to_i
    low = damage * ((100.00 - item.damage.variance) / 100.00)
    low = low - amp
    low = low.to_i
    high = damage * ((100.00 + item.damage.variance) / 100.00)
    high = high + amp
    high = high.to_i
    return [low, high]
  end

end

class Game_Battler < Game_BattlerBase
  def find_damage_value(enemy, user, item)
    ovars = Marshal.load(Marshal.dump($game_variables))
    oswitchs = $game_switches.clone
    value = item.damage.eval(user, enemy, $game_variables)
    value *= item_element_rate(user, item)
    $game_variables = ovars
    $game_switches = oswitchs
    enemy_element = $data_enemies[enemy.enemy_id]
    item_element = item.damage.element_id
    enemy_element.features.each do |elem|
      if elem.data_id == item_element
        value *= elem.value
        value = value.to_i
      end
    end
    value *= pdr if item.physical?
    value *= mdr if item.magical?
    value *= rec if item.damage.recover?
    return value
  end
end
class Window_BattleEnemy < Window_Selectable
  def process_cursor_move
    super
    $game_switches[R2_DAM::DAMAGE_SWITCH] = false
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
  if !$imported["YEA-BattleEngine"]
    def on_skill_ok
      @skill = @skill_window.item
      BattleManager.actor.input.set_skill(@skill.id)
      BattleManager.actor.last_skill.object = @skill
      if !@skill.need_selection?
        @skill_window.hide
        next_command
      elsif @skill.for_opponent?
        @skill_window.hide
        select_enemy_selection
      else
        select_actor_selection
      end
      $game_switches[R2_DAM::DAMAGE_SWITCH] = false
    end
    def on_skill_cancel
      @skill_window.hide
      @actor_command_window.activate
      $game_switches[R2_DAM::DAMAGE_SWITCH] = false
    end
    def on_enemy_cancel
      @enemy_window.hide
      case @actor_command_window.current_symbol
      when :attack
        @actor_command_window.activate
      when :skill
        @skill_window.show
        @skill_window.activate
      when :item
        @item_window.activate
      end
      $game_switches[R2_DAM::DAMAGE_SWITCH] = false
    end
  end
end
