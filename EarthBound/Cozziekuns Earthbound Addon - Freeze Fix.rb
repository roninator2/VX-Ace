# https://forums.rpgmakerweb.com/index.php?threads/vx-ace-need-help-with-cozziekuns-earthbound-scripts.138226/#post-1200040

class Scene_Battle
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

  alias r2_sprite_effect_update_basic   update_basic
  def update_basic(*args)
    @old_enemy.sprite_effect_type = nil if !@old_enemy.nil? && !@enemy_window.active
    @old_enemy = @enemy_window.active ? @enemy_window.enemy : nil
    r2_sprite_effect_update_basic(*args)
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
end
