# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Hide Explorer HUD            ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║ Galv's Explorer HUD -               ╠════════════════════╣
# ║ Turn HUD ON or OFF                  ║    01 Nov 2020     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Used to hide Galv's Explorer HUD                         ║
# ║ Set the switch number and turn the switch on             ║
# ║ to hide the HUD.                                         ║
# ╚══════════════════════════════════════════════════════════╝
# ╔═════════════════════════════════════╗
# ║ Terms of use:                       ║
# ║ Follow the Original Authors terms   ║
# ╚═════════════════════════════════════╝
module R2_GALV_HUD
  HUD_TRIGGER = 45 # switch used to hide the HUD
end

class Scene_Map < Scene_Base
  alias r2_check_trigger_913by  check_trigger
  def check_trigger
    return if $game_switches[R2_GALV_HUD::HUD_TRIGGER]
    r2_check_trigger_913by
  end
end
