#========================================================
# Author: Heirukichi
# Last update: 05-26-2019 [MM-DD-YYYY]
# License: CC 4.0 BY-SA
#========================================================
# Mod by Roninator2
# use <custom_offset: x, y>
# to move a specific event
# Place inside a comment on the event
#========================================================

module HRK_CHOFS

  #======================================================
  # Set this to false if you want to use the default offset
  #======================================================
  USE_CUSTOM_OFFSET = true
 
  #======================================================
  # - - - WARNING! Do not modify after this point!
  #======================================================
  Regex = /<custom[-_ ]offset:\s*(v\[\d+\]|\d+)\s*(\w+)?>/i

end

module RPG
  class Event::Page

    def custom_position?
      return @is_custom_position unless @is_custom_position.nil?
      load_notetag_custom_event_positions
      return @is_custom_position
    end

    def load_notetag_custom_event_positions
      @is_custom_position = false
      @custom_position_x = 0
      @custom_position_y = 0
      @list.each do |cmd|
        if cmd.code == 108 && cmd.parameters[0] =~ HRK_CHOFS::Regex
          @custom_position_x = $1
          @custom_position_y = $2
          break
        end
      end
    end

	end
end

#========================================================
# * Game_CharacterBase class
#========================================================
class Game_CharacterBase
 
  alias hrk_chofs_shift_y_old shift_y
  def shift_y
    if HRK_CHOFS::USE_CUSTOM_OFFSET
      object_character? ? 0 : @custom_position_y
    else
      hrk_chofs_shift_y_old
    end
  end

  def shift_x
    object_character? ? 0 : @custom_position_x
  end

  alias hrk_chofs_screen_x_old screen_x
  def screen_x
    hrk_chofs_screen_x_old - shift_x
  end

end
