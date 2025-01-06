#==============================================================================
# ■ Smooth Cursor Movement var 0.00 by Kanji the Grass
# This work is provided under the MTCM Blue License
# https://en.materialcommons.tk/mtcm-b-summary/
# Credits display: Kanji the Grass
#==============================================================================
# module add on by roninator2
module Kanji
	module Scroll_cursor
		Scroll_time = 12
	end
end

class Window_Selectable
  def c_max_time
    return 3
  end
  #--------------------------------------------------------------------------
  # ● Set cursor position
  #--------------------------------------------------------------------------
  alias kns_index index=
  def index=(index)
    @last_index2 = @index
    @cursor_end = false
    @c_time = 0
    kns_index(index)
  end
  #--------------------------------------------------------------------------
  # ● Update cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @cursor_all
      cursor_rect.set(0, 0, contents.width, row_max * item_height)
      self.top_row = 0
    elsif @index < 0
      cursor_rect.empty
    else
      ensure_cursor_visible
      @o_rect = @last_index2 == -1 ? @o_rect.empty : item_rect(@last_index2)
      @t_rect = @index == -1 ? @t_rect.empty : item_rect(@index)
    end
  end
  def update_cursor_par_frame
    return unless self.visible
    if !(@cursor_all || @index < 0) && !@cursor_end
      x, y = @o_rect.x, @o_rect.y
      x2, y2 = @t_rect.x, @t_rect.y
      nx = (x2 - x) * @c_time.next.to_f / c_max_time + x
      ny = (y2 - y) * @c_time.next.to_f / c_max_time + y
      cursor_rect.set(nx, ny, @t_rect.width, @t_rect.height)
      @c_time += 1
      @cursor_end = @c_time >= c_max_time
      Graphics.frame_reset
    end
  end
 
  alias kns_initialize initialize
  def initialize(x, y, width, height)
    kns_initialize(x, y, width, height)
    @oy_time = @t_oy = 0
    @ox_time = @t_ox = 0
    @last_index2 = 0
    @cursor_end = false
    @c_time = 0
    @o_rect = Rect.new(0,0,1,10)
    @t_rect = Rect.new(0,0,1,10)
  end
  alias kns_update update
  def update
    kns_update
    update_scroll_o
    update_cursor_par_frame
  end
  alias kns_oy oy=
  def oy=(oy)
    return if @t_oy == oy
    @oy_time = 0
    @t_oy = oy
  end
  alias kns_ox ox=
  def ox=(ox)
    return if @t_ox == ox
    @ox_time = 0
    @t_ox = ox
  end
  def update_scroll_o
    return unless self.visible
    need_reset = nil
    if @t_oy != self.oy
      @oy_time = @oy_time.next % scroll_o_time
      kns_oy((@t_oy - self.oy) * @oy_time.next.to_f / scroll_o_time + self.oy)
      @oy_time += 1
      need_reset = true
    end
    if @t_ox != self.ox
      @ox_time = @ox_time.next % scroll_o_time
      kns_ox((@t_ox - self.ox) * @ox_time.next.to_f / scroll_o_time + self.ox)
      @ox_time += 1
      need_reset = true
    end
    Graphics.frame_reset if need_reset
  end
  def scroll_o_time
    return Kanji::Scroll_cursor::Scroll_time #12
  end
end
