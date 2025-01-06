# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Code Input on Title Screen             ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Allows to input a 'code' on the             ╠════════════════════╣
# ║   title screen to activate bonuses            ║    15 Feb 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Allow entering in a cheat code                               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║ Script provides the ability to input a code like you               ║
# ║  use to on old arcade games, in order to activate                  ║
# ║  bonuses or special powers.                                        ║
# ║                                                                    ║
# ║  Adjust the settings as desired for how many codes                 ║
# ║  you wish to use for your game.                                    ║
# ║  'B' cannot be used as it controls deleting entries                ║
# ║  and closing the window. This is the X on the keyboard             ║
# ║                                                                    ║
# ║  Codes must have the text in lower case not upper case             ║
# ║                                                                    ║
# ║   Name  Game pad    Keyboard          Main function                ║
# ║   A     Button 1    Shift             Dash                         ║
# ║   B     Button 2    Esc, Num 0, X     Cancel, Menu                 ║
# ║   C     Button 3    Space, Enter, Z   Confirm, OK, Enter           ║
# ║   X     Button 4    A -                                            ║
# ║   Y     Button 5    S -                                            ║
# ║   Z     Button 6    D -                                            ║
# ║   L     Button 7    Q, Page Up        Previous page                ║
# ║   R     Button 8    W, Page Down      Next page                    ║
# ║                                                                    ║
# ║   Other options are                                                ║
# ║   CTRL    ??        CTRL                                           ║
# ║   ALT     ??        ALT                                            ║
# ║   Down   down                                                      ║
# ║   Up     up                                                        ║
# ║   Left   left                                                      ║
# ║   Right  right                                                     ║
# ║                                                                    ║
# ║   More could be programmed if using a full keyboard input script   ║
# ║   this script does not account for keyboard input scripts.         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 15 Feb 2021 - Script finished                               ║
# ║ 1.01 - 15 Feb 2021 - Added block codes if continue                 ║
# ║ 1.02 - 16 Feb 2021 - Added option to hide code in menu             ║
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

module R2_BONUS_CODES

	# Codes for cheats/bonuses. 
  # Leave empty if not using that code. I.E. :code# = [""]
	# Add more as you desire
  # each code matches to the switches listed below
	CHEATCODES = {
  :code1 => ["up","up","down","down","left","left","right","right","x","y"],
  :code2 => ["left","left","down","left","right","right","z","x"],
  :code3 => ["up","l","down","r","up","left","down","right","r","l","y"],
  :code4 => [""],
	}

  # add more switches as you add more codes.
  # set to 0 to not use that code
  # [switch 5, switch 6, switch 7, switch 0]
  CODE_SWITCHES = [5, 6, 7, 0]
  
	# Sounds for codes
  BAD = "Buzzer1"		# wrong code entry
  BTN = "Knock"			# Button pressed
  CODE = "Load"		  # Code complete
	
  CONTINUE = false # if a save file is present, code entry is blocked when true
  HIDE_COMMAND = false # true will hide the command in the title menu
  # then use F8 to open the code screen, F7 to back space and close
end 

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

#######################################################################
# * Window CodeCommand
#######################################################################

class Window_CodeCommand < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @inputed_code = []
    @pos = 0
  end
  #--------------------------------------------------------------------------
  # * Process handling
  #--------------------------------------------------------------------------
  def process_handling
    if R2_BONUS_CODES::HIDE_COMMAND
      process_back if Input.repeat?(:F7)
    else
      process_back if Input.repeat?(:B)
    end
  end
  #--------------------------------------------------------------------------
  # * Process delete input / go back one
  #--------------------------------------------------------------------------
  def process_back
    if @pos == 0
      call_cancel_handler
    else
      @inputed_code.pop
      @pos -= 1
    end
  end
  #--------------------------------------------------------------------------
  # * Call cancel to close window
  #--------------------------------------------------------------------------
  def call_cancel_handler
    call_handler(:cancel)
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    @sprite.dispose if @sprite
    return unless @inputed_code != []
    @sprite = Sprite.new
    @sprite.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprite.z = 400
    rect = Rect.new(10, y+10, Graphics.width - 20, line_height)
    result = @inputed_code.to_s.clone
    result.gsub!(/\"/)  { "" }
    result.gsub!(/\[/)  { "" }
    result.gsub!(/\]/)  { "" }
    text = result
    @sprite.bitmap.font.size = 24
    @sprite.bitmap.draw_text(rect, text) 
  end
  #--------------------------------------------------------------------------
  # * Reset window
  #--------------------------------------------------------------------------
  def reset
    @inputed_code = []
    @pos = 0
  end
  #--------------------------------------------------------------------------
  # * Display Input
  #--------------------------------------------------------------------------
  def dis_input(word)
    case word
    when "down"
      @inputed_code[@pos] = "Down"
      @pos += 1
    when "left"
      @inputed_code[@pos] = "Left"
      @pos += 1
    when "right"
      @inputed_code[@pos] = "Right"
      @pos += 1
    when "up"
      @inputed_code[@pos] = "Up"
      @pos += 1
    when "a"
      @inputed_code[@pos] = "A"
      @pos += 1
    when "b"
      if R2_BONUS_CODES::HIDE_COMMAND
        @inputed_code[@pos] = "B"
        @pos += 1
      else 
        process_handling
      end
    when "c"
      @inputed_code[@pos] = "C"
      @pos += 1
    when "x"
      @inputed_code[@pos] = "X"
      @pos += 1
    when "y"
      @inputed_code[@pos] = "Y"
      @pos += 1
    when "z"
      @inputed_code[@pos] = "Z"
      @pos += 1
    when "l"
      @inputed_code[@pos] = "L"
      @pos += 1
    when "r"
      @inputed_code[@pos] = "R"
      @pos += 1
    when "ctrl"
      @inputed_code[@pos] = "Ctrl"
      @pos += 1
    when "alt"
      @inputed_code[@pos] = "Alt"
      @pos += 1
    when "f7"
      process_handling if R2_BONUS_CODES::HIDE_COMMAND
    end
  end
end

#######################################################################
# * Add title command for codes
#######################################################################
class Window_TitleCommand < Window_Command
  def make_command_list
    codes = R2_BONUS_CODES::CONTINUE ? !continue_enabled : true
    add_command(Vocab::new_game, :new_game)
    add_command(Vocab::continue, :continue, continue_enabled)
    add_command(Vocab::shutdown, :shutdown)
    add_command("Enter Codes", :bonus_code, codes) unless R2_BONUS_CODES::HIDE_COMMAND
  end
end

#######################################################################
# * Scene Title
#######################################################################
class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
	alias r2_bonus_code_start	start
  def start
    r2_bonus_code_start
    @r2_btn_press = 0
    @temp_count = 0
		@cheatcodes = []
    @linecode = []
    for i in 0..R2_BONUS_CODES::CHEATCODES.size - 1
      @cheatcodes.push(false)
      @linecode.push(true)
    end
    create_code_window
		@enter_code = false
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_TitleCommand.new
    @command_window.set_handler(:new_game, method(:command_new_game))
    @command_window.set_handler(:continue, method(:command_continue))
    @command_window.set_handler(:shutdown, method(:command_shutdown))
    @command_window.set_handler(:bonus_code, method(:command_bonus_code)) unless R2_BONUS_CODES::HIDE_COMMAND
  end
  #--------------------------------------------------------------------------
  # * Create Code Window
  #--------------------------------------------------------------------------
  def create_code_window
    @code_window = Window_CodeCommand.new(0, 160, Graphics.width, 48)
    @code_window.viewport = @viewport
    @code_window.x = 0
    @code_window.y = Graphics.height / 2 - 50
    @code_window.hide
    @code_window.set_handler(:cancel,    method(:close_code_window))
  end
  #--------------------------------------------------------------------------
  # * Close Code Window
  #--------------------------------------------------------------------------
  def close_code_window
    @code_window.deactivate
    @code_window.hide
    @command_window.activate
    for i in 0..R2_BONUS_CODES::CHEATCODES.size - 1
      @linecode[i] = true if @linecode[i] == false
    end
		@enter_code = false
  end
  #--------------------------------------------------------------------------
  # * [New Game] Command
  #--------------------------------------------------------------------------
  def command_new_game
    DataManager.setup_new_game
    close_command_window
    fadeout_all
    $game_map.autoplay
    SceneManager.goto(Scene_Map)
    check_bonus
  end
  #--------------------------------------------------------------------------
  # * Activate switches
  #--------------------------------------------------------------------------
  def check_bonus
    R2_BONUS_CODES::CODE_SWITCHES.each_with_index { |code, i|
      next if code == 0
      if @cheatcodes[i] == true
        $game_switches[R2_BONUS_CODES::CODE_SWITCHES[i]] = true 
      end
    }
  end
  #--------------------------------------------------------------------------
  # * Show code window
  #--------------------------------------------------------------------------
  def command_bonus_code
    @code_window.show
    @code_window.activate
    max_length
		@enter_code = true
    @command_window.deactivate
  end
  #--------------------------------------------------------------------------
  # * Show code window
  #--------------------------------------------------------------------------
  def max_length
    @max_length = 0
		R2_BONUS_CODES::CHEATCODES.each_with_index do |code_hash, c|
			code = code_hash[1]
      code.each_with_index do | step, i |
        @max_length = code.length if (@max_length < code.length)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Wait to slow player input
  #--------------------------------------------------------------------------
  def wait(duration)
    count = 0
    duration.times { count += 1}
    return
  end
  #--------------------------------------------------------------------------
  # * Alias Update 
  #--------------------------------------------------------------------------
	alias r2_bonus_code_update	update
  def update
    r2_bonus_code_update
    if R2_BONUS_CODES::HIDE_COMMAND
      command_bonus_code if Input.trigger?(:F8)
    end
    btn = triggered if @enter_code
    return if btn == nil
    RPG::SE.new(R2_BONUS_CODES::BTN).play
    wait(30) # wait between player input
    climb = false
    @r2_btn_press -= 1 if btn == "b" 
    @r2_btn_press -= 1 if btn == "f7"
    @temp_count -= 1 if btn == "b"
    @temp_count -= 1 if btn == "f7"
    @code_window.reset if @r2_btn_press == -1
    @r2_btn_press = 0 if @r2_btn_press <= 0
    @temp_count = 0 if @temp_count <= 0
    if @r2_btn_press == 0
      for i in 0..R2_BONUS_CODES::CHEATCODES.size - 1
        @linecode[i] = true if @linecode[i] == false
      end
    end
		R2_BONUS_CODES::CHEATCODES.each_with_index do |code_hash, c|
      for line in code_hash
        next unless @linecode[c] == true
      end
			code = code_hash[1]
      code.each_with_index do | step, i |
        if (@r2_btn_press == i) && (btn == code[@r2_btn_press])
          climb = true
          if @r2_btn_press == code.length - 1
            @cheatcodes[c] = true
            RPG::SE.new(R2_BONUS_CODES::CODE).play
            reset
            for r in 0..R2_BONUS_CODES::CHEATCODES.size - 1
              @linecode[r] = true if @linecode[r] == false
            end
          end
        elsif (btn != code[@r2_btn_press])
          @linecode[c] = false
          if @temp_count > @max_length
            RPG::SE.new(R2_BONUS_CODES::BAD).play
            reset
          end
        end
      end
    end
    @temp_count += 1
    @r2_btn_press += 1 if climb == true
    code_count = 0
    @linecode.each do |b|
      if b == true
        code_count += 1
      end
    end
    if code_count == 0 && @r2_btn_press == 0
      @code_window.reset
      for i in 0..R2_BONUS_CODES::CHEATCODES.size - 1
        @linecode[i] = true if @linecode[i] == false
      end
      @temp_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Reset - set values to 0
  #--------------------------------------------------------------------------
  def reset
    @code_window.reset
    @r2_btn_press = 0
    @temp_count = 0
  end
  #--------------------------------------------------------------------------
  # * Triggered - to check player input
  #--------------------------------------------------------------------------
  def triggered
    case true
    when Input.trigger?(:DOWN)
      @code_window.dis_input("down")
      return "down"
    when Input.trigger?(:LEFT)
      @code_window.dis_input("left")
      return "left"
    when Input.trigger?(:RIGHT)
      @code_window.dis_input("right")
      return "right"
    when Input.trigger?(:UP)
      @code_window.dis_input("up")
      return "up"
    when Input.trigger?(:A)
      @code_window.dis_input("a")
      return "a"
    when Input.trigger?(:B)
      @code_window.dis_input("b")
      return "b"
    when Input.trigger?(:C)
      @code_window.dis_input("c")
      return "c"
    when Input.trigger?(:X)
      @code_window.dis_input("x")
      return "x"
    when Input.trigger?(:Y)
      @code_window.dis_input("y")
      return "y"
    when Input.trigger?(:Z)
      @code_window.dis_input("z")
      return "z"
    when Input.trigger?(:L)
      @code_window.dis_input("l")
      return "l"
    when Input.trigger?(:R)
      @code_window.dis_input("r")
      return "r"
    when Input.trigger?(:CTRL)
      @code_window.dis_input("ctrl")
      return "ctrl"
    when Input.trigger?(:ALT)
      @code_window.dis_input("alt")
      return "alt"
    when Input.trigger?(:F7)
      @code_window.dis_input("f7")
    end
  end
end
