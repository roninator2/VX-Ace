#==============================================================================
#
# ▼ Triacular - Steal Shop v1.06
# -- Last Updated: 2019.03.13
# -- Level: Easy, Normal
# -- Requires: n/a
#
#==============================================================================
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script allows stealing of items in scene shop, made for RPG Maker VX Ace.
#
# Please give credit to Triacular
# free for non-commercial and commercial uses
#==============================================================================
($imported ||= {})[:Triacular_ShopSteal] = 1.06
#==============================================================================
# ▼ Versions Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2019-01-26 - Initial script                         - Triacular
# 2019-01-27 - Reduced duplicate parts                - Triacular
# 2019-02-12 - Added switch to disable script         - Triacular
# 2019-02-13 - Added alias, removed global switches   - Roninator2
# 2019-03-03 - Changed to not show the number window  - Roninator2
# 2019-03-13 - Several Changes. Listed below          - CaRaCrAzY_Petrassi
#   ▼ [Compatibility]
#     Moved all classes inside a namespace module
#     Changed the use of Aliasing to Method Wrapping     
#     Added a component module for wrapping extension objects
#     Moved all Scene_Shop's new methods to an extension class
#     Added version data to $imported global variable
#   ▼ [Convenience]
#     Moved constants to the module root
#     Transformed the DICE constant into VARIABLE_STEAL_BONUS
#   ▼ [Features]
#     Displays the Stealing Success rate insteand of item's price.
#     Added a constant for controling the [steal] command's position in the list
#     Added a switch to enable or disable steal command mid-game
#     Added a constant for inputing a formula for General Stealing Success Rate
#     Entries in the shop that has zero percent chance of stealing are disabled
#     Added notetag support for editing Custom Stealing Success Rate formulas
#==============================================================================
#==============================================================================
# ▼ Notetags
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script support the following notetags:
#
#-------------------------------------------------------------------------------
#   <steal: x>
#-------------------------------------------------------------------------------
#   This will add a custom calculation method for a particular item. This
#   means that the default Success Rate formula will be replaced for this one.
#     x : formula
#
#   Considerations about the Formula:
#   The formula is an actual piece of code that will be evaluated, its final
#   output must be a number between zero and one that will be converted into a
#   percentage; and these are the following values that will be passed to it:
#     a : Game Party   (Same thing as $game_party)
#     b : item         (The item itself)
#     p : item's price (converted to float, used for calculating divisions)
#
#   Examples:
#   <steal: a.agi / p> 
#   <steal: 0.5>
#   <steal: a.agi / (a.agi + p / 10.0)>
#==============================================================================

#===============================================================================
# ** TRIACULAR
#-------------------------------------------------------------------------------
#   Module used for namespacing the Shop Steal System
#   Everything about this system is contained inside this module.
#===============================================================================

module TRIACULAR
  #-----------------------------------------------------------------------------
  # * ID of the Switch that enables the script
  #-----------------------------------------------------------------------------
  SWITCH_ENABLE        = 22     
 
  #-----------------------------------------------------------------------------
  # * ID of the Switch that will become ON when stealing fails
  #-----------------------------------------------------------------------------
  SWITCH_STEAL         = 21     

  #-----------------------------------------------------------------------------
  # * ID of the Switch that enable/disable the shop's [Steal] command at runtime
  #-----------------------------------------------------------------------------
  SWITCH_COMMAND       = 23     

  #-----------------------------------------------------------------------------
  # * ID of the Variable responsible for giving a percent bonus to steal chance
  #-----------------------------------------------------------------------------
  VARIABLE_STEAL_BONUS = 20     
 
  #-----------------------------------------------------------------------------
  # * [Steal] command's name in the Shop's command list
  #-----------------------------------------------------------------------------
  VOCAB_STEAL          = "Steal" 
 
  #-----------------------------------------------------------------------------
  # * Steal command's position at Shop's command list
  #   Useful if you want the [Steal] command to appear between [Buy] or [Sell]
  #-----------------------------------------------------------------------------
  COMMAND_POSITION     = 2       
 
  #-----------------------------------------------------------------------------
  # * Dynamically increases the number of columns in Shop's command list to fit
  #   the [Steal] command entry.
  #-----------------------------------------------------------------------------
  DYNAMIC_COL_COUNT    = true   
 
  #-----------------------------------------------------------------------------
  # * General Stealing Success Rate formula usef for all items lacking a Custom
  #   Stealing Formula notetag.
  #-----------------------------------------------------------------------------
  #     a : Game Party (Same thing as $game_party)
  #     b : item
  #     p : item's price (converted to float, used for calculating divisions)
  #-----------------------------------------------------------------------------
  STEAL_FORMULA        = "a.agi / p"
 
  #-----------------------------------------------------------------------------
  # * Maximum Stealing Rate chance
  #-----------------------------------------------------------------------------
  STEAL_RATE_CAP       = 0.9
 
  #=============================================================================
  # ** Component
  #-----------------------------------------------------------------------------
  #  Component used to avoid poluting the engine classes with new methods.
  #=============================================================================
 
  module Component
    #---------------------------------------------------------------------------
    # * Forwards calls from a class public interface through an attribute
    #---------------------------------------------------------------------------
    #   Public instance method calls from a given class are forwarded to the
    #   given attribute.
    #
    #   By design, method calls from super classes are not forwarded. You 
    #   should explicitly invoke this command again for each super class you 
    #   need its calls forwarded.
    #---------------------------------------------------------------------------
    def forward(klass, attribute)
      klass.public_instance_methods(false).each do |meth|
        define_method(meth) { |*args| self.send(attribute).send(meth, *args) }
      end
    end
    #---------------------------------------------------------------------------
    # * Adds itself as a component attribute into a compositor class
    #---------------------------------------------------------------------------
    #   This command is equivalent to reopenning a class definition and adding
    #   a getter for lazily loading and retrieving a component's instance.
    #
    #   That means every instance of a composite class will wrap a lazy loaded
    #   component instance through an automatically generated attribute.
    #---------------------------------------------------------------------------
    def compose(composite, attr_name)
      component = self
      body = eval("proc { @#{attr_name} ||= component.new(self) }")
      composite.send(:define_method, attr_name) { instance_eval(&body) }
    end
    #---------------------------------------------------------------------------
    # * Generates attribute readers for getting forwarded instance variables
    #---------------------------------------------------------------------------
    #   This method really breaks incapsulation. Use it only when dealing with
    #   compositors that lack attr_readers.
    #---------------------------------------------------------------------------
    def forward_reader(compositor, *args)
      args.each do |variable| 
        define_method(variable) do
          self.send(compositor).instance_variable_get("@#{variable}".to_sym) 
        end
      end
    end
  end
 
  #==============================================================================
  # ** Window_ShopCommand
  #------------------------------------------------------------------------------
  #  Wraping and redefining methods inside Window_ShopCommand class
  #==============================================================================
 
  class ::Window_ShopCommand
    #---------------------------------------------------------------------------
    # * Wraping Methods for redefinition
    #---------------------------------------------------------------------------
    old_make_command_list = instance_method :make_command_list 
    old_col_max           = instance_method :col_max
    #---------------------------------------------------------------------------
    # * Redefining method
    #---------------------------------------------------------------------------
    #   Updates the shining command effect
    #---------------------------------------------------------------------------
    define_method :make_command_list do |*args|
      expectations = old_make_command_list.bind(self).(*args)
      return expectations unless $game_switches[SWITCH_ENABLE]
      command = {
        name:    VOCAB_STEAL,
        symbol:  :steal,
        enabled: $game_switches[SWITCH_COMMAND],
      }
      @list.insert([[COMMAND_POSITION, 0].max, @list.size].min, command)
      expectations
    end 
    #--------------------------------------------------------------------------
    # * Get Digit Count
    #--------------------------------------------------------------------------
    define_method :col_max do |*args|
      old_col_max.bind(self).(*args) + ($game_switches[SWITCH_ENABLE] ? 1 : 0)
    end if DYNAMIC_COL_COUNT
  end
 
  #=============================================================================
  # ** Scene_Shop
  #-----------------------------------------------------------------------------
  #   Wraping and redefining methods inside Scene_Shop class
  #=============================================================================

  class ::Scene_Shop
    #---------------------------------------------------------------------------
    # * Wraping Methods for redefinition
    #---------------------------------------------------------------------------
    old_start                 = instance_method :start
    old_create_command_window = instance_method :create_command_window
    #---------------------------------------------------------------------------
    # * Redefining method
    #---------------------------------------------------------------------------
    #   Adding Steal Window creation to scene Start
    #---------------------------------------------------------------------------
    define_method :start do |*args|
      expectations  = old_start.bind(self).(*args)
      wy            = @dummy_window.y
      wh            = @dummy_window.height
      @steal_window = Window_ShopSteal.new(0, wy, wh, @goods)
      triacular_shopsteal.create_steal_window
      expectations
    end
    #---------------------------------------------------------------------------
    # * Redefining method
    #---------------------------------------------------------------------------
    # * Adding :steal handler to command window
    #---------------------------------------------------------------------------
    define_method :create_command_window do |*args|
      expectations = old_create_command_window.bind(self).(*args)
      meth         = triacular_shopsteal.method(:command_steal)
      @command_window.set_handler(:steal, meth)
      expectations
    end
  end
 
  #=============================================================================
  # ** Stealable_Item
  #-----------------------------------------------------------------------------
  #  Class containing steal data to be inserted into RPG::BaseItem
  #  Used almost exclusively to extract notetags about stealing.
  #=============================================================================
 
  class Stealable_Item
    #---------------------------------------------------------------------------
    # * Macros
    #---------------------------------------------------------------------------
    extend  Component                       
    compose RPG::BaseItem, :triacular_shopsteal 
    forward RPG::BaseItem, :item           
    #---------------------------------------------------------------------------
    # * Public instance attributes
    #---------------------------------------------------------------------------
    attr_reader :item # BaseItem wrapping this object
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    def initialize(item)
      @item = item
    end
    #-------------------------------------------------------------------------
    # * Calculates the chances of stealing this item
    #-------------------------------------------------------------------------
    def rate
      rate = steal_rate_formula.($game_party, item, item.price.to_f)
      rate += $game_variables[VARIABLE_STEAL_BONUS] / 100.0
      [[rate, 0].max, STEAL_RATE_CAP].min
    end
   
    private
    #---------------------------------------------------------------------------
    # * Formula for calculating the chances of stealing this item from a shop
    #---------------------------------------------------------------------------
    def steal_rate_formula
      @steal_rate_formula ||= retrieve_steal_rate_data
    end
    #---------------------------------------------------------------------------
    # * Steal Rate formula from a retrieved notetag
    #---------------------------------------------------------------------------
    def retrieve_steal_rate_data
      if match_data = steal_rate_tag
        eval("lambda {|a, b, p| #{match_data[:value]} }")
      else
        Steal.default_rate
      end
    end
    #---------------------------------------------------------------------------
    # * Match_data from all matches of <steal: formula>
    #---------------------------------------------------------------------------
    def steal_rate_tag
      Notetag.scan_tags(note, :steal, :single).first
    end
  end

  #=============================================================================
  # ** Window_ShopSteal
  #-----------------------------------------------------------------------------
  #  This window displays a list of steal goods on the shop screen.
  #=============================================================================

  class Window_ShopSteal < Window_Selectable
    #--------------------------------------------------------------------------
    # * Public Instance Variables
    #--------------------------------------------------------------------------
    attr_reader :status_window # Status window
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(x, y, height, shop_goods)
      super(x, y, window_width, height)
      @shop_goods = shop_goods
      refresh
      select(0)
    end
    #--------------------------------------------------------------------------
    # * Get Window Width
    #--------------------------------------------------------------------------
    def window_width
      return 304
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
      @data[index]
    end
    #--------------------------------------------------------------------------
    # * Get Activation State of Selection Item
    #--------------------------------------------------------------------------
    def current_item_enabled?
      enable?(@data[index])
    end
    #--------------------------------------------------------------------------
    # * Get Price of Item
    #--------------------------------------------------------------------------
    def price(item)
      @price[item]
    end
    #--------------------------------------------------------------------------
    # * Display in Enabled State?
    #--------------------------------------------------------------------------
    def enable?(item)
      item && price(item) > 0 && !$game_party.item_max?(item)
    end
    #--------------------------------------------------------------------------
    # * Refresh
    #--------------------------------------------------------------------------
    def refresh
      make_item_list
      create_contents
      draw_all_items
    end
    #--------------------------------------------------------------------------
    # * Create Item List
    #--------------------------------------------------------------------------
    def make_item_list
      containers = [$data_items, $data_weapons, $data_armors]
      @data = @shop_goods.map { |goods| item = containers[goods[0]][goods[1]] }
      @price = Hash[@data.map { |item| [item, item.triacular_shopsteal.rate] }]
    end
    #--------------------------------------------------------------------------
    # * Draw Item
    #--------------------------------------------------------------------------
    def draw_item(index)
      item = @data[index]
      rect = item_rect(index)
      draw_item_name(item, rect.x, rect.y, enable?(item))
      rect.width -= 4
      draw_text(rect, "#{(price(item) * 100).to_i}%", 2)
    end
    #--------------------------------------------------------------------------
    # * Set Status Window
    #--------------------------------------------------------------------------
    def status_window=(status_window)
      @status_window = status_window
      call_update_help
    end
    #--------------------------------------------------------------------------
    # * Update Help Text
    #--------------------------------------------------------------------------
    def update_help
      @help_window.set_item(item) if @help_window
      @status_window.item = item if @status_window
    end
  end
 
  #=============================================================================
  # ** Steal
  #-----------------------------------------------------------------------------
  #  Class containing additional data to be inserted into Scene_Shop
  #=============================================================================
 
  module Steal
    #-------------------------------------------------------------------------
    # * Default Stealing Success formula defined at the start of the script.
    #   This formula is used for items lacking a <steal:formula> Notetag.
    #-------------------------------------------------------------------------
    def self.default_rate
      @default_rate ||= eval("lambda {|a, b, p| #{STEAL_FORMULA} }")
    end
  end
 
  #=============================================================================
  # ** Scene_ShopSteal
  #-----------------------------------------------------------------------------
  #  Class containing additional data to be inserted into Scene_Shop
  #=============================================================================
 
  class Scene_ShopSteal
    #---------------------------------------------------------------------------
    # * Macros
    #---------------------------------------------------------------------------
    extend  Component               
    compose Scene_Shop    , :triacular_shopsteal         
    forward Scene_Shop    , :scene 
    forward Scene_MenuBase, :scene 
    forward Scene_Base    , :scene 
    #--------------------------------------------------------------------------
    # * Public Instance Attributes
    #--------------------------------------------------------------------------
    forward_reader :scene, :command_window, :help_window, :dummy_window
    forward_reader :scene, :status_window , :goods      , :viewport
    forward_reader :scene, :steal_window
    #---------------------------------------------------------------------------
    # * Public instance attributes
    #---------------------------------------------------------------------------
    attr_reader :scene # Scene wraping this object. The compositor.
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    def initialize(scene)
      @scene = scene
    end
    #--------------------------------------------------------------------------
    # * Create Steal Window
    #--------------------------------------------------------------------------
    def create_steal_window
      steal_window.viewport      = viewport
      steal_window.help_window   = help_window
      steal_window.status_window = status_window
      steal_window.hide
      steal_window.set_handler(:ok,     method(:on_steal_ok))
      steal_window.set_handler(:cancel, method(:on_steal_cancel))
    end
    #--------------------------------------------------------------------------
    # * The current selected item
    #--------------------------------------------------------------------------
    def item
      steal_window.item
    end
    #--------------------------------------------------------------------------
    # * [Steal] Command
    #--------------------------------------------------------------------------
    def command_steal
      dummy_window.hide
      activate_steal_window
    end
    #--------------------------------------------------------------------------
    # * Category Steal [Cancel]
    #--------------------------------------------------------------------------
    def on_steal_cancel
      command_window.activate
      dummy_window.show
      steal_window.hide
      status_window.hide
      status_window.item = nil
      help_window.clear
    end
    #--------------------------------------------------------------------------
    # * Category Steal [OK]
    #--------------------------------------------------------------------------
    def on_steal_ok
      do_steal(1)
    end
    #--------------------------------------------------------------------------
    # * Quantity Input [OK]
    #--------------------------------------------------------------------------
    def activate_steal_window
      steal_window.show.activate
      status_window.show
    end
    #--------------------------------------------------------------------------
    # * Execute Steal
    #--------------------------------------------------------------------------
    def do_steal(number)
      if rand <= item.triacular_shopsteal.rate
        $game_party.gain_item(item, number)
        activate_steal_window
      else
        $game_switches[SWITCH_STEAL] = true
        SceneManager.goto(Scene_Map)
      end
    end
  end
 
  #=============================================================================
  # ** Notetag
  #-----------------------------------------------------------------------------
  #  Module for extrating Notetags
  #=============================================================================
 
  module Notetag
    class << self
      #-------------------------------------------------------------------------
      # * Extracts notetag data matching the given pattern type
      #-------------------------------------------------------------------------
      #     note : The note field or string
      #     tag  : The tag's name i.e. :Expertise will search for <Expertise>
      #     type : The notetag's pattern (:plain, :single or :pair)
      #-------------------------------------------------------------------------
      def scan_tags(note, tag, type)
        note.to_enum(:scan, pattern(tag, type)).map { Regexp.last_match }
      end
     
      private
      #-------------------------------------------------------------------------
      # * Return a regex for the given pattern to match the given tag_name
      #-------------------------------------------------------------------------
      def pattern(tag, type)
        method(type).(tag)
      end
      #-------------------------------------------------------------------------
      # * Regex for retrieving a notetag containing only one value
      #     base format: <tag_name> or <tag_name:opt>
      #-------------------------------------------------------------------------
      def plain(tag_name)
        %r{
          (?: <\s*#{tag_name}\s*) # < tag_name    the tag name
          (?: :\s*(?<opt>  .+?))? # : optional    the optional value
          (?: \s*\/?>)            # />            the tag closing
        }ix
      end
      #-------------------------------------------------------------------------
      # * Regex for retrieving a notetag containing only one value
      #     base format: <tag_name:value> or <tag_name:value,opt>
      #-------------------------------------------------------------------------
      def single(tag_name)
        %r{
          (?: <\s*#{tag_name}\s*) # < tag_name    the tag name
          (?: :\s*(?<value>.+?))  # : value       the second value
          (?: ,\s*(?<opt>  .+?))? # , optional    the optional value
          (?: \s*\/?>)            # />            the tag closing
        }ix
      end
      #-------------------------------------------------------------------------
      # * Regex for retrieving a notetag containing two values
      #     base format: <tag_name:key,value> or <tag_name:key,value,opt>
      #-------------------------------------------------------------------------
      def pair(tag_name)
        %r{
          (?: <\s*#{tag_name}\s*) # < tag_name    the tag name
          (?: :\s*(?<key>  .+?))  # : key         the first value
          (?: ,\s*(?<value>.+?))  # , value       the second value
          (?: ,\s*(?<opt>  .+?))? # , optional    the optional value
          (?: \s*\/?>)            # />            the tag closing
        }ix
      end
    end
  end
end
