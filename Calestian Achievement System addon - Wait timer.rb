# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Achievement wait             ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║ Calestian Achievement System        ╠════════════════════╣
# ║ Specifies a wait period             ║    05 Apr 2019     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ You can set the time to wait before the window starts    ║
# ║ to disappear and the window skin to use for the message. ║
# ╚══════════════════════════════════════════════════════════╝
# ╔═════════════════════════════════════╗
# ║ Terms of use:                       ║
# ║ Follow the Original Authors terms   ║
# ╚═════════════════════════════════════╝

module Clstn_Achievement_System

  Notification_Pause        = 160       # Frames to wait before disappearing
  Window_Skin            = "Window_Effects" # Must be in quotes
  
end

class Window_AchievementNotification < Window_Base
 
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize
    @window = $game_party.notifications[0][1]
    @item   = $game_party.notifications[0][0]
    super(x, 0, width, height)
    $game_party.notification_enabled = false
    self.windowskin = Cache.system(Clstn_Achievement_System::Window_Skin)
    @view = Clstn_Achievement_System::Notification_Pause
    refresh
  end
  
  def update
    if !disposed? && @view > 0
      @view -= 1
    elsif !disposed? && self.opacity > 0
      self.opacity -= 5
      self.contents_opacity -= 5
      self.back_opacity -= 5
    else
      $game_party.notifications.delete_at(0) unless $game_party.notifications.empty?
      if !$game_party.notifications.empty?
        $game_party.notification_enabled = true
      else
        $game_party.notification_enabled = false
        SceneManager.call(Scene_Map)
      end
      @view = Clstn_Achievement_System::Notification_Pause
    end
  end
end
