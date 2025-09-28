# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: YEA Title Options                      ║  Version: 1.03     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║    Preserve Yanfly System Options             ╠════════════════════╣
# ║                                               ║    16 Mar 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Yanfly's System Options                                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║   Script allows accessing the options screen                       ║
# ║   before starting the game                                         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   plug and play                                                    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 19 Mar 2021 - Script finished                               ║
# ║ 1.01 - 20 Sep 2022 - Fixed new game bug                            ║
# ║ 1.02 - 28 Sep 2025 - Corrected issue for extra system data         ║
# ║ 1.03 - 28 Sep 2025 - Adeed support for my List Options addon       ║
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

module DataManager
  class << self; alias title_options_create_game_objects create_game_objects; end
  def self.create_game_objects
    if $game_system.nil?
        title_options_create_game_objects
    else
      sysbase = gather_system_colour_sound
      sysextra = gather_system_switch_variable
      title_options_create_game_objects
      set_system_colour_sound(sysbase)
      set_system_switch_variable(sysextra)
    end
  end
  def self.gather_system_colour_sound
    data = {}
    data[:bgm] = $game_system.volume(:bgm)
    data[:bgs] = $game_system.volume(:bgs)
    data[:sfx] = $game_system.volume(:sfx)
    tone = $game_system.window_tone.clone
    data[:red] = tone.red
    data[:green] = tone.green
    data[:blue] = tone.blue
    return data
  end
  def self.gather_system_switch_variable
    data = {}
    YEA::SYSTEM::CUSTOM_SWITCHES.each do |sw|
      next if !YEA::SYSTEM::COMMANDS.include?(sw[0])
      data[sw[0]] = $game_switches[sw[1][0]]
    end
    YEA::SYSTEM::CUSTOM_VARIABLES.each do |var|
      next if !YEA::SYSTEM::COMMANDS.include?(var[0])
      data[var[0]] = $game_variables[var[1][0]]
    end
    if YEA::SYSTEM::CUSTOM_LISTS != nil
      YEA::SYSTEM::CUSTOM_LISTS.each do |var|
        next if !YEA::SYSTEM::COMMANDS.include?(var[0])
        data[var[0]] = $game_variables[var[1][0]]
      end
    end
    return data
  end
  def self.set_system_colour_sound(data)
    bgm = 100 - data[:bgm]
    bgs = 100 - data[:bgs]
    sfx = 100 - data[:sfx]
    $game_system.volume_change(:bgm, -bgm)
    $game_system.volume_change(:bgs, -bgs)
    $game_system.volume_change(:sfx, -sfx)
    tone = $game_system.window_tone.clone
    tone.red = data[:red]
    tone.green = data[:green]
    tone.blue = data[:blue]
    $game_system.window_tone = tone
  end
  def self.set_system_switch_variable(data)
    YEA::SYSTEM::CUSTOM_SWITCHES.each do |sw|
      next if !YEA::SYSTEM::COMMANDS.include?(sw[0])
      $game_switches[sw[1][0]] = data[sw[0]]
    end
    YEA::SYSTEM::CUSTOM_VARIABLES.each do |var|
      next if !YEA::SYSTEM::COMMANDS.include?(var[0])
      $game_variables[var[1][0]] = data[var[0]]
    end
    if YEA::SYSTEM::CUSTOM_LISTS != nil
      YEA::SYSTEM::CUSTOM_LISTS.each do |var|
        next if !YEA::SYSTEM::COMMANDS.include?(var[0])
        $game_variables[var[1][0]] = data[var[0]]
      end
    end
  end
end #DataManager
class Scene_Title < Scene_Base
  alias r2_title_options_start    start
  def start
    r2_title_options_start
    DataManager.create_game_objects# if $game_switches.nil?
  end
  def create_command_window
    @command_window = Window_TitleCommand.new
    @command_window.set_handler(:new_game, method(:command_new_game))
    @command_window.set_handler(:continue, method(:command_continue))
    @command_window.set_handler(:options, method(:command_options))
    @command_window.set_handler(:shutdown, method(:command_shutdown))
  end
  def command_options
    close_command_window
    SceneManager.call(Scene_System)
  end
end

class Window_TitleCommand < Window_Command
  def make_command_list
    add_command(Vocab::new_game, :new_game)
    add_command(Vocab::continue, :continue, continue_enabled)
    add_command("Options", :options)
    add_command(Vocab::shutdown, :shutdown)
  end
end
