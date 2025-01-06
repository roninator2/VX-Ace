# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Save Image                             ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Display an image when saving                ║    17 Dec 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Show image on save screen                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Plug and play                                                    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 17 Dec 2021 - Script finished                               ║
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

module R2_Save_Image
  Image = "Saving" # Graphics\system folder
end

class Scene_Save < Scene_File
  
  #--------------------------------------------------------------------------
  # ● initialize
  #--------------------------------------------------------------------------
  alias r2_savefile_ok  on_savefile_ok
  def on_savefile_ok
    execute_dispose
    create_layout
    save_image_display
    r2_savefile_ok
  end
  
 #--------------------------------------------------------------------------
 # ● Main
 #--------------------------------------------------------------------------          
  def save_image_display
    Graphics.transition
    execute_loop
    execute_dispose
  end   
 
 #--------------------------------------------------------------------------
 # ● Execute Loop
 #--------------------------------------------------------------------------           
  def execute_loop
    loop do
      Graphics.update
      Input.update
      update
      if DataManager.save_game(@index)
        break
      end
    end
  end   
  
  #--------------------------------------------------------------------------
  # ● Create_background
  #--------------------------------------------------------------------------  
  def create_layout
    @background = Plane.new  
    file = R2_Save_Image::Image
    @background.bitmap = Cache.system(file) 
    @background.z = 0
  end
  
  #--------------------------------------------------------------------------
  # ● Execute Dispose
  #--------------------------------------------------------------------------
  def execute_dispose
    return if @background == nil
    Graphics.freeze
    @background.bitmap.dispose
    @background.dispose
    @background = nil
  end
  
end
