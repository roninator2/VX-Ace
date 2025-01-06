# Coder : efeberk
# Mod : Roninator2
# 
# Show text box with a message
# 
# Script call:
# show_textbox(x, y, width, height, variable, title = nil, txt = "Hello!")
# 
# x : X position for the window
# y : y position for the window
# height : message window height
# width : message window width
# variable : which variable will be used to display text, 0 = not used
# title : optional
# txt : text to display if variable is not used.
# 
# Sample : show_textbox(120, 50, 270, 48, 0, "PIN Code", "Looks like it says 25871")
# Sample : show_textbox(120, 50, 270, 48, 10, "PIN Code", "")
# Variable 10 = "Looks like it says 25871"

class Window_TextBox < Window_Base
  
  attr_accessor :enabled
  attr_reader :finished
  
  def initialize(x, y, width, height, var, title, txt)
    @txt = txt
    @var = var
    @title = title
    @x = x
    @y = y
    @width = width
    @finished = false
    super(x, y, width, height)
  end
  
  def update
    self.contents.clear
    update_textbox if @var != 0 || @txt != ""
    update_keyboard
  end
  
  def update_keyboard
    if Input.trigger?(:C)
      @finished = true
      @text = ""
    end
  end
  
  def update_textbox
    if @var != 0
      draw_text_ex(@width / 2 - @var.size * 6, 0, @var) 
    else
      draw_text_ex(0, 0, @txt) 
    end
  end
  
end

class Scene_TextBox < Scene_Base
  
  def prepare(x, y, width, height, var, title, txt)
    @x, @y, @width, @height, @var, @title, @txt = x, y, width, height, $game_variables[var.to_i], title, txt
  end
  
  def start
    super
    create_background
    create_textbox
  end
    
  def create_background
    @background_sprite = Spriteset_Map.new
  end
  
  def create_textbox
    if @title
      @header = Window_Base.new(@x+@width/2-@title.size*6, @y-48, @title.size*12, 48)
      @header.draw_text(0, 0, @header.contents_width, @header.contents_height, @title, 1)
    end
    @textbox = Window_TextBox.new(@x, @y, @width, @height, @var, @title, @txt)
  end
  
  def update
    super
    if @textbox.finished then return_scene end
  end
  
end

class Game_Interpreter
  
  def show_textbox(x, y, width, height, var = 0, title = nil, txt = "")
    SceneManager.call(Scene_TextBox)
    SceneManager.scene.prepare(x, y, width, height, var, title, txt)
    Fiber.yield while SceneManager.scene_is?(Scene_TextBox)
  end

end
