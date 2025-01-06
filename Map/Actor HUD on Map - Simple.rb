# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Actor HUD on Map                       ║  Version: 1.03a    ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║     Trimmed down version                      ╠════════════════════╣
# ║    Show a HUD on the map                      ║    10 Oct 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║        Allows to display actor data on screen                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Adjust the settings to your preference                           ║
# ║   Not compatible with Vlue Sleek gauges                            ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 10 Oct 2021 - Script finished                               ║
# ║ 1.01 - 12 Oct 2021 - Added more options                            ║
# ║ 1.02 - 15 Oct 2021 - fixed not updating when removing actors       ║
# ║ 1.03 - 16 Oct 2021 - reduced to minimum requested data             ║
# ║                                                                    ║
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

module R2_MAP_HUD
  # Configure options
 
  Hud_X         = 0      # Hud Position
  Hud_Y         = 300     # Hud Position
  Hud_Width     = 300     # Hud Width
  Hud_Height    = 120     # Hud Height
 
  Actor_Shown   = 0       # 0 = party leader, 1 = first follower
 
  Key_Cycle     = :CTRL   # Key to cycle actors
  Use_Cycle     = true   # Option to use cycle control
 
  Show_Face     = true    # Show face graphic
  Face_X        = 0       # Face graphic X position
  Face_Y        = 0       # Face graphic Y position
  Face_Index    = 0       # Index of face Graphic

  Show_HP       = true    # Show HP bar
  HP_X          = 120     # HP bar X position
  HP_Y          = 50      # HP bar Y position
  HP_Width      = 124     # HP bar width
  HP_Height     = 20      # HP bar heigth
 
  HP_Color1     = 22      # Set the HP color
  HP_Color2     = 26      # Set the HP color
 
  Window_Opacity      = 0         # window visibility, does not affect contents
  Window_Back_Opacity = 0         # Window background opacity
  Window_Graphic      = "Window"  # Window Graphic file to use
 
  Font          = "Arial"
  Font_Size     = 20
  
  Toggle        = :ALT
  Toggle_Switch = 4 # if switch is on, hud can be displayed
      # if switch is off hud cannot be displayed
  Formation_Switch = 2 # switch to update hud when changing formation
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Actor_Hud_Window < Window_Base
  def initialize(id)
    x = R2_MAP_HUD::Hud_X
    y = R2_MAP_HUD::Hud_Y
    w = R2_MAP_HUD::Hud_Width
    h = R2_MAP_HUD::Hud_Height
    super(x,y,w,h)
    self.windowskin = Cache.system(R2_MAP_HUD::Window_Graphic)
    self.opacity = R2_MAP_HUD::Window_Opacity
    self.back_opacity = R2_MAP_HUD::Window_Back_Opacity
    self.contents_opacity = 255
    @current_actor = id
    @old_actor = 0
    refresh
  end
 
  def actor_data
    switch_actor if @current_actor > ($game_party.members.size - 1)
    @old_actor = @current_actor
    @actor = $game_party.members[@current_actor]
    face = R2_MAP_HUD::Face_Index > 0 ? R2_MAP_HUD::Face_Index : @actor.face_index
    # actor image
    draw_face(@actor.face_name, face, R2_MAP_HUD::Face_X, R2_MAP_HUD::Face_Y, enabled = true) if R2_MAP_HUD::Show_Face
    width = R2_MAP_HUD::HP_Width
    draw_actor_hud_hp(@actor, R2_MAP_HUD::HP_X, R2_MAP_HUD::HP_Y, width) if R2_MAP_HUD::Show_HP
    @current_hp = @actor.hp
  end
 
  def draw_actor_hud_hp(actor, x, y, width = 124, height = R2_MAP_HUD::HP_Height)
    color1 = text_color(R2_MAP_HUD::HP_Color1)
    color2 = text_color(R2_MAP_HUD::HP_Color2)
    draw_gauge(x, y, width, actor.hp_rate, color1, color2)
  end
  
  def draw_gauge(x, y, width, rate, color1, color2)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 8
    height = R2_MAP_HUD::HP_Height
    contents.fill_rect(x, gauge_y, width, height, gauge_back_color)
    contents.gradient_fill_rect(x, gauge_y, fill_w, height, color1, color2)
  end

  def refresh
    self.contents.clear
    font = R2_MAP_HUD::Font
    font_size = R2_MAP_HUD::Font_Size
    self.contents.font = Font.new(font, font_size)
    actor_data
  end
 
  def hud_data_changed
    return true if @current_actor != @old_actor
    return true if @current_hp != @actor.hp
    return false
  end
  
  alias r2_hud_update_vlue    update
  def update
    refresh if hud_data_changed
    r2_hud_update_vlue
  end
 
  def switch_actor
    @old_actor = @current_actor
    @current_actor += 1
    if @current_actor > ($game_party.members.size - 1 )
      @current_actor = 0
    end
    update
  end
  
  def c_actor
    return @current_actor
  end
  
  def formation_change(id)
    @current_actor = id
  end
end

class Scene_Map < Scene_Base
  alias r2_map_hud_start  start
  def start
    r2_map_hud_start
    @map_hud_seen = true if @map_hud_seen.nil?
    start_hud
  end
  def start_hud
    @actor_shown = R2_MAP_HUD::Actor_Shown == 0 ? $game_party.leader : $game_party.members[R2_MAP_HUD::Actor_Shown] if @actor_shown.nil?
    @map_hud = Actor_Hud_Window.new(@actor_shown.id)
  end
  alias r2_map_update_switch_actor    update
  def update
    r2_map_update_switch_actor
    if $game_switches[R2_MAP_HUD::Toggle_Switch] == false
      @map_hud.close
    end
    if Input.trigger?(R2_MAP_HUD::Toggle)
      @map_hud_seen = !@map_hud_seen
    end
    if @map_hud_seen == false
      @map_hud.close if @map_hud.open?
    else
      @map_hud.open if @map_hud.close?
    end
    if Input.trigger?(R2_MAP_HUD::Key_Cycle)
      @map_hud.switch_actor if R2_MAP_HUD::Use_Cycle
    end
    hud_update if @actor_shown != $game_party.members[@map_hud.c_actor]
    if $game_switches[R2_MAP_HUD::Formation_Switch] == true
      @map_hud.formation_change(0)
      @map_hud.refresh
      @actor_shown = $game_party.members[0]
      $game_switches[R2_MAP_HUD::Formation_Switch] = false
    end
  end
  def hud_update
    return if @actor_shown.nil?
    @map_hud.refresh
    @actor_shown = $game_party.members[@map_hud.c_actor]
  end
end
  
class Scene_Menu < Scene_MenuBase
  alias r2_on_formation_ok_actor_hud  on_formation_ok
  def on_formation_ok
    r2_on_formation_ok_actor_hud
    $game_switches[R2_MAP_HUD::Formation_Switch] = true
  end
end
