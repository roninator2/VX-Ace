=begin
CSCA Encyclopedia
version: 3.0.3 (Released: March 7, 2013)
Created by: Casper Gaming (http://www.caspergaming.com/)

## Modded by Roninator2

##    Custom note for encyclopedia items now
##    use the following:
##    <cscanote>
      Your Text Here
      with more text

      tada
##    </cscanote>
##   
##    all the text inside will be displayed for the note description
##
##    fixed the press action button position for 640x480 screen

=end

class Scene_CSCA_Encyclopedia < Scene_MenuBase
  def start
    super
    create_command_window
    create_dummy_window
    create_csca_info_window
    create_specific_total_window
    create_csca_list_window
    create_total_window
  end
  def create_command_window
    @command_window = CSCA_Window_EncyclopediaMainSelect.new(0, 0)
    @command_window.viewport = @viewport
    @command_window.set_handler(:ok,     method(:on_category_ok))
    @command_window.set_handler(:cancel, method(:return_scene))
  end
  def create_specific_total_window
    wy = @csca_info_window.height - @command_window.height
    wh = @command_window.height
    wl = @dummy_window.width - 80
    @specific_total_window = CSCA_Window_EncyclopediaSpecificTotal.new(0, wy, wl, wh)
    @specific_total_window.viewport = @viewport
    @command_window.csca_specific_total_window = @specific_total_window
  end
 
  def create_total_window
    wy = @csca_list_window.y + @csca_list_window.height + @specific_total_window.height
    wh = @command_window.height
    wl = @csca_list_window.width
    @total_window = CSCA_Window_EncyclopediaTotal.new(0, wy, wl, wh)
    @total_window.viewport = @viewport
  end
end

class CSCA_Window_EncyclopediaInfo < Window_Base
  def notes
    @item.effect_desc
  end

  def csca_draw_custom_note(x,y,width,height,item)
    @item = item
    contents.font.size = 20
    change_color(system_color)
    draw_text(x,y,width,height,"Note: ")
    change_color(normal_color)
    notes.each do |l|
      draw_text(x+45, y, contents.width, line_height, l)
      y += line_height
    end
  end
  def csca_draw_toggle_tutorial
    contents.font.size = 16
    draw_text(0,380,contents.width,line_height,CSCA_ENCYCLOPEDIA::TRIGGER_TEXT,1)
  end
end

class RPG::BaseItem
  def effect_desc
    make_effect_desc if @effect_desc.nil?
    return @effect_desc
  end
 
  def make_effect_desc
    @effect_desc = []
    results = self.note.scan(/<cscanote>(.*?)<\/cscanote>/imx)
    results.each do |res|
      res[0].strip.split("\r\n").each do |line|
      @effect_desc.push("#{line}")
      end
    end
  end
end
