# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Credits Scene                          ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Display credits for your                    ╠════════════════════╣
# ║   hard work & attribution                     ║    18 Oct 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║        Provide an alternate method of ending credits scene         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Modify the hash array with the credits to display                ║
# ║                                                                    ║
# ║ Credits = {         # page 1                                       ║
# ║   0 => { 0 => {     # title text                                   ║
# ║            :text         => "Producers",                           ║
# ║            :font         => "Arial",                               ║
# ║            :font_size    => 50,                                    ║
# ║            :red          => 0,                                     ║
# ║            :green        => 250,                                   ║
# ║            :blue         => 0,                                     ║
# ║            },                                                      ║
# ║          1 => {     # credits to                                   ║
# ║            :text         => "Kadokawa",                            ║
# ║              },                                                    ║
# ║         },          # page 2                                       ║
# ║   1 => { 0 => {                                                    ║
# ║            :text         => "Developers",                          ║
# ║            :font         => "Arial",                               ║
# ║            :font_size    => 50,                                    ║
# ║            :red          => 0,                                     ║
# ║            :green        => 250,                                   ║
# ║            :blue         => 0,                                     ║
# ║            },                                                      ║
# ║          1 => {                                                    ║
# ║            :text         => "Roninator2",                          ║
# ║              },                                                    ║
# ║         },                                                         ║
# ║   2 => { 0 => {  # breaks from the scene                           ║
# ║            :text         => "junk",                                ║
# ║              },  # used if you want to exit                        ║
# ║         },                                                         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 18 Oct 2021 - Script finished                               ║
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

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

module R2_Game_Credits
  # key control to change to the next page
  Next_Page             = :C
  Key_Text              = "Z"
  # :A = shift, :B = X, :C = Z, :X = A, :Y = S, :Z = D, :L = Q, :R = W
  # Music to play. If blank, no music will play
  BGM                   = ""
  # Window Opacity and skin
  Window_Skin           = "Window"
  Window_Opacity        = 0
  Window_Back_Opacity   = 0
  # set text font and size
  Default_Font          = "Times New Roman"
  Default_Font_Size     = 25
  # set default text color (255, 255, 255) = white
  RED                   = 255
  GREEN                 = 255
  BLUE                  = 255
  # space between the title and the credits & space from top of screen & title
  Title_Shift           = 40 
  # scene break text. used to exit scene automatically
  Scene_Break           = "junk"
  # variable used to save credit page
  Page_Var              = 2
end

module Credit_Text
  # only the text needs to be there.
  # Zero entry is for the title, one onwards is for the credits
  Credits = {
      0 => { 
          0 => {
          :text         => "Production",
          :font         => "Arial",
          :font_size    => 50,
          :red          => 0,      
          :green        => 250,
          :blue         => 0
            },
          1 => {
          :text         => "Enterbrain",
            },
          2 => {
          :text         => "Kadakowa",
            },
          3 => {
          :text         => "Gotcha, Gotcha Games",
            },
          4 => {
          :text         => "Text in here",
            },
          5 => {
          :text         => "Who helped me",
            },
          6 => {
          :text         => "No credit for you",
            },
      },
      # page two
    1 => { 
          0 => {
          :text         => "Designers",
          :font         => "Arial",
          :font_size    => 50,
          :red          => 0,      
          :green        => 250,
          :blue         => 0
            },
           1 => {
           :text        => "Roninator2",
          },
      },
    2 => { 
          0 => {
          :text         => "junk", # returns to map
            },
      },
    3 => { 
          0 => {
          :text         => "Returned",
          :font         => "Arial",
          :font_size    => 50,
          :red          => 0,      
          :green        => 250,
          :blue         => 0
            },
           1 => {
           :text        => "Other people",
          },
      },
    4 => { 
          0 => {
          :text         => "Lot of Credits",
          :font         => "Arial",
          :font_size    => 50,
          :red          => 0,      
          :green        => 250,
          :blue         => 0
            },
           1 => {
           :text        => "Must be a big game",
          },
      },
    5 => { 
          0 => {
          :text         => "junk", # returns to map
            },
      },
    6 => { 
          0 => {
          :text         => "Extra Credits",
          :font         => "Arial",
          :font_size    => 50,
          :red          => 0,      
          :green        => 250,
          :blue         => 0
            },
           1 => {
           :text        => "Did you pay for these",
          },
      },
    }
end

class Game_Interpreter
  def game_credits
    SceneManager.call(Scene_Game_Credits)
  end
end

class Window_Credits < Window_Base
  def initialize(x, y, width, height)
    super
    self.windowskin = Cache.system(R2_Game_Credits::Window_Skin)
    @scene_out = false
    @w_width = width
    @w_height = height
  end
  def draw_credits(data)
    contents.clear
    # draw here
    @disp_data = data
    old_font = Font.default_name
    for i in 0..@disp_data.size - 1
      text = @disp_data[i][:text]
      if text == R2_Game_Credits::Scene_Break
        @scene_out = true
        break
      end
      font = @disp_data[i][:font].nil? ? R2_Game_Credits::Default_Font : @disp_data[i][:font]
      font_size = @disp_data[i][:font_size].nil? ? R2_Game_Credits::Default_Font_Size : @disp_data[i][:font_size]
      red = @disp_data[i][:red].nil? ? R2_Game_Credits::RED : @disp_data[i][:red]
      green = @disp_data[i][:green].nil? ? R2_Game_Credits::GREEN : @disp_data[i][:green]
      blue = @disp_data[i][:blue].nil? ? R2_Game_Credits::BLUE : @disp_data[i][:blue]
      x = (@w_width - ((text.size * font_size) / 2)) / 2
      if i == 0
        y = 0 + R2_Game_Credits::Title_Shift
      else
        y = (i + 1) * font_size + R2_Game_Credits::Title_Shift * 2
      end
      Font.default_name = font
      width = (text.size * font_size)
      colour = Color.new(red, green, blue, 255)
      contents.font.color = colour
      contents.font.size = font_size
      draw_text(x, y, width, font_size, text)
    end
    Font.default_name = old_font
    reset_font_settings
    btn = "Press #{R2_Game_Credits::Key_Text} to continue"
    draw_text(@w_width / 2 - (btn.size * 12 / 2), @w_height - 50, 200, line_height, btn, 1)
  end
  def scene_out
    return @scene_out
  end
end

class Scene_Game_Credits < Scene_Base
  def start
    super
    create_window
    play_music
    scene_control
    create_credits
  end
  def create_window
    @window = Window_Credits.new(0,0,Graphics.width,Graphics.height)
    @window.opacity = R2_Game_Credits::Window_Opacity
    @window.back_opacity = R2_Game_Credits::Window_Back_Opacity
  end  
  def play_music
    file = "Audio/BGM/" + R2_Game_Credits::BGM.to_s rescue nil
    if file != nil
      Audio.bgm_play(file,100,100) rescue nil
    end   
  end
  def scene_control
    @credit_page = nil
    @page_count = $game_variables[R2_Game_Credits::Page_Var]
    @page_count += 1 if @page_count > 0
  end
  def create_credits
    @credit_page = Credit_Text::Credits[@page_count]
    if @credit_page.nil?
      SceneManager.return
    else
      @window.draw_credits(@credit_page)
    end
  end
  def update
    super
    if @window.scene_out
      $game_variables[R2_Game_Credits::Page_Var] = @page_count
      return_scene
    end
    if Input.trigger?(R2_Game_Credits::Next_Page)
      @page_count += 1 
      create_credits
    end
  end
end
