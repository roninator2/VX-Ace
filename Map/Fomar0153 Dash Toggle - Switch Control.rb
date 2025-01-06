# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Dash Switch Control          ║  Version: 1.00     ║
# ║ Author: Roninator2 / Fomar0153      ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║  Toggle Dash by Switch              ║    07 Feb 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║    Configure switch to control the dash function         ║
# ║    True = Press shift to run (default)                   ║
# ║    False = Toggle run/walk with button push (shift)      ║
# ║                                                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Updates:                                                 ║
# ║   2023-Feb-07 - Initial publish                          ║
# ║                                                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker VX Ace - except nudity    ║
# ╚══════════════════════════════════════════════════════════╝

module R2_Toggle_Dash
  Dash_Switch = 4 # switch that controls the changing of the dash controls
end

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias dash_initialize initialize
  def initialize
    dash_initialize
    @dash = false
  end
  #--------------------------------------------------------------------------
  # * Determine if Dashing
  #--------------------------------------------------------------------------
  def dash?
    return false if @move_route_forcing
    return false if $game_map.disable_dash?
    return false if vehicle
		if $game_switches[R2_Toggle_Dash::Dash_Switch]
			return Input.press?(:A)
		else
			return @dash
		end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias dash_update update
  def update
    dash_update
    @dash = !@dash if Input.trigger?(:A)
  end
end
