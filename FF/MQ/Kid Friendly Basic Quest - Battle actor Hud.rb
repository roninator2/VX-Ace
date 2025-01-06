# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Battle Actor HUD        ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Actor Battle HUD       ║    10 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Function:                                                ║
# ║                                                          ║
# ║  Set the Windows to look like FFMQ.                      ║
# ║                                                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# ** Scene Battle
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Start HUD
  #--------------------------------------------------------------------------
  def start_hud
    @actor1_hud = Actor_Hud_Window.new($game_party.members[0].id)
    @actor2_hud = Actor_Hud_Window.new($game_party.members[1].id) if $game_party.members[1]
    draw_no_actor if !$game_party.members[1]
    @actor1_level = Actor_Level_Window.new($game_party.members[0].id)
    @actor1_level.viewport = Viewport.new
    @actor1_level.viewport.z += 2500
    @actor2_level = Actor_Level_Window.new($game_party.members[1].id) if $game_party.members[1]
    @actor2_level.viewport = Viewport.new if $game_party.members[1]
    @actor2_level.viewport.z += 2500 if $game_party.members[1]
    @actor1_name = Actor_Name_Window.new($game_party.members[0].id)
    @actor1_name.viewport = Viewport.new
    @actor1_name.viewport.z += 2500
    @actor2_name = Actor_Name_Window.new($game_party.members[1].id) if $game_party.members[1]
    @actor2_name.viewport = Viewport.new if $game_party.members[1]
    @actor2_name.viewport.z += 2500 if $game_party.members[1]
    @actor2_control = Actor_Control_Window.new($game_party.members[1].id) if $game_party.members[1]
    @actor2_control.viewport = Viewport.new if $game_party.members[1]
    @actor2_control.viewport.z += 2500 if $game_party.members[1]
    @actor_status_back = Actor_Hud_Back.new
  end
  #--------------------------------------------------------------------------
  # * Update Status Window Information
  #--------------------------------------------------------------------------
  def refresh_status
    @actor1_hud.refresh if @actor1_hud
    @actor2_hud.refresh if @actor2_hud
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  alias r2_battle_hud_update    update
  def update
    r2_battle_hud_update
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
    $game_party.members[0].change_equip(0, $data_weapons[new_id])
    @actor1_hud.refresh
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
end
