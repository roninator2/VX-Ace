# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Weapon Upgrade - Sockets               ║  Version: 1.06     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Add sockets to upgraded weapons             ║    28 Jan 2024     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Smithing -- Simply Upgrade Your Weapon                   ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║   Adds sockets to upgraded weapons which can then have             ║
# ║   armour marked as socket items attached                           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Configure settings below to preferences                          ║
# ║     Theo Smith                                                     ║
# ║        W_Socket_Table                                              ║
# ║     R2_Socket_Config                                               ║
# ║        Slot_Icon_Nothing                                           ║
# ║        Use_Menu_Command                                            ║
# ║        Max_Socket_Items                                            ║
# ║        Elements - element names in terms database                  ║
# ║     Vocab                                                          ║
# ║        Socket_Menu                                                 ║
# ║        Cur_Socket_Text                                             ║
# ║        New_Socket_Text                                             ║
# ║                                                                    ║
# ║   Socketed items are Armours                                       ║
# ║                                                                    ║
# ║   Call scene by using menu command or script call                  ║
# ║    SceneManager.call(Scene_Socket_System)                          ║
# ║                                                                    ║
# ║   Mark armour to be used as socketing items                        ║
# ║     <SOCKET ITEM>                                                  ║
# ║                                                                    ║
# ║   The features of the armour will be added to the actor            ║
# ║                                                                    ║
# ║   Supports:                                                        ║
# ║             Added Skills                                           ║
# ║             Elements Changes                                       ║
# ║               add an element and set the rate e.g. 110%            ║
# ║             Stats                                                  ║
# ║               Those added to the armour in the database            ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 28 Jan 2024 - Script finished                               ║
# ║ 1.01 - 28 Jan 2024 - Did stuff                                     ║
# ║ 1.02 - 28 Jan 2024 - Fixed stuff                                   ║
# ║ 1.03 - 30 Jan 2024 - Made improvements                             ║
# ║ 1.04 - 06 Feb 2024 - Fixed bugs                                    ║
# ║ 1.05 - 16 Feb 2024 - Found bug with transferring sockets           ║
# ║ 1.06 - 24 Feb 2024 - Bug found with weapons socket empty           ║
# ║                      and window update issue                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Victor Sant - borrowed code - Materia                            ║
# ║   TheoAllen - weapon upgrade script                                ║
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
# ║                         Edit Below                                 ║
# ╚════════════════════════════════════════════════════════════════════╝
module THEO
  module Smith
  #==========================================================================
  # Weapon Socket Table
  #==========================================================================
   
    W_Socket_Table = { # <-- Do not touch this at all cost!
    #------------------------------------------------------------------------
    # Socket addition design
    #------------------------------------------------------------------------
    # ID => [ <-- opening
    #
    #       [level, num},  # Level 2
    #       [level, num},  # Level 3
    #       [ <add more here for the next level> ], # Level 4
    #
    #       ], <-- ending (do not forget to add comma!)
    #------------------------------------------------------------------------
    # Just a quick guide won't kill yourself :)
    #------------------------------------------------------------------------
    # ID                = Weapon ID in database.
    #
    # {level} = At what level the change is to be applied
    #           Weapons start at level 1 and first upgrade to level 2
    #           so using level 0 or 1 doesn't do anything
    # 
    # {num} = Once you've upgrade your weapon, the parameter will
    #              change whether it's up or down. Here's how:
    #            ---------------------------------------------------
    #            num = 1 # then you can attach 1 accessory to the weapon socket
    #            num = 2 # then you can attach 2 accessory to the weapon socket
    #
    # Here's the example :
    #------------------------------------------------------------------------
      1  => [
            [2,2], # dont forget comma
            [3,3], # one socket
            [4,4], # two sockets
            ], # dont forget comma
           
     13  => [
            [2,0],
            [3,2],
            ],
           
     19  => [
            [2,0],
            [3,1],
            [4,4],
            ],
           
    # add more here if it's necessary
   
    #------------------------------------------------------------------------
    } # <-- Must be here!
  end
end

module R2_Socket_Config
  # Default icons for Socket slots
  Slot_Icon_Nothing  = 16
  
  # Specify if using Menu commands
  Use_Menu_Command = true

  # Specify maximum number of socket item that can be carried
  Max_Socket_Items = 250

  # Specify maximum number of socket item that can be carried
  Elements = {
              1 => "Physical",
              2 => "Absorb",
              3 => "Fire",
              4 => "Ice",
              5 => "Thunder",
              6 => "Water",
              7 => "Earth",
              8 => "Wind",
              9 => "Holy",
              10 => "Dark",
            }
  # position for the Vertical line
  Vertical_Line_X = 260
end

module Vocab

  # Socket menu text
  Socket_Menu = "Socket Weapon"
  # Display the text for current sockets
  Cur_Socket_Text = "Current Sockets Available"
  # Display the text for new sockets to acquire
  New_Socket_Text = "New Sockets Upon Upgrade"
  
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

#==============================================================================
# ** Object
#------------------------------------------------------------------------------
#  This class is the superclass of all other classes.
#==============================================================================

class Object
  #--------------------------------------------------------------------------
  # * New method: make_symbol
  #--------------------------------------------------------------------------
  def make_symbol(string)
    string.downcase.gsub(" ", "_").to_sym
  end
  #--------------------------------------------------------------------------
  # * New method: get_param_id
  #--------------------------------------------------------------------------
  def get_param_id(text)
    case text.upcase
    when "MAXHP", "HP" then 0
    when "MAXMP", "MP" then 1
    when "ATK" then 2
    when "DEF" then 3
    when "MAT" then 4
    when "MDF" then 5
    when "AGI" then 6
    when "LUK" then 7
    end
  end
  #--------------------------------------------------------------------------
  # * New method: get_param_text
  #--------------------------------------------------------------------------
  def get_param_text(id)
    case id
    when 0 then "HP" 
    when 1 then "MP"
    when 2 then "ATK"
    when 3 then "DEF"
    when 4 then "MAT"
    when 5 then "MDF"
    when 6 then "AGI"
    when 7 then "LUK"
    end
  end
  #--------------------------------------------------------------------------
  # * New method: get_xparam_id
  #--------------------------------------------------------------------------
  def get_xparam_id(text)
    case text.upcase
    when "HIT" then 0
    when "EVA" then 1
    when "CRI" then 2
    when "CEV" then 3
    when "MEV" then 4
    when "MRF" then 5
    when "CNT" then 6
    when "HRG" then 7
    when "MRG" then 8
    when "TRG" then 9
    end
  end
  #--------------------------------------------------------------------------
  # * New method: get_xparam_text
  #--------------------------------------------------------------------------
  def get_xparam_text(id)
    case id
    when 0 then "HIT" 
    when 1 then "EVA"
    when 2 then "CRI"
    when 3 then "CEV"
    when 4 then "MEV"
    when 5 then "MRF"
    when 6 then "CNT"
    when 7 then "HRG"
    when 8 then "MRG"
    when 9 then "TRG"
    end
  end
  #--------------------------------------------------------------------------
  # * New method: get_sparam_id
  #--------------------------------------------------------------------------
  def get_sparam_id(text)
    case text.upcase
    when "TGR" then 0
    when "GRD" then 1
    when "REC" then 2
    when "PHA" then 3
    when "MCR" then 4
    when "TCR" then 5
    when "PDR" then 6
    when "MDR" then 7
    when "FDR" then 8
    when "EXR" then 9
    end
  end
  #--------------------------------------------------------------------------
  # * New method: get_sparam_text
  #--------------------------------------------------------------------------
  def get_sparam_text(id)
    case id
    when 0 then "TGR" 
    when 1 then "GRD"
    when 2 then "REC"
    when 3 then "PHA"
    when 4 then "MCR"
    when 5 then "TCR"
    when 6 then "PDR"
    when 7 then "MDR"
    when 8 then "FDR"
    when 9 then "EXR"
    end
  end
  #--------------------------------------------------------------------------
  # * New method: get_feature_text
  #--------------------------------------------------------------------------
  def get_feature_text(id)
    case id
    when 11 then "Element" 
    when 32 then "State" 
    when 43 then "Skill" 
    end
  end
  #--------------------------------------------------------------------------
  # * effect_name
  #--------------------------------------------------------------------------
  def get_element_name(id)
    return R2_Socket_Config::Elements[id]
  end
end

class RPG::UpgradedWeapon < RPG::Weapon
  attr_accessor :sockets
  alias r2_socket_insert_init initialize
  def initialize
    r2_socket_insert_init
    @sockets = {}
  end
  def socket_item?
    return false
  end
  def ori_id?
    @ori_id != nil
  end
end

class RPG::Weapon < RPG::EquipItem
  def sockets?
    @sockets != nil
  end
  def ori_id?
    false
  end
end

class RPG::Item < RPG::UsableItem
  def sockets?
    false
  end
  def socket_item?
    return false
  end
  def ori_id?
    false
  end
end

class RPG::UsableItem < RPG::BaseItem
  def sockets?
    false
  end
  def socket_item?
    return false
  end
  def ori_id?
    false
  end
end

class Window_SocketResult < Window_SmithResult
  
  def refresh
    contents.clear
    @weapon = $game_party.members[@menu_actor.index].equips[0]
    return unless @weapon
    if @weapon.is_a?(RPG::UpgradedWeapon)
      return unless THEO::Smith::W_Socket_Table[@weapon.ori_id]
    else
      return unless THEO::Smith::W_Socket_Table[@weapon.id]
    end
    reset_font_settings
    draw_socket_info
  end
 
  def draw_socket_info
    rect = Rect.new(0,0,contents.width,line_height)
    contents.font.size -= 4
    draw_text(rect,Vocab::Cur_Socket_Text,0)
    cur = nil
    new = nil
    if @weapon.ori_id?
      lvls = THEO::Smith::W_Socket_Table[@weapon.ori_id]
      lvls.each { |itm| if itm[0] == @weapon.level; cur = itm[1];  end }
      cur = 0 if cur == nil
    else
      lvls = THEO::Smith::W_Socket_Table[@weapon.id]
      lvls.each { |itm| if itm[0] == @weapon.level; cur = itm[1];  end }
      cur = 0 if cur == nil
    end
    draw_text(rect,cur,2)
    rect.y += 24
    draw_text(rect,Vocab::New_Socket_Text,0)
    if @weapon.ori_id?
      lvls = THEO::Smith::W_Socket_Table[@weapon.ori_id]
      lvls.each { |itm| if itm[0] == (@weapon.level + 1); new = itm[1];  end }
      new = cur if new == nil
    else
      lvls = THEO::Smith::W_Socket_Table[@weapon.id]
      lvls.each { |itm| if itm[0] == (@weapon.level + 1); new = itm[1];  end }
      new = cur if new == nil
    end
    draw_text(rect,new,2)
  end
  
  def actor_window=(window)
    @menu_actor = window
  end
end

class Window_SmithMenu < Window_Selectable
 
  def socket_window=(window)
    @socket_window = window
  end
  
  def update_help
    @help_window.refresh(weapon)
    @socket_window.refresh if @socket_window
  end
  
end

class Scene_Smith < Scene_MenuBase
  
  alias r2_start_socket_window  start
  def start
    r2_start_socket_window
    create_socket_result
  end
  
  def create_socket_result
    x = @smith_result.x
    y = @smith_result.height + @smith_result.y
    w = Graphics.width - @menu_actor.width - @gold_window.width
    h = 24 * 3 + 4
    @socket_result = Window_SocketResult.new(x,y,w,h)
    @socket_result.z = 1
    @socket_result.actor_window = @menu_actor
    @menu_actor.socket_window = @socket_result
    @socket_result.refresh
  end
  
  alias r2_weapon_assign_sockets_smith_weapon craft_weapon
  def craft_weapon
    itm = item_to_lose
    r2_weapon_assign_sockets_smith_weapon
    assign_sockets(actor.equips[0], itm)
    @socket_result.refresh
  end
  
  def assign_sockets(wpn, old)
    $upgraded_weapons.each do |uw|
      if uw[1].id == wpn.id
        if old.sockets?
          old.sockets.each_with_index do |sk, i|
            uw[1].sockets[i] = sk[1]
          end
        end
        lvl = uw[1].level
        sock = 0
        THEO::Smith::W_Socket_Table[uw[1].ori_id].each do |lv| 
          sock = lv[1].to_i if lv[0] == lvl
        end
        sock.times do |ws|
          uw[1].sockets[ws] = [] if uw[1].sockets[ws] == nil
        end
      end
    end
  end
end
 
class RPG::EquipItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # * New method: socket_item?
  #--------------------------------------------------------------------------
  def socket_item?
    return false
  end
end

class RPG::Armor < RPG::EquipItem
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :stats
  #--------------------------------------------------------------------------
  # * New method: materia?
  #--------------------------------------------------------------------------
  def socket_item?
    note =~ /<SOCKET ITEM>/i
  end
  #--------------------------------------------------------------------------
  # * New method: sockets?
  #--------------------------------------------------------------------------
  def sockets?
    @sockets != nil
  end
  #--------------------------------------------------------------------------
  # * New method: setup_item_stats
  #--------------------------------------------------------------------------
  def setup_item_stats
    setup_stats
    setup_effects
    self
  end
  #--------------------------------------------------------------------------
  # * New method: setup_stats
  #--------------------------------------------------------------------------
  def setup_stats
    @stats = {}
    values = note =~ /<STATS:\s([\w\s\+\-:%,;]+)>/i ? $1.dup : ""
    regexp = /(\w+):\s*([+-]?\d+)%/i
    values.scan(regexp).each {|x, y| @stats[get_param_id(x)] = y.to_i }
  end
  #--------------------------------------------------------------------------
  # * New method: setup_effects
  #--------------------------------------------------------------------------
  def setup_effects
    values   = note =~ /<EFFECTS:\s([\w\s\+\-:%,;]+)>/i ? $1.dup : ""
    @effects = values.scan(/[\w\s\+\-\:\%]*/i).inject({}) do |r, i|
      if i =~ /([\w\s]+)(?:: *([+-]?\d+)%?)?/i
        r[make_symbol($1)] = $2 ? $2.to_i / 100.0 : true
      end
      r
    end
    @effects.default = 0
  end
  #--------------------------------------------------------------------------
  # * New method: effect?
  #--------------------------------------------------------------------------
  def effect?(effect)
    @effects.keys.include?(effect)
  end
  #--------------------------------------------------------------------------
  # * New method: effect
  #--------------------------------------------------------------------------
  def effect(value)
    @effects[value]
  end
end

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * New method: call_materia_shop
  #--------------------------------------------------------------------------
  def call_socket_scene
    return if $game_party.in_battle
    SceneManager.call(Scene_Socket_System)
  end
end

class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Alias method: add_main_commands 
  #--------------------------------------------------------------------------
  alias :add_main_commands_r2_socket_system :add_main_commands
  def add_main_commands
    add_main_commands_r2_socket_system
    add_command(Vocab::Socket_Menu, :socket, main_commands_enabled)
  end
end

class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Alias method: create_command_window
  #--------------------------------------------------------------------------
  alias :socket_system_create_command_window :create_command_window
  def create_command_window
    socket_system_create_command_window
    @command_window.set_handler(:socket,   method(:command_personal))
  end
  #--------------------------------------------------------------------------
  # * Alias method: on_personal_ok
  #--------------------------------------------------------------------------
  alias :socket_system_on_personal_ok :on_personal_ok
  def on_personal_ok
    socket_system_on_personal_ok
    if @command_window.current_symbol == :socket
      SceneManager.call(Scene_Socket_System)
    end
  end
end

#==============================================================================
# ** Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Alias method: param_plus
  #--------------------------------------------------------------------------
  alias :param_plus_r2_socket_system :param_plus
  def param_plus(param_id)
    result = param_plus_r2_socket_system(param_id)
    all_socket_items.inject(result) {|r, item| r += item.params[param_id] }
  end
  #--------------------------------------------------------------------------
  # * Alias method: param_rate
  #--------------------------------------------------------------------------
  alias :param_rate_r2_socket_system :param_rate
  def param_rate(param_id)
    result = param_rate_r2_socket_system(param_id)
    result + socket_item_param(param_id)
  end
  #--------------------------------------------------------------------------
  # * Alias method: xparam
  #--------------------------------------------------------------------------
  alias :xparam_r2_socket_system :xparam
  def xparam(param_id)
    result = xparam_r2_socket_system(param_id)
    result + socket_item_xparam(param_id)
  end
  #--------------------------------------------------------------------------
  # * Alias method: sparam
  #--------------------------------------------------------------------------
  alias :sparam_r2_socket_system :sparam
  def sparam(param_id)
    result = sparam_r2_socket_system(param_id)
    result + socket_item_sparam(param_id)
  end  
  #--------------------------------------------------------------------------
  # * Alias method: feature_objects
  #--------------------------------------------------------------------------
  alias :feature_objects_r2_socket_system :feature_objects
  def feature_objects
    feature_objects_r2_socket_system + all_socket_items
  end
  #--------------------------------------------------------------------------
  # * New method: all_socket_items
  #--------------------------------------------------------------------------
  def all_socket_items
    return [] if self.equips[0].nil?
    return [] if self.equips[0].sockets? == false
    self.equips[0].sockets.values.inject([]) {|r, i| r += i }
  end
  #--------------------------------------------------------------------------
  # * New method: socket_item_param
  #--------------------------------------------------------------------------
  def socket_item_param(id)
    all_socket_items.inject(0.0) do |r, m|
      r += socket_item_param_plus(m, id)
    end
  end
  #--------------------------------------------------------------------------
  # * New method: socket_item_param_plus
  #--------------------------------------------------------------------------
  def socket_item_param_plus(m, id)
    m.effect(make_symbol(get_param_text(id)))
  end
  #--------------------------------------------------------------------------
  # * New method: socket_item_xparam
  #--------------------------------------------------------------------------
  def socket_item_xparam(id)
    all_socket_items.inject(0.0) do |r, m|
      r += socket_item_xparam_plus(m, id)
    end
  end
  #--------------------------------------------------------------------------
  # * New method: socket_item_xparam_plus
  #--------------------------------------------------------------------------
  def socket_item_xparam_plus(m, id)
    m.effect(make_symbol(get_xparam_text(id)))
  end
  #--------------------------------------------------------------------------
  # * New method: socket_item_sparam
  #--------------------------------------------------------------------------
  def socket_item_sparam(id)
    all_socket_items.inject(0.0) do |r, m|
      r += socket_item_sparam_plus(m, id)
    end
  end
  #--------------------------------------------------------------------------
  # * New method: socket_item_sparam_plus
  #--------------------------------------------------------------------------
  def socket_item_sparam_plus(m, id)
    m.effect(make_symbol(get_sparam_text(id)))
  end
  #--------------------------------------------------------------------------
  # * New method: equip_socket_item
  #--------------------------------------------------------------------------
  def equip_socket_item(slot, id)
    old = self.equips[0].sockets[slot][0]
    self.equips[0].sockets[slot] = [$game_party.socket_items[id]]
    $game_party.lose_socket_item(id)
    $game_party.gain_item(old, 1) if old != []
    refresh
  end
  #--------------------------------------------------------------------------
  # * New method: unequip_materia
  #--------------------------------------------------------------------------
  def unequip_socket_item(slot)
    $game_party.gain_item(self.equips[0].sockets[slot][0], 1)
    self.equips[0].sockets[slot] = []
    refresh
  end
end

#==============================================================================
# ** Game_Party
#==============================================================================

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  attr_reader   :socket_items
  #--------------------------------------------------------------------------
  # * Alias method: init_all_items
  #--------------------------------------------------------------------------
  alias :init_all_items_r2_socket_system :init_all_items
  def init_all_items
    init_all_items_r2_socket_system
    @socket_items = []
  end
  #--------------------------------------------------------------------------
  # * Alias method: gain_item
  #--------------------------------------------------------------------------
  alias :gain_item_r2_socket_system :gain_item
  def gain_item(item, amount, include_equip = false)
    if item && item.socket_item?
      gain_socket_item(item, amount)
    else
      gain_item_r2_socket_system(item, amount, include_equip)
    end
  end
  #--------------------------------------------------------------------------
  # * New method: gain_socket_item
  #--------------------------------------------------------------------------
  def gain_socket_item(item, amount = 1)
    if amount > 0
      socket_item = item.clone.setup_item_stats
      amount.times { @socket_items.push(socket_item) if !socket_items_max?}
    elsif amount < 0
      remove_socket_item(item, amount.abs)
    end
    @socket_items.sort! {|a, b| a.id <=> b.id }
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # * New method: remove_socket_item
  #--------------------------------------------------------------------------
  def remove_socket_item(item, amount = 1)
    amount.times do
      removed = false
      @socket_items.each_with_index do |m, i|
        if m.id == item.id && !removed
          removed = true
          break @socket_items.delete_at(i) 
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * New method: lose_materia
  #--------------------------------------------------------------------------
  def lose_socket_item(index)
    @socket_items.delete_at(index)
    @socket_items.sort! {|a, b| a.id <=> b.id }
  end
  #--------------------------------------------------------------------------
  # * New method: max_materia?
  #--------------------------------------------------------------------------
  def socket_items_max?
    @socket_items.size >= R2_Socket_Config::Max_Socket_Items
  end
end

#==============================================================================
# ** Scene_Shop
#------------------------------------------------------------------------------
#  This class performs shop screen processing.
#==============================================================================
class Scene_Shop < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Execute Sale
  #--------------------------------------------------------------------------
  alias r2_shop_sell_sockets      do_sell
  def do_sell(number)
    if @item.sockets?
      @item.sockets.each do |i, itm|
        next if itm == []
        $game_party.gain_socket_item(itm[0], 1)
      end
    end
    r2_shop_sell_sockets(number)
  end
end

#==============================================================================
# ** Window_SocketInfo
#------------------------------------------------------------------------------
#  This window shows the socket item information.
#==============================================================================

class Window_SocketInfo < Window_Base
  #--------------------------------------------------------------------------
  # * initialize
  #--------------------------------------------------------------------------
  def initialize(width, height)
    super(0, 200, width, height)
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
    draw_vertical_line_ex(R2_Socket_Config::Vertical_Line_X, 0, Color.new(255,255,255,128), Color.new(0,0,0,64))
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
# ** Window_SocketList
#------------------------------------------------------------------------------
#  This window shows the socket list.
#==============================================================================

class Window_SocketList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :socket_window
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
# ** Window_SocketStatus
#------------------------------------------------------------------------------
#  This window shows the materias on the socket equip screen.
#==============================================================================

class Window_SocketStatus < Window_SocketList
  #--------------------------------------------------------------------------
  # * initialize
  #--------------------------------------------------------------------------
  def initialize
    super(window_x, 200, 192, window_height)
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
    216 + [Graphics.height - 416, 0].max
  end
  #--------------------------------------------------------------------------
  # * make_item_list
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $game_party.socket_items.collect {|socket_item| socket_item }
    @data.push(nil)
  end
end

#==============================================================================
# ** Window_SocketActor
#------------------------------------------------------------------------------
#  This window shows the actor status on the socket equip screen.
#==============================================================================

class Window_SocketActor < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :actor
  #--------------------------------------------------------------------------
  # * initialize
  #--------------------------------------------------------------------------
  def initialize
    @equip = 0
    super(0, 0, Graphics.width, 128)
    @index = 0
  end
  #--------------------------------------------------------------------------
  # * actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    draw_face(actor.face_name, actor.face_index, 4, 4)
    draw_actor_name(actor, 104, line_height * 0)
    draw_actor_level(actor, 104, line_height * 1)
    draw_actor_hp(actor, 104, line_height * 2)
    draw_actor_mp(actor, 104, line_height * 3)
  end
end

#==============================================================================
# ** Window_Socket_Item_Equip
#------------------------------------------------------------------------------
#  This window shows the actor equipe sockets. Do not show the window frame.
#==============================================================================

class Window_Socket_Item_Equip < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :equip  
  attr_reader   :actor
  attr_reader   :socket_window
  #--------------------------------------------------------------------------
  # * initialize
  #--------------------------------------------------------------------------
  def initialize
    @equip = 0
    super(window_x, 0, Graphics.width - window_x, 128)
    @index = 0
  end
  #--------------------------------------------------------------------------
  # * item_max
  #--------------------------------------------------------------------------
  def item_max
    return 1
  end
  #--------------------------------------------------------------------------
  # * contents_width
  #--------------------------------------------------------------------------
  def contents_width
    width - standard_padding * 2
  end
  #--------------------------------------------------------------------------
  # * contents_height
  #--------------------------------------------------------------------------
  def contents_height
    48
  end
  #--------------------------------------------------------------------------
  # * update_padding_bottom
  #--------------------------------------------------------------------------
  def update_padding_bottom
  end
  #--------------------------------------------------------------------------
  # * actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * socket_item
  #--------------------------------------------------------------------------
  def socket_item
    return [] if @actor.equips[0].nil?
    slots = actor.equips[0].sockets? ? actor.equips[0].sockets : []
    slots ? slots[index] : slots
  end
  #--------------------------------------------------------------------------
  # * slot_width
  #--------------------------------------------------------------------------
  def slot_width
    max_slots * 32
  end
  #--------------------------------------------------------------------------
  # * max_slots
  #--------------------------------------------------------------------------
  def max_slots
    return 0 if @actor.nil?
    return 0 if @actor.equips[0].nil?
    @actor.equips[0].sockets? ? actor.equips[0].sockets.size : 0
  end
  #--------------------------------------------------------------------------
  # * window_x
  #--------------------------------------------------------------------------
  def window_x
    return 160
  end
  #--------------------------------------------------------------------------
  # * refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    create_contents
    self.opacity = 0
    draw_equipments(8 + window_x)
    draw_socket_items(28 + window_x)
  end
  #------------------------------------------------------------------------------
  # * draw_equipments 
  #------------------------------------------------------------------------------
  def draw_equipments(x)
    item = actor.equips[0]
    draw_item_name(item, x, y)
  end
  #------------------------------------------------------------------------------
  # * draw_socket_items
  #------------------------------------------------------------------------------
  def draw_socket_items(x)
    draw_background(x)
    draw_slots(x)
    draw_socket_item_icons(x)
  end
  #------------------------------------------------------------------------------
  # * draw_background
  #------------------------------------------------------------------------------
  def draw_background(x)
    color = Color.new(0, 0, 0, 50)
    actor.equip_slots.size.times do |i|
      contents.fill_rect(x - 4, i * 50 + 26, slot_width, 22, color)
    end
  end
  #------------------------------------------------------------------------------
  # * draw_slots
  #------------------------------------------------------------------------------
  def draw_slots(x)
    return unless actor.equips[0]
    return unless actor.equips[0].sockets?
    icon1 = R2_Socket_Config::Slot_Icon_Nothing
    actor.equips[0].sockets.each {|y, i| draw_icon(icon1, x + y * 32, 24) }
  end
  #------------------------------------------------------------------------------
  # * draw_socket_item_icons
  #------------------------------------------------------------------------------
  def draw_socket_item_icons(x)
    return unless actor.equips[0]
    return unless actor.equips[0].sockets?
    actor.equips[0].sockets.each do |y, m|
      next if m == []
      draw_socketed_item(m[0].icon_index, x + y * 32, 24, m, 200) if m
    end
  end
  #--------------------------------------------------------------------------
  # * draw_socketed_items
  #--------------------------------------------------------------------------
  def draw_socketed_item(icon_index, x, y, item, opacity = 255)
    bitmap = Cache.system("Iconset")
    rect   = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    contents.blt(x, y, bitmap, rect, opacity)
  end
  #--------------------------------------------------------------------------
  # * equip
  #--------------------------------------------------------------------------
  def equip=(equip)
    @equip = equip
    update_cursor
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * update_cursor
  #--------------------------------------------------------------------------
  def update_cursor
    ensure_cursor_visible
    cursor_rect.set(item_rect(@index, @equip))
  end
  #--------------------------------------------------------------------------
  # * item_rect
  #--------------------------------------------------------------------------
  def item_rect(index, equip)
    rect = Rect.new
    rect.width  = 26
    rect.height = 26
    rect.x  = index * 32 + 27 + window_x
    rect.y  = equip * 50 + 24
    self.oy = (equip - equip % 2) * 50
    rect
  end
  #--------------------------------------------------------------------------
  # * cursor_down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    return if max_slots == 0
    self.index += 1
    self.index %= max_slots
  end
  #--------------------------------------------------------------------------
  # * cursor_up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    return if max_slots == 0
    self.index -= 1
    self.index %= max_slots
  end
  #--------------------------------------------------------------------------
  # * cursor_right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    return if max_slots == 0
    self.index += 1
    self.index %= max_slots
  end
  #--------------------------------------------------------------------------
  # * cursor_left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    return if max_slots == 0
    self.index -= 1
    self.index %= max_slots
  end
  #--------------------------------------------------------------------------
  # * current_item_enabled?
  #--------------------------------------------------------------------------
  def current_item_enabled?
    return false if actor.equips[0].nil?
    return false unless actor.equips[0].sockets?
    index < actor.equips[0].sockets.size
  end
  #--------------------------------------------------------------------------
  # * process_handling
  #--------------------------------------------------------------------------
  def process_handling
    return unless open? && active
    return process_clear  if Input.trigger?(:A)
    super 
  end
  #--------------------------------------------------------------------------
  # * socket_window=
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
    return if @socket_item.nil? || @socket_item == []
    @help_window.set_item(socket_item)
  end
end

#==============================================================================
# ** Scene_Socket_System
#------------------------------------------------------------------------------
#  This class performs the materia equip screen processing.
#==============================================================================

class Scene_Socket_System < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * start
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_socket_item_window
    create_status_window
    create_equip_window
    create_item_window
  end
  #--------------------------------------------------------------------------
  # * create_help_window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_Help.new(2)
    @help_window.viewport = @viewport
    @help_window.y = 128
  end
  #--------------------------------------------------------------------------
  # * create_materia_window
  #--------------------------------------------------------------------------
  def create_socket_item_window
    ww = 352 + [Graphics.width - 544, 0].max
    wh = 216 + [Graphics.height - 416, 0].max
    @socket_item_window = Window_SocketInfo.new(ww, wh)
    @socket_item_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * create_status_window
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_SocketActor.new
    @status_window.actor = @actor
    @status_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * create_equip_window
  #--------------------------------------------------------------------------
  def create_equip_window
    @equip_window = Window_Socket_Item_Equip.new
    @equip_window.actor = @actor
    @equip_window.viewport = @viewport
    @equip_window.help_window = @help_window
    @equip_window.socket_window = @socket_item_window
    @equip_window.set_handler(:ok,       method(:command_equip))
    @equip_window.set_handler(:cancel,   method(:return_scene))
    @equip_window.set_handler(:pagedown, method(:next_actor))
    @equip_window.set_handler(:pageup,   method(:prev_actor))
    @equip_window.activate
  end
  #--------------------------------------------------------------------------
  # * create_item_window
  #--------------------------------------------------------------------------
  def create_item_window
    @item_window = Window_SocketStatus.new
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.socket_window = @socket_item_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @item_window.refresh
  end
  #--------------------------------------------------------------------------
  # * command_equip
  #--------------------------------------------------------------------------
  def command_equip
    @item_window.activate
    @item_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * on_actor_change
  #--------------------------------------------------------------------------
  def on_actor_change
    @equip_window.actor  = @actor
    @status_window.actor = @actor
    @item_window.refresh
    @socket_item_window.refresh
    @equip_window.activate
  end
  #--------------------------------------------------------------------------
  # * on_item_ok
  #--------------------------------------------------------------------------
  def on_item_ok
    Sound.play_equip
    if @item_window.socket_item
      @actor.equip_socket_item(@equip_window.index, @item_window.index)
    else
      @actor.unequip_socket_item(@equip_window.index)
    end
    @item_window.refresh
    @equip_window.refresh
    @status_window.refresh
    @socket_item_window.refresh
    @equip_window.activate
    @item_window.unselect
  end
  #--------------------------------------------------------------------------
  # * on_item_cancel
  #--------------------------------------------------------------------------
  def on_item_cancel
    @equip_window.activate
    @item_window.unselect
  end
end
