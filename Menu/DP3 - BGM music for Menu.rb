#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#             Play BGM on main menu
#             Author: DiamondandPlatinum3
#             Modded by Roninator2 for Main Menu Music
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Description:
#
#    This script allows you to play BGM on the main menu.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class Scene_Menu < Scene_MenuBase
  #======================================
  #       Editable Region
  #======================================
  BGM_MUSIC_FOR_MENU_SCREEN  = "Scene6"
  BGM_VOLUME                 = 100
  BGM_PITCH                  = 100
  #======================================
 
  alias play_music_onmenuscreen start
  def start
    @map_bgm = RPG::BGM.last
    RPG::BGM.new(BGM_MUSIC_FOR_MENU_SCREEN, BGM_VOLUME, BGM_PITCH).play
    play_music_onmenuscreen
  end
  
  def return_scene
    @map_bgm.replay
    SceneManager.return
  end

end
