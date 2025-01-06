#Sleek Item Popup v1.14f
#Mod by Roninator2
#Features: A nice and sleek little pop up you can use to tell the player
#           they received (or lost) an item! Now with automatic popups whenever
#           you use the gain item commands in events!
#
#Usage:   Event Script Call:
#           popup(type,item,amount,[duration],[xoff],[yoff],event_id)
#
#          Where: type is category of item (0 = item, 1 = weapon,
#                                            2 = armor, 3 = gold)
#                 item is the id number of the item
#                 amount is the amount lost or gained
#                 duration is the time the window is up and is optional
#          
#          Examples:
#            popup(0,1,5)
#            popup(2,12,1,120)
#            $game_switches[X] = false
#            $game_switches[X] = true
#          To use the event, you can use x offset and y offset but it is
#          not required, but still must be placed in the script call.
#          popup(1,   5,    1,     120,    0,   0,    3)
#         popup(type,item,amount,duration,xoff,yoff,event)
#               event #3 will have the popup
#
#Customization: Everything down there under customization
#
#----------#
#-- Script by: V.M of D.T
#
#- Questions or comments can be:
#    given by email: sumptuaryspade@live.ca
#    provided on facebook: http://www.facebook.com/DaimoniousTailsGames
#   All my other scripts and projects can be found here: http://daimonioustails.weebly.com/
#
#--- Free to use in any project, commercial or non-commercial, with credit given
# - - Though a donation's always a nice way to say thank you~ (I also accept actual thank you's)
 
$imported = {} if $imported.nil?
$imported[:Vlue_SleekPopup] = true

module Vlue_Popup
#Sound effect played on popup: # "Filename", Volume(0-100), Pitch(50-150)
PU_SOUND_EFFECT_GAIN = ["Item3",100,50]
PU_SOUND_EFFECT_LOSE = ["Item3",100,50]
PU_SOUND_GOLD_GAIN = ["Coin",100,50]
PU_SOUND_GOLD_LOSE = ["Coin",100,50]
 
#Animation to be played on the player during popup
PU_USE_ANIMATION = false
PU_POPUP_ANIMATION = 2
 
#Duration in frames of Item Popup fadein and fadeout
PU_FADEIN_TIME = 30
PU_FADEOUT_TIME = 30
 
#Default duration of the popup
PU_DEFAULT_DURATION = 90
 
#Use automatic popup? Can be enabled/disabled in game, see examples
PU_AUTOMATIC_POPUP = 186 # switch to turn on off
PU_IGNORE_ITEM_LOSS = true
 
#Whether to use a custom or default font
PU_USE_CUSTOM_FONT = false
 
#Settings for custom item popup font
PU_DEFAULT_FONT_NAME = ["Verdana"]
PU_DEFAULT_FONT_SIZE = 16
PU_DEFAULT_FONT_COLOR = Color.new(255,255,255,255)
PU_DEFAULT_FONT_BOLD = false
PU_DEFAULT_FONT_ITALIC = false
PU_DEFAULT_FONT_SHADOW = false
PU_DEFAULT_FONT_OUTLINE = true
 
#Compact mode will hide the amount unless it's greater then 1
PU_COMPACT_MODE = true
 
#Background Icon to be displayed under item icon
PU_USE_BACKGROUND_ICON = true
PU_BACKGROUND_ICON = 102
 
#Gold details:
PU_GOLD_NAME = "Lytil"
PU_GOLD_ICON = 262
 
#True for single line, false for multi line
PU_SINGLE_LINE = true

end

class Item_Popup < Window_Base
  def initialize(item, amount, duration, nosound,xoff,yoff,event)
    super(0,0,100,96)
    return if item.nil?
    amount = 0 if amount.nil?
    if item.name == Vlue_Popup::PU_GOLD_NAME
      sedg, sedl = Vlue_Popup::PU_SOUND_GOLD_GAIN, Vlue_Popup::PU_SOUND_GOLD_LOSE
    else
      sedg, sedl = Vlue_Popup::PU_SOUND_EFFECT_GAIN, Vlue_Popup::PU_SOUND_EFFECT_LOSE
    end
    se = RPG::SE.new(sedg[0],sedg[1],sedg[2]) unless sedg.nil? or nosound
    se2 = RPG::SE.new(sedl[0],sedl[1],sedl[2]) unless sedl.nil? or nosound
    se.play if se and amount > 0
    se2.play if se2 and amount < 0
    self.opacity = 0
    self.x = $game_player.screen_x - 16
    self.y = $game_player.screen_y - 80
    @xoff = xoff
    @yoff = yoff
    @duration = duration ? duration : 120
    @item = item
    @amount = amount
    @name = item.name.clone
    @text = ""
    @padding = ' '*@name.size
    @timer = 0
    @event = event
    @split = (Vlue_Popup::PU_FADEIN_TIME) / @name.size
    @split = 2 if @split < 2
    amount > 0 ? @red = Color.new(0,255,0) : @red = Color.new(255,0,0)
    if Vlue_Popup::PU_USE_CUSTOM_FONT
      contents.font.size = Vlue_Popup::PU_DEFAULT_FONT_SIZE
    else
      contents.font.size = 16
    end
    @textsize = text_size(@name)
    textsize2 = text_size("+" + amount.to_s)
    self.width = @textsize.width + standard_padding * 2 + 24
    self.width += textsize2.width + 48 if Vlue_Popup::PU_SINGLE_LINE
    contents.font.size < 24 ? size = 24 : size = contents.font.size
    self.height = size + standard_padding * 2
    self.height += size if !Vlue_Popup::PU_SINGLE_LINE
    self.x -= self.width / 2
    create_contents
    if Vlue_Popup::PU_USE_CUSTOM_FONT
      contents.font.name = Vlue_Popup::PU_DEFAULT_FONT_NAME
      contents.font.size = Vlue_Popup::PU_DEFAULT_FONT_SIZE
      contents.font.color = Vlue_Popup::PU_DEFAULT_FONT_COLOR
      contents.font.bold = Vlue_Popup::PU_DEFAULT_FONT_BOLD
      contents.font.italic = Vlue_Popup::PU_DEFAULT_FONT_ITALIC
      contents.font.shadow = Vlue_Popup::PU_DEFAULT_FONT_SHADOW
      contents.font.outline = Vlue_Popup::PU_DEFAULT_FONT_OUTLINE
    end
    self.contents_opacity = 0
    $game_player.animation_id = Vlue_Popup::PU_POPUP_ANIMATION if Vlue_Popup::PU_USE_ANIMATION
    update
  end
  def update
    #super
    return if self.disposed?
    return if @item.nil?
    self.visible = true if !self.visible
    @event = 0 if @event.nil?
    if @event != 0
      self.x = $game_map.events[@event].screen_x - contents.width/4 + 12
      self.y = $game_map.events[@event].screen_y - 80 + @yoff
    else
      self.x = $game_player.screen_x - contents.width/4 + 12
      self.y = $game_player.screen_y - 80 + @yoff
    end
    self.x -= self.width / 3
    if self.x < $game_player.screen_x - 32 && $game_player.screen_x < 64
      self.x = 0
    end
    if $game_player.screen_x > (Graphics.width - 64)
      self.x -= 48
    end
    open if @timer < (Vlue_Popup::PU_FADEIN_TIME)
    close if @timer > (Vlue_Popup::PU_FADEOUT_TIME + @duration)
    @timer += 1
    return if @timer % @split != 0
    @text += @name.slice!(0,1)
    @padding.slice!(0,1)
    contents.clear
    contents.font.color = @red
    stringamount = @amount
    stringamount = "+" + @amount.to_s if @amount > 0
    if Vlue_Popup::PU_SINGLE_LINE
      width = text_size(@item.name).width
      draw_text(27 + width,0,36,24,stringamount) unless Vlue_Popup::PU_COMPACT_MODE and @amount == 1
      if Module.const_defined?(:AFFIXES)
        contents.font.color = @item.color
      else
        contents.font.color = Font.default_color
      end
      change_color(@item.rarity_colour) if $imported[:TH_ItemRarity]
      draw_text(24,0,contents.width,contents.height,@text+@padding)
      change_color(normal_color)
      draw_icon(Vlue_Popup::PU_BACKGROUND_ICON,0,0) if Vlue_Popup::PU_USE_BACKGROUND_ICON
      draw_icon(@item.icon_index,0,0)
    else
      draw_text(contents.width / 4 + 16,24,36,24,stringamount) unless Vlue_Popup::PU_COMPACT_MODE and @amount == 1
      if Module.const_defined?(:AFFIXES)
        contents.font.color = @item.color
      else
        contents.font.color = Font.default_color
      end
      draw_icon(Vlue_Popup::PU_BACKGROUND_ICON,contents.width / 2 - 24,24) if Vlue_Popup::PU_USE_BACKGROUND_ICON
      draw_icon(@item.icon_index,contents.width / 2 - 24,24)
      draw_text(0,0,contents.width,line_height,@text+@padding)
    end
  end
  def close
    self.contents_opacity -= (255 / (Vlue_Popup::PU_FADEOUT_TIME))
  end
  def open
    self.contents_opacity += (255 / (Vlue_Popup::PU_FADEIN_TIME))
  end
end
 
class Game_Interpreter
  alias pu_command_126 command_126
  alias pu_command_127 command_127
  alias pu_command_128 command_128
  alias pu_command_125 command_125
  def popup(type,item,amount,duration = Vlue_Popup::PU_DEFAULT_DURATION,nosound = false, xo = 0, yo = 0, event)
    event = 0 if event.nil?
    data = $data_items[item] if type == 0
    data = $data_weapons[item] if type == 1
    data = $data_armors[item] if type == 2
    if type == 3
      data = RPG::Item.new
      data.name = Vlue_Popup::PU_GOLD_NAME
      data.icon_index = Vlue_Popup::PU_GOLD_ICON
    end
    Popup_Manager.add(data,amount,duration,nosound,xo,yo,event)
  end
  def command_125
    pu_command_125
    value = operate_value(@params[0], @params[1], @params[2])
    popup(3,@params[0],value,0) if $game_switches[Vlue_Popup::PU_AUTOMATIC_POPUP]
  end
end
 
module Popup_Manager
  def self.init
    @queue = {}
    @last_item = nil
    @last_event = 0
    @yoff = false
  end
  def self.add(item,value,dura,ns,xo,yo,event)
    return if Vlue_Popup::PU_IGNORE_ITEM_LOSS && value < 1
    @last_item = item if @last_item.nil?
    @last_event = event if @last_event.nil?
    if @last_item != item && @last_event == event
      @yoff = true
      @last_item = item
      @last_event = event
    else
      @yoff = false
    end
    i = @queue.size
    @queue[i] = [item,value,dura,ns,xo,yo,event]
  end
  def self.queue
    @queue
  end
  def self.yoff
    @yoff
  end
end  
 
class Scene_Map
  attr_accessor :popupwindow
  alias popup_update update
  alias popup_preterminate pre_terminate
  alias r2_popup_start  start
  def start
    @popupwindow = {}
    Popup_Manager.init
    r2_popup_start
  end
  alias r2_popup_call_menu call_menu
  def call_menu
    @popupwindow.each_with_index do |pop, i|
      @popupwindow[i].dispose if !@popupwindow[i].nil?
      if @popupwindow[i].nil?
        Popup_Manager.queue.delete(i)
      end
    end
    r2_popup_call_menu
  end
  def update
    popup_update
    update_popup_window unless @popupwindow.nil?
    for i in 0..Popup_Manager.queue.size - 1
      if @popupwindow[i].nil? or @popupwindow[i].contents_opacity <= 20
        var = Popup_Manager.queue[i]
        Popup_Manager.queue.delete(i)
        next if var.nil?
        if Popup_Manager.yoff == true
          var[5] -= 24 * i
        end
        @popupwindow[i].dispose if !@popupwindow[i].nil? and !@popupwindow[i].disposed?
        @popupwindow[i] = Item_Popup.new(var[0],var[1],var[2],var[3],var[4],var[5],var[6]) unless !@popupwindow[i].nil?
      end
      update_popup_window unless @popupwindow[i].nil?
    end
  end
  def update_popup_window
    for i in 0..@popupwindow.size - 1
      next if @popupwindow[i].nil?
      @popupwindow[i].update
      @popupwindow[i].dispose if !@popupwindow[i].disposed? and @popupwindow[i].contents_opacity <= 10
      @popupwindow[i] = nil if @popupwindow[i].disposed?
    end
  end
  def pre_terminate
    popup_preterminate
    for i in 0..@popupwindow.size - 1
      @popupwindow[i].visible = false unless @popupwindow[i].nil?
    end
  end
end

class Game_Party
  def gain_item(item, amount, include_equip = false)
    container = item_container(item.class)
    return unless container
    last_number = item_number(item)
    new_number = last_number + amount
    container[item.id] = [[new_number, 0].max, max_item_number(item)].min
    container.delete(item.id) if container[item.id] == 0
    if include_equip && new_number < 0
      discard_members_equip(item, -new_number)
    end
    $game_map.need_refresh = true
    if SceneManager.scene.is_a?(Scene_Map) && $game_switches[Vlue_Popup::PU_AUTOMATIC_POPUP]
      Popup_Manager.add(item,amount,90,false,0,0,0)
    end
  end
end
