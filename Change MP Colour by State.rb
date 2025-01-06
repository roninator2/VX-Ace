# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Change MP Bar Colour                   ║  Version: 1.1      ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Display different colours by state            ║    13 May 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║   Displays the MP bar in another colour when the                   ║
# ║   battler is inflicted with a state note tagged.                   ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║ Place the following note tag on the state that will                ║
# ║ change the MP bar colour                                           ║
# ║ <state color: 0, 0>                                                ║
# ║ This will make the MP bar show as white                            ║
# ║ The numbers are from the VX Ace colour wheel                       ║
# ║                                                                    ║
# ║ The first number is for the state of the bar,                      ║
# ║ The second number is for the end of the bar.                       ║
# ║ By default the mp bar colours are 22, 23                           ║
# ║                                                                    ║
# ║  0 - white,         1 - medium blue,   2 - red-orange              ║
# ║  3 - light green,   4 - light blue,    5 - light purple            ║
# ║  6 - yellow-orange, 7 - medium grey,   8 - light grey              ║
# ║  9 - deep blue.    10 - red,          11 - deep green              ║
# ║ 12 - blue,         13 - purple-blue,  14 - orange-yellow           ║
# ║ 15 - black,        16 - blue-purple,  17 - yellow                  ║
# ║ 18 - deep red,     19 - dark grey,    20 - orange                  ║
# ║ 21 - light orange, 22 - dark blue,    23 - bright blue             ║
# ║ 24 - bright green, 25 - brown,        26 - blue-purple-red         ║
# ║ 27 - pink,         28 - deep green,   29 - green                   ║
# ║ 30 - deep purple,  31 - purple                                     ║
# ║                                                                    ║
# ║ The second value to use is optional                                ║
# ║    <state color order: 3>                                          ║
# ║ This will make the priority of this state colour change            ║
# ║ take third priority. So if state 2 is applied and is               ║
# ║ priority 4, then state 6 is applied and is priority 3,             ║
# ║ state 2 will stay the colour and it will not change to             ║
# ║ state 6. Without this state 6 would take over and apply            ║
# ║ it's colour change as it is further down in order.                 ║
# ║ NOTE*                                                              ║
# ║ If you use the second note tag in only a few states,               ║
# ║ you may not get the desired results.                               ║
# ║                                                                    ║
# ║ This was as best my eye and monitor could see the colours          ║
# ║ You can search for VX ACE color codes for a second look.           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 13 May 2021 - Script finished                               ║
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

module R2_MP_Colour_Change
  MP_STATE_COLOUR = /<state[-_ ]color:[ ](\d+),[ ](\d+)>/i
  MP_COLOUR_ORDER = /<state[-_ ]color[-_ ]order:[ ](\d+)>/i
end
# Color.new(255, 255, 255, 255)
module DataManager
  
  class <<self; alias load_database_original_state_colour load_database; end
  def self.load_database
    load_database_original_state_colour
    load_notetags_mp_colour
  end
  
  def self.load_notetags_mp_colour
    for state in $data_states
      next if state.nil?
      state.load_notetags_mp_colour
    end
  end
  
end # DataManager

class RPG::State < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :state_mp_colour
  attr_accessor :state_mp_colour_order
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_sani
  #--------------------------------------------------------------------------
  def load_notetags_mp_colour
    @state_mp_colour = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when R2_MP_Colour_Change::MP_STATE_COLOUR
        @state_mp_colour = [$1.to_i, $2.to_i]
      when R2_MP_Colour_Change::MP_COLOUR_ORDER
        @state_mp_colour_order = $1.to_i
      end
    } # self.note.split
    #---
  end
  
end # RPG::State

class Window_Base < Window
  def draw_actor_mp(actor, x, y, width = 124)
    @colour_order = 0
    @previous_colour = []
    draw_gauge(x, y, width, actor.mp_rate, mp_gauge_color1, mp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::mp_a)
    actor.states.each do |state|
      if !state.state_mp_colour.empty?
        if !state.state_mp_colour_order.nil? && @colour_order < state.state_mp_colour_order
          draw_gauge(x, y, width, actor.mp_rate, text_color(state.state_mp_colour[0]), text_color(state.state_mp_colour[1]))
          change_color(text_color(state.state_mp_colour[1]))
          draw_text(x, y, 30, line_height, Vocab::mp_a)
        else
          state.state_mp_colour = @previous_colour if !@previous_colour.empty?
          draw_gauge(x, y, width, actor.mp_rate, text_color(state.state_mp_colour[0]), text_color(state.state_mp_colour[1]))
          change_color(text_color(state.state_mp_colour[1]))
          draw_text(x, y, 30, line_height, Vocab::mp_a)
        end
      end
      @colour_order = state.state_mp_colour_order
      @previous_colour = state.state_mp_colour
    end
    draw_current_and_max_values(x, y, width, actor.mp, actor.mmp,
      mp_color(actor), normal_color)
  end
end
