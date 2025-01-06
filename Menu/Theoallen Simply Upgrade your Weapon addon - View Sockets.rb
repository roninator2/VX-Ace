# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Socket View Scene                      ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   View Socket Item Data                       ║    28 Jan 2024     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires:  Weapon Upgrade - Sockets                                ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║ Simply view socket item data                                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Call scene                                                       ║
# ║     SceneManager.call(Scene_Socket_Data)                           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 28 Jan 2024 - Script finished                               ║
# ║ 1.01 - 07 Feb 2024 - Added vertical line x position                ║
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

module Vocab
  # Socket menu text
  Socket_Data = "Socket Info"
end

module R2_Socket_Config
  # If true will show command in item menu to view sockets items
  # if false will include items in item menu as key items
  Use_Item_Command  = false

  # position for the Vertical line
  Vertical_Line_View_X = 260
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

#==============================================================================
# ** Window_SocketItemData
#------------------------------------------------------------------------------
#  This window shows the socket item information.
#==============================================================================
if R2_Socket_Config::Use_Item_Command
class Window_ItemCategory < Window_HorzCommand
  #--------------------------------------------------------------------------
  # * Alias method: make_command_list 
  #--------------------------------------------------------------------------
  alias :make_command_list_r2_socket_system :make_command_list
  def make_command_list
    make_command_list_r2_socket_system
    add_command(Vocab::Socket_Data, :socket_data, $game_party.socket_items != [])
  end
end

class Scene_Item < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Alias method: create_category_window
  #--------------------------------------------------------------------------
  alias :socket_system_create_category_window :create_category_window
  #--------------------------------------------------------------------------
  # * Create Category Window
  #--------------------------------------------------------------------------
  def create_category_window
    socket_system_create_category_window
    @category_window.set_handler(:socket_data,   method(:socket_info))
  end
  #--------------------------------------------------------------------------
  # * socket_info
  #--------------------------------------------------------------------------
  def socket_info
    SceneManager.call(Scene_Socket_Data)
  end
end
else
class Window_ItemList < Window_Selectable
  alias :r2_key_item_socket_list  :make_item_list
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    r2_key_item_socket_list
    $game_party.socket_items.each do |si|
      @data.push(si) if @category == :key_item
    end
    @data.compact!
    @data.push(nil) if include?(nil)
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y, enable?(item))
      draw_item_number(rect, item) unless item.is_a?(RPG::Armor)
    end
  end
end
end

class Window_SocketItemData < Window_Base
  #--------------------------------------------------------------------------
  # * initialize
  #--------------------------------------------------------------------------
  def initialize(width, height)
    super(0, 72, width, height)
  end
  #--------------------------------------------------------------------------
  # * socket_item
  #--------------------------------------------------------------------------
  def socket_item=(socket_item)
    @socket_item = socket_item
    refresh
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if @socket_item.nil?
    contents.font.size = Font.default_size
    return if @socket_item == []
    @socket_item = @socket_item[0] if @socket_item.is_a?(Array)
    draw_item_name(@socket_item, 0, 0, true, width)
    contents.font.size = 19
    draw_socket_item_stats
  end
  #--------------------------------------------------------------------------
  # * draw_item_name
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    draw_icon(item.icon_index, x, y - 2, enabled)
    change_color(normal_color, enabled)
    draw_text(x + 24, y, width, line_height, item.name)
  end
  #--------------------------------------------------------------------------
  # * draw_icon
  #--------------------------------------------------------------------------
  def draw_icon(icon_index, x, y, enabled = true)
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    contents.blt(x, y, bitmap, rect, enabled ? 255 : 120)
  end
  #--------------------------------------------------------------------------
  # * draw_socket_item_stats
  #--------------------------------------------------------------------------
  def draw_socket_item_stats
    list1 = get_params_values
    list2 = get_stats_values
    list3 = get_feature_values
    list1.each_with_index {|param, i| draw_param_value(param, i, false) }
    list2.each_with_index {|param, i| draw_param_value(param, i + list1.size) }
    list3.each_with_index {|ft, i| draw_feature_value(ft, i) }
    draw_vertical_line_ex(R2_Socket_Config::Vertical_Line_View_X, 0, Color.new(255,255,255,128), Color.new(0,0,0,64))
  end
  #--------------------------------------------------------------------------
  # * get_params_values
  #--------------------------------------------------------------------------
  def get_params_values
    list = []
    @socket_item.params.size.times do |i|
      next if @socket_item.params[i] == 0
      list.push({name: Vocab::param(i), value: @socket_item.params[i]})
    end
    list
  end
  #--------------------------------------------------------------------------
  # * get_stats_values
  #--------------------------------------------------------------------------
  def get_stats_values
    list = []
    @socket_item.stats.keys.each do |i|
      next if @socket_item.stats[i] == 0
      list.push({name: Vocab::param(i), value: @socket_item.stats[i]})
    end
    list
  end
  #--------------------------------------------------------------------------
  # * get_params_values
  #--------------------------------------------------------------------------
  def get_feature_values
    list = []
    @socket_item.features.each_with_index do |ft, i|
      next if ft.data_id == 0
      list.push({name: feature_type(ft), value: @socket_item.features[i]})
    end
    list
  end
  #--------------------------------------------------------------------------
  # * feature_type
  #--------------------------------------------------------------------------
  def feature_type(ft)
    code = get_feature_text(ft.code)
    id = ft.data_id
    return "#{code}-#{id}"
  end
  #--------------------------------------------------------------------------
  # * draw_param_value
  #--------------------------------------------------------------------------
  def draw_param_value(param, i, rate = true)
    name  = param[:name]
    plus  = param[:value] < 0 ? "-" : "+"
    value = sprintf("%02d", param[:value].abs)
    rate  = rate ? "%" : ""
    draw_param_info(name, plus, value, rate, i, width - 176, 108)
  end
  #--------------------------------------------------------------------------
  # * draw_param_info
  #--------------------------------------------------------------------------
  def draw_param_info(name, plus, value, rate, i, x, y)
    z = 88
    contents.draw_text(x + 40, z + i * 18, 172, 24, name)
    contents.draw_text(x + y, z + i * 18, 172, 24, plus)
    change_color(plus == "-" ? knockout_color : crisis_color)
    wid = text_size(plus).width
    contents.draw_text(x + y + wid, z + i * 15, 172, 24, value)
    change_color(normal_color)
    wid += text_size(value).width
    contents.draw_text(x + y + wid, z + i * 15, 172, 24, rate)
  end
  #--------------------------------------------------------------------------
  # * draw_feature_value
  #--------------------------------------------------------------------------
  def draw_feature_value(ft, i)
    title = ""
    data  = ft[:name].split("-")
    name = data[0]
    value = (ft[:value].value * 100).to_i
    id = ft[:value].data_id
    draw_feature_info(name, value, id, i, 0, 108)
  end
  #--------------------------------------------------------------------------
  # * draw_feature_info
  #--------------------------------------------------------------------------
  def draw_feature_info(name, value, id, i, x, y)
    z = 88
    contents.draw_text(x, z + i * 15, 172, 24, name)
    case name
    when "Skill"
      skill = $data_skills[id]
      skname = skill.name
      wid = text_size(skname).width
      change_color(system_color)
      contents.draw_text(70, z + i * 15, 172, 24, skname)
      change_color(normal_color)
    when "Element"
      ele = get_element_name(id)
      wid = text_size(ele).width
      change_color(system_color)
      contents.draw_text(70, z + i * 15, 172, 24, ele)
      change_color(crisis_color)
      wid += text_size(value).width
      contents.draw_text(160, z + i * 15, 172, 24, "#{value}%")
    end
  end
  #--------------------------------------------------------------------------
  # * draw_vertical_line
  #--------------------------------------------------------------------------
  def draw_vertical_line_ex(x, y, color, shadow)
    # // Method to draw a vertical line with a shadow.
    line_x = x + line_height / 2 - 1
    contents.fill_rect(line_x, y, 2, contents_height, color)
    line_x += 1
    contents.fill_rect(line_x, y, 2, contents_height, shadow)
  end
end


#==============================================================================
# ** Window_SocketItems
#------------------------------------------------------------------------------
#  This window shows the socket item list.
#==============================================================================

class Window_SocketItems < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :socket_window
  #--------------------------------------------------------------------------
  # * initialize
  #--------------------------------------------------------------------------
  def initialize
    super(window_x, 72, 192, window_height)
    @data = []
  end
  #--------------------------------------------------------------------------
  # * window_x
  #--------------------------------------------------------------------------
  def window_x
    352 + [Graphics.width - 544, 0].max
  end
  #--------------------------------------------------------------------------
  # * window_height
  #--------------------------------------------------------------------------
  def window_height
    346 + [Graphics.height - 416, 0].max
  end
  #--------------------------------------------------------------------------
  # * item_max
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * socket_item
  #--------------------------------------------------------------------------
  def socket_item
    @data[index]
  end
  #--------------------------------------------------------------------------
  # * draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y)
    end
  end
  #--------------------------------------------------------------------------
  # * draw_item_name
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    draw_icon(item.icon_index, x, y, enabled, item)
    change_color(normal_color, enabled)
    draw_text(x + 24, y, width, line_height, item.name)
  end
  #--------------------------------------------------------------------------
  # * draw_icon
  #--------------------------------------------------------------------------
  def draw_icon(icon_index, x, y, enabled = true, item)
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    contents.blt(x, y, bitmap, rect, enabled ? 255 : translucent_alpha)
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * make_item_list
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $game_party.socket_items.collect {|socket_item| socket_item }
    @data.push(nil)
  end
  #--------------------------------------------------------------------------
  # * materia_window
  #--------------------------------------------------------------------------
  def socket_window=(socket_window)
    @socket_window = socket_window
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * update_help
  #--------------------------------------------------------------------------
  def update_help
    super
    @socket_window.socket_item = socket_item if @socket_window
    return if socket_item.nil? || socket_item == []
    @help_window.set_item(socket_item)
  end
  
end

#==============================================================================
# ** Scene_Socket_Data
#------------------------------------------------------------------------------
#  This class performs the materia equip screen processing.
#==============================================================================

class Scene_Socket_Data < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * start
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_socket_data_window
    create_item_window
  end
  #--------------------------------------------------------------------------
  # * create_help_window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_Help.new(2)
    @help_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * create_materia_window
  #--------------------------------------------------------------------------
  def create_socket_data_window
    ww = 352 + [Graphics.width - 544, 0].max
    wh = 346 + [Graphics.height - 416, 0].max
    @socket_data_window = Window_SocketItemData.new(ww, wh)
    @socket_data_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * create_item_window
  #--------------------------------------------------------------------------
  def create_item_window
    @item_window = Window_SocketItems.new
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.socket_window = @socket_data_window
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @item_window.refresh
    @item_window.activate
    @item_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * on_item_cancel
  #--------------------------------------------------------------------------
  def on_item_cancel
    return_scene
  end
end
