# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: MOG Save file fix            ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║ MOG Scene File A                    ╠════════════════════╣
# ║ Corrects save slot number           ║    01 Nov 2020     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ If you find in your game that the save slot number       ║
# ║ is not accurate or there are errors, then try this       ║
# ║ to correct the save slot index position.                 ║
# ╚══════════════════════════════════════════════════════════╝
# ╔═════════════════════════════════════╗
# ║ Terms of use:                       ║
# ║ Follow the Original Authors terms   ║
# ╚═════════════════════════════════════╝
class Scene_File 
  include MOG_SCENE_FILE
  def initialize
      @saving = $game_temp.scene_save
      @file_max = FILES_MAX
      @file_max = 1 if FILES_MAX < 1
      execute_dispose
      create_layout
      create_savefile_windows
      @index = DataManager.last_savefile_index 
      @check_prev_index = true
      if ADIK::QUICK::INDEX > FILES_MAX
        @index = 0
      end
      @savefile_windows[@index].selected = true 
  end
end
