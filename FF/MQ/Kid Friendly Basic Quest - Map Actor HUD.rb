# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Map Actor HUD           ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Actor Map HUD          ║    09 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  Set the Windows to look like FFMQ.                      ║
# ║                                                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# ** Scene Map
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Start
  #--------------------------------------------------------------------------
  alias r2_map_hud_start  start
  def start
    r2_map_hud_start
    start_hud
  end
  #--------------------------------------------------------------------------
  # * Start HUD
  #--------------------------------------------------------------------------
  def start_hud
    @actor1_hud = Actor_Hud_Window.new($game_party.members[0].id)
    @actor2_hud = Actor_Hud_Window.new($game_party.members[1].id) if $game_party.members[1]
    draw_no_actor if !$game_party.members[1]
    @actor1_level = Actor_Level_Window.new($game_party.members[0].id)
    @actor1_level.viewport = Viewport.new
    @actor1_level.viewport.z += 100
    @actor2_level = Actor_Level_Window.new($game_party.members[1].id) if $game_party.members[1]
    @actor2_level.viewport = Viewport.new if $game_party.members[1]
    @actor2_level.viewport.z += 100 if $game_party.members[1]
    @actor1_name = Actor_Name_Window.new($game_party.members[0].id)
    @actor1_name.viewport = Viewport.new
    @actor1_name.viewport.z += 100
    @actor2_name = Actor_Name_Window.new($game_party.members[1].id) if $game_party.members[1]
    @actor2_name.viewport = Viewport.new if $game_party.members[1]
    @actor2_name.viewport.z += 100 if $game_party.members[1]
    @actor2_control = Actor_Control_Window.new($game_party.members[1].id) if $game_party.members[1]
    @actor2_control.viewport = Viewport.new if $game_party.members[1]
    @actor2_control.viewport.z += 100 if $game_party.members[1]
    @actor_status_back = Actor_Hud_Back.new
  end
  #--------------------------------------------------------------------------
  # * Call Menu
  #--------------------------------------------------------------------------
  alias r2_call_menu_dispose_image  call_menu
  def call_menu
    remove_blank_space
    r2_call_menu_dispose_image
  end
  #--------------------------------------------------------------------------
  # * Update Call Debug
  #--------------------------------------------------------------------------
  def update_call_debug
    if $TEST && Input.press?(:F9)
      remove_blank_space
      r2_call_menu_dispose_image
      SceneManager.call(Scene_Debug)
    end
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  alias r2_map_hud_update    update
  def update
    r2_map_hud_update
    @actor1_hud.update
    if @actor2_hud == nil
      @actor2_hud = Actor_Hud_Window.new($game_party.members[1].id) if $game_party.members[1]
      @actor2_level = Actor_Level_Window.new($game_party.members[1].id) if $game_party.members[1]
      @actor2_level.viewport = Viewport.new if $game_party.members[1]
      @actor2_level.viewport.z += 100 if $game_party.members[1]
      @actor2_control = Actor_Control_Window.new($game_party.members[1].id) if $game_party.members[1]
      @actor2_control.viewport = Viewport.new if $game_party.members[1]
      @actor2_control.viewport.z += 100 if $game_party.members[1]
      @actor2_name = Actor_Name_Window.new($game_party.members[1].id) if $game_party.members[1]
      @actor2_name.viewport = Viewport.new if $game_party.members[1]
      @actor2_name.viewport.z += 100 if $game_party.members[1]
      draw_no_actor if !$game_party.members[1] && ((@no_actor == 0) || (@no_actor == nil))
    else
      remove_blank_space if $game_party.members[1]
      clean_actor if !$game_party.members[1]
      @actor2_hud.update if $game_party.members[1]
    end
    check_weapon_swap
    check_control
  end
  #--------------------------------------------------------------------------
  # * Swap Weapons by Key press
  #--------------------------------------------------------------------------
  def check_weapon_swap
    if Input.trigger?(:L)
      swap_weapons(0)
    elsif Input.trigger?(:R)
      swap_weapons(1)
    end
  end
  #--------------------------------------------------------------------------
  # * Swap Weapons by Key press
  #--------------------------------------------------------------------------
  def swap_weapons(value)
    wdata = []
    for i in 1..$data_weapons.size - 1
      wdata[i-1] = nil
      weapon = $data_weapons[i]
      if $game_party.has_item?(weapon, true)
        weapon.note.split(/[\r\n]+/).each { |line|
          case line
          when /<position:[-_ ]\d+>/i
            pos = $1.to_i
            wdata[pos-1] = weapon.id
          end
        }
      end
    end
    wdata.compact!
    current = $game_party.members[0].equips[0].id
    pos = current
    for i in 0..wdata.size - 1
      pos = i if current == wdata[i]
    end
    if pos == 0
      if value == 1
        new_id = wdata[1]
      else
        new_id = wdata[-1]
      end
    elsif pos == wdata.size - 1
      if value == 1
        new_id = wdata[0]
      else
        new_id = wdata[pos-1]
      end
    else
      if value == 1
        new_id = wdata[pos+1]
      else
        new_id = wdata[pos-1]
      end
    end
    if new_id == nil; new_id = current; end
    $game_party.members[0].change_equip(0, $data_weapons[new_id])
    @actor1_hud.refresh
  end
  #--------------------------------------------------------------------------
  # * Change Autobattle Contol by keypress
  #--------------------------------------------------------------------------
  def check_control
    if Input.trigger?(:X)
      $game_system.autobattle = !$game_system.autobattle?
      @actor2_control.refresh if @actor2_control
    end
  end
  #--------------------------------------------------------------------------
  # * Clear Actor place holder
  #--------------------------------------------------------------------------
  def clean_actor
    return if @actor2_hud == nil
    @actor2_hud.dispose
    @actor2_hud = nil
    @actor2_level.dispose
    @actor2_control.dispose
    @actor2_name.dispose
  end
  #--------------------------------------------------------------------------
  # * Draw image when no second player
  #--------------------------------------------------------------------------
  def draw_no_actor
    @no_actor = Sprite.new
    @no_actor.bitmap = Cache.system("Blank_Actor")
    @no_actor.x = Graphics.width / 2
    @no_actor.y = Graphics.height - 100
    @no_actor.z = 2
  end
  #--------------------------------------------------------------------------
  # * Remove image when second player added
  #--------------------------------------------------------------------------
  def remove_blank_space
    return if (@no_actor == 0) || (@no_actor == nil)
    @no_actor.bitmap.dispose
    @no_actor.dispose
    @no_actor = 0
  end
  #--------------------------------------------------------------------------
  # * Remove image when leaving map
  #--------------------------------------------------------------------------
  alias r2_terminator_map_sprite  terminate
  def terminate
    r2_terminator_map_sprite
    remove_blank_space
  end
  #--------------------------------------------------------------------------
  # * Remove image when starting battle
  #--------------------------------------------------------------------------
  alias r2_clear_back_battle  pre_battle_scene
  def pre_battle_scene
    r2_clear_back_battle
    remove_blank_space
  end
end
