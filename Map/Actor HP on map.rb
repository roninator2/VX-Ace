# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Actor HP on Map                        ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║ Trimmed down version                          ╠════════════════════╣
# ║ Show actor hp on the map                      ║    10 Oct 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║ Allows to display actor hp on screen when damaged                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Adjust the settings to your preference                           ║
# ║   Not compatible with Vlue Sleek gauges                            ║
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
  Hud_Width     = 120     # Hud Width
  Hud_Height    = 40     # Hud Height
 
  HP_Width      = 95     # HP bar width , # must be 25 less than hud window
  HP_Height     = 10      # HP bar heigth
 
  HP_Color1     = 22      # Set the HP color
  HP_Color2     = 26      # Set the HP color
 
  Window_Opacity      = 0         # window visibility, does not affect contents
  Window_Back_Opacity = 0         # Window background opacity
  Window_Graphic      = "Window"  # Window Graphic file to use
 
  Toggle        = :ALT  # Button to call the HP bar
	
  Time_Held     = 60 # length of time (in frames) to show the HP bar
end
# ╔══════════════════════════════════════════════════════════╗
# ║ End of Configuration                                     ║
# ╚══════════════════════════════════════════════════════════╝

class Actor_Hud_Window < Window_Base
  def initialize(id)
    x = $game_player.screen_x - (R2_MAP_HUD::Hud_Width / 2)
    y = $game_player.screen_y - (R2_MAP_HUD::Hud_Height * 2)
    w = R2_MAP_HUD::Hud_Width
    h = R2_MAP_HUD::Hud_Height
    super(x,y,w,h)
    self.windowskin = Cache.system(R2_MAP_HUD::Window_Graphic)
    self.opacity = R2_MAP_HUD::Window_Opacity
    self.back_opacity = R2_MAP_HUD::Window_Back_Opacity
    self.contents_opacity = 255
    @current_actor = id
    refresh
  end
 
  def actor_data
    @actor = $game_actors[@current_actor]
    width = R2_MAP_HUD::HP_Width
    height = R2_MAP_HUD::HP_Height
    draw_actor_hud_hp(@actor, 0, 0, width, height)
    @current_hp = @actor.hp
  end
 
  def draw_actor_hud_hp(actor, x, y, width, height)
    color1 = text_color(R2_MAP_HUD::HP_Color1)
    color2 = text_color(R2_MAP_HUD::HP_Color2)
    draw_gauge(x, y, width, actor.hp_rate, color1, color2)
  end
  
  def draw_gauge(x, y, width, rate, color1, color2)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 28
    height = R2_MAP_HUD::HP_Height
    contents.fill_rect(x, gauge_y, width, height, gauge_back_color)
    contents.gradient_fill_rect(x, gauge_y, fill_w, height, color1, color2)
  end

  def refresh
    self.contents.clear
    actor_data
  end
 
  def hud_data_changed
    return true if @current_hp != @actor.hp
    return false
  end
  
  alias r2_hud_update_vlue    update
  def update
    refresh if hud_data_changed
    r2_hud_update_vlue
  end
 
end

class Scene_Map < Scene_Base
  alias r2_map_hud_start  start
  def start
    @map_hud_seen = false
    r2_map_hud_start
    start_hud
  end
  def start_hud
    @actor_shown = $game_party.leader
    @map_hud = Actor_Hud_Window.new(@actor_shown.id)
    @map_hud.close
  end
  alias r2_map_update_switch_actor    update
  def update
    r2_map_update_switch_actor
    if @map_hud.open?
      @map_hud.x = $game_player.screen_x - (R2_MAP_HUD::Hud_Width / 2)
      @map_hud.y = $game_player.screen_y - (R2_MAP_HUD::Hud_Height * 2)
    end
    if Input.trigger?(R2_MAP_HUD::Toggle)
      @map_hud_seen = !@map_hud_seen
      set_timer
    end
    if @map_hud.hud_data_changed
      hud_update
      @map_hud_seen = true
      set_timer
    end
    if @timer == Graphics.frame_count
      @map_hud_seen = false
    end
    if @map_hud_seen == false
      @map_hud.close if @map_hud.open?
    else
      @map_hud.open if @map_hud.close?
    end
  end
  def set_timer
    @map_hud.x = $game_player.screen_x - (R2_MAP_HUD::Hud_Width / 2)
    @map_hud.y = $game_player.screen_y - (R2_MAP_HUD::Hud_Height * 2)
    @timer = Graphics.frame_count
    @timer += R2_MAP_HUD::Time_Held
  end
  def hud_update
    return if @actor_shown.nil?
    @map_hud.refresh
  end
end
