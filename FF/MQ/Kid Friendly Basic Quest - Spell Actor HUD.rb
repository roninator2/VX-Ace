# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Spell Actor HUD         ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Actor Spell HUD        ║    09 Mar 2023     ║
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
# ** Scene Spell
#==============================================================================
class Scene_Spell < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start
  #--------------------------------------------------------------------------
  alias r2_spell_hud_start  start
  def start
    r2_spell_hud_start
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
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  alias r2_menu_hud_update    update
  def update
    r2_menu_hud_update
    @actor1_hud.update
    if @actor2_hud == nil
      @actor2_hud = Actor_Hud_Window.new($game_party.members[1].id) if $game_party.members[1]
      @actor2_control = Actor_Control_Window.new($game_party.members[1].id) if $game_party.members[1]
      draw_no_actor if !$game_party.members[1] && (@no_actor == 0)
    else
      remove_blank_space if $game_party.members[1]
      clean_actor if !$game_party.members[1]
      @actor2_hud.update if $game_party.members[1]
    end
  end
  #--------------------------------------------------------------------------
  # * Remove Window if no second player
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
  # * Draw place holder image when no second player
  #--------------------------------------------------------------------------
  def draw_no_actor
    @no_actor = Sprite.new
    @no_actor.bitmap = Cache.system("Blank_Actor")
    @no_actor.x = Graphics.width / 2
    @no_actor.y = Graphics.height - 100
    @no_actor.z = 2
  end
  #--------------------------------------------------------------------------
  # * Remove place holder image when second player added
  #--------------------------------------------------------------------------
  def remove_blank_space
    return if (@no_actor == 0) || (@no_actor == nil)
    @no_actor.bitmap.dispose
    @no_actor.dispose
    @no_actor = 0
  end
  #--------------------------------------------------------------------------
  # * Terminate
  #--------------------------------------------------------------------------
  alias r2_terminator_menu_sprite  terminate
  def terminate
    r2_terminator_menu_sprite
    remove_blank_space
  end
end
