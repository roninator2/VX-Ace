=begin
#==============================================================================
[Name] Display of remaining turns of state + α
[Author] Grilled paste
[Distributor] Relaxing Maker miscellaneous goods 
http://mata-tuku.ldblog.jp/
# ------------------------------------------------- -----------------------------
[Change log]・2012/10/28 public
・2012/12/01 Bug fixes. Added "Hide state icon with display priority 0" function
Modified by Roninator2 to change icon and not show number
#==============================================================================

#------------------------------------------------------------------------------
[Correspondence]
・ Only RGSS3 is possible
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
[function]
-Only during battle, the number of remaining turns of state and ability change 
is displayed on the icon.
-Hide the icon of the state where the display priority is 0.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
[how to use]
-There is no special operation. Just install this script and it will work.
#------------------------------------------------------------------------------

[Redefined part]
・Window_Base の draw_actor_icons
#------------------------------------------------------------------------------
[○: New definition, ◎: Alias definition, ●: Redefinition]
#------------------------------------------------------------------------------
=end

module R2_State_Icon_Turns
	Switch = 3 # switch used to change behavior from icon change to numbers.
  # set to zero to disable.
  # icon change is set to the number below
  Added = 2
  # the number is how many extra icons to use 
  # default = 3, Added = 3, inflicted = icon 5
end
#==============================================================================
# ■ Game_BattlerBase
#==============================================================================
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # ◎ Get the current state as an array of icon numbers
  #--------------------------------------------------------------------------
  alias yknr_ShowStatesTurnsGame_BattlerBase_state_icons :state_icons
  def state_icons
    states = self.states.select {|state| !state.priority.zero? }
    yknr_ShowStatesTurnsGame_BattlerBase_state_icons
  end
  #--------------------------------------------------------------------------
  # ○ Get the current state as an array of the number of remaining turns
  #--------------------------------------------------------------------------
  def state_turns
    turns = []
    states.each do |s|
      if !s.icon_index.zero?
        is_turn = !s.auto_removal_timing.zero? && !s.priority.zero?
        turn = is_turn ? @state_turns[s.id].truncate : -1
        turns.push(turn)
      end
    end
    turns
  end
  #--------------------------------------------------------------------------
  # ○ Get the current enhancement / 
  #   weakness in an array of the number of remaining turns
  #--------------------------------------------------------------------------
  def buff_turns
    turns = []
    @buffs.each_with_index do |lv, i|
      turns.push(@buff_turns[i].truncate) if !lv.zero?
    end
    turns
  end
end

#==============================================================================
# ■ Window_Base
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # ● Draw state and enhancement / weakness icons
  #--------------------------------------------------------------------------
  def draw_actor_icons(actor, x, y, width = 96)
    last_font = contents.font.clone
    contents.font.size = 19
    contents.font.bold = true
    contents.font.color = crisis_color
    icons = []
    turns = []
    icons = (actor.state_icons + actor.buff_icons)[0, width / 24]
		if $game_switches[R2_State_Icon_Turns::Switch] == true
      turns = actor.state_turns[0, width / 24]
			turns.each_with_index do |n, i| # turns, array index
        if n >= R2_State_Icon_Turns::Added
          turns[i] = R2_State_Icon_Turns::Added
        end
			end
      icons.each_with_index do |n, i| # icon, array index
        draw_icon(n + turns[i], x + 24 * i, y)
      end
		else
      turns = (actor.state_turns + actor.buff_turns)[0, width / 24]
      icons.each_with_index do |n, i|
        draw_icon(n, x + 24 * i, y)
        if $game_party.in_battle && turns[i] != -1
          draw_text(x + 24 * i, y, 24, line_height, turns[i] + 1, 2)
        end
      end
    end
    contents.font = last_font
  end
end
