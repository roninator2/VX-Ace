# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Food Quality                           ║  Version: 1.03     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Display window with stars                     ║    07 Jun 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Add a quality value to food                                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║    Add note tag to items that will show the                        ║
# ║    quality window.                                                 ║
# ║       <food quality: x>                                            ║
# ║                                                                    ║
# ║    Current settings are for showing 3 stars                        ║
# ║                                                                    ║
# ║    Change settings below to preference                             ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 07 Jun 2022 - Script finished                               ║
# ║ 1.03 - 08 Jun 2022 - Added Tone Control                            ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Yanfly                                                           ║
# ║   Neon Black                                                       ║
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

module R2_Item_Quality
  WindowSkin = "Window"     # set windowskin preference
  Default = 3               # number of stars to show
  Default_Image = "Bstar2"  # back star image
  Fill_Image = "Gstar2"     # front star image
  Spacer = 38               # distance to place the next star
  # images are 32x32 in size. so 38 leaves 6 pixels in between
  Tone_Red = 120            # window background colour
  Tone_Green = 120          # window background colour
  Tone_Blue = 120           # window background colour
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

module R2_Item_Quality
  Food_Quality = /<Food Quality:[ ]*(\d+)>/i # do not touch
end

class Window_ItemList

  alias :r2_itemquality_update :update
  def update
    r2_itemquality_update
    return if item.nil?
    close_quality_window if item.food_quality == 0 || @item_quality
    show_quality_window  if item.food_quality > 0 && self.active
  end
  def show_quality_window
    rect = item_rect(@index)
    x = rect.x + self.x + padding + 24 - ox
    y = rect.y + line_height + self.y + padding - oy - 2
    @item_quality = Window_FoodQualityShow.new(item, x, y, self)
  end
  def close_quality_window
    @item_quality.dispose if @item_quality
  end
end

class Window_FoodQualityShow < Window_Base
  def initialize(item, x, y, parent)
    @parent = parent
    @qwx = x; @qwy = y
    @item = item
    super(0, 0, 130, 55) # change width and height here
    self.z = @parent.z + 500
    self.windowskin = Cache.system(R2_Item_Quality::WindowSkin)
    self.back_opacity = 255
    r = R2_Item_Quality::Tone_Red
    g = R2_Item_Quality::Tone_Green
    b = R2_Item_Quality::Tone_Blue
    self.tone = Tone.new(r, g, b)
    self.width = 130    # copy width here
    self.height = 55    # copy height here
    make_position
    draw_all_items
  end

  def make_position
    self.x = @qwx + self.width > Graphics.width ? Graphics.width - self.width :
             @qwx
    self.y = @qwy + self.height <= Graphics.height ? @qwy :
             @qwy - self.height - @parent.line_height + 4 > 0 ? @qwy -
             self.height - @parent.line_height + 4 : Graphics.height -
             self.height
  end

  def draw_all_items
    contents.clear
    x = 0
    @back_image = []
    @top_image = []
    bimage = R2_Item_Quality::Default_Image
    gimage = R2_Item_Quality::Fill_Image
    bgstar = R2_Item_Quality::Default
    bgstar.times do |b|
      @back_image[b] = Sprite.new
      @back_image[b].bitmap = Cache.system(bimage)
      @back_image[b].x = b * R2_Item_Quality::Spacer + self.x + 10
      @back_image[b].y = self.y + 10
      @back_image[b].z = @parent.z + 501
    end
    @item.food_quality.times do |d|
      @top_image[d] = Sprite.new
      @top_image[d].bitmap = Cache.system(gimage)
      @top_image[d].x = d * R2_Item_Quality::Spacer + self.x + 10
      @top_image[d].y = self.y + 10
      @top_image[d].z = @parent.z + 502
    end
  end
  alias r2_dispose_quality dispose
  def dispose
    @back_image.size.times do |i|
      @back_image[i].bitmap.dispose
      @back_image[i].dispose
    end
    @top_image.size.times do |i|
      @top_image[i].bitmap.dispose
      @top_image[i].dispose
    end
    r2_dispose_quality
  end
end

class Scene_Item < Scene_ItemBase
  alias r2_close_quality_window_food_item_ok  on_item_ok
  def on_item_ok
    @item_window.close_quality_window
    r2_close_quality_window_food_item_ok
  end
  alias r2_close_quality_window_food_item_cancel  on_item_cancel
  def on_item_cancel
    @item_window.close_quality_window
    r2_close_quality_window_food_item_cancel
  end
end

module DataManager
  class <<self; alias load_database_r2_food_quality_load_database load_database; end
  def self.load_database
    load_database_r2_food_quality_load_database
    load_notetags_quality_items
  end
  def self.load_notetags_quality_items
    for item in $data_items
      next if item.nil?
      item.load_notetags_quality_items
    end
  end
end

class RPG::Item < RPG::UsableItem
  attr_accessor :food_quality
  def load_notetags_quality_items
    @food_quality = 0
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when R2_Item_Quality::Food_Quality
        @food_quality = $1.to_i
      end
    }
  end
end
