# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Actor HUD on Map                       ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
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
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 10 Oct 2021 - Script finished                               ║
# ║ 1.01 - 12 Oct 2021 - Added more options                            ║
# ║ 1.02 - 15 Oct 2021 - fixed not updating when removing actors       ║
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

module Vocab
  Exp_s = "EXP"
end

module R2_MAP_HUD
  # Configure options
  
  Hud_X         = 0      # Hud Position
  Hud_Y         = 300     # Hud Position
  Hud_Width     = 300     # Hud Width
  Hud_Height    = 120     # Hud Height
  
  Actor_Shown   = 0       # 0 = party leader, 1 = first follower
  
  Key_Cycle     = :CTRL   # Key to cycle actors
  Use_Cycle     = true    # Option to use cycle control
  
  Show_Level    = true    # Show actor level
  Level_X       = 0       # Face graphic X position
  Level_Y       = 0       # Face graphic Y position
  
  Show_Class    = true    # Show actor class
  Class_X       = 0       # Face graphic X position
  Class_Y       = 0       # Face graphic Y position
  
  Show_Face     = true    # Show face graphic
  Face_X        = 0       # Face graphic X position
  Face_Y        = 0       # Face graphic Y position
  Face_Index    = 0       # Index of face Graphic
  
  Show_Sprite   = false   # Show Sprite graphic
  Sprite_X      = 50      # Sprite graphic X position
  Sprite_Y      = 80      # Sprite graphic Y position
  
  Show_HP       = true    # Show HP bar
  HP_X          = 120     # HP bar X position
  HP_Y          = 0       # HP bar Y position
  HP_Width      = 124     # HP bar width
  
  Show_MP       = true    # Show MP bar
  MP_X          = 120     # MP bar X position
  MP_Y          = 20      # MP bar Y position
  MP_Width      = 124     # MP bar width
  
  Show_TP       = true    # Show TP bar
  TP_X          = 120     # TP bar X position
  TP_Y          = 40      # TP bar Y position
  TP_Width      = 124     # TP bar width
  
  Show_EXP      = true    # Show Experience
  EXP_X         = 120     # Exp bar X position
  EXP_Y         = 60      # Exp bar Y position
  EXP_Width     = 124     # Exp bar width
  
  Show_Gold     = true    # Show Gold amount
  Gold_X        = 220     # Gold X position
  Gold_Y        = 80      # Gold Y position
  
  Window_Opacity      = 0         # window visibility, does not affect contents
  Window_Back_Opacity = 0         # Window background opacity
  Window_Graphic      = "Window"  # Window Graphic file to use
  
  Font          = "Arial"
  Font_Size     = 20
  
end
# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Actor_Hud_Window < Window_Base
  attr_reader :map_refresh
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
    draw_actor_graphic(@actor, R2_MAP_HUD::Sprite_X, R2_MAP_HUD::Sprite_Y) if R2_MAP_HUD::Show_Sprite
    # level
    draw_actor_level(@actor, R2_MAP_HUD::Level_X, R2_MAP_HUD::Level_Y + line_height * 1) if R2_MAP_HUD::Show_Level
    # class
    draw_actor_class(@actor, R2_MAP_HUD::Class_X, R2_MAP_HUD::Class_Y) if R2_MAP_HUD::Show_Class
    # hp
    width = R2_MAP_HUD::HP_Width
    draw_actor_hp(@actor, R2_MAP_HUD::HP_X, R2_MAP_HUD::HP_Y, width) if R2_MAP_HUD::Show_HP
    # mp
    width = R2_MAP_HUD::MP_Width
    draw_actor_mp(@actor, R2_MAP_HUD::MP_X, R2_MAP_HUD::MP_Y, width) if R2_MAP_HUD::Show_MP
    # tp
    width = R2_MAP_HUD::TP_Width
    draw_actor_tp(@actor, R2_MAP_HUD::TP_X, R2_MAP_HUD::TP_Y, width) if R2_MAP_HUD::Show_TP
    # exp
    width = R2_MAP_HUD::EXP_Width
    draw_actor_exp(@actor, R2_MAP_HUD::EXP_X, R2_MAP_HUD::EXP_Y, width) if R2_MAP_HUD::Show_EXP
    # gold
    draw_currency_value($game_party.gold, Vocab::currency_unit, R2_MAP_HUD::Gold_X - contents.width, R2_MAP_HUD::Gold_Y, R2_MAP_HUD::Hud_Width) if R2_MAP_HUD::Show_Gold
    @hud_gold = $game_party.gold
    @current_hp = @actor.hp
    @current_mp = @actor.mp
    @current_tp = @actor.tp
  end
  
  def exp_gauge_color1;   text_color(30);  end;    # TP gauge 1
  def exp_gauge_color2;   text_color(27);  end;    # TP gauge 2

  def draw_actor_exp(actor, x, y, width = 124)
    draw_exp_gauge(x, y, width, actor.exp, actor.current_level_exp, actor.next_level_exp, exp_gauge_color1, exp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::Exp_s)
    change_color(normal_color)
    draw_text(x + width - 42, y, 42, line_height, actor.exp.to_i, 2)
  end

  def draw_exp_gauge(x, y, width, exp, cur_exp, next_exp, color1, color2)
    curr = (exp - cur_exp).to_f
    dif = (next_exp - cur_exp).to_f
    fill_w = (curr/dif).to_f
    fill_w = fill_w * width
    fill_w = fill_w.to_i
    gauge_y = y + line_height - 8
    contents.fill_rect(x, gauge_y, width, 6, gauge_back_color)
    contents.gradient_fill_rect(x, gauge_y, fill_w, 6, color1, color2)
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
    return true if @current_mp != @actor.mp
    return true if @current_tp != @actor.tp
    return true if @hud_gold != $game_party.gold
    if @actor.exp_value
      @actor.exp_value=(false)
      return true 
    end
    return false
  end
  
  def update
    super
    refresh if hud_data_changed
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
end

class Game_Actor < Game_Battler
  attr_accessor :exp_value
  alias r2_actor_setup_hud  setup
  def setup(actor_id)
    r2_actor_setup_hud(actor_id)
    @exp_value = false
  end
  alias r2_change_exp_update_hud  change_exp
  def change_exp(exp, show)
    r2_change_exp_update_hud(exp, show)
    exp_value=(true)
  end
  def exp_value=(value = false)
    @exp_value = value
  end
  def exp_value
    return @exp_value
  end
end

class Scene_Map < Scene_Base
  alias r2_map_hud_start  start
  def start
    r2_map_hud_start
    start_hud
  end
  def start_hud
    @actor_shown = R2_MAP_HUD::Actor_Shown == 0 ? $game_party.leader : $game_party.members[R2_MAP_HUD::Actor_Shown] if @actor_shown.nil?
    @map_hud = Actor_Hud_Window.new(@actor_shown.id - 1)
  end
  alias r2_map_update_switch_actor    update
  def update
    r2_map_update_switch_actor
    if Input.trigger?(R2_MAP_HUD::Key_Cycle)
      @map_hud.switch_actor if R2_MAP_HUD::Use_Cycle
    end
    hud_update if @actor_shown != $game_party.members[@map_hud.c_actor]
    @hud_actor = $game_party.members[@map_hud.c_actor]
    if @hud_actor.exp_value
      hud_update
    end
  end
  def hud_update
    @map_hud.refresh
    @actor_shown = $game_party.members[@map_hud.c_actor]
  end
end
