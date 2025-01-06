#===============================================================================
# http://thiagodd.blogspot.com.br/
# TSDA Advanced Message System
#   by thiago_d_d
#   Version 1.2.1
# Mod by Roninator2
# Any suggestions are apreciated, please make them here:
# http://thiagodd.blogspot.com.br/
#===============================================================================
# Changelog of this version:
#      - Fixed the bug with the y position of gold window.
#      - Added an italic tag.
#      - Added option to deactivate face window during game play. Now the face
# window is activated by an switch, so if you don't want to use face outside
# the window, deactivate that switch.
#===============================================================================
# Features
#    - Created name window to show a name of your choice, only if you want.
#    - The name window is customized, so you change color, etc.
#    - Added support to hex colors.
#    - Advanced letter by letter mode with advanced speed configuration.
#    - You can choose if the player can skip the letter by letter mode
#    - Added \Map tag, that shows the actual map name display
#    - Added support to changes to the font name, size, and bold flag.
#    - The face can be shown on a separate window.
#    - The face can be shown on the right when separate window.
#    - Message window position and size can now be customized.
#    - Message window opacity can be customized.
#    - Possibility to play an sound when letter by letter is on.
#    - Everything is customized, you can change everything with tags during the
#      text draw.
#===============================================================================
# Changing window size and position
#===============================================================================
# To change height, width, and x position -> go to TSDA module and configure
# To change message window y position, execute a script, there are 4 options
#
# $game_message.real_position = desired_y
#     changes the position to the desired y position in the screen
#
# $game_message.real_position = "event_id"
#     changes the position based on the specified event coordinates, so the
#     window will not be above the event
#
# $game_message.real_position = "player"
#     changes the position based on the player coordinates, so the
#     window will not be above the player
#
# $game_message.real_position = nil
#     the message window position will be normal, like if there is not 
#     this script
#===============================================================================
# Playing sound letter by letter
#===============================================================================
# Configure the switch that activates that mode on the TSDA module.
# To determine the sound that will be player, execute the script:
#     $game_message.letter_sound = "Sound name"
# Sound should be on the SE folder
#===============================================================================
# OLD TAGS
#    These tags already exists, only listing them to make things easy for you.
#===============================================================================
# \V[ID] - Shows the value of the variable with the specified ID.
# \N[ID] - Shows the name of the hero with the specified ID.
# \C[ID] - Changes the color to that color index of the windowskin.
# \P[n] - Shows the name of the hero in the team that has the specified position
# \$ - Shows gold window.
# \I[index] - Show the icon with the specified index.
# \G - Shows the gold name.
# \{ - Increases font size.
# \} - Decreases font size.
# \. - waits for 0.25 seconds.
# \| - waits for 1 second.
# \\ - draws the \ character.
# \< - Shows the next text imediately.
# \> - Stops to show the text imediately
# \! - Pauses the window, waiting for input.
# \^ - Closes the window.
#===============================================================================
# NEWS TAGS
#    You can still use old tags, they work normally.
#===============================================================================
# \c[#000000]
#      changes text color by the specified hex color.
#---------------------------------------
# \M 
#      activates the letter by letter mode if it is activated, or deactivate is
#      if it is activated.
#---------------------------------------
# \Q[speed]
#      changes letter by letter by letter mode speed delay.
#---------------------------------------
# \W
#      activates the jump letter by letter function if it is deactivate, or
#      deactivates it if it is activated.
#---------------------------------------
# \Map
#      shows the actual map name.
#---------------------------------------
# \S[Text]
#      shows the name window above the message window, with the specified text.
#      You can use other tags inside the text
#---------------------------------------
# \R
#      closes the name window
#---------------------------------------
# \I[color]
#      changes the name window text color(supports hex)
#---------------------------------------
# \F[font name]
#      changes the message window font
#---------------------------------------
# \L
#      sets the font to bold, if it's not bold, or set it to normal, 
#      if it is bold
#---------------------------------------
# \H[size]
#      sets the font size
#---------------------------------------
# \X
#      sets the font to italic if it's not italic, or set it to normal, if it
#      is italic
#---------------------------------------
#===============================================================================
#===============================================================================
# module TSDA
#===============================================================================
module TSDA
  #ID of the switch that activates letter by letter mode
  AMS_LETTER_BY_LETTER_SWITCH = 1
  #ID of the switch that indicates if the player can jump letter by letter mode
  AMS_JUMP_LBL_SWITCH = 2
  #ID of the variable that indicates letter by letter mode speed delay.
  AMS_SPEED_DELAY_LBL_VARIABLE = 1
  #The font used in the name box
  # format:
  # ["name",size,bold]
  NAME_BOX_FONT = ["Trebuchet MS",Font.default_size,false]
  #Number of lines of the message window, determines the window height
  #Width of the window and the x pos of the window
  MESSAGE_WINDOW_LINES = 3
  MESSAGE_WINDOW_WIDTH = 400
  MESSAGE_WINDOW_XPOS = 30
  #Face window opacity
  NAME_WINDOW_OPACITY = 160
  NAME_WINDOW_BACK_OPACITY = 160
  #Use face window?
  USE_MESSAGE_FACE_WINDOW_SWITCH = 4
  # above switch must be on.
  USE_MESSAGE_FACE_WINDOW_SWITCH_RIGHT = 5 
  #Face window opacity
  FACE_WINDOW_OPACITY = 160
  FACE_WINDOW_BACK_OPACITY = 160
  #id of the switch that determinates if the letter sound will be played
  LETTER_SOUND_SWITCH = 3
end
#===============================================================================
# Game_Message
#===============================================================================
class Game_Message
  attr_accessor         :real_position
  attr_accessor         :letter_sound
end
#===============================================================================
# Window_Message
#===============================================================================
class Window_Message
  include TSDA
  #-----------------------------------------------------------------------------
  # initialize - overwritten method
  #-----------------------------------------------------------------------------
  def initialize
    super(MESSAGE_WINDOW_XPOS, 0, MESSAGE_WINDOW_WIDTH, window_height)
    self.z = 200
    self.openness = 0
    create_all_windows
    create_back_bitmap
    create_back_sprite
    clear_instance_variables
  end
  #-----------------------------------------------------------------------------
  # visible_line_number - overwritten method
  #-----------------------------------------------------------------------------
  def visible_line_number
    return MESSAGE_WINDOW_LINES
  end
  #-----------------------------------------------------------------------------
  # new_line_x - aliased method
  #-----------------------------------------------------------------------------
  alias ams_new_line_x new_line_x
  def new_line_x
    $game_switches[USE_MESSAGE_FACE_WINDOW_SWITCH] ? 0 : ams_new_line_x
  end
  #-----------------------------------------------------------------------------
  # obtain_escape_code - overwritten method
  #-----------------------------------------------------------------------------
  def obtain_escape_code(text)
    text.slice!(/^[\$\.\|\^!><\{\}\\]|^[A-Z]{1}/i)
  end
  #-----------------------------------------------------------------------------
  # new_page - overwritten method
  #-----------------------------------------------------------------------------
  def new_page(text, pos)
    contents.clear
    if $game_switches[USE_MESSAGE_FACE_WINDOW_SWITCH]
      if $game_switches[USE_MESSAGE_FACE_WINDOW_SWITCH_RIGHT]
        @face_window.right_face(MESSAGE_WINDOW_XPOS + MESSAGE_WINDOW_WIDTH - 120)
      end
      @face_window.set_face(self,$game_message.face_name, $game_message.face_index)
    else
      @face_window.visible = false
      draw_face($game_message.face_name, $game_message.face_index, 0, 0)
    end
    reset_font_settings
    pos[:x] = new_line_x
    pos[:y] = 0
    pos[:new_x] = new_line_x
    pos[:height] = calc_line_height(text)
    clear_flags
  end
  #-----------------------------------------------------------------------------
  # obtain_real_escape_param - new method
  #-----------------------------------------------------------------------------
  def obtain_real_escape_param(text,hex=true)
    if hex
      text.slice!(/^\[[0123456789ABCDEF#]+\]/)[/[0123456789ABCDEF#]+/] rescue nil
    else
      text.slice!(/^\[[\w\s]+\]/)[/[\w\s]+/] rescue nil
    end
  end
  #-----------------------------------------------------------------------------
  # convert_escape_characters - overwritten method
  #-----------------------------------------------------------------------------
  def convert_escape_characters(text)
    result = text.to_s.clone
    result.gsub!(/\\/)            { "\e" }
    result.gsub!(/\e\e/)          { "\\" }
    result.gsub!(/\eV\[(\d+)\]/i) { $game_variables[$1.to_i] }
    result.gsub!(/\eN\[(\d+)\]/i) { actor_name($1.to_i) }
    result.gsub!(/\eP\[(\d+)\]/i) { party_member_name($1.to_i) }
    result.gsub!(/\eG/i)          { Vocab::currency_unit }
    result.gsub!(/\eMap/i)        { $game_map.display_name }
    result
  end
  #-----------------------------------------------------------------------------
  # process_escape_character - aliased method
  #-----------------------------------------------------------------------------
  alias ams_process_escape_character process_escape_character
  def process_escape_character(code, text, pos)
    case code.upcase
    when 'C'
      param = obtain_real_escape_param(text)
      if param[0,1] == "#" and param.size == 7
        change_color(convert_to_hex(param[1,6]))
      else
        change_color(text_color(param.to_i))
      end
    when 'M'
      sw = $game_switches[AMS_LETTER_BY_LETTER_SWITCH]
      $game_switches[AMS_LETTER_BY_LETTER_SWITCH] = !sw
      @letter_by_letter_mode = $game_switches[AMS_LETTER_BY_LETTER_SWITCH]
    when 'Q'
      param = obtain_escape_param(text)
      $game_variables[AMS_SPEED_DELAY_LBL_VARIABLE] = param
      @lbl_max = $game_variables[AMS_SPEED_DELAY_LBL_VARIABLE]
    when 'W'
      sw = $game_switches[AMS_JUMP_LBL_SWITCH]
      $game_switches[AMS_JUMP_LBL_SWITCH] = !sw
      @can_jump = $game_switches[AMS_JUMP_LBL_SWITCH]
    when 'S'
      param = obtain_real_escape_param(text,false)
      @message_name_window.set_text(param,self)
    when 'R'
      @message_name_window.finish
    when 'I'
      param = obtain_real_escape_param(text)
      if param[0,1] == "#" and param.size == 7
        color = convert_to_hex(param[1,6])
      else
        color = text_color(param.to_i)
      end
      @message_name_window.font_color = color
      @message_name_window.refresh
    when 'F'
      param = obtain_real_escape_param(text,false)
      self.contents.font.name = param
    when 'L'
      self.contents.font.bold = !self.contents.font.bold
    when 'H'
      param = obtain_real_escape_param(text).to_i
      self.contents.font.size = param
    when 'X'
      self.contents.font.italic = !self.contents.font.italic
    else
      ams_process_escape_character(code, text, pos)
    end
  end
  #-----------------------------------------------------------------------------
  # convert_to_hex - new method
  #-----------------------------------------------------------------------------
  def convert_to_hex(text)
    return nil if text.size != 6
    rgb = [0,0,0]
    for index in 0...6
      letter = text.slice!(/./m)
      hex = hex_value(letter)
      if index % 2 == 0
        rgb[index / 2] += hex * 16
      else
        rgb[index / 2] += hex
      end
    end
    return Color.new(rgb[0],rgb[1],rgb[2])
  end
  #-----------------------------------------------------------------------------
  # hex_value - new method
  #-----------------------------------------------------------------------------
  def hex_value(text)
    case text
    when "0"
      return 0
    when "1"
      return 1
    when "2"
      return 2
    when "3"
      return 3
    when "4"
      return 4
    when "5"
      return 5
    when "6"
      return 6
    when "7"
      return 7
    when "8"
      return 8
    when "9"
      return 9
    when "A"
      return 10
    when "B"
      return 11
    when "C"
      return 12
    when "D"
      return 13
    when "E"
      return 14
    when "F"
      return 15
    end
  end
  #-----------------------------------------------------------------------------
  # process_all_text - aliased method
  #-----------------------------------------------------------------------------
  alias ams_process_all_text process_all_text
  def process_all_text
    @letter_by_letter_mode = $game_switches[AMS_LETTER_BY_LETTER_SWITCH]
    @lbl_max = $game_variables[AMS_SPEED_DELAY_LBL_VARIABLE]
    @can_jump = $game_switches[AMS_JUMP_LBL_SWITCH]
    ams_process_all_text
  end
  #-----------------------------------------------------------------------------
  # wait_for_one_character - overwritten method
  #-----------------------------------------------------------------------------
  def wait_for_one_character
    return if @show_fast
    if @letter_by_letter_mode
      if @can_jump
        @show_fast = true if Input.press?(:B)
        if Input.press?(:C)
          if $game_variables[AMS_SPEED_DELAY_LBL_VARIABLE] > 1
            @lbl_max = 1
          else
            @lbl_max = 0
          end
        else
          @lbl_max = $game_variables[AMS_SPEED_DELAY_LBL_VARIABLE]
        end
      end
      if @lbl_max > 0
        play_sound = $game_switches[LETTER_SOUND_SWITCH]
        Audio.se_play("Audio/SE/" + $game_message.letter_sound) if play_sound
        for time in 0...@lbl_max
          Fiber.yield
        end
      end
    end
  end
  #-----------------------------------------------------------------------------
  # update_placement - aliased method
  #-----------------------------------------------------------------------------
  alias ams_update_placement update_placement
  def update_placement
    @real_position = $game_message.real_position
    @position = $game_message.position
    if @real_position.nil?
      self.y = @position * (Graphics.height - height) / 2
    elsif @real_position.is_a?(Integer)
      self.y = @real_position
    elsif @real_position == "player"
      y = $game_player.screen_y - 48
      hei = calculate_total_component_height + 48
      if y >= hei
        self.y = $game_player.screen_y - height - 48
      else
        self.y = $game_player.screen_y
      end
    else
      param = @real_position.to_i
      event = $game_map.events[param]
      y = event.screen_y - 48
      hei = calculate_total_component_height + 48
      if y >= hei
        self.y = event.screen_y - height - 48
      else
        self.y = event.screen_y
      end
    end
    @gold_window.y = ((self.y > @gold_window.height) ? 
      0 : Graphics.height - @gold_window.height)
  end
  #-----------------------------------------------------------------------------
  # calculate_total_component_height - new method
  #-----------------------------------------------------------------------------
  def calculate_total_component_height
    h = height + calculate_extra_component_height
    h
  end
  #-----------------------------------------------------------------------------
  # calculate_extra_component_height - new method
  #-----------------------------------------------------------------------------
  def calculate_extra_component_height
    h = 0
    if $game_switches[USE_MESSAGE_FACE_WINDOW_SWITCH] and !$game_message.face_name.empty?
      h = 120
    elsif @message_name_window.visible
      h = @message_name_window.height
    end
    h
  end
  #-----------------------------------------------------------------------------
  # settings_changed? - aliased method
  #-----------------------------------------------------------------------------
  alias ams_settings_changed? settings_changed?
  def settings_changed?
    return ams_settings_changed? || 
      @real_position != $game_message.real_position
  end
  #-----------------------------------------------------------------------------
  # create_all_windows - aliased method
  #-----------------------------------------------------------------------------
  alias ams_create_all_windows create_all_windows
  def create_all_windows
    ams_create_all_windows
    @message_name_window = Window_MessageName.new
    @face_window = Window_MessageFace.new
  end
  #-----------------------------------------------------------------------------
  # dispose_all_windows - aliased method
  #-----------------------------------------------------------------------------
  alias ams_dispose_all_windows dispose_all_windows
  def dispose_all_windows
    ams_dispose_all_windows
    @message_name_window.dispose
    @face_window.dispose
  end
  #-----------------------------------------------------------------------------
  # update_all_windows - aliased method
  #-----------------------------------------------------------------------------
  alias ams_update_all_windows update_all_windows
  def update_all_windows
    ams_update_all_windows
    @message_name_window.update
    @face_window.update
  end
  #-----------------------------------------------------------------------------
  # close_and_wait - aliased method
  #-----------------------------------------------------------------------------
  alias ams_close_and_wait close_and_wait
  def close_and_wait
    @message_name_window.finish
    @face_window.finish
    ams_close_and_wait
  end
end
#===============================================================================
# Window_MessageName - new class
#===============================================================================
class Window_MessageName < Window_Base
  include TSDA
  #-----------------------------------------------------------------------------
  attr_accessor          :font_color
  #-----------------------------------------------------------------------------
  # initialize - new method
  #-----------------------------------------------------------------------------
  def initialize
    super(0,0,10,10)
    self.visible = false
    self.openness = 0
    self.back_opacity = NAME_WINDOW_BACK_OPACITY
    self.opacity = NAME_WINDOW_OPACITY
    @font_color = text_color(0)
  end
  #-----------------------------------------------------------------------------
  # set_text - new method
  #-----------------------------------------------------------------------------
  def set_text(text,window)
    @text = text
    bitmap = Bitmap.new(10,10)
    bitmap.font.name = NAME_BOX_FONT[0]
    bitmap.font.size = NAME_BOX_FONT[1]
    bitmap.font.bold = NAME_BOX_FONT[2]
    size = bitmap.text_size(text)
    self.width = size.width + 24
    self.height = size.height + 24
    self.contents = Bitmap.new(size.width,size.height)
    contents.font.name = NAME_BOX_FONT[0]
    contents.font.size = NAME_BOX_FONT[1]
    contents.font.bold = NAME_BOX_FONT[2]
    h = window.calculate_extra_component_height
    self.y = window.y > h ? window.y - height : window.y + window.height
    self.x = ($game_message.face_name.empty? or !$game_switches[USE_MESSAGE_FACE_WINDOW_SWITCH]) ? 
      window.x : window.x + 120
    self.visible = true
    refresh
    open
    Fiber.yield until open?
  end
  #-----------------------------------------------------------------------------
  # refresh - new method
  #-----------------------------------------------------------------------------
  def refresh
    contents.clear
    contents.font.color = @font_color
    contents.draw_text(0,0,width - 24,height - 24,@text)
  end
  #-----------------------------------------------------------------------------
  # finish - new method
  #-----------------------------------------------------------------------------
  def finish
    close
    until close?
      update
      Fiber.yield
    end
    self.openness = 0
    self.visible = false
  end
end
#===============================================================================
# Window_MessageFace - new class
#===============================================================================
class Window_MessageFace < Window_Base
  include TSDA
  #---------------------------------------------------------------------------
  # initialize - new method
  #---------------------------------------------------------------------------
  def initialize
    super(0,0,120,120)
    self.visible = false
    self.openness = 0
    self.back_opacity = FACE_WINDOW_BACK_OPACITY
    self.opacity = FACE_WINDOW_OPACITY
    @adjust = 0
  end
  #---------------------------------------------------------------------------
  # set_face - new method
  #---------------------------------------------------------------------------
  def set_face(window,face_name,face_index)
    self.y = window.y > 120 ? window.y - height : window.y + window.height
    if $game_switches[USE_MESSAGE_FACE_WINDOW_SWITCH_RIGHT]
      self.x = @adjust
    else
      self.x = window.x
    end
    self.visible = true
    refresh
    open
    Fiber.yield until open?
  end
  def right_face(pos=0)
    @adjust = pos
  end
  #---------------------------------------------------------------------------
  # refresh - new method
  #---------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_face($game_message.face_name, $game_message.face_index, 0, 0)
  end
  #---------------------------------------------------------------------------
  # finish - new method
  #---------------------------------------------------------------------------
  def finish
    close
    until close?
      update
      Fiber.yield
    end
    self.openness = 0
    self.visible = false
  end
end
