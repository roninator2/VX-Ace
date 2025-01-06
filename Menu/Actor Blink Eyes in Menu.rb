# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Blink graphic in Menu                  ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║     Use alternate graphic file                ╠════════════════════╣
# ║     to perform a blink of eyes                ║    10 Mar 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║        Animated face graphic in menu                               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Using face graphics, have the blink graphic                      ║
# ║   called "face graphic name[blink]"                                ║
# ║                                                                    ║
# ║  Change the numbers below to adjust the length of blink            ║
# ║  [40, 120] = [time between blinks, + random time (0-120)]          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 10 Mar 2022 - Script finished                               ║
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

module R2_Blink_Menu_Graphic
  Blink_Ext = "[blink]"
  # [time in between blinks, plus random 0-value (120)]
  Blink_Timing = [40, 120]
	Blink_Hold = 20 # frames to hold the blink graphic
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Window_MenuStatus < Window_Selectable
  alias r2_menu_blink_eyes_init initialize
  def initialize(x, y)
    r2_menu_blink_eyes_init(x, y)
    @blink = false
    @pause_time = 0
    @blink_time = 0
  end
  def draw_item(index)
    actor = $game_party.members[index]
    enabled = $game_party.battle_members.include?(actor)
    rect = item_rect(index)
    draw_item_background(index)
    draw_actor_blink(actor, rect.x + 1, rect.y + 1, enabled)
    if @blink == true
      if @pause_time < Graphics.frame_count
        @blink = false
      end
      draw_actor_face(actor, rect.x + 1, rect.y + 1, enabled) if @blink == false
    end
    draw_actor_simple_status(actor, rect.x + 108, rect.y + line_height / 2)
  end
  def draw_actor_blink(actor, x, y, enabled = true)
    graphic = actor.face_name + R2_Blink_Menu_Graphic::Blink_Ext
    draw_face(graphic, actor.face_index, x, y, enabled)
  end
  alias r2_update_blink_menu_face  update
  def update
    r2_update_blink_menu_face
    process_blinking
  end
  def process_blinking
    if @blink_time < Graphics.frame_count
      t1 = R2_Blink_Menu_Graphic::Blink_Timing[0]
      t2 = R2_Blink_Menu_Graphic::Blink_Timing[1]
      t3 = rand(t2)
      @blink_time = Graphics.frame_count + t1 + t3
      @pause_time = Graphics.frame_count + R2_Blink_Menu_Graphic::Blink_Hold
      @blink = true
    end
    refresh if @blink == true
  end
end
