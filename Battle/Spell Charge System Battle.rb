# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Spell Charge System Battle             ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║  Battle System for Spell Charges              ║    14 Feb 2024     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Spell Charge System Base                                 ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║ Use spell charges in battle                                        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Configure settings Below                                         ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 14 Feb 2024 - Script finished                               ║
# ║ 1.01 - 29 Jul 2024 - fixed bug                                     ║
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
# ** Vocab
#==============================================================================
module Vocab
  
  # Spell Battle Screen - Actor Command
  Battle_Spell = "Magic"
  
end

# ╔══════════════════════════════════════════════════════════╗
# ║              End of Editable section                     ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# ** Window_ActorCommand
#==============================================================================

class Window_ActorCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    return unless @actor
    add_attack_command
    add_spell_command
    add_skill_commands if Spell_Charge::Options::INCLUDE_SKILLS
    add_guard_command
    add_item_command
  end
  #--------------------------------------------------------------------------
  # * Add Magic Command to List
  #--------------------------------------------------------------------------
  def add_spell_command
    add_command(Vocab::Battle_Spell, :spell)
  end
end

#==============================================================================
# ** Window_BattleSpell
#==============================================================================

class Window_BattleSpell < Window_Spell_List
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     info_viewport : Viewport for displaying information
  #--------------------------------------------------------------------------
  def initialize(help_window, info_viewport)
    y = help_window.height
    super(0, y, Graphics.width, info_viewport.rect.y - y)
    self.visible = false
    @help_window = help_window
    @info_viewport = info_viewport
  end
  #--------------------------------------------------------------------------
  # * Show Window
  #--------------------------------------------------------------------------
  def show
    select_last
    @help_window.show
    super
  end
  #--------------------------------------------------------------------------
  # * Hide Window
  #--------------------------------------------------------------------------
  def hide
    @help_window.hide
    super
  end
end

#==============================================================================
# ** Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Create All Windows
  #--------------------------------------------------------------------------
  def create_all_windows
    create_message_window
    create_scroll_text_window
    create_log_window
    create_status_window
    create_info_viewport
    create_party_command_window
    create_actor_command_window
    create_help_window
    create_skill_window if Spell_Charge::Options::INCLUDE_SKILLS
    create_spell_window
    create_item_window
    create_actor_window
    create_enemy_window
  end
  #--------------------------------------------------------------------------
  # * Create Actor Commands Window
  #--------------------------------------------------------------------------
  alias :r2_battle_spell_actor_command_window   :create_actor_command_window
  def create_actor_command_window
    r2_battle_spell_actor_command_window
    @actor_command_window.set_handler(:spell,  method(:command_spell))
  end
  #--------------------------------------------------------------------------
  # * Create Spell Window
  #--------------------------------------------------------------------------
  def create_spell_window
    @spell_window = Window_BattleSpell.new(@help_window, @info_viewport)
    @spell_window.set_handler(:ok,     method(:on_spell_ok))
    @spell_window.set_handler(:cancel, method(:on_spell_cancel))
  end
  #--------------------------------------------------------------------------
  # * Actor [OK]
  #--------------------------------------------------------------------------
  def on_actor_ok
    BattleManager.actor.input.target_index = @actor_window.index
    @actor_window.hide
    @skill_window.hide if @skill_window
    @spell_window.hide if @spell_window
    @item_window.hide
    next_command
  end
  #--------------------------------------------------------------------------
  # * Actor [Cancel]
  #--------------------------------------------------------------------------
  def on_actor_cancel
    @actor_window.hide
    case @actor_command_window.current_symbol
    when :spell
      on_spell_cancel
    when :item
      @item_window.activate
    end
  end
  #--------------------------------------------------------------------------
  # * Enemy [OK]
  #--------------------------------------------------------------------------
  def on_enemy_ok
    BattleManager.actor.input.target_index = @enemy_window.enemy.index
    @enemy_window.hide
    @skill_window.hide if @skill_window
    @spell_window.hide if @spell_window
    @item_window.hide
    next_command
  end
  #--------------------------------------------------------------------------
  # * [Spell] Command
  #--------------------------------------------------------------------------
  def command_spell
    @spell_window.actor = BattleManager.actor
    @spell_window.refresh
    @spell_window.show.activate
  end
  #--------------------------------------------------------------------------
  # * Spell [OK]
  #--------------------------------------------------------------------------
  def on_spell_ok
    @spell = @spell_window.item
    BattleManager.actor.input.set_skill(@spell.id)
    BattleManager.actor.last_skill.object = @spell
    if !@spell.need_selection?
      @spell_window.hide
      next_command
    elsif @spell.for_opponent?
      select_enemy_selection
    else
      select_actor_selection
    end
  end
  #--------------------------------------------------------------------------
  # * Spell [Cancel]
  #--------------------------------------------------------------------------
  def on_spell_cancel
    @spell_window.hide
    @actor_command_window.activate
  end
end

