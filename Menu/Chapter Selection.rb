# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Chapter Selection                      ║  Version: 1.03     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Allows to perform a chapter                 ╠════════════════════╣
# ║   selection                                   ║    15 Feb 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Provide a Chapter Selection scene                            ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Script calls:                                                    ║
# ║     chapter_unlock(id)                                             ║
# ║       id = the chapter to unlock. Chapter 1 = 0                    ║
# ║          it is presumed that you will call this                    ║
# ║          command when the previous chapter is finished             ║
# ║     load_chapter(id)                                               ║
# ║       just simply load a chapter.                                  ║
# ║       doesn't have to be unlocked                                  ║
# ║     start_new_chapter                                              ║
# ║       calls the chapter select menu                                ║
# ║                                                                    ║
# ║   Pu in your desired words and image names below                   ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.03 - 20 Feb 2022 - Added fadeout - returning to title            ║
# ║ 1.02 - 18 Feb 2022 - Configured for 640 x 480 screen               ║
# ║ 										 Added more control options.                   ║
# ║ 1.01 - 16 Feb 2022 - minor additions                               ║
# ║ 1.00 - 16 Feb 2022 - Script finished                               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Whotfisjojo                                                      ║
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

module R2_Chapter_Select
  
  # background image for the scene
  Background = ""
  
	
  # Switch used temporarily to control exiting the menu 
  # * required - but used internally. do not change in game.
  Control_Switch = 3
	
  
  # file where chapter data writened below is saved
  Chapter_Save_File = "Chapters.rvdata2"
  
  # name of image to use for locked chapters
  Locked = "Locked"
  # Text to display in description when chapter locked
  Locked_Text = "Locked"

  
  # text to be displayed on the chapter select screen
  Title_Text = "Select an Episode"
  # Set font size for title text
  Title_Font = 48
  # position adjustment for centering
  Title_X = 160

  
	# Arrows
  # set to false to not use arrows
  Arrows = false
  # Right Arrow for moving right
  Right_Arrow = "Right_Arrow"
  # Left arrow for moving left
  Left_Arrow = "Left_Arrow"
  # set to false to not use text for the left and right direction
  Arrows_Text = true
  # Right text for moving right
  Right_Text = "->"
  # Left text for moving left
  Left_Text = "<-"
  # variable used to pass index position to the other window for draing text
  Arrow_Var = 2
  # Set font size for text. When using the <- -> for the arrows
  Arrow_Font = 24
  # Right text position for moving right
  Right_Arrow_X = 580 # 485 for 544 screen
  Right_Arrow_Y = 170
  # Left text for position moving left
  Left_Arrow_X = 10
  Left_Arrow_Y = 170
  
 
  # Chapter image window
  # set how many rows to show on the screen
  Column_Max = 5
  # adjusts based on other numbers
  Chapter_Window_Height = 100  # Graphics.height - value # 50 for 416 height
  # adjusts based on other numbers
  Chapter_Window_X = 45 
  Chapter_Window_Y = 90
  # Window padding. push everthing more inside
  Window_Padding = 16
  # Position of chapter images. hard coded formula will need 
  # to be changed if using different sized images
  Image_Base_X = 18
  Image_Base_Y = 100
  Image_Base_Adjust = 3
  # Determine the Y position of the text under the chapter image
  Chapter_Text_X = 90
  Chapter_Text_Y = 180
  # Window width to show chapter images
  Chapter_Width = 90  # Graphics.width - 100
  Chapter_Height = 220 # Graphics.height - 220
  
  
  # turn line drawn off
  Lines_Off = false
  # Move line drawn on the bottom
  Line_Y = 140  # Graphics.height - 140 # 90 for 416 height
  

	# Help window
  # set to false to not use marker
  Help_Window_Height = 100  # 2 rows in 416 height, 4 rows in 480 height
  # number of description lines to use
  Help_Lines = 4 # 2 for 416 height, 4 for 480 height


	# last mark image
  # set to false to not use marker
  Last_Marker = true
  # Determine y position of last mark image
  Last_Mark_Y = 120
  # Determine the OFFSET of the X position
  Last_Mark_X = 0
  # image used to indicate what chapter was played last
  Last_Image = "Battle_Cursor"
	# adjust value to position mark
  Last_Mark_Adjust = 140
  
	
	# cursor
  # Width of selection cursor
  Select_Width = 95
  # Height of selection cursor
  Select_Height = 220
  # Space between cursor selections
  Spacing = 10
  
	
  # Chapter data
  Chapters = { 
              0 => {
                    :title => "Part 1",
                    :image => "Chapter_1",
                    :location => [1,5,5], # [ map id, x, y ]
                    :locked => false,     # show chapter image or - blank (true)
                    :last => true,        # last chapter accessed
                    :description => 
      "The first chapter in your journey. Welcome adventurer" + "\n" +
      "Your quest is to find the crown and finish the race" + "\n" +
      "Larger screen means larger description text" + "\n" +
      "What can you fill in here to give the player info?",
                    },
              1 => {
                    :title => "Part 2",
                    :image => "Chapter_2",
                    :location => [2,5,5],
                    :locked => true,
                    :last => false,
                    :description => 
      "The second chapter in your journey. Welcome to the adventure" + "\n" +
      "Your quest is to find the item and proceed to the next chapter",
                    },
              2 => {
                    :title => "Part 3",
                    :image => "Chapter_3",
                    :location => [1,5,5],
                    :locked => true,
                    :last => false,
                    :description => 
      "The third chapter in your journey. Welcome to the adventure" + "\n" +
      "Your quest is to find the thing and proceed to the next chapter",
                    },
              3 => {
                    :title => "Part 4",
                    :image => "Chapter_4",
                    :location => [1,5,5],
                    :locked => true,
                    :last => false,
                    :description => 
      "The fourth chapter in your journey. Welcome to the adventure" + "\n" +
      "Your quest is to find the herb and proceed to the next chapter",
                    },
              4 => {
                    :title => "Part 5",
                    :image => "Chapter_5",
                    :location => [1,5,5],
                    :locked => true,
                    :last => false,
                    :description => 
      "The fifth chapter in your journey. Welcome to the adventure" + "\n" +
      "Your quest is to find the mouse and proceed to the next chapter",
                    },
              5 => {
                    :title => "Part 6",
                    :image => "Chapter_6",
                    :location => [1,5,5],
                    :locked => true,
                    :last => false,
                    :description => 
      "The first chapter in your journey. Welcome to the adventure" + "\n" +
      "Your quest is to find the crown and proceed to the next chapter",
                    },
              6 => {
                    :title => "Part 7",
                    :image => "Chapter_7",
                    :location => [1,5,5],
                    :locked => true,
                    :last => false,
                    :description => 
      "The first chapter in your journey. Welcome to the adventure" + "\n" +
      "Your quest is to find the crown and proceed to the next chapter",
                    },
              7 => {
                    :title => "Part 8",
                    :image => "Chapter_8",
                    :location => [1,5,5],
                    :locked => true,
                    :last => false,
                    :description => 
      "The first chapter in your journey. Welcome to the adventure" + "\n" +
      "Your quest is to find the crown and proceed to the next chapter",
                    },
              8 => {
                    :title => "Part 9",
                    :image => "Chapter_9",
                    :location => [1,5,5],
                    :locked => true,
                    :last => false,
                    :description => 
      "The first chapter in your journey. Welcome to the adventure" + "\n" +
      "Your quest is to find the crown and proceed to the next chapter",
                    },
              9 => {
                    :title => "Part 10",
                    :image => "Chapter_10",
                    :location => [1,5,5],
                    :locked => true,
                    :last => false,
                    :description => 
      "The first chapter in your journey. Welcome to the adventure" + "\n" +
      "Your quest is to find the crown and proceed to the next chapter",
                    }
              }
end
# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝


module DataManager
  
  class << self  
    alias r2_chapter create_game_objects
    alias r2_load_chapter extract_save_contents
    alias r2_save_chapter make_save_contents
  end

  def self.make_save_contents
    r2chapterdata = r2_save_chapter
    r2chapterdata[:chapters] = $chapter_data
    r2chapterdata
  end
  
  def self.extract_save_contents(contents)
    r2_load_chapter(contents)
    $chapter_data = contents[:chapters]
  end

  def self.save_chapter
    filename = R2_Chapter_Select::Chapter_Save_File
    File.open(filename, "wb") do |file|
      Marshal.dump(make_save_contents, file)
    end
    return true
  end
  
  def self.load_chapter
    filename = R2_Chapter_Select::Chapter_Save_File
    File.open(filename, "rb") do |file|
      extract_save_contents(Marshal.load(file))
    end
    return true
  end

  def self.create_game_objects
    r2_chapter
    $chapter_data = Game_Chapters.new
    load_chapter if File.exist?(R2_Chapter_Select::Chapter_Save_File)
  end

  def self.setup_chapter(id)
    load_chapter if File.exist?(R2_Chapter_Select::Chapter_Save_File)
    for i in 0..$chapter_data.chapter_info.size-1
      if i == id
        $chapter_data.chapter_info[i][:last] = true
      else
        $chapter_data.chapter_info[i][:last] = false
      end
    end
    map = $chapter_data.chapter_info[id][:location][0]
    x   = $chapter_data.chapter_info[id][:location][1]
    y   = $chapter_data.chapter_info[id][:location][2]
    $game_player.reserve_transfer(map, x, y)
    $game_player.perform_transfer
    $game_player.refresh
    Graphics.frame_count = 0
    save_chapter
  end

end

class Game_Interpreter
  def chapter_unlock(id)
    $chapter_data.chapter_info[id][:locked] = false
    DataManager.save_chapter
  end
  def load_chapter(id)
    command_221
    DataManager.setup_chapter(id)
    command_222
  end
  def start_new_chapter
    SceneManager.call(Scene_Chapter)
  end
end

class Game_Chapters
  attr_accessor :id
  attr_accessor :chapter_info
  def initialize
    @id = 0
    @chapter_info = R2_Chapter_Select::Chapters
  end
end

class Window_Chapter_Back < Window_Base
  def initialize
    super(0, 0, Graphics.width, Graphics.height)
    if (R2_Chapter_Select::Arrows == false) && (R2_Chapter_Select::Arrow_Var == 0)
      draw_lines
      draw_title
    end
  end
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(0, line_y, contents_width, 2, line_color)
  end
  def line_color
    color = normal_color
    color.alpha = 100
    color
  end
  def draw_title
    contents.font.size = R2_Chapter_Select::Title_Font
    contents.font.bold = true
    @text = R2_Chapter_Select::Title_Text
    draw_text(0, 10, Graphics.width, 68, @text, 1)
    contents.font.size = Font.default_size
    contents.font.bold = false
  end
  def draw_lines
    return if R2_Chapter_Select::Lines_Off == true
    draw_horz_line(Graphics.height - R2_Chapter_Select::Line_Y)
    draw_horz_line(Graphics.height - R2_Chapter_Select::Line_Y + 1)
    draw_horz_line(58);    draw_horz_line(59)
    draw_horz_line(5);    draw_horz_line(4)
  end
  def draw_direction
    contents.font.size = R2_Chapter_Select::Arrow_Font
    contents.font.bold = true
    l_x = R2_Chapter_Select::Left_Arrow_X
    l_y = R2_Chapter_Select::Left_Arrow_Y
    r_x = R2_Chapter_Select::Right_Arrow_X
    r_y = R2_Chapter_Select::Right_Arrow_Y
    @text = ""
    if @index > 0
      @text = R2_Chapter_Select::Left_Text
    end
    draw_text(l_x, l_y, 40, 100, @text, 1)
    @text = ""
    if @index < $chapter_data.chapter_info.size - 1
      @text = R2_Chapter_Select::Right_Text
    end
    draw_text(r_x, r_y, 40, 100, @text, 1)
    contents.font.size = Font.default_size
    contents.font.bold = false
  end
  alias r2_chapter_update update
  def update
    r2_chapter_update
    return if R2_Chapter_Select::Arrow_Var == 0
    if $game_variables[R2_Chapter_Select::Arrow_Var] != @index
      @index = $game_variables[R2_Chapter_Select::Arrow_Var]
      contents.clear if R2_Chapter_Select::Arrow_Var > 0
      draw_title
      draw_lines
      draw_direction if R2_Chapter_Select::Arrows_Text == true
    end
  end
end

class Window_ChapterHelp < Window_Base
  def initialize(line_number = R2_Chapter_Select::Help_Lines)
    super(0, 0, Graphics.width, fitting_height(line_number))
  end
  def set_text(text)
    if text != @text
      @text = text
      refresh
    end
  end
  def clear
    set_text("")
  end
  def set_item(item)
    set_text(item ? item.description : "")
  end
  def refresh
    contents.clear
    draw_text_ex(4, 0, @text)
  end
end

class Window_Chapter_Choose < Window_Selectable
  def initialize
    super(window_x,window_y, window_width, window_height)
    if R2_Chapter_Select::Column_Max == 4
      @ch_sh = [0, 1, 2, 3] # chapter shown
    else 
      @ch_sh = [0, 1, 2, 3, 4] # chapter shown
    end
    @chap_image = []
    @text = []
    @place = 0
    @index_pos = 0
    @index = 0
    create_help_window
    update_pictures
    self.z = 101
    select(0)
    activate
  end
  def window_x
    return R2_Chapter_Select::Chapter_Window_X
  end
  def window_y
    return R2_Chapter_Select::Chapter_Window_Y
  end
  def window_width
    return Graphics.width - R2_Chapter_Select::Chapter_Width
  end
  def window_height
    return Graphics.height - R2_Chapter_Select::Chapter_Height
  end
  def col_max
    return R2_Chapter_Select::Column_Max
  end
  def spacing
    return R2_Chapter_Select::Spacing
  end
  def item_max
    return $chapter_data.chapter_info.size
  end
  def item_width
    return R2_Chapter_Select::Select_Width
  end
  def item_height
    return R2_Chapter_Select::Select_Height
  end
  def row_max
    return 1
  end
  def standard_padding
    return R2_Chapter_Select::Window_Padding
  end
  def create_help_window
    @help_window = Window_ChapterHelp.new
    @help_window.y = Graphics.height - @help_window.height + 4
    @help_window.opacity = 0
  end
  def show_chapters
    @ch_sh.each_with_index do |i, j|
      if $chapter_data.chapter_info[i][:locked] == true
        image = R2_Chapter_Select::Locked
      else
        image = $chapter_data.chapter_info[i][:image]
      end
      draw_image(image, i, j)
      @text = $chapter_data.chapter_info[i][:title]
      draw_chapter_title(j, @text)
    end
  end
  def draw_chapter_title(j, text)
    rect = Rect.new
    r_x = R2_Chapter_Select::Chapter_Text_X
    r_y = R2_Chapter_Select::Chapter_Text_Y
    rect.width = r_x
    rect.height = 40
    rect.x = (r_x * j) + (j * standard_padding / 2) + j * 8
    rect.y = r_y
    draw_text(rect.x, rect.y, rect.width, rect.height, text, 1)
  end
  def update_pictures
    contents.clear
    clear_image
    if @index == 0
      if R2_Chapter_Select::Column_Max == 5
        @ch_sh = [0, 1, 2, 3, 4]
      else
        @ch_sh = [0, 1, 2, 3]
      end
    elsif @index == $chapter_data.chapter_info.size - 1
      max = $chapter_data.chapter_info.size.to_i - 1
      last = max
      sndlast = max - 1
      thrlast = max - 2
      frthlast = max - 3
      ffthlast = max - 4
      if R2_Chapter_Select::Column_Max == 5
        @ch_sh = [ffthlast, frthlast, thrlast, sndlast, last]
      else
        @ch_sh = [frthlast, thrlast, sndlast, last]
      end
    elsif (@index > 0) && (@index < $chapter_data.chapter_info.size) && (@index < @ch_sh[0])
      if R2_Chapter_Select::Column_Max == 5
        max = @ch_sh[4].to_i
      else
        max = @ch_sh[3].to_i
      end
      last = max - 1
      sndlast = max - 2
      thrlast = max - 3
      frthlast = max - 4
      ffthlast = max - 5
      if R2_Chapter_Select::Column_Max == 5
        @ch_sh = [ffthlast, frthlast, thrlast, sndlast, last]
      else
        @ch_sh = [frthlast, thrlast, sndlast, last]
      end
    else
      if R2_Chapter_Select::Column_Max == 5
        if (@index > 4) && (@index < $chapter_data.chapter_info.size - 1) && (@index > @ch_sh[4]) 
          max = @ch_sh[4].to_i
          last = max + 1
          sndlast = max
          thrlast = max - 1
          frthlast = max - 2
          ffthlast = max - 3
          @ch_sh = [ffthlast, frthlast, thrlast, sndlast, last]
        end
      else
        if (@index > 3) && (@index < $chapter_data.chapter_info.size - 1) && (@index > @ch_sh[3])
          max = @ch_sh[3].to_i
          last = max + 1
          sndlast = max
          thrlast = max - 1
          frthlast = max - 2
          @ch_sh = [frthlast, thrlast, sndlast, last]
        end
      end
    end
    show_arrows
    show_chapters
    show_last
  end
  def draw_image(file, i, j)
    @chap_image[i] = Sprite.new
    @chap_image[i].bitmap = Cache.system(file)
    i_x = R2_Chapter_Select::Image_Base_X
    i_y = R2_Chapter_Select::Image_Base_Y
    i_a = R2_Chapter_Select::Image_Base_Adjust
    i_w = R2_Chapter_Select::Chapter_Window_X
    case j
    when 0
      @chap_image[i].x = i_x + i_w + j * 106 + i_a * j - j * 4 # 68
      @chap_image[i].y = i_y + standard_padding / 2
    when 1
      @chap_image[i].x = i_x + i_w + j * 106 + i_a * j - j * 4 # 172
      @chap_image[i].y = i_y + standard_padding / 2
    when 2
      @chap_image[i].x = i_x + i_w + j * 106 + i_a * j - j * 4 # 278
      @chap_image[i].y = i_y + standard_padding / 2
    when 3
      @chap_image[i].x = i_x + i_w + j * 106 + i_a * j - j * 4 # 384
      @chap_image[i].y = i_y + standard_padding / 2
    when 4
      @chap_image[i].x = i_x + i_w + j * 106 + i_a * j - j * 4 # 490
      @chap_image[i].y = i_y + standard_padding / 2
    end
    @chap_image[i].z = 102
  end
  def show_arrows
    $game_variables[R2_Chapter_Select::Arrow_Var] = @index
    if @index > 0
      draw_left
    else
      clear_left
    end
    if @index < $chapter_data.chapter_info.size - 1
      draw_right
    else
      clear_right
    end
  end
  def show_last
    return if R2_Chapter_Select::Last_Marker == false
    @last_mark = Sprite.new
    @last_mark.bitmap = Cache.system(R2_Chapter_Select::Last_Image)
    m_x = R2_Chapter_Select::Chapter_Text_X
		m_a = R2_Chapter_Select::Last_Mark_Adjust
    @last_mark.x = -200
    @ch_sh.each_with_index do |d, m|
      @last_mark.x = m * m_x + m_a if $chapter_data.chapter_info[d][:last] == true
    end
    @last_mark.y = R2_Chapter_Select::Last_Mark_Y
    @last_mark.z = 111
  end
  def draw_left
    return if R2_Chapter_Select::Arrows == false
    @l_arrow = Sprite.new
    @l_arrow.bitmap = Cache.system(R2_Chapter_Select::Left_Arrow)
    @l_arrow.x = R2_Chapter_Select::Left_X
    @l_arrow.y = R2_Chapter_Select::Left_Y
    @l_arrow.z = 110
  end
  def draw_right
    return if R2_Chapter_Select::Arrows == false
    @r_arrow = Sprite.new
    @r_arrow.bitmap = Cache.system(R2_Chapter_Select::Right_Arrow)
    @r_arrow.x = R2_Chapter_Select::Right_X
    @r_arrow.y = R2_Chapter_Select::Right_Y
    @r_arrow.z = 110
  end
  def clear_left
    return if @l_arrow.nil?
    @l_arrow.bitmap.dispose
    @l_arrow.dispose
  end
  def clear_right
    return if @r_arrow.nil?
    @r_arrow.bitmap.dispose
    @r_arrow.dispose
  end
  def clear_image
    for i in 0..@chap_image.size - 1
      next if @chap_image[i].nil?
      @chap_image[i].bitmap.dispose
      @chap_image[i].dispose
    end
    @help_window.set_text("")
    @r_arrow.bitmap.dispose if @r_arrow
    @r_arrow.dispose if @r_arrow
    @l_arrow.bitmap.dispose if @l_arrow
    @l_arrow.dispose if @l_arrow
    @last_mark.bitmap.dispose if @last_mark
    @last_mark.dispose if @last_mark
  end
  def terminate
    super
    for i in 0..@chap_image.size - 1
      next if @chap_image[i].nil?
      @chap_image[i].bitmap.dispose
      @chap_image[i].dispose
      @text[i].dispose if @text[i]
    end
    @r_arrow.bitmap.dispose if @r_arrow
    @r_arrow.dispose if @r_arrow
    @l_arrow.bitmap.dispose if @l_arrow
    @l_arrow.dispose if @l_arrow
    @last_mark.bitmap.dispose
    @last_mark.dispose
  end
  def cursor_down(wrap = false)
  end
  def cursor_up(wrap = false)
  end
  def cursor_pagedown
  end
  def cursor_pageup
  end
  def cursor_right(wrap = false)
    if col_max >= 2 && (index < item_max - 1 || (wrap && horizontal?))
      @index_pos = ((index + 1) % item_max)
      if R2_Chapter_Select::Column_Max == 5
        if (@index_pos > 4) && (@index_pos < ($chapter_data.chapter_info.size)) && (@place == 4)
          select(4)
          @place = 4
        elsif (@index_pos > 0) && (@index_pos < ($chapter_data.chapter_info.size - 1)) && (@place < 4)
          @place += 1
          select(@place)
        elsif (@index_pos > 0) && (@index_pos == ($chapter_data.chapter_info.size - 1)) && (@place == 4)
          @place = 0
          select(@place)
        elsif (@index_pos == ($chapter_data.chapter_info.size - 1)) && (@place < 4)
          select(4)
          @place = 4
        elsif (@index_pos == 0) && (@place == 4)
          @place = 0
          select(@place)
        else
          select(@place)
        end
      else
        if (@index_pos > 3) && (@index_pos < ($chapter_data.chapter_info.size)) && (@place == 3)
          select(3)
          @place = 3
        elsif (@index_pos > 0) && (@index_pos < ($chapter_data.chapter_info.size - 1)) && (@place < 3)
          @place += 1
          select(@place)
        elsif (@index_pos > 0) && (@index_pos == ($chapter_data.chapter_info.size - 1)) && (@place == 3)
          @place = 0
          select(@place)
        elsif (@index_pos == ($chapter_data.chapter_info.size - 1)) && (@place < 3)
          select(3)
          @place = 3
        elsif (@index_pos == 0) && (@place == 3)
          @place = 0
          select(@place)
        else
          select(@place)
        end
      end
      @index = @index_pos
    end
    update_pictures
  end
  def cursor_left(wrap = false)
    if col_max >= 2 && (index > 0 || (wrap && horizontal?))
      @index_pos = (index - 1 + item_max) % item_max
      if (@index_pos > 0) && (@index_pos < ($chapter_data.chapter_info.size - 1)) && (@place == 0)
        select(0)
        @place = 0
      elsif (@index_pos > 0) && (@index_pos < ($chapter_data.chapter_info.size - 1)) && (@place > 0)
        @place -= 1
        select(@place)
      elsif (@index_pos == 0) && (@place == 0)
        @place = 0
        select(@place)
      elsif (@index_pos == 0) && (@place > 0)
        @place = 0
        select(@place)
      elsif (@index_pos == ($chapter_data.chapter_info.size - 1)) && (@place == 0) && R2_Chapter_Select::Column_Max == 5
        @place = 4
        select(@place)
      elsif (@index_pos == ($chapter_data.chapter_info.size - 1)) && (@place == 0)
        @place = 3
        select(@place)
      else
        @place -= 1 unless @index_pos == 0 || @place == 0
        select(@place)
      end
      @index = @index_pos
    end
    update_pictures
  end
  def process_cursor_move
    return unless cursor_movable?
    last_index = @index
    cursor_down (Input.trigger?(:DOWN))  if Input.repeat?(:RIGHT)
    cursor_up   (Input.trigger?(:UP))    if Input.repeat?(:LEFT)
    cursor_right(Input.trigger?(:RIGHT)) if Input.repeat?(:RIGHT)
    cursor_left (Input.trigger?(:LEFT))  if Input.repeat?(:LEFT)
    Sound.play_cursor if @index != last_index
    if @index <= 0
      @index = 0
    elsif @index >= $chapter_data.chapter_info.size
      @index = $chapter_data.chapter_info.size
    end
    if $chapter_data.chapter_info[@index][:locked] == true
      @help_window.set_text(R2_Chapter_Select::Locked_Text)
    else
      @help_window.set_text($chapter_data.chapter_info[@index][:description])
    end
  end
end

class Scene_Title < Scene_Base
  def command_new_game
      DataManager.setup_new_game
      close_command_window
      fadeout_all
      $game_switches[R2_Chapter_Select::Control_Switch] = true
      SceneManager.call(Scene_Chapter)
  end
end

class Scene_Chapter < Scene_Base
  def start
    super
    create_chapter_back
    create_back_window
    create_command_window
  end
  def create_chapter_back
    @chapterback = Sprite.new
    @chapterback.bitmap = Cache.system(R2_Chapter_Select::Background)
    @chapterback.tone.set(0, 0, 0, 180)
  end
  def terminate
    super
    @chapterback.bitmap.dispose if @spritech
    @chapterback.dispose if @spritech
    @back_window.dispose
    @chapter_window.clear_image
  end
  def create_back_window
    @back_window = Window_Chapter_Back.new
  end
  def create_command_window
    @chapter_window = Window_Chapter_Choose.new
    @chapter_window.set_handler(:ok, method(:chapter))
    @chapter_window.set_handler(:cancel, method(:on_chapter_cancel))
  end
  def chapter
    id = @chapter_window.index
    if $chapter_data.chapter_info[id][:locked] == true
      Sound.play_buzzer
      @chapter_window.activate
      return
    else
      fadeout_all
      DataManager.setup_chapter(id)
      $game_map.autoplay
    end
    SceneManager.goto(Scene_Map)
  end
  def on_chapter_cancel
    Sound.play_cancel
    fadeout_all
    terminate
    if $game_switches[R2_Chapter_Select::Control_Switch] == true
      SceneManager.goto(Scene_Title)
    else
      return_scene
    end
  end
end
