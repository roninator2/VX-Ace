# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Shop Item Name Scroll Text             ║ Version: 1.05      ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║ Date Created       ║
# ║                                               ╠════════════════════╣
# ║ Scroll the text when too long to fit          ║ 17 Sep 2023        ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║ TsukiHime Instance Items                                           ║
# ║ Intended to assist with Item Affixes                               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║ Scroll Item names in Shop                                          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║ Plug and play                                                      ║
# ║ Change the speed number if you like                                ║
# ║                                                                    ║
# ║ Designed for the default system and settings                       ║
# ║ Modifications may need to be done if not using defaults            ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.04 - 17 Sep 2023 - Script finished                               ║
# ║ 1.05 - added support for item rarity script                        ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║ RPG Maker Source                                                   ║
# ║ Roninator2                                                         ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Terms of use:                                                      ║
# ║ Follow the original Authors terms of use where applicable          ║
# ║ - When not made by me (Roninator2)                                 ║
# ║ Free for all uses in RPG Maker except nudity                       ║
# ║ Anyone using this script in their project before these terms       ║
# ║ were changed are allowed to use this script even if it conflicts   ║
# ║ with these new terms. New terms effective 03 Apr 2024              ║
# ║ No part of this code can be used with AI programs or tools         ║
# ║ Credit must be given                                               ║
# ╚════════════════════════════════════════════════════════════════════╝
 
 
module R2_Shop_Scroll_Name
  Shop_Speed = 0.8 # anything from 0.4 to 1.2 is ok
  Shop_length = 16
end
 
#==============================================================================
# ** Window_ShopBuy
#==============================================================================
 
class Window_ShopBuy < Window_Selectable
 
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias r2_shopbuy_text_scroll_init initialize
  def initialize(x, y, height, shop_goods)
    @r2_scrolling_shop_buy_text_line ||= {}
    r2_shopbuy_text_scroll_init(x, y, height, shop_goods)
  end
  #--------------------------------------------------------------------------
  # * Draw Item Name
  # enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 175)
    return unless item
    draw_icon(item.icon_index, x, y, enabled)
    if $imported[:TH_ItemRarity]
      change_color(item.rarity_colour, enabled)
    else
      change_color(normal_color, enabled)
    end
    cw = contents.text_size(item.name).width
    if (cw < width)
      draw_text(x + 24, y, width, line_height, item.name)
    else
      set_text(item.id, x, y, item.name, width, cw)
    end
  end
  #=============================================================================
  #--------------------------------------------------------------------------
  # * Update. [MOD]
  #--------------------------------------------------------------------------
  alias r2_update_equip_text_scroll update
  def update
    # Original method.
    r2_update_equip_text_scroll
    # data -> key = id -> 0 = text, 1 = speed, 2 = width, 3 = bitmap,
    # 4 - position {x,y}, 5 - text width, 6 - placement, 7 - direction <- ->
    # 8 - viewport, 9 - type
    dispose_shopbuy_list if !self.active
    return if !self.active
    buyitem = @Data[@index].nil? ? -1 : @Data[@index].id
    @r2_scrolling_shop_buy_text_line.each do |id, data|
      next if buyitem != id
      data[3].visible = visible
      # Advance the image position
      # Change the offset X to scroll.
      if (data[7] == 0)
        data[6] += (1.0 * data[1]).to_f
        data[3].ox = data[6]
      elsif (data[7] == 1)
        data[6] -= (1.0 * data[1]).to_f
        data[3].ox = data[6]
      end
      if data[6] >= (data[5] - (data[2] / 5 * 3) - 30)
        data[7] = 1
      elsif data[6] <= 10
        data[7] = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set Text. [REP]
  #--------------------------------------------------------------------------
  def set_text(id, x, y, text, width, cw)
    # New text?
    # data -> key = id -> 0 = text, 1 = speed, 2 = width, 3 = bitmap,
    # 4 - position, 5 - text width, 6 - placement, 7 - direction,
    # 8 - viewport
    @r2_scrolling_shop_buy_text_line ||= {}
    if @r2_scrolling_shop_buy_text_line.empty? || @r2_scrolling_shop_buy_text_line[id].nil? ||
      text != @r2_scrolling_shop_buy_text_line[id][1]
      # Dispose the Scrolling Help objects if needed.
      r2_scrolling_text_dispose(id) if @r2_scrolling_shop_buy_text_line[id] != nil
      speed = R2_Shop_Scroll_Name::Shop_Speed
      x = x + self.x
      if cw > width
        # draw the line as a scrolling line.
        @r2_scrolling_shop_buy_text_line[id] = [text, speed, width, nil, [x, y], cw,
        x, 0, nil]
        r2_shop_scrolling_text_create(id, x, y, text, width)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Scrolling Help Create. [NEW]
  #--------------------------------------------------------------------------
  def r2_shop_scrolling_text_create(id, x, y, text, width)
    # draw normal text if not at index position
    buyitem = @Data[@index].nil? ? -1 : @Data[@index].id
    if buyitem != id
      text = text[0..(R2_Shop_Scroll_Name::Shop_length - 1)] + "..."
      draw_text(x + 24, y, width, line_height, text)
      return
    end
    # Create a Bitmap instance to draw the text into it.
    line_bitmap = Bitmap.new(@r2_scrolling_shop_buy_text_line[id][5] + 24, calc_line_height(text))
    # Save current Window's Bitmap.
    original_contents = contents
    # Set the recently created Bitmap as the Window's Bitmap.
    self.contents = line_bitmap
    # Use the default method to draw the text into it.
    draw_text_ex(24, 0, text)
    # Reset back the Window's Bitmap to the original one.
    self.contents = original_contents
    # Viewport for the Scrolling Line.
    @r2_scrolling_shop_buy_text_line[id][8] = Viewport.new(
    x + standard_padding + 24,
    self.y + (@index - self.top_row) * 24 + standard_padding,
    width, line_bitmap.height )
    # Put the recently created Viewport on top of this Window.
    @r2_scrolling_shop_buy_text_line[id][8].z = viewport ? viewport.z + 1 : z + 1
    # Create a Plane instance for the scrolling effect.
    @r2_scrolling_shop_buy_text_line[id][3] = Plane.new(@r2_scrolling_shop_buy_text_line[id][8])
    # Assign the recently created Bitmap (where the line is drawn) to it.
    @r2_scrolling_shop_buy_text_line[id][3].bitmap = line_bitmap
  end
  #--------------------------------------------------------------------------
  # * Scrolling Help Dispose. [NEW]
  #--------------------------------------------------------------------------
  def r2_shop_scrolling_text_dispose(id)
    # Disposes Bitmap, Plane and Viewport.
    if !@r2_scrolling_shop_buy_text_line[id][3].nil?
      @r2_scrolling_shop_buy_text_line[id][3].bitmap.dispose
      @r2_scrolling_shop_buy_text_line[id][3].dispose
    end
    # Prevents executing this method when the Plane (or Viewport) is disposed.
    @r2_scrolling_shop_buy_text_line[id][3] = nil
  end
  #--------------------------------------------------------------------------
  # * Dispose All values. [NEW]
  #--------------------------------------------------------------------------
  def dispose_shopbuy_list
    if @r2_scrolling_shop_buy_text_line != {}
      @r2_scrolling_shop_buy_text_line.each do |key, entry|
        r2_shop_scrolling_text_dispose(key)
      end
    end
    @r2_scrolling_shop_buy_text_line = {}
  end
  #--------------------------------------------------------------------------
  # * Dispose. [MOD]
  #--------------------------------------------------------------------------
  def dispose
    # Dispose Scrolling Help objects if needed.
    if @r2_scrolling_shop_buy_text_line != {}
      dispose_shopbuy_list
    end
    @r2_scrolling_shop_buy_text_line = {}
    # Original method.
    super
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias r2_refresh_dispose_scroll_text refresh
  def refresh
    if @r2_scrolling_shop_buy_text_line != {}
      dispose_shopbuy_list
    end
    @r2_scrolling_shop_buy_text_line = {}
    r2_refresh_dispose_scroll_text
  end
  #--------------------------------------------------------------------------
  # * Cursor Movement Processing
  #--------------------------------------------------------------------------
  alias r2_cursor_index_move_refresh_draw process_cursor_move
  def process_cursor_move
    last_index = @index
    r2_cursor_index_move_refresh_draw
    refresh if @index != last_index
  end
end
 
#==============================================================================
# ** Window_ShopNumber
#==============================================================================
 
class Window_ShopNumber < Window_Selectable
 
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias r2_shopnumber_text_scroll_init initialize
  def initialize(x, y, height)
    @r2_scrolling_shop_number_text_line ||= {}
    r2_shopnumber_text_scroll_init(x, y, height)
  end
  #--------------------------------------------------------------------------
  # * Draw Item Name
  # enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 175)
    return unless item
    draw_icon(item.icon_index, x, y, enabled)
    change_color(normal_color, enabled)
    dispose_number_buy
    cw = contents.text_size(item.name).width
    if cw < width
      draw_text(x + 24, y, width, line_height, item.name)
    else
      set_text(item.id, x, y, item.name, width)
    end
  end
  #=============================================================================
  #--------------------------------------------------------------------------
  # * Update. [MOD]
  #--------------------------------------------------------------------------
  alias r2_update_shopnumber_text_scroll update
  def update
    # Original method.
    r2_update_shopnumber_text_scroll
    # data -> key = id -> 0 = text, 1 = speed, 2 = width, 3 = bitmap,
    # 4 - position {x,y}, 5 - text width, 6 - placement, 7 - direction <- ->
    # 8 - viewport, 9 - type
    return if @r2_scrolling_shop_number_text_line == {}
    @r2_scrolling_shop_number_text_line.each do |id, data|
      next if data[3].nil?
      data[3].visible = visible
      # Advance the image position
      # Change the offset X to scroll.
      if (data[7] == 0)
        data[6] += (1.0 * data[1]).to_f
        data[3].ox = data[6]
      elsif (data[7] == 1)
        data[6] -= (1.0 * data[1]).to_f
        data[3].ox = data[6]
      end
      if data[6] >= (data[5] - (data[2] / 5 * 3) - 30)
        data[7] = 1
      elsif data[6] <= 10
        data[7] = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set Text. [REP]
  #--------------------------------------------------------------------------
  def set_text(id, x, y, text, width)
    # New text?
    # data -> key = id -> 0 = text, 1 = speed, 2 = width, 3 = bitmap,
    # 4 - position, 5 - text width, 6 - placement, 7 - direction,
    # 8 - viewport
    cw = contents.text_size(text).width
    if @r2_scrolling_shop_number_text_line.empty? || @r2_scrolling_shop_number_text_line[id].nil? ||
      text != @r2_scrolling_shop_buy_text_line[id][1]
      # Dispose the Scrolling Help objects if needed.
      r2_scrolling_text_dispose(id) if @r2_scrolling_shop_number_text_line[id] != nil
      speed = R2_Shop_Scroll_Name::Shop_Speed
      x = x + self.x
      if cw > width
        # draw the line as a scrolling line.
        @r2_scrolling_shop_number_text_line[id] = [text, speed, width, nil, [x, y], cw,
        x, 0, nil]
        r2_scrolling_text_create(id, x, y, text, width)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Scrolling Help Create. [NEW]
  #--------------------------------------------------------------------------
  def r2_scrolling_text_create(id, x, y, text, width)
    # Create a Bitmap instance to draw the text into it.
    line_bitmap = Bitmap.new(@r2_scrolling_shop_number_text_line[id][5] + 24, calc_line_height(text))
    # Save current Window's Bitmap.
    original_contents = contents
    # Set the recently created Bitmap as the Window's Bitmap.
    self.contents = line_bitmap
    # Use the default method to draw the text into it.
    draw_text_ex(24, 0, text)
    # Reset back the Window's Bitmap to the original one.
    self.contents = original_contents
    # Viewport for the Scrolling Line.
    @r2_scrolling_shop_number_text_line[id][8] = Viewport.new(
    x + standard_padding + 24,
    self.y + y + standard_padding,
    width,
    line_bitmap.height
    )
    # Put the recently created Viewport on top of this Window.
    @r2_scrolling_shop_number_text_line[id][8].z = viewport ? viewport.z + 1 : z + 1
    # Create a Plane instance for the scrolling effect.
    @r2_scrolling_shop_number_text_line[id][3] = Plane.new(@r2_scrolling_shop_number_text_line[id][8])
    # Assign the recently created Bitmap (where the line is drawn) to it.
    @r2_scrolling_shop_number_text_line[id][3].bitmap = line_bitmap
    @r2_scrolling_shop_number_text_line[id][3].visible = !visible
  end
  #--------------------------------------------------------------------------
  # * Dispose All values. [NEW]
  #--------------------------------------------------------------------------
  def dispose_number_buy
    if !@r2_scrolling_shop_number_text_line.empty?
      @r2_scrolling_shop_number_text_line.each do |key, entry|
        # Disposes Bitmap, Plane and Viewport.
        @r2_scrolling_shop_number_text_line[key][3].bitmap.dispose
        @r2_scrolling_shop_number_text_line[key][3].dispose
        # Prevents executing this method when the Plane (or Viewport) is disposed.
        @r2_scrolling_shop_number_text_line[key] = nil
      end
    end
    @r2_scrolling_shop_number_text_line = {}
  end
  #--------------------------------------------------------------------------
  # * Dispose. [MOD]
  #--------------------------------------------------------------------------
  def dispose
    # Dispose Scrolling Help objects if needed.
    dispose_number_buy
    @r2_scrolling_shop_number_text_line = {}
    # Original method.
    super
  end
end
 
#==============================================================================
# ** Window_ShopStatus
#==============================================================================
 
class Window_ShopStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias r2_shop_status_text_scroll_init initialize
  def initialize(x, y, width, height)
    @r2_scrolling_shop_status_text_line ||= {}
    r2_shop_status_text_scroll_init(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # * Draw Item Name
  # enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 175)
    return unless item
    draw_icon(item.icon_index, x, y, enabled)
    change_color(normal_color, enabled)
    cw = contents.text_size(item.name).width
    if cw < width
      draw_text(x + 24, y, width, line_height, item.name)
    else
      if TH::Instance_Items::Enable_Armors
        set_text(item.id, x, y, item.name, width)
      else
        id = @r2_scrolling_shop_status_text_line.size
        set_text(id, x, y, item.name, width)
      end
    end
  end
  #=============================================================================
  #--------------------------------------------------------------------------
  # * Update. [MOD]
  #--------------------------------------------------------------------------
  alias r2_update_shop_status_text_scroll update
  def update
    # Original method.
    r2_update_shop_status_text_scroll
    # data -> key = id -> 0 = text, 1 = speed, 2 = width, 3 = bitmap,
    # 4 - position {x,y}, 5 - text width, 6 - placement, 7 - direction <- ->
    # 8 - viewport
    return if @r2_scrolling_shop_status_text_line.nil? || @r2_scrolling_shop_status_text_line.empty?
    @r2_scrolling_shop_status_text_line.each do |id, data|
      data[3].visible = visible
      # Advance the image position
      # Change the offset X to scroll.
      if (data[7] == 0)
        data[6] += (1.0 * data[1]).to_f
        data[3].ox = data[6] - data[2] - 25
      elsif (data[7] == 1)
        data[6] -= (1.0 * data[1]).to_f
        data[3].ox = data[6] - data[2] - 25
      end
      if (data[6] >= (data[5] + (data[2] / 5 * 2) ))
        data[7] = 1
      elsif (data[6] <= (data[5] - (data[2] / 5 * 3) - 10))
        data[7] = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set Text. [REP]
  #--------------------------------------------------------------------------
  def set_text(id, x, y, text, width)
    # New text?
    # data -> key = id -> 0 = text, 1 = speed, 2 = width, 3 = bitmap,
    # 4 - position, 5 - text width, 6 - placement, 7 - direction,
    # 8 - viewport
    @r2_scrolling_shop_status_text_line ||= {}
    cw = contents.text_size(text).width
    if @r2_scrolling_shop_status_text_line.empty? || @r2_scrolling_shop_status_text_line[id].nil? ||
      text != @r2_scrolling_shop_status_text_line[id][1]
      # Dispose the Scrolling Help objects if needed.
      r2_shop_status_text_dispose(id) if @r2_scrolling_shop_status_text_line[id] != nil
      speed = R2_Shop_Scroll_Name::Shop_Speed
      x = x + self.x
      if cw > width
        # draw the line as a scrolling line.
        @r2_scrolling_shop_status_text_line[id] = [text, speed, width, nil, [x, y], cw,
        x, 0, nil]
        r2_shop_status_scrolling_text_create(id, x, y, text, width)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Scrolling Help Create. [NEW]
  #--------------------------------------------------------------------------
  def r2_shop_status_scrolling_text_create(id, x, y, text, width)
    # Create a Bitmap instance to draw the text into it.
    line_bitmap = Bitmap.new(@r2_scrolling_shop_status_text_line[id][5] + 24, calc_line_height(text))
    # Save current Window's Bitmap.
    original_contents = contents
    # Set the recently created Bitmap as the Window's Bitmap.
    self.contents = line_bitmap
    # Use the default method to draw the text into it.
    draw_text_ex(24, 0, text)
    # Reset back the Window's Bitmap to the original one.
    self.contents = original_contents
    # Viewport for the Scrolling Line.
    @r2_scrolling_shop_status_text_line[id][8] = Viewport.new(
    x + standard_padding + 24,
    self.y + y + standard_padding,
    width,
    line_bitmap.height
    )
    # Put the recently created Viewport on top of this Window.
    @r2_scrolling_shop_status_text_line[id][8].z = viewport ? viewport.z + 1 : z + 1
    # Create a Plane instance for the scrolling effect.
    @r2_scrolling_shop_status_text_line[id][3] = Plane.new(@r2_scrolling_shop_status_text_line[id][8])
    # Assign the recently created Bitmap (where the line is drawn) to it.
    @r2_scrolling_shop_status_text_line[id][3].bitmap = line_bitmap
    @r2_scrolling_shop_status_text_line[id][3].visible = !visible
  end
  #--------------------------------------------------------------------------
  # * Dispose. [MOD]
  #--------------------------------------------------------------------------
  def dispose
    # Dispose Scrolling Help objects if needed.
    if @r2_scrolling_shop_status_text_line != {}
      @r2_scrolling_shop_status_text_line.each do |key, entry|
        # Disposes Bitmap, Plane and Viewport.
        @r2_scrolling_shop_status_text_line[key][3].bitmap.dispose
        @r2_scrolling_shop_status_text_line[key][3].dispose
        # Prevents executing this method when the Plane (or Viewport) is disposed.
        @r2_scrolling_shop_status_text_line[key][3] = nil
      end
    end
    @r2_scrolling_shop_status_text_line = {}
    # Original method.
    super
  end
  #--------------------------------------------------------------------------
  # * Scrolling Help Dispose. [NEW]
  #--------------------------------------------------------------------------
  def r2_shop_status_text_dispose(id)
    # Disposes Bitmap, Plane and Viewport.
    if !@r2_scrolling_shop_status_text_line[id][3].nil?
      @r2_scrolling_shop_status_text_line[id][3].bitmap.dispose
      @r2_scrolling_shop_status_text_line[id][3].dispose
    end
    # Prevents executing this method when the Plane (or Viewport) is disposed.
    @r2_scrolling_shop_status_text_line[id][3] = nil
  end
  #--------------------------------------------------------------------------
  # * Dispose All values. [NEW]
  #--------------------------------------------------------------------------
  def dispose_shopstatus_list
    if @r2_scrolling_shop_status_text_line != {}
      @r2_scrolling_shop_status_text_line.each do |key, entry|
        r2_shop_status_text_dispose(key)
      end
    end
    @r2_scrolling_shop_status_text_line = {}
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  alias r2_refresh_dispose_scroll_text refresh
  def refresh
    dispose_shopstatus_list
    r2_refresh_dispose_scroll_text
  end
end
 
#==============================================================================
# ** Scene_Shop
#==============================================================================
 
class Scene_Shop < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Sell [Cancel]
  #--------------------------------------------------------------------------
  alias r2_shop_sell_refresh_cancel on_sell_cancel
  def on_sell_cancel
    r2_shop_sell_refresh_cancel
    @sell_window.refresh
  end
end
