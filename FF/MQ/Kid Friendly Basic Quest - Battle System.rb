# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Battle System           ║  Version: 1.01     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   Recreate FFMQ Battle Scene        ║    14 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  Recreate the Final Fantasy Mystic Quest Battle System   ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

# Requires Map Battle Data to get enemy remaining count
module BattleManager
  #--------------------------------------------------------------------------
  # * Victory Processing
  #--------------------------------------------------------------------------
  def self.process_victory
    play_battle_end_me
    replay_bgm_and_bgs
    $game_message.add(Vocab::Victory)
    display_exp
    gain_gold
    gain_drop_items
    gain_exp
    number_remaining # <- battle data
    SceneManager.return
    battle_end(0)
    return true
  end
  #--------------------------------------------------------------------------
  # * Display EXP Earned
  #--------------------------------------------------------------------------
  def self.display_exp
    if $game_troop.exp_total > 0
      text = sprintf(Vocab::ObtainExp, $game_troop.exp_total)
      $game_message.add('\.' + text)
    end
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # * Gold Acquisition and Display
  #--------------------------------------------------------------------------
  def self.gain_gold
    if $game_troop.gold_total > 0
      text = sprintf(Vocab::ObtainGold, $game_troop.gold_total)
      $game_message.add('\.' + text)
      $game_party.gain_gold($game_troop.gold_total)
    end
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # * Dropped Item Acquisition and Display
  #--------------------------------------------------------------------------
  def self.gain_drop_items
    $game_troop.make_drop_items.each do |item|
      $game_party.gain_item(item, 1)
      $game_message.add(sprintf(Vocab::ObtainItem, item.name))
   end
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # * EXP Acquisition and Level Up Display
  #--------------------------------------------------------------------------
  def self.gain_exp
    $game_party.all_members.each do |actor|
      actor.gain_exp($game_troop.exp_total)
    end
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # * EXP Acquisition and Level Up Display
  #--------------------------------------------------------------------------
  def self.number_remaining
    map = $game_variables[R2_Enemy_Count_Data::Data_Transfer][0]
    return if R2_Enemy_Count_Data::Battle_Data[map].nil?
    id = $game_variables[R2_Enemy_Count_Data::Data_Transfer][1]
    $game_variables[R2_Enemy_Count_Data::Remaining] -= 1
    $game_variables[R2_Enemy_Count_Data::Current_Data][map][id][1] = 
    $game_variables[R2_Enemy_Count_Data::Remaining]
    if $game_variables[R2_Enemy_Count_Data::Remaining] > 0
      text = sprintf("%s more to go!", $game_variables[R2_Enemy_Count_Data::Remaining])
      $game_message.add('\.' + text)
      wait_for_message
    elsif $game_variables[R2_Enemy_Count_Data::Remaining] == 0
      text = "All clear!"
      $game_message.add('\.' + text)
      wait_for_message
    end
  end
end

#==============================================================================
# * Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Update Frame (Basic)
  #--------------------------------------------------------------------------
  def update_basic
    super
    $game_timer.update
    $game_troop.update
    @spriteset.update
    update_message_open
  end
  #--------------------------------------------------------------------------
  # * Update Information Display Viewport
  #--------------------------------------------------------------------------
  def update_info_viewport
  end
  #--------------------------------------------------------------------------
  # * Update Processing for Opening Message Window
  #    Set openness to 0 until the status window and so on are finished closing.
  #--------------------------------------------------------------------------
  def update_message_open
    if $game_message.busy? && !@status_window.close?
      @message_window.openness = 0
      @status_window.close
      @party_command_window.close
      @actor_command_window.close
      @spell_window.close
      hide_actor_blank_windows
    end
  end
  #--------------------------------------------------------------------------
  # * Create All Windows
  #--------------------------------------------------------------------------
  def create_all_windows
    create_log_window
    create_log_window2
    create_status_window
    create_info_viewport
    create_status_viewport
    create_message_window
    create_party_command_window
    create_actor_command_window
    create_help_window
    create_item_window
    create_actor_window
    create_enemy_window
    create_battlespell_command
    create_spell_row_window
    create_spell_arrow
    create_spell_window
    create_battleitem_command
    create_party_blank_windows
    create_actor_blank_windows
    start_hud
  end
  #--------------------------------------------------------------------------
  # * Create Log Window
  #--------------------------------------------------------------------------
  def create_log_window2
    @log_window2 = KFBQ_BattleLog.new
    @log_window2.method_wait = method(:wait)
    @log_window2.method_wait_for_effect = method(:wait_for_effect)
  end
  #--------------------------------------------------------------------------
  # * Create Party Commands Window
  #--------------------------------------------------------------------------
  def create_party_command_window
    @party_command_window = Window_KFBQPartyCommand.new
    @party_command_window.viewport = @info_viewport
    @party_command_window.set_handler(:fight,  method(:command_fight))
    @party_command_window.set_handler(:escape, method(:command_escape))
    @party_command_window.set_handler(:control, method(:command_control))
    @party_command_window.unselect
  end
  #--------------------------------------------------------------------------
  # * Start Actor Commmand windows
  #--------------------------------------------------------------------------
  def create_party_blank_windows
    @party_command1 = Window_BattleCommandBlank.new(35,290,120,1)
    @party_command2 = Window_BattleCommandBlank.new(195,290,120,1)
    @party_command3 = Window_BattleCommandBlank.new(360,290,120,1)
    hide_party_blank_windows
  end
  #--------------------------------------------------------------------------
  # * Create Actor Commands Window
  #--------------------------------------------------------------------------
  def create_actor_command_window
    @actor_command_window = Window_KFBQActorCommand.new
    @actor_command_window.viewport = @info_viewport
    @actor_command_window.set_handler(:attack, method(:command_attack))
    @actor_command_window.set_handler(:spell,  method(:command_spell))
    @actor_command_window.set_handler(:guard,  method(:command_guard))
    @actor_command_window.set_handler(:item,   method(:command_item))
    @actor_command_window.set_handler(:cancel, method(:prior_command))
    @actor_command_window.close
  end
  #--------------------------------------------------------------------------
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = KFBQ_BattleHelp.new
    @help_window.visible = false
  end
  #--------------------------------------------------------------------------
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_BattleStatus.new
  end
  #--------------------------------------------------------------------------
  # * Create Skill Window
  #--------------------------------------------------------------------------
  def create_spell_window
    @spell_window = KFBQ_BattleSpell.new(@help_window, @info_viewport)
    @spell_window.help_window = @help_window
    @spell_window.type_window = @spell_type
    @spell_window.set_handler(:ok,     method(:on_spell_ok))
    @spell_window.set_handler(:cancel, method(:on_spell_cancel))
  end
  #--------------------------------------------------------------------------
  # * Create Item Command Text Window
  #--------------------------------------------------------------------------
  def create_battlespell_command
    @spell_command_window = KFBQ_Spell_Command.new
    @spell_command_window.viewport = @viewport
    @spell_command_window.hide
  end
  #--------------------------------------------------------------------------
  # * Create Spell Row Window
  #--------------------------------------------------------------------------
  def create_spell_row_window
    @spell_type = KFBQ_Spell_Type.new(1)
    @spell_type.hide
  end
  #--------------------------------------------------------------------------
  # * Create Spell Arrow Window
  #--------------------------------------------------------------------------
  def create_spell_arrow
    @spell_arrow = KFBQ_Spell_Arrow.new
    @spell_arrow.hide
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    @item_window = KFBQ_BattleItem.new(@help_window, @info_viewport)
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
  end
  #--------------------------------------------------------------------------
  # * Create Item Command Text Window
  #--------------------------------------------------------------------------
  def create_battleitem_command
    @item_command_window = KFBQ_Item_Command.new
    @item_command_window.viewport = @viewport
    @item_command_window.hide
  end
  #--------------------------------------------------------------------------
  # * Start Actor Commmand windows
  #--------------------------------------------------------------------------
  def create_actor_blank_windows
    @actor_command1 = Window_BattleCommandBlank.new(95,270,120,1)
    @actor_command2 = Window_BattleCommandBlank.new(295,270,120,1)
    @actor_command3 = Window_BattleCommandBlank.new(95,330,120,1)
    @actor_command4 = Window_BattleCommandBlank.new(295,330,120,1)
    hide_actor_blank_windows
  end
  #--------------------------------------------------------------------------
  # * Create Message Window
  #--------------------------------------------------------------------------
  def create_message_window
    @message_window = KFBQ_BattleMessage.new
    @message_window.viewport = @viewport
    @message_window.set_visible_line_number(1)
  end
  #--------------------------------------------------------------------------
  # * Create Information Display Viewport
  #--------------------------------------------------------------------------
  def create_info_viewport
    @info_viewport = Viewport.new
    @info_viewport.rect.y = Graphics.height - @status_window.height - 120
    @info_viewport.rect.x = 0
    @info_viewport.rect.height = @status_window.height
    @info_viewport.z = 200
  end
  #--------------------------------------------------------------------------
  # * Create Information Display Viewport
  #--------------------------------------------------------------------------
  def create_status_viewport
    @status_viewport = Viewport.new
    @status_viewport.rect.y = Graphics.height - @status_window.height
    @status_viewport.rect.height = @status_window.height
    @status_viewport.z = 360
    @status_window.viewport = @status_viewport
  end
  #--------------------------------------------------------------------------
  # * Create Actor Window
  #--------------------------------------------------------------------------
  def create_actor_window
    @actor_window = Window_BattleActor.new(@status_viewport)
    @actor_window.set_handler(:ok,     method(:on_actor_ok))
    @actor_window.set_handler(:cancel, method(:on_actor_cancel))
    @actor_window.z = 300
  end
  #--------------------------------------------------------------------------
  # * Start Actor Commmand windows
  #--------------------------------------------------------------------------
  def show_party_blank_windows
    @party_command1.show
    @party_command2.show
    @party_command3.show
  end
  #--------------------------------------------------------------------------
  # * Start Actor Commmand windows
  #--------------------------------------------------------------------------
  def hide_party_blank_windows
    @party_command1.hide
    @party_command2.hide
    @party_command3.hide
  end
  #--------------------------------------------------------------------------
  # * Start Actor Commmand windows
  #--------------------------------------------------------------------------
  def dispose_party_blank_windows
    @party_command1.dispose if @party_command1
    @party_command2.dispose if @party_command2
    @party_command3.dispose if @party_command3
  end
  #--------------------------------------------------------------------------
  # * Start Actor Commmand windows
  #--------------------------------------------------------------------------
  def hide_actor_blank_windows
    @actor_command1.hide
    @actor_command2.hide
    @actor_command3.hide
    @actor_command4.hide
  end
  #--------------------------------------------------------------------------
  # * Start Actor Commmand windows
  #--------------------------------------------------------------------------
  def show_actor_blank_windows
    @actor_command1.show
    @actor_command2.show
    @actor_command3.show
    @actor_command4.show
  end
  #--------------------------------------------------------------------------
  # * Start Actor Commmand windows
  #--------------------------------------------------------------------------
  def dispose_actor_blank_windows
    @actor_command1.dispose if @actor_command1
    @actor_command2.dispose if @actor_command2
    @actor_command3.dispose if @actor_command3
    @actor_command4.dispose if @actor_command4
  end
  #--------------------------------------------------------------------------
  # * To Previous Command Input
  #--------------------------------------------------------------------------
  def prior_command
    if BattleManager.prior_command
      start_actor_command_selection
    else
      hide_actor_blank_windows
      start_party_command_selection
    end
  end
  #--------------------------------------------------------------------------
  # * Start Party Command Selection
  #--------------------------------------------------------------------------
  def start_party_command_selection
    unless scene_changing?
      refresh_status
      @status_window.unselect
      @status_window.open
      if BattleManager.input_start
        @actor_command_window.close
        @party_command_window.setup
        @party_command_window.update_cursor
        show_party_blank_windows
      else
        @party_command_window.deactivate
        turn_start
      end
    end
  end
  #--------------------------------------------------------------------------
  # * [Escape] Command
  #--------------------------------------------------------------------------
  def command_escape
    hide_party_blank_windows
    turn_start unless BattleManager.process_escape
  end
  #--------------------------------------------------------------------------
  # * [Control] Command
  #--------------------------------------------------------------------------
  def command_control
    $game_system.autobattle = !$game_system.autobattle?
    @actor2_control.refresh if @actor2_control
    @party_command_window.activate
  end
  #--------------------------------------------------------------------------
  # * Start Actor Command Selection
  #--------------------------------------------------------------------------
  def start_actor_command_selection
    @status_window.select(BattleManager.actor.index)
    @party_command_window.close
    hide_party_blank_windows
    @actor_command_window.open
    @actor_command_window.setup(BattleManager.actor)
    show_actor_blank_windows
  end
  #--------------------------------------------------------------------------
  # new method: command_use_skill
  #--------------------------------------------------------------------------
  def command_attack
    @skill = $data_skills[BattleManager.actor.attack_skill_id]
    if @skill.note.match(/<Bomb>/i)
      if $game_party.bombs? == 0
        Sound.play_buzzer
        @actor_command_window.activate
        return 
      end
    end
    if @skill.note.match(/<Ninja Star>/i)
      if $game_party.ninja_stars? == 0
        Sound.play_buzzer
        @actor_command_window.activate
        return 
      end
    end
    BattleManager.actor.input.set_skill(@skill.id)
    hide_actor_blank_windows
    @help_window.hide
    if !@skill.need_selection?
      next_command
    elsif @skill.for_opponent?
      select_enemy_selection
    else
      select_actor_selection
    end
  end
  #--------------------------------------------------------------------------
  # * [Spell] Command
  #--------------------------------------------------------------------------
  def command_spell
    @help_window.show
    @spell_command_window.show
    @spell_window.actor = BattleManager.actor
    @spell_window.show.activate
    @spell_type.show
    @spell_arrow.show
    @spell_arrow.refresh
    @actor_command_window.close
    hide_actor_blank_windows
  end
  #--------------------------------------------------------------------------
  # * [Item] Command
  #--------------------------------------------------------------------------
  def command_item
    @help_window.show
    @item_command_window.show
    @item_window.refresh
    @item_window.show.activate
    @actor_command_window.close
    hide_actor_blank_windows
  end
  #--------------------------------------------------------------------------
  # * Actor [OK]
  #--------------------------------------------------------------------------
  def on_actor_ok
    BattleManager.actor.input.target_index = @actor_window.index
    @actor_window.deactivate
    @status_window.show
    @actor_window.hide
    @spell_window.hide
    @item_window.hide
    @help_window.hide
    @spell_command_window.hide
    @spell_type.hide
    @spell_arrow.hide
    next_command
  end
  #--------------------------------------------------------------------------
  # * Actor [Cancel]
  #--------------------------------------------------------------------------
  def on_actor_cancel
    @actor_window.hide
    @actor_window.deactivate
    case @actor_command_window.current_symbol
    when :attack
      @help_window.hide
      show_actor_blank_windows
      @actor_command_window.open
      @actor_command_window.activate
    when :spell
      @help_window.show
      @spell_command_window.show
      @spell_window.refresh
      @spell_window.show.activate
      @spell_type.show
      @spell_arrow.show
      @spell_arrow.refresh
    when :item
      @item_window.show.activate
      @help_window.show
      @item_command_window.show
      @item_window.refresh
    end
    @status_window.hide
  end
  #--------------------------------------------------------------------------
  # ? On enemy ok
  #--------------------------------------------------------------------------    
  def on_enemy_ok
    BattleManager.actor.input.target_index = @target_index
    @enemy_window.hide
    @spell_window.hide
    @item_window.hide   
    @actor_command_window.show
    next_command
  end  
  #--------------------------------------------------------------------------
  # * Enemy [Cancel]
  #--------------------------------------------------------------------------
  def on_enemy_cancel
    @enemy_window.hide
    case @actor_command_window.current_symbol
    when :attack
      @help_window.hide
      show_actor_blank_windows
      @actor_command_window.show.activate
    when :spell
      @spell_command_window.show
      @spell_window.show.activate
      @help_window.show
      @spell_window.refresh
      @spell_type.show
      @spell_arrow.show
      @spell_arrow.refresh
    when :item
      @item_window.show.activate
      @help_window.show
      @item_command_window.show
    end
  end
  #--------------------------------------------------------------------------
  # * Skill [OK]
  #--------------------------------------------------------------------------
  def on_spell_ok
    @spell = @spell_window.item
    if @spell.nil?
      @spell_window.activate
      return
    end
    if !BattleManager.actor.skill_cost_payable?(@spell)
      Sound.play_buzzer
      @spell_window.activate
      return
    end
    BattleManager.actor.input.set_skill(@spell.id)
    BattleManager.actor.last_skill.object = @spell
    @spell_window.hide
    @help_window.hide
    @spell_command_window.hide
    @spell_type.hide
    @spell_arrow.hide
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
  # * Skill [Cancel]
  #--------------------------------------------------------------------------
  def on_spell_cancel
    @help_window.hide
    @spell_window.hide
    @spell_command_window.hide
    @spell_type.hide
    @spell_arrow.hide
    show_actor_blank_windows
    @actor_command_window.show.activate
    @actor_command_window.setup(BattleManager.actor)
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    @item = @item_window.item
    if @item.nil?
      @item_window.activate
      return
    end
    BattleManager.actor.input.set_item(@item.id)
    @item_window.hide
    @help_window.hide
    @item_command_window.hide
    if !@item.need_selection?
      @item_window.hide
      next_command
    elsif @item.for_opponent?
      select_enemy_selection
    else
      select_actor_selection
    end
    $game_party.last_item.object = @item
  end
  #--------------------------------------------------------------------------
  # * Item [Cancel]
  #--------------------------------------------------------------------------
  def on_item_cancel
    @help_window.hide
    @item_window.hide
    @item_command_window.hide
    show_actor_blank_windows
    @actor_command_window.show.activate
    @actor_command_window.setup(BattleManager.actor)
  end
  #--------------------------------------------------------------------------
  # * Start Actor Selection
  #--------------------------------------------------------------------------
  def select_actor_selection
    @status_window.show
    @actor_window.refresh
    @actor_window.show.activate
  end
  #--------------------------------------------------------------------------
  # ? Selects an enemy
  #--------------------------------------------------------------------------    
  def select_enemy_selection
    @actor_input = false
    @help_window.show
    @help_window.open
    @spell_window.hide
    @item_window.hide    
    @target_index = 0
    @target_sprites = get_sprites($game_troop.members).compact
    @target_size = $game_troop.members.size
    @cursor_sprite = Sprite_TargetCursor.new
    while !@actor_input && $game_troop.members[@target_index].dead?
      @target_index = (@target_index + 1) % @target_size
    end     
    @selection_active = true
    while @selection_active
      update_for_wait
      if Input.trigger?(:C)
        Sound.play_ok
        @cursor_sprite.dispose
        on_enemy_ok
        return
      elsif Input.trigger?(:B)
        Sound.play_cancel
        @cursor_sprite.dispose
        on_enemy_cancel
        return
      end  
      update_target_selection
    end
  end
  #--------------------------------------------------------------------------
  # * Start Turn
  #--------------------------------------------------------------------------
  def turn_start
    @party_command_window.close
    @actor_command_window.close
    hide_party_blank_windows
    hide_actor_blank_windows
    @status_window.unselect
    @subject =  nil
    BattleManager.turn_start
    @log_window.wait
    @log_window.clear
  end
  #--------------------------------------------------------------------------
  # * End Turn
  #--------------------------------------------------------------------------
  def turn_end
    all_battle_members.each do |battler|
      battler.on_turn_end
      refresh_status
    end
    BattleManager.turn_end
    process_event
    start_party_command_selection
  end
  #--------------------------------------------------------------------------
  # * Battle Action Processing
  #--------------------------------------------------------------------------
  def process_action
    return if scene_changing?
    if !@subject || !@subject.current_action
      @subject = BattleManager.next_subject
    end
    return turn_end unless @subject
    if @subject.current_action
      @subject.current_action.prepare
      if @subject.current_action.valid?
        @status_window.open
        execute_action
      end
      @subject.remove_current_action
    end
    process_action_end unless @subject.current_action
  end
  #--------------------------------------------------------------------------
  # * Event Processing
  #--------------------------------------------------------------------------
  def process_event
    while !scene_changing?
      $game_troop.interpreter.update
      $game_troop.setup_battle_event
      wait_for_message
      @log_window2.defeat_enemy if $game_troop.all_dead?
      wait_for_effect if $game_troop.all_dead?
      process_forced_action
      BattleManager.judge_win_loss
      break unless $game_troop.interpreter.running?
      update_for_wait
    end
  end
  #--------------------------------------------------------------------------
  # * Execute Battle Actions
  #--------------------------------------------------------------------------
  def execute_action
    @subject.sprite_effect_type = :whiten
    use_item
  end
  #--------------------------------------------------------------------------
  # * Processing at End of Action
  #--------------------------------------------------------------------------
  def process_action_end
    @subject.on_action_end
    refresh_status
    BattleManager.judge_win_loss
  end
  #--------------------------------------------------------------------------
  # * Pay Cost of Using Bombs/Ninja Stars * Use Skill/Item
  #--------------------------------------------------------------------------
    # R2_Element_Icons::Elements
    # code 13 - state rate - states
    # code 14 - state resist - states
    # code 11 - element rate - elements - 3 = fire
    # code 12 - debuff rate - params - 0 = mhp
    # code 22 - xparam
    # code 23 - sparams
    # element defense
    # weapons
    # code 31 - attack element
    # code 32 - attack state
  def use_item
    item = @subject.current_action.item
    if @subject.is_a?(Game_Actor)
      @log_window2.display_use_item(@subject, item)
      @log_window2.wait_and_clear
    end
    @subject.use_item(item)
    refresh_status
    targets = @subject.current_action.make_targets.compact
    if @subject.is_a?(Game_Actor) && targets[0].is_a?(Game_Enemy)
      enmy = $data_enemies[targets[0].enemy_id]
      enmy.features.each do |ft|
        if ft.code == 13
          case item
          when RPG::Weapon
            weapon = $data_weapons[@subject.equips[0].id]
            weapon.features.each do |ft2|
              if ft2.code == 32
                if ft2.data_id == ft.data_id
                  @log_window2.display_enemy_weakness(enmy.name, ft.data_id, ft.value, ft2.value)
                  @log_window2.wait_and_clear
                end
              end
            end
          when RPG::Skill
            spellft = $data_skills[item.id]
            spellft.features.each do |ft2|
              if ft2.code == 32
                if ft2.data_id == ft.data_id
                  @log_window2.display_enemy_weakness(enmy.name, ft.data_id, ft.value, ft2.value)
                  @log_window2.wait_and_clear
                end
              end
            end
          when RPG::Item
            itemft = $data_items[item.id]
            itemft.features.each do |ft2|
              if ft2.code == 32
                if ft2.data_id == ft.data_id
                  @log_window2.display_enemy_weakness(enmy.name, ft.data_id, ft.value, ft2.value)
                  @log_window2.wait_and_clear
                end
              end
            end
          end
            item.features.each do |ft2|
              if ft2.code == 32
                if ft2.data_id == ft.data_id
                  @log_window2.display_enemy_weakness(enmy.name, ft.data_id, ft.value, ft2.value)
                  @log_window2.wait_and_clear
                end
              end
            end
        end
      end
    end
    show_animation(targets, item.animation_id)
    targets.each {|target| item.repeats.times { invoke_item(target, item) } }
    if item.note.match(/<Bomb>/i)
      $game_party.use_bomb(true)
    end
    if item.note.match(/<Ninja Star>/i)
      $game_party.use_star(true)
    end
  end
  #--------------------------------------------------------------------------
  # * Invoke Counterattack
  #--------------------------------------------------------------------------
  def invoke_counter_attack(target, item)
    attack_skill = $data_skills[target.attack_skill_id]
    @subject.item_apply(target, attack_skill)
    refresh_status
  end
  #--------------------------------------------------------------------------
  # * Apply Skill/Item Effect
  #--------------------------------------------------------------------------
  def apply_item_effects(target, item)
    target.item_apply(@subject, item)
    refresh_status
    @log_window.display_action_results(target, item)
  end
  #--------------------------------------------------------------------------
  # * Determine if Fast Forward
  #--------------------------------------------------------------------------
  def show_fast?
    Input.press?(:A) || Input.press?(:C)
  end
end
