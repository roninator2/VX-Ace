#============================================================================
# [VXAce] Dragon Quest Battle V1.00 (Mod)
#----------------------------------------------------------------------------
# By Roninator2 - For Jamiras843# DQ Battle
# Features:
#     V1.00
#     * Dragon Quest XI Enemy Grouping
#     * Display Enemy number
#     * Always show enemy window during action selection
#============================================================================
class Window_BattleEnemy < Window_Selectable
  def initialize(info_viewport)
    super(200, 296, 344, item_max * 24 + 24)
    refresh  
    self.visible = false
  end
  def col_max
    return 1
  end
  def item_max
    @group = []
    $game_troop.alive_members.each do |e|
      @group << e.enemy_id if !@group.include?(e.enemy_id)
    end
    return @group.size
  end
  def draw_item(index)
    id = $game_troop.alive_members[index].enemy_id
    return if @grplist.include?(id)
    change_color(normal_color)
    name = $game_troop.alive_members[index].name
    draw_text(item_rect_for_text(@ind_line), name)
    draw_text(item_rect_for_text(@ind_line), quantity(index), 2)
    @ind_line += 1
    @grplist.push(id) if !@grplist.include?(id)
  end
  def quantity(index)
    count = 0
    $game_troop.alive_members.each do |e|
      count += 1 if e.enemy_id == $game_troop.alive_members[index].enemy_id
    end
    return count
  end
  def refresh
    contents.clear
    @grplist = []
    @ind_line = 0
    draw_all_items
  end
end
class Scene_Battle < Scene_Base
  def on_enemy_ok
    BattleManager.actor.input.target_index = @enemy_window.enemy.index
    @enemy_window.unselect
    @skill_window.hide
    @item_window.hide
    next_command
  end
  def on_enemy_cancel
    @enemy_window.unselect
    case @actor_command_window.current_symbol
    when :attack
      @actor_command_window.activate
    when :skill
      @skill_window.activate
    when :item
      @item_window.activate
    end
  end
  def create_enemy_window  
    @enemy_window = Window_BattleEnemy.new(@help_window)  
    @enemy_window.set_handler(:ok,     method(:on_enemy_ok))  
    @enemy_window.set_handler(:cancel, method(:on_enemy_cancel))
  end  
  def start_party_command_selection
    @enemy_window.show
    @enemy_window.refresh
    unless scene_changing?    
    refresh_status    
    @DQ_status_window.open    
    if BattleManager.input_start      
      @actor_command_window.close      
      @party_command_window.setup    
    else      
      @party_command_window.deactivate      
      turn_start    
    end  
    end
  end
  def command_escape
    @enemy_window.hide
    turn_start unless BattleManager.process_escape
  end
  def turn_start  
    @party_command_window.close  
    @actor_command_window.close  
    @enemy_window.hide
    @subject =  nil  
    BattleManager.turn_start  
    if Jami_DQ_Battle::HUD_HIDE == true  
      @info_viewport.rect.height = 60  
    end #if HUDE_HIDE  
    @log_window.clear
  end
end
