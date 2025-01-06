=begin
#=====================================================================
#   AMN V's Promotions - Add-on
#   Version 1.2
#   Author: AMoonlessNight
#   Date: 23 Mar 2018
#   Latest: 24 Mar 2018
#=====================================================================#
#   UPDATE LOG
#---------------------------------------------------------------------#
# 23 Mar 2018 - created the add-on script for V's Promotions
# 24 Mar 2018 - fixed level up and gain exp methods
#             - added greyed out colour for actors that are promotable
#               but don't have the correct items
#             - fixed gain exp method
#=====================================================================#

This script was requested as an add-on to V's Promotions script.
It will not work without it.

V's Promotions script can be found here:
https://forums.rpgmakerweb.com/index.php?threads/vs-promotion-system-v0-2.18875/

Requested by Roninator2

#=====================================================================#
          NOTETAGS
#=====================================================================#

Notetag actors as many times as you require with the following:

    * <Promotion: Level, Graphic_Name, Graphic_Index, Cost, Class, Item>
  #----------------------------------------------------------------#
  # Item is a new addition and should be replaced with the number
  # of the item that the party must have in order for this actor
  # to be promoted (e.g. 5 for Stimulant).
  #----------------------------------------------------------------#
 
=end


#==============================================================================
#
# ** Please do not edit below this point unless you know what you are doing.
#
#==============================================================================



#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It is used within the Game_Actors class
# ($game_actors) and is also referenced from the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler

  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :next_promotion_item             # Item needed to promote actor
  attr_accessor :next_promo_level                # The next promotion level

  #--------------------------------------------------------------------------
  # * Setup                                                  # ALIAS METHOD #
  #--------------------------------------------------------------------------
  alias :amn_vpromo_gameactor_setup :setup
  def setup(actor_id)
    @next_promotion_item = 0
    amn_vpromo_gameactor_setup(actor_id)
  end
 
  #--------------------------------------------------------------------------
  # * Gain EXP (Account for Experience Rate)
  #--------------------------------------------------------------------------
  alias :amn_vpromo_gameactor_gainexp :gain_exp
  def gain_exp(exp)
    req_exp = exp_for_level(next_promo_level?)
    value = self.exp + (exp * final_exp_rate).to_i
    if !at_promotion_level?
      if value < req_exp
        amn_vpromo_gameactor_gainexp(exp)
      else
        change_exp(req_exp, true)
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Change Experience
  #     show : Level up display flag
  #--------------------------------------------------------------------------
  def change_exp(exp, show)
    @exp[@class_id] = [exp, 0].max unless at_promotion_level?
    last_level = @level
    last_skills = skills
    level_up while !max_level? && self.exp >= next_level_exp
    level_down while self.exp < current_level_exp
    display_level_up(skills - last_skills) if show && @level > last_level
    refresh
  end
 
  #--------------------------------------------------------------------------
  # * Sets up the actor's note                           # OVERWRITE METHOD #
  #--------------------------------------------------------------------------
  def set_up_actor_note(actor_id)
    note= /<Promotion:\s*(\d*)\S*\s*(\w*)\S*\s*(\d*)\S*\s*(\d*)\S*\s*(\d*)\S*\s*(\d*)>/i
    @actors_note = $data_actors[actor_id].note.scan(note)
  end
 
  #--------------------------------------------------------------------------
  # * Check For Promotions                                   # ALIAS METHOD #
  #--------------------------------------------------------------------------
  alias amn_vpromo_checkforpromo  check_for_promotion
  def check_for_promotion
    amn_vpromo_checkforpromo &&
    @actors_note.size.times { |i| @next_promotion_item = @actors_note[i][5].to_i if @level == @actors_note[i][0].to_i }
  end
 
  #--------------------------------------------------------------------------
  # * Check Promotion Items                                    # NEW METHOD #
  #--------------------------------------------------------------------------
  def check_promotion_items
    return true if needs_promotion_item? && $game_party.items.include?($data_items[@next_promotion_item])
  end
 
  #--------------------------------------------------------------------------
  # * Needs Promotion Item?                                    # NEW METHOD #
  #--------------------------------------------------------------------------
  def needs_promotion_item?
    return false if @next_promotion_item == 0
    return true
  end
 
  #--------------------------------------------------------------------------
  # * Checks if actor is promotable                          # ALIAS METHOD #
  #--------------------------------------------------------------------------
  alias amn_vpromo_promotable?  promotable?
  def promotable?
    if needs_promotion_item?
      return true if check_promotion_items && @needs_promotion == true
    else
      amn_vpromo_promotable?
    end
  end
 
  #--------------------------------------------------------------------------
  # * Next Promotion Level                                     # NEW METHOD #
  #--------------------------------------------------------------------------
  def next_promo_level?
    array = []
    @actors_note.size.times { |i| array.push(@actors_note[i][0].to_i) }
    array.keep_if { |a| a > @level }
    array.sort
    if array.empty?
      @next_promo_level = max_level
    else
      @next_promo_level = array[0]
    end
  end
 
  #--------------------------------------------------------------------------
  # * At Promotion Level?                                      # NEW METHOD #
  #--------------------------------------------------------------------------
  # Had to do this in order for level up commands to work properly
  #--------------------------------------------------------------------------
  def at_promotion_level?
    amn_vpromo_promotable?
  end
 
  #--------------------------------------------------------------------------
  # * Promote Processing                                     # ALIAS METHOD #
  #--------------------------------------------------------------------------
  alias amn_vpromo_promote  promote
  def promote
    if @next_promotion_item > 0
      $game_party.lose_item($data_items[@next_promotion_item], 1)
    end
    amn_vpromo_promote
  end
 
  #--------------------------------------------------------------------------
  # * Promotion Items                                          # NEW METHOD #
  #--------------------------------------------------------------------------
  def promotion_items?
    return @next_promotion_item
  end
 
end

#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  An interpreter for executing event commands. This class is used within the
# Game_Map, Game_Troop, and Game_Event classes.
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Change EXP
  #--------------------------------------------------------------------------
  alias amn_vpromo_gameint_cmd315   command_315
  def command_315
    value = operate_value(@params[2], @params[3], @params[4])
    iterate_actor_var(@params[0], @params[1]) do |actor|
      req_exp = actor.exp_for_level(actor.next_promo_level?)
      if !actor.at_promotion_level?
        if value < req_exp
          actor.change_exp(actor.exp + value, @params[5])
        else
          actor.change_exp(req_exp, @params[5])
        end
      end
    end
  end
 
  #--------------------------------------------------------------------------
  # * Change Level
  #--------------------------------------------------------------------------
  alias amn_vpromo_gameint_cmd316   command_316
  def command_316
    value = operate_value(@params[2], @params[3], @params[4])
    iterate_actor_var(@params[0], @params[1]) do |actor|
      if !actor.at_promotion_level?
        if value < actor.next_promo_level?
          actor.change_level(actor.level + value, @params[5])
        else
          actor.change_level(actor.next_promo_level, @params[5])
        end
      end
    end
  end
 
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This is a super class of all windows within the game.
#==============================================================================

class Window_Base < Window
 
  def greyout_colour;    text_color(7);  end;    # Greyed out

  #--------------------------------------------------------------------------
  # * Draw Level
  #--------------------------------------------------------------------------
  alias :amn_vpromo_windbase_drawactorlevel   :draw_actor_level
  def draw_actor_level(actor, x, y)
    amn_vpromo_windbase_drawactorlevel(actor, x, y)
    if actor.promotable?
      draw_v_text(x, y + 25, 150, line_height, "Promotable", 0, 24, crisis_color)
    elsif actor.at_promotion_level? && !actor.promotable?
      draw_v_text(x, y + 25, 150, line_height, "Promotable", 0, 24, greyout_colour)
    end
  end
 
end

#==============================================================================
# ** Promotion_Info_Window
#------------------------------------------------------------------------------
#  This class handles all of the Promotion Info Window processing.
#==============================================================================

class Promotion_Info_Window < Window_Base
    
  #--------------------------------------------------------------------------
  # * Draws actors info                                  # OVERWRITE METHOD #
  #--------------------------------------------------------------------------
  def draw_actor_info(index)
    actor = @promotables[@index]
    cost = "Cost: " + actor.promotion_cost?.to_s
    # AMN addition
    if actor.next_promotion_item > 0
      item = $data_items[actor.next_promotion_item]
      icon = '\i[' + item.icon_index.to_s + '] '
      name = item.name.to_s + ' '
      amt = $game_party.item_number(item)
      if amt == 0
        itemtxt = icon + name + '\c[2]' + amt.to_s + '\c[2] / 1'
      else
        itemtxt = icon + name + amt.to_s + ' / 1'
      end
      
    else
      itemtxt = ''
    end
    #
    draw_v_text(120, 55, (Graphics.width / 3) * 2, 75, actor.name, 0, 45)
    draw_actor_face(actor, 10, 10)
    draw_zoomed_actor_graphic(actor, 40, 150, 2)
    draw_v_text(-105, 200, (Graphics.width / 3) * 2, 75, $data_classes[actor.class_id].name, 1, 22)
    draw_v_text(-10, 150, (Graphics.width / 3) * 2, 75, ">", 1, 55)
    draw_zoomed_character(actor.next_promotion_name, actor.next_promotion_index, 230, 150, 2)
    draw_v_text(85, 200, (Graphics.width / 3) * 2, 75, $data_classes[actor.next_promotion_class].name, 1, 22)
    draw_v_text(-10, 250, (Graphics.width / 3) * 2, 75, cost, 1, 40)
    draw_text_ex(10, 250, itemtxt)
  end
 
end

#==============================================================================
# ** Promotion_Command_Window
#------------------------------------------------------------------------------
#  This class handles all of the Promotion Command Window processing.
#==============================================================================

class Promotion_Command_Window < Window_Command
    
  #--------------------------------------------------------------------------
  # * Checks if party has enough to buy promotion            # ALIAS METHOD #
  #--------------------------------------------------------------------------
  alias amn_vpromo_promocmdwdw_afford?      afford?
  def afford?(id)
    if @promotables[id].promotion_items? != 0
      $game_party.gold >= @promotables[id].promotion_cost? && $game_party.items.include?($data_items[@promotables[id].promotion_items?])
    else
      $game_party.gold >= @promotables[id].promotion_cost?
    end
    
  end
end 
