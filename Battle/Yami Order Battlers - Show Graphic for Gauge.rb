# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Yami Order Gauge Image - sidebar       ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Draw a background image for gauge             ║    29 Dec 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Yanfly Battle Engine                                     ║
# ║           Yami Order Battlers                                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║     Order Battlers - Show sidebar image                            ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Place below Order Battlers                                       ║
# ║   Fixes the issue that the gauge doesn't update when an            ║
# ║   enemy is revealed, transformed, or revived                       ║
# ║   Configure settings below                                         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 28 Dec 2022 - Script finished                               ║
# ║ 1.01 - 29 Dec 2022 - fix bug                                       ║
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

module R2_SideBar_Gauge_Image
  POS_X = 0
  POS_Y = 65
  Graphic = "Order Battler Sidebar"
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Scene_Battle < Scene_Base

  alias r2_order_gauge_create_graphic create_all_windows
  def create_all_windows
    r2_order_gauge_create_graphic
    @sidebar_gauge = Sprite.new
    @sidebar_gauge.bitmap = Cache.system(R2_SideBar_Gauge_Image::Graphic)
    @sidebar_gauge.opacity = 0
    @sidebar_gauge.x = R2_SideBar_Gauge_Image::POS_X
    @sidebar_gauge.y = R2_SideBar_Gauge_Image::POS_Y
    @sidebar_gauge.z = 50
    if $game_switches[YSA::ORDER_GAUGE::SHOW_SWITCH] == true
      @sidebar_gauge.opacity = 255
    else
      @sidebar_gauge.opacity = 0
    end
  end
  alias r2_order_gauge_graphics_update update
  def update
    if $game_switches[YSA::ORDER_GAUGE::SHOW_SWITCH] == true
      if $game_party.all_dead? || $game_troop.all_dead?
				@sidebar_gauge.opacity = 0
			else
				@sidebar_gauge.opacity = 255
			end
    else
      @sidebar_gauge.opacity = 0
    end
    r2_order_gauge_graphics_update
  end
  alias r2_order_gauge_dispose_all dispose_spriteset
  def dispose_spriteset
    for order in @spriteset_order
      order.bitmap.dispose
      order.dispose
    end
    @sidebar_gauge.bitmap.dispose
    @sidebar_gauge.dispose
    r2_order_gauge_dispose_all
  end
end
