# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Battle Message Override ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Battle Messages        ║    12 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  none                                                    ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# ** BattleMessage
#==============================================================================

class KFBQ_BattleMessage < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @lines = 1
    super(0, 0, window_width, window_height)
    self.z = 200
    self.openness = 0
    create_back_bitmap
    create_back_sprite
    clear_instance_variables
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(visible_line_number)
  end
  #--------------------------------------------------------------------------
  # * Clear Instance Variables
  #--------------------------------------------------------------------------
  def clear_instance_variables
    @fiber = nil                # Fiber
    @background = 0             # Background type
    @position = 2               # Display position
    clear_flags
  end
  #--------------------------------------------------------------------------
  # * Clear Flag
  #--------------------------------------------------------------------------
  def clear_flags
    @show_fast = false          # Fast forward flag
    @line_show_fast = false     # Fast forward by line flag
    @pause_skip = false         # Input standby omission flag
  end
  #--------------------------------------------------------------------------
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
    return @lines
  end
  #--------------------------------------------------------------------------
  # * Set Number of Lines to Show
  #--------------------------------------------------------------------------
  def set_visible_line_number(value = 1)
    @lines = value
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    super
    dispose_back_bitmap
    dispose_back_sprite
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_back_sprite
    update_fiber
  end
  #--------------------------------------------------------------------------
  # * Update Fiber
  #--------------------------------------------------------------------------
  def update_fiber
    if @fiber
      @fiber.resume
    elsif $game_message.busy? && !$game_message.scroll_mode
      @fiber = Fiber.new { fiber_main }
      @fiber.resume
    else
      $game_message.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # * Create Background Bitmap
  #--------------------------------------------------------------------------
  def create_back_bitmap
    @back_bitmap = Bitmap.new(width, height)
    rect1 = Rect.new(0, 0, width, 12)
    rect2 = Rect.new(0, 12, width, height - 24)
    rect3 = Rect.new(0, height - 12, width, 12)
    @back_bitmap.gradient_fill_rect(rect1, back_color2, back_color1, true)
    @back_bitmap.fill_rect(rect2, back_color1)
    @back_bitmap.gradient_fill_rect(rect3, back_color1, back_color2, true)
  end
  #--------------------------------------------------------------------------
  # * Get Background Color 1
  #--------------------------------------------------------------------------
  def back_color1
    Color.new(0, 0, 0, 160)
  end
  #--------------------------------------------------------------------------
  # * Get Background Color 2
  #--------------------------------------------------------------------------
  def back_color2
    Color.new(0, 0, 0, 0)
  end
  #--------------------------------------------------------------------------
  # * Create Background Sprite
  #--------------------------------------------------------------------------
  def create_back_sprite
    @back_sprite = Sprite.new
    @back_sprite.bitmap = @back_bitmap
    @back_sprite.visible = false
    @back_sprite.z = z - 1
  end
  #--------------------------------------------------------------------------
  # * Free Background Bitmap
  #--------------------------------------------------------------------------
  def dispose_back_bitmap
    @back_bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # * Free Background Sprite
  #--------------------------------------------------------------------------
  def dispose_back_sprite
    @back_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Update Background Sprite
  #--------------------------------------------------------------------------
  def update_back_sprite
    @back_sprite.visible = (@background == 1)
    @back_sprite.y = y
    @back_sprite.opacity = openness
    @back_sprite.update
  end
  #--------------------------------------------------------------------------
  # * Main Processing of Fiber
  #--------------------------------------------------------------------------
  def fiber_main
    $game_message.visible = true
    update_background
    update_placement
    loop do
      process_all_text if $game_message.has_text?
      process_input
      $game_message.clear
      Fiber.yield
      break unless text_continue?
    end
    close_and_wait
    $game_message.visible = false
    @fiber = nil
  end
  #--------------------------------------------------------------------------
  # * Update Window Background
  #--------------------------------------------------------------------------
  def update_background
    @background = $game_message.background
    self.opacity = @background == 0 ? 255 : 0
  end
  #--------------------------------------------------------------------------
  # * Update Window Position
  #--------------------------------------------------------------------------
  def update_placement
    self.y = (Graphics.height - height - 100)
  end
  #--------------------------------------------------------------------------
  # * Process All Text
  #--------------------------------------------------------------------------
  def process_all_text
    open_and_wait
    text = convert_escape_characters($game_message.all_text)
    pos = {}
    new_page(text, pos)
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end
  #--------------------------------------------------------------------------
  # * Input Processing
  #--------------------------------------------------------------------------
  def process_input
    input_pause unless @pause_skip
  end
  #--------------------------------------------------------------------------
  # * Open Window and Wait for It to Fully Open
  #--------------------------------------------------------------------------
  def open_and_wait
    open
    Fiber.yield until open?
  end
  #--------------------------------------------------------------------------
  # * Close Window and Wait for It to Fully Close
  #--------------------------------------------------------------------------
  def close_and_wait
    close
    Fiber.yield until all_close?
  end
  #--------------------------------------------------------------------------
  # * Determine if All Windows Are Fully Closed
  #--------------------------------------------------------------------------
  def all_close?
    close?
  end
  #--------------------------------------------------------------------------
  # * Determine Whether to Continue Displaying Text 
  #--------------------------------------------------------------------------
  def text_continue?
    $game_message.has_text? && !settings_changed?
  end
  #--------------------------------------------------------------------------
  # * Determine if Background and Position Changed
  #--------------------------------------------------------------------------
  def settings_changed?
    @background != $game_message.background ||
    @position != $game_message.position
  end
  #--------------------------------------------------------------------------
  # * Wait
  #--------------------------------------------------------------------------
  def wait(duration)
    duration.times { Fiber.yield }
  end
  #--------------------------------------------------------------------------
  # * Update Fast Forward Flag
  #--------------------------------------------------------------------------
  def update_show_fast
    @show_fast = true if Input.trigger?(:C)
  end
  #--------------------------------------------------------------------------
  # * Wait After Output of One Character
  #--------------------------------------------------------------------------
  def wait_for_one_character
    update_show_fast
    Fiber.yield unless @show_fast || @line_show_fast
  end
  #--------------------------------------------------------------------------
  # * New Page
  #--------------------------------------------------------------------------
  def new_page(text, pos)
    contents.clear
    draw_face($game_message.face_name, $game_message.face_index, 0, 0)
    reset_font_settings
    pos[:x] = new_line_x
    pos[:y] = 0
    pos[:new_x] = new_line_x
    pos[:height] = calc_line_height(text)
    clear_flags
  end
  #--------------------------------------------------------------------------
  # * Get New Line Position
  #--------------------------------------------------------------------------
  def new_line_x
    $game_message.face_name.empty? ? 0 : 112
  end
  #--------------------------------------------------------------------------
  # * Normal Character Processing
  #--------------------------------------------------------------------------
  def process_normal_character(c, pos)
    super
    wait_for_one_character
  end
  #--------------------------------------------------------------------------
  # * New Line Character Processing
  #--------------------------------------------------------------------------
  def process_new_line(text, pos)
    @line_show_fast = false
    super
    if need_new_page?(text, pos)
      input_pause
      new_page(text, pos)
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if New Page Is Needed
  #--------------------------------------------------------------------------
  def need_new_page?(text, pos)
    pos[:y] + pos[:height] > contents.height && !text.empty?
  end
  #--------------------------------------------------------------------------
  # * New Page Character Processing
  #--------------------------------------------------------------------------
  def process_new_page(text, pos)
    text.slice!(/^\n/)
    input_pause
    new_page(text, pos)
  end
  #--------------------------------------------------------------------------
  # * Icon Drawing Process by Control Characters
  #--------------------------------------------------------------------------
  def process_draw_icon(icon_index, pos)
    super
    wait_for_one_character
  end
  #--------------------------------------------------------------------------
  # * Control Character Processing
  #     code : the core of the control character
  #            e.g. "C" in the case of the control character \C[1].
  #     text : character string buffer in drawing processing (destructive)
  #     pos  : draw position {:x, :y, :new_x, :height}
  #--------------------------------------------------------------------------
  def process_escape_character(code, text, pos)
    case code.upcase
    when '$'
      @gold_window.open
    when '.'
      wait(15)
    when '|'
      wait(60)
    when '!'
      input_pause
    when '>'
      @line_show_fast = true
    when '<'
      @line_show_fast = false
    when '^'
      @pause_skip = true
    else
      super
    end
  end
  #--------------------------------------------------------------------------
  # * Input Pause Processing
  #--------------------------------------------------------------------------
  def input_pause
    self.pause = true
    wait(10)
    Fiber.yield until Input.trigger?(:B) || Input.trigger?(:C)
    Input.update
    self.pause = false
  end
end
