# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Auto Save / Load                       ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function: Requested by kiriyubel              ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Allows auto saving and auto loading           ║    21 Jan 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Make Auto Save and Load control                              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Script provides auto save and auto load features                 ║
# ║   Can be used for multiple save slots.                             ║
# ║   Autosave is designed to work for specific maps.                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 21 Jan 2021 - Initial publish                               ║
# ║ 1.01 - 06 Mar 2021 - Removed 1 slot restriction                    ║
# ║ 1.02 - 19 May 2021 - Set Option for skip title screen              ║
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

module R2_AutoSave_AutoLoad
  Switch_Save = 6 # switch to enable auto save
  Use_switch = false # turns switch feature on if true
  
  Save_Maps = [1, 2] 
  # add as many maps as you want to use autosave feature with
  Save_Slots = 16
  # change the number for how many slot you wish to use.
  
  Auto_load = true
  # if true will load the saved game without going to the title
  Continue_load = true
  # if true this will load the latest saved game when 
    # selecting continue
  
  Skip_Title = true
  # used if you want to load a custom title screen
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

module DataManager
  def self.savefile_max
    return R2_AutoSave_AutoLoad::Save_Slots
  end
    def self.setup_load_game
    $game_map.setup($data_system.start_map_id)
    $game_player.moveto($data_system.start_x, $data_system.start_y)
    $game_player.refresh
    end
end

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  alias r2_autostart_autoload start
  def start
    @saves = []
    @last = 0
    if DataManager.save_file_exists?
      for i in 0..DataManager.savefile_max
        i += 1
        if i > 9
          if !Dir.glob("Save#{i}.rvdata2").empty?
            i -= 1
            @saves << i
          end
        else
          if !Dir.glob("Save0#{i}.rvdata2").empty?
            i -= 1
            @saves << i
          end
        end
      end
      @last = @saves[0]
      @saves.each do |i|
        if DataManager.savefile_time_stamp(i) > DataManager.savefile_time_stamp(@last)
          @last = i
        end
      end
      if R2_AutoSave_AutoLoad::Auto_load
        super
        SceneManager.clear
        fadeout_all
        DataManager.load_game(@last)
                DataManager.setup_load_game if R2_AutoSave_AutoLoad::Skip_Title == true
        SceneManager.goto(Scene_Map)
      else
        if R2_AutoSave_AutoLoad::Skip_Title == true
          SceneManager.clear
          Graphics.freeze
          DataManager.setup_new_game
          $game_map.autoplay
          SceneManager.goto(Scene_Map)
        else
          r2_autostart_autoload
        end
      end
    else
      if R2_AutoSave_AutoLoad::Skip_Title == true
        SceneManager.clear
        Graphics.freeze
        DataManager.setup_new_game
        $game_map.autoplay
        SceneManager.goto(Scene_Map)
      else
        r2_autostart_autoload
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  alias r2_autosave_load_terminate  terminate
  def terminate
    if R2_AutoSave_AutoLoad::Auto_load == true
      if DataManager.save_file_exists?
        super
      else
        if R2_AutoSave_AutoLoad::Skip_Title == true
          SceneManager.snapshot_for_background
          Graphics.fadeout(Graphics.frame_rate)
        else
          r2_autosave_load_terminate
        end
      end
    else
      if R2_AutoSave_AutoLoad::Skip_Title == true
        SceneManager.snapshot_for_background
        Graphics.fadeout(Graphics.frame_rate)
      else
        r2_autosave_load_terminate
      end
    end
  end
  #--------------------------------------------------------------------------
  # * [Continue] Command
  #--------------------------------------------------------------------------
  def command_continue
    if R2_AutoSave_AutoLoad::Continue_load == true
      DataManager.load_game(@last)
      fadeout_all
      RPG::BGM.fade(30)
      $game_map.autoplay
      SceneManager.goto(Scene_Map)
    else
      close_command_window
      SceneManager.call(Scene_Load)
    end
  end
  
end

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Post Processing for Transferring Player
  #--------------------------------------------------------------------------
  alias r2_autosave_post_transfer   post_transfer
  def post_transfer
    r2_autosave_post_transfer
    @saves = []
    @last = 0
    if DataManager.save_file_exists?
      for i in 0..DataManager.savefile_max
        i += 1
        if i > 9
          if !Dir.glob("Save#{i}.rvdata2").empty?
            i -= 1
            @saves << i
          end
        else
          if !Dir.glob("Save0#{i}.rvdata2").empty?
            i -= 1
            @saves << i
          end
        end
      end
      @last = @saves[0]
      @saves.each do |i|
        if DataManager.savefile_time_stamp(i) > DataManager.savefile_time_stamp(@last)
          @last = i
        end
      end
    end
    if R2_AutoSave_AutoLoad::Use_switch == true && 
      $game_switches[R2_AutoSave_AutoLoad::Switch_Save] == true
      if R2_AutoSave_AutoLoad::Save_Maps.include?($game_map.map_id)
        DataManager.save_game(@last)
      end
    elsif R2_AutoSave_AutoLoad::Save_Maps.include?($game_map.map_id) && 
      R2_AutoSave_AutoLoad::Use_switch == false
      DataManager.save_game(@last)
    end
  end
end
