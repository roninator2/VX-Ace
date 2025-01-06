# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Notes and Letters                      ║  Version: 1.04     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Display a scene for notes and clues         ║    17 Jun 2024     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║      A new scene to show information from notes and letters        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Use note tag in note box to make the item a Note or Letter       ║
# ║       <nal>                                                        ║
# ║  Use note tag to specify the image that will be shown for the item ║
# ║       <nal image: Image>                                           ║
# ║  Call scene with SceneManager.call(Scene_NAL)                      ║
# ║                                                                    ║
# ║  Images go in the pictures folder                                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 17 Jun 2024 - Script finished                               ║
# ║ 1.01 - 19 Jun 2024 - Make text full screen                         ║
# ║ 1.02 - 21 Jun 2024 - Make requested adjustments                    ║
# ║ 1.03 - 21 Jun 2024 - Added Sound and menu option                   ║
# ║ 1.04 - 13 Jul 2024 - Converted to save data                        ║
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

module R2_NAL
  # title text
  TITLE = "Scene to view all Notes and Letters"
  # set font settings
  NAL_FONT = "VL Gothic"
  NAL_FONT_SIZE = 24
  NAL_FONT_BOLD = false
  NAL_FONT_ITALIC = false
  # text to show for returning
  RETURN_TEXT = "\\I[19] Cancel"
  # Variable to save data
  NAL_VAR = 12
  # NAL Text
  NAL_TEXT = { # place the item text here
            # Item ID => ["Item text line1", Item text line 2", ...]
              17 => ["Put your text here. new lines",
                      "go like this in the quotes",], # comma at the end
  # carefull how much is placed in the line. too much and it will get cut off
              18 => ["This is a basic item",
"If your line is long you can move it back like this.",
"Just so you can see it when you type it out.",
"But the second line is the max length at 544 pixels.",],
          # add more as needed

            } # do not touch
  # Icon shown for when items have not been read
  READ_ICON = 41
  # open page sound
  PAGE_READ = "Book2"
  # Use the menu option
  SHOW_IN_MENU = true
  # Menu Command Text
  MENU_COMMAND = "Notes Found"
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

module R2_NAL
  # regex to match in item note box
  NAL = /<nal>/i
  NAL_IMAGE = /<nal image: (\w+(?:[, ]*\w*)*)>/i
end

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
 
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_objects_nal create_game_objects; end
  def self.create_game_objects
    load_objects_nal
    $game_variables[R2_NAL::NAL_VAR] = {}
    load_notetags_nal
  end
 
  #--------------------------------------------------------------------------
  # load_notetags_nal
  #--------------------------------------------------------------------------
  def self.load_notetags_nal
    for obj in $data_items
      next if obj.nil?
      obj.load_notetags_nal
    end
  end
 
end

#==============================================================================
# ■ RPG::Item
#==============================================================================

class RPG::Item
 
  #--------------------------------------------------------------------------
  # load_notetags_nal
  #--------------------------------------------------------------------------
  def load_notetags_nal
    nal = false
    nal_image = ""
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when R2_NAL::NAL
        nal = true
      when R2_NAL::NAL_IMAGE
        nal_image = $1.to_s
      end
    }
    $game_variables[R2_NAL::NAL_VAR][self.id] = [nal, nal_image, false]
  end
 
end

#==============================================================================
# ■ Scene_Menu
#==============================================================================

class Scene_Menu < Scene_MenuBase
  alias r2_command_menu_nal_scene   create_command_window
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    r2_command_menu_nal_scene
    @command_window.set_handler(:nal, method(:command_nal)) if R2_NAL::SHOW_IN_MENU
  end
  #--------------------------------------------------------------------------
  # * [NAL] Command
  #--------------------------------------------------------------------------
  def command_nal
    SceneManager.call(Scene_NAL)
  end
end

#==============================================================================
# ■ Window_MenuCommand
#==============================================================================

class Window_MenuCommand < Window_Command
  alias r2_original_command_scene_nal   add_original_commands
  #--------------------------------------------------------------------------
  # * For Adding Original Commands
  #--------------------------------------------------------------------------
  def add_original_commands
    r2_original_command_scene_nal
    add_command(R2_NAL::MENU_COMMAND, :nal) if R2_NAL::SHOW_IN_MENU
  end
end

#==============================================================================
# ■ Window NAL Item
#==============================================================================

class Window_NAL_Title < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, fitting_height(1))
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_text_ex(0,0,R2_NAL::TITLE)
  end
end

#==============================================================================
# ■ Window Note List
#==============================================================================

class Window_Note_List < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @data = []
    refresh
    select(0)
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Include in Item List?
  #--------------------------------------------------------------------------
  def include?(item)
    item.is_a?(RPG::Item) && $game_variables[R2_NAL::NAL_VAR][item.id][0] != false
  end
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $game_party.all_items.select {|item| include?(item) }
    @data.push(nil) if include?(nil)
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select(@data.index($game_party.last_item.object) || 0)
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y)
      draw_icon(R2_NAL::READ_ICON, rect.x, rect.y, true) if 
        $game_variables[R2_NAL::NAL_VAR][item.id][2] == false
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item Name
  #     enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    if $game_variables[R2_NAL::NAL_VAR][item.id][0] && 
        $game_variables[R2_NAL::NAL_VAR][item.id][2] == false
      # draw no icon
    else
      draw_icon(item.icon_index, x, y, enabled) 
    end
    change_color(normal_color, enabled)
    draw_text(x + 30, y, width, line_height, item.name)
  end
  #--------------------------------------------------------------------------
  # * Image Window
  #--------------------------------------------------------------------------
  def image_window=(window)
    @image_window = window
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    super
    @image_window.set_item(item) if @image_window
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end

#==============================================================================
# ■ Window NAL Image
#==============================================================================

class Window_NAL_Image < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #--------------------------------------------------------------------------
  def set_image(image)
    if image != @image
      @image = image
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    set_image(nil)
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #     item : Skills and items etc.
  #--------------------------------------------------------------------------
  def set_item(item)
    set_image(item ? $game_variables[R2_NAL::NAL_VAR][item.id][1] ? 
      $game_variables[R2_NAL::NAL_VAR][item.id][1] : nil : nil)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    bitmap = Cache.picture("#{@image}")
    rect = Rect.new(0,0,self.width,self.height)
    contents.blt(0, 0, bitmap, rect)
    bitmap.dispose
  end
end

#==============================================================================
# ■ Window NAL Text
#==============================================================================

class Window_NAL_Text < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    self.opacity = 0
    deactivate
    hide
    self.opacity = 255
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #--------------------------------------------------------------------------
  def set_text(text)
    if text != @text
      @text = text
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    set_text("")
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #     item : Skills and items etc.
  #--------------------------------------------------------------------------
  def set_item(item)
    RPG::SE.new(R2_NAL::PAGE_READ, 80, 0).play if R2_NAL::PAGE_READ != ""
    set_text(item ? R2_NAL::NAL_TEXT[item.id] ? R2_NAL::NAL_TEXT[item.id] : [] : [])
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    y = 0
    @text.each do |txt|
      draw_text_ex(4, y, txt)
      y += line_height
    end
    draw_text_ex(0, contents.height - 32, R2_NAL::RETURN_TEXT)
  end
  #--------------------------------------------------------------------------
  # * Reset Font Settings
  #--------------------------------------------------------------------------
  def reset_font_settings
    change_color(normal_color)
    contents.font.name = R2_NAL::NAL_FONT
    contents.font.size = R2_NAL::NAL_FONT_SIZE
    contents.font.bold = R2_NAL::NAL_FONT_BOLD
    contents.font.italic = R2_NAL::NAL_FONT_ITALIC
  end
end

#==============================================================================
# ■ Scene NAL
#==============================================================================

class Scene_NAL < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_text_window
    create_title_window
    create_image_window
    create_list_window
  end
  #--------------------------------------------------------------------------
  # * Create Text Window
  #--------------------------------------------------------------------------
  def create_text_window
    ww = Graphics.width
    wh = Graphics.height
    @text_window = Window_NAL_Text.new(0, 0, ww, wh)
    @text_window.z = 200
  end
  #--------------------------------------------------------------------------
  # * Create Title Window
  #--------------------------------------------------------------------------
  def create_title_window
    @title_window = Window_NAL_Title.new
  end
  #--------------------------------------------------------------------------
  # * Create Image Window
  #--------------------------------------------------------------------------
  def create_image_window
    wx = 200
    wy = @title_window.height
    ww = Graphics.width - wx
    wh = Graphics.height - wy
    @image_window = Window_NAL_Image.new(wx, wy, ww, wh)
  end
  #--------------------------------------------------------------------------
  # * Create List Window
  #--------------------------------------------------------------------------
  def create_list_window
    wx = 0
    wy = @title_window.height
    ww = 200
    wh = Graphics.height - wy
    @list_window = Window_Note_List.new(wx, wy, ww, wh)
    @list_window.set_handler(:ok,     method(:on_item_ok))
    @list_window.set_handler(:cancel, method(:on_item_cancel))
    @list_window.activate
    @list_window.image_window = @image_window
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    if @list_window.item == nil
      Sound.play_buzzer
      @list_window.activate
      return
    end
    @list_window.deactivate
    @text_window.activate
    @text_window.show
    @text_window.set_item(@list_window.item)
    $game_variables[R2_NAL::NAL_VAR][@list_window.item.id][2] = true if 
      $game_variables[R2_NAL::NAL_VAR][@list_window.item.id][2] == false
    @title_window.hide
    @image_window.hide
    @list_window.hide
  end
  #--------------------------------------------------------------------------
  # * Item [Cancel]
  #--------------------------------------------------------------------------
  def on_item_cancel
    return_scene
  end
  #--------------------------------------------------------------------------
  # * Text Cancel
  #--------------------------------------------------------------------------
  def on_text_cancel
    @text_window.deactivate
    @text_window.hide
    @title_window.show
    @image_window.show
    @list_window.show
    @list_window.activate
    @list_window.refresh
    Sound.play_cancel
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    on_text_cancel if Input.press?(:B) && @text_window.active
  end
end
