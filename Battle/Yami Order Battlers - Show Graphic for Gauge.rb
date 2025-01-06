# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Show Graphic for Gauge       ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   Display graphic file for gauge    ║    14 Feb 2022     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Specify the X & Y and the file name in System folder     ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker except nudity             ║
# ╚══════════════════════════════════════════════════════════╝
 
module R2_SideBar_Gauge_Image
  POS_X = 0
  POS_Y = 50
  Graphic = "Sidebar"
end
 
class Scene_Battle < Scene_Base
 
  alias r2_order_gauge_create_graphic create_all_windows
  def create_all_windows
    r2_order_gauge_create_graphic
    @sidebar_gauge = Sprite.new
    @sidebar_gauge.bitmap = Cache.system(R2_SideBar_Gauge_Image::Graphic)
    @sidebar_gauge.opacity = 0
    @sidebar_gauge.x = R2_SideBar_Gauge_Image::POS_X
    @sidebar_gauge.y = R2_SideBar_Gauge_Image::POS_Y
    @sidebar_gauge.z = 100
    if $game_switches[YSA::ORDER_GAUGE::SHOW_SWITCH] == true
      @sidebar_gauge.opacity = 255
    end
  end
  alias r2_order_gauge_graphics_update update
  def update
    r2_order_gauge_graphics_update
    if $game_switches[YSA::ORDER_GAUGE::SHOW_SWITCH] == true
      @sidebar_gauge.opacity = 255 
    else
      @sidebar_gauge.opacity = 0
    end
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
