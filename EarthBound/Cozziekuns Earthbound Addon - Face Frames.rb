# https://forums.rpgmakerweb.com/index.php?threads/need-a-little-modification-on-cozziekunss-earthbound-battle-system.143025/#post-1236737

module R2_Cozzie_Status_Back_Color
  Back = Color.new(0,65,155,180) # color for back when Show_Back == false
  Show_Back = false # show default status window
end
class Window_BattleStatus < Window_Selectable
  def draw_window_frame(x, y, w, h)
    contents.blt(x, y, windowskin, Rect.new(64,0,16,16))
    contents.blt(x+w-16, y, windowskin, Rect.new(112,0,16,16))
    contents.blt(x, y+h-16, windowskin, Rect.new(64,48,16,16))
    contents.blt(x+w-16, y+h-16, windowskin, Rect.new(112,48,16,16))
    adjust = $game_party.battle_members.size
    contents.fill_rect(x + 6, y + 6, adjust % 3 == 0 ? 117 : 119, 108, R2_Cozzie_Status_Back_Color::Back) unless
    R2_Cozzie_Status_Back_Color::Show_Back == true
    i=0
    while i < w-32 do
      contents.blt(x+16+i, y, windowskin, Rect.new(80,0,[w-32-i,32].min,16))
      contents.blt(x+16+i, y+h-16, windowskin, Rect.new(80,48,[w-32-i,32].min,16))
      i+=32
    end
    i=0
    while i < h-32 do
      contents.blt(x, y+16+i, windowskin, Rect.new(64,16,16,[h-32-i,32].min))
      contents.blt(x+w-16, y+16+i, windowskin, Rect.new(112,16,16,[h-32-i,32].min))
      i+=32
    end   
  end
 
  def draw_basic_area(rect, actor)
    draw_window_frame(rect.x, rect.y, rect.width, rect.height)
    draw_actor_name(actor, rect.x, rect.y + 3, rect.width)
    draw_actor_icons(actor, rect.x + 4, rect.y + line_height, rect.width)
  end

  def draw_gauge_area_with_tp(rect, actor)
    draw_gauge_area_without_tp(rect, actor)
    draw_actor_tp(actor, rect.x + 8, rect.y + line_height * 4 - 5, rect.width - 18)
  end

  def draw_gauge_area_without_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 8, rect.y + line_height * 2 - 5, rect.width - 18)
    draw_actor_mp(actor, rect.x + 8, rect.y + line_height * 3 - 5, rect.width - 18)
  end
 
end

class Scene_Battle < Scene_Base
  alias r2_status_window_hide create_status_window
  def create_status_window
    r2_status_window_hide
    @status_window.opacity = 0 if R2_Cozzie_Status_Back_Color::Show_Back == false
  end
end
