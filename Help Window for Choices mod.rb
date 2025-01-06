#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#             Help Window for Choices
#             Version: 2.1
#             Authors: DiamondandPlatinum3
#                       Roninator2
#             Date: December 4, 2012  (Original)
#                   December 14, 2013 (Updated)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Description:
#
#    This script adds on to the default choice system, allowing you to have a 
#    help window at the top of the screen to assist players in the choices they
#    have to make
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

=begin
##    *Addition by Roninator2
##    Displays a dim background instead of default window
##   
##    Only setting is the opacity of the window
##    Values from 0-255 
##   
##    Adjust position depending on where you place the message. E.g. top or bottom
##    0 for top, (depending on your screen resolution) 400 for bottom
=end

#==============================================================================
# Setting
#==============================================================================
module R2DP3CH

  #Help Window Opacity 0-255
  View = 180
  
  #Help Window Y position
  WinY = 400
end

#==============================================================================
# Addon Script
#==============================================================================
class DP3_Choice_Window_Help < Window_Help
    
  def initialize(text, position)
    super( [text.split("\n").size, 2].max )
    self.y = position * (Graphics.height - self.height) / 2
    self.openness = 255
    set_text(text)
    self.windowskin = Cache.system("Window_blank")
    self.opacity = R2DP3CH::View
    create_back_bitmap_CH
    create_back_sprite_CH
    refresh
  end
  #--------------------------------------------------------------------------
  # * Create Background Bitmap
  #--------------------------------------------------------------------------
  def create_back_bitmap_CH
    @back_bitmap_CH = Bitmap.new(width, height) if @back_bitmap_CH.nil?
    rect1 = Rect.new(0, 0, width, 12)
    rect2 = Rect.new(0, 12, width, height - 24)
    rect3 = Rect.new(0, height - 12, width, 12)
    @back_bitmap_CH.gradient_fill_rect(rect1, back_color2, back_color1, true)
    @back_bitmap_CH.fill_rect(rect2, back_color1)
    @back_bitmap_CH.gradient_fill_rect(rect3, back_color1, back_color2, true)
  end
  #--------------------------------------------------------------------------
  # * Get Background Color 1
  #--------------------------------------------------------------------------
  def back_color1
    Color.new(0, 0, 0, R2DP3CH::View)
  end
  #--------------------------------------------------------------------------
  # * Get Background Color 2
  #--------------------------------------------------------------------------
  def back_color2
    Color.new(0, 0, 0, R2DP3CH::View)
  end
  #--------------------------------------------------------------------------
  # * Create Background Sprite
  #--------------------------------------------------------------------------
  def create_back_sprite_CH
    @back_sprite_CH = Sprite.new if @back_sprite_CH.nil?
    @back_sprite_CH.bitmap = @back_bitmap_CH
    @back_sprite_CH.z = z - 1
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_back_sprite_CH
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    super
    dispose_back_bitmap_CH
    dispose_back_sprite_CH
  end
  #--------------------------------------------------------------------------
  # * Update Background Sprite
  #--------------------------------------------------------------------------
  def update_back_sprite_CH
    @back_sprite_CH.visible = $game_message.visible ? true : false
    @back_sprite_CH.opacity = R2DP3CH::View
    @back_sprite_CH.y = R2DP3CH::WinY
    @back_sprite_CH.update
  end
  #--------------------------------------------------------------------------
  # * Free Background Bitmap
  #--------------------------------------------------------------------------
  def dispose_back_bitmap_CH
    @back_bitmap_CH.dispose
  end
  #--------------------------------------------------------------------------
  # * Free Background Sprite
  #--------------------------------------------------------------------------
  def dispose_back_sprite_CH
    @back_sprite_CH.dispose
  end

end
