# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Picture Gallery                        ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Show an image gallery in menu                 ║    06 Oct 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires:                                                          ║
# ║        Global save system by TheLeech                              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║   Allows to display pictures for the player to view                ║
# ║   Requires Global save system by theleech                          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Specify the settings for each image in the array                 ║
# ║     {                                                              ║
# ║     :name => "P1", # image name                                    ║
# ║     :opacity => 255, # opacity of image                            ║
# ║     :x => 0, # x position                                          ║
# ║     :y => 0, # y position                                          ║
# ║     :visible => true, # picture visible                            ║
# ║     :mcmd => false, # commands visible                             ║
# ║     :wait => 180,  # how long to display image                     ║
# ║     :command => "Picture 1", # Command in menu                     ║
# ║     },                                                             ║
# ║                                                                    ║
# ║  Add or remove sections to accomdate your game.                    ║
# ║                                                                    ║
# ║  If you want to block access to the Gallery in title               ║
# ║  you will need to use a global data script                         ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 06 Oct 2021 - Script finished                               ║
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

module R2_Gallery_Title
  Switch = 2 # switch to determine if in menu or title screen
  Stop_Music = true # stops background music if true
  Gallery_Music = "Battle1" # music to play while viewing gallery
  Play_Music = false # play music while viewing gallery
  Return_Text = "Back to Menu" # text to show for returning to menu
  Background_Image = "Gallery_Background" # image to show for the background
  Global_Switch = 5 # variable used with global variables
  # requires a global variable script
  
  Picture_Gallery = [
  {
    :name => "P1", # image name
    :opacity => 255, # opacity of image
    :x => 0, # x position
    :y => 0, # y position
    :visible => true, # picture visible
    :mcmd => false, # commands visible
    :wait => 180,
    :command => "Picture 1",
    },
  {
    :name => "P2", # image name
    :opacity => 255, # opacity of image
    :x => 0, # x position
    :y => 0, # y position
    :visible => true, # picture visible
    :mcmd => false, # commands visible
    :wait => 180,
    :command => "Picture 2",
    },
  {
    :name => "P3", # image name
    :opacity => 255, # opacity of image
    :x => 0, # x position
    :y => 0, # y position
    :visible => true, # picture visible
    :mcmd => false, # commands visible
    :wait => 180,
    :command => "Picture 3",
    },
  {
    :name => "P4", # image name
    :opacity => 255, # opacity of image
    :x => 0, # x position
    :y => 0, # y position
    :visible => true, # picture visible
    :mcmd => false, # commands visible
    :wait => 180,
    :command => "Picture 4",
    },
  {
    :name => "P5", # image name
    :opacity => 255, # opacity of image
    :x => 0, # x position
    :y => 0, # y position
    :visible => true, # picture visible
    :mcmd => false, # commands visible
    :wait => 180,
    :command => "Picture 5",
    },
  {
    :name => "P6", # image name
    :opacity => 255, # opacity of image
    :x => 0, # x position
    :y => 0, # y position
    :visible => true, # picture visible
    :mcmd => false, # commands visible
    :wait => 180,
    :command => "Picture 6",
    },
  {
    :name => "P7", # image name
    :opacity => 255, # opacity of image
    :x => 0, # x position
    :y => 0, # y position
    :visible => true, # picture visible
    :mcmd => false, # commands visible
    :wait => 180,
    :command => "Picture 7",
    },
  {
    :name => "P8", # image name
    :opacity => 255, # opacity of image
    :x => 0, # x position
    :y => 0, # y position
    :visible => true, # picture visible
    :mcmd => false, # commands visible
    :wait => 180,
    :command => "Picture 8",
    },
  {
    :name => "P9", # image name
    :opacity => 255, # opacity of image
    :x => 0, # x position
    :y => 0, # y position
    :visible => true, # picture visible
    :mcmd => false, # commands visible
    :wait => 180,
    :command => "Picture 9",
    },
  {
    :name => "P10", # image name
    :opacity => 255, # opacity of image
    :x => 0, # x position
    :y => 0, # y position
    :visible => true, # picture visible
    :mcmd => false, # commands visible
    :wait => 180,
    :command => "Picture 10",
    },
  ]

end
# ╔══════════════════════════════════════════════════════════╗
# ║ End of configuration                                     ║
# ╚══════════════════════════════════════════════════════════╝

class Window_Gallery < Window_Command
  def make_command_list
    add_command(R2_Gallery_Title::Return_Text, :menu)
    for cmd in R2_Gallery_Title::Picture_Gallery
      add_command(cmd[:command], cmd[:command])
    end
  end
end

class Scene_Gallery < Scene_MenuBase
  def start
    super
    @last_bgm = RPG::BGM.last
    RPG::BGM.stop if R2_Gallery_Title::Stop_Music
    msc = RPG::BGM.new(R2_Gallery_Title::Gallery_Music, 100, 100) if R2_Gallery_Title::Play_Music
    msc.play if R2_Gallery_Title::Play_Music
    create_background
    create_commands
  end
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = Cache.system(R2_Gallery_Title::Background_Image)
    @background_sprite.color.set(0, 0, 0, 0)
  end
  def create_commands
    @cmd = Window_Gallery.new(0,0) #(x,y)
    @cmd.width = 244
    @cmd.height = 416
    @cmd.opacity = 0
    @cmd.set_handler(:menu, method(:cmd_menu))
    for cmd in R2_Gallery_Title::Picture_Gallery
      @cmd.set_handler(cmd[:command], method(:sh_pic))
    end
  end
  def cmd_menu
    if $game_switches[R2_Gallery_Title::Switch]
      return_scene
      @last_bgm.play(@last_bgm.pos) if R2_Gallery_Title::Stop_Music
      $game_switches[R2_Gallery_Title::Switch] = false
    else
      SceneManager.goto(Scene_Title)
    end
  end
  def sh_pic
    index = @cmd.index - 1
    R2_Gallery_Title::Picture_Gallery.each_with_index { |cmd, i|
      next if index != i
      @pic = Sprite.new
      @pic.bitmap = Cache.picture(cmd[:name])
      @pic.opacity = cmd[:opacity]
      @pic.x = cmd[:x]
      @pic.y = cmd[:y]
      @pic.visible = cmd[:visible]
      @cmd.visible = cmd[:mcmd]
      Graphics.wait(cmd[:wait])
    }
      @pic.visible = false
      @cmd.visible = true
      @cmd.activate
  end
end

class Window_MenuCommand < Window_Command
  def add_original_commands
    add_command("Gallery", :gallery)
  end
end

class Scene_Menu < Scene_MenuBase
  alias r2_handler_command_gallery  create_command_window
  def create_command_window
    r2_handler_command_gallery
    @command_window.set_handler(:gallery,   method(:command_gallery))
  end
  def command_gallery
    $game_switches[R2_Gallery_Title::Switch] = true
    SceneManager.call(Scene_Gallery)
  end
end

# ╔══════════════════════════════════════════════════════════╗
# ║ Title Screen command                                     ║
# ║ Requires Global save system by theleech                  ║
# ╚══════════════════════════════════════════════════════════╝

class Scene_Title < Scene_Base
  alias r2_gallery_title  create_command_window
  def create_command_window
    r2_gallery_title
    @command_window.set_handler(:gallery, method(:command_gallery))
  end
  def command_gallery
    close_command_window
    SceneManager.call(Scene_Gallery)
  end
end

class Window_TitleCommand < Window_Command
  alias r2_command_gallery_title  make_command_list
  def make_command_list
    r2_command_gallery_title
    if $imported[:lglobal_save]
      LGlobalSave.load
      add_command("Gallery", :gallery) if $game_switches[R2_Gallery_Title::Global_Switch] == true
    end
  end
end
