# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Map Name Position       ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Map Name Shown         ║    09 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  Script sets the position and display of the Map Name    ║
# ║  on the screen.                                          ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# ** Window Map NAme
#==============================================================================
class Window_MapName < Window_Base
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize
    x = (Graphics.width - window_width) / 2
    y = Graphics.height - 150
    super(x, y, window_width, fitting_height(1))
		self.opacity, self.contents_opacity, @show_count = 0, 0, 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * Update Fadein
  #--------------------------------------------------------------------------
	def update_fadein
		self.opacity += 32 unless $game_map.display_name.empty?
		self.contents_opacity += 16
	end
  #--------------------------------------------------------------------------
  # * Update Fadeout
  #--------------------------------------------------------------------------
	def update_fadeout
		self.opacity -= 16 unless $game_map.display_name.empty?
		self.contents_opacity -= 16
	end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
	def refresh
		contents.clear
		return if $game_map.display_name.empty?
		draw_text(contents.rect, $game_map.display_name, 1)
	end
end

#==============================================================================
# ** Scene_Map
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Start
  #--------------------------------------------------------------------------
  alias r2_map_start_name start
  def start
    r2_map_start_name
    display_name
  end
  #--------------------------------------------------------------------------
  # * Display Name
  #--------------------------------------------------------------------------
  def display_name
    return if @shown_name == true
    @map_name_window.open
    @shown_name = true
  end
end
