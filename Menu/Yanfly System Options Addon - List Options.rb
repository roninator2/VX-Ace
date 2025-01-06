# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Yanfly System Options - List Options   ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Separate items into sections                ║    21 Jun 2019     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Yanfly System Options                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Variable text lists add-on for System Options                ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Edit the categories below to suit your game                      ║
# ║   You can specify in the Custom_Lists below which variable you     ║
# ║   want to use and the text to be displayed.                        ║
# ║   The text must be short,                                          ║
# ║   otherwise you will have to adjust the script                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 21 Jun 2019 - Script finished                               ║
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

module YEA
  module SYSTEM
    CUSTOM_LISTS ={
    # -------------------------------------------------------------------------
    # :list    => [Variable, Name, minimum, maximum, Color1, Color2, 
    #               Help Window Description, Value1, Value2, Value3, etc
    #               ], # Do not remove this.
    # -------------------------------------------------------------------------
      :list_1  => [ 67, "Difficulty", 0, 3, 0, 7, "Change Difficulty?", 
                      "Easy", "Normal", "Heroic", "Legendary"
                    ],
    # -------------------------------------------------------------------------
      :list_2  => [ 127, "Cursor", 0, 3, 0, 7, "Change the cursor for the menu.\n"+
                      "Exit screen for change to take effect.", 
                      "Magic", "Crystal", "Hand", "None"
                    ],
    # -------------------------------------------------------------------------
    } # Do not remove this.
  end
end
# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝


class Window_SystemOptions < Window_Command
  #--------------------------------------------------------------------------
  # Overwrite * update_help
  #--------------------------------------------------------------------------
  def update_help
    if current_symbol == :custom_switch || current_symbol == :custom_variable ||
      current_symbol == :custom_list
      text = @help_descriptions[current_ext]
    else
      text = @help_descriptions[current_symbol]
    end
    text = "" if text.nil?
    @help_window.set_text(text)
  end
  #--------------------------------------------------------------------------
  # new * process_custom_list
  #--------------------------------------------------------------------------
  def process_custom_list(command)
    return unless YEA::SYSTEM::CUSTOM_LISTS.include?(command)
    name = YEA::SYSTEM::CUSTOM_LISTS[command][1]
    add_command(name, :custom_list, true, command)
    @help_descriptions[command] = YEA::SYSTEM::CUSTOM_LISTS[command][6]
  end
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  alias r2_draw_item_823gf  draw_item
  def draw_item(index)
    reset_font_settings
    rect = item_rect(index)
    contents.clear_rect(rect)
    r2_draw_item_823gf(index)
    case @list[index][:symbol]
    when :custom_list
      draw_custom_list(rect, index, @list[index][:ext])
    end
  end
  
  def item_height
    line_height
  end
  
  def line_height
    return 23
  end
  
  #--------------------------------------------------------------------------
  # Overwrite * make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    @help_descriptions = {}
    for command in YEA::SYSTEM::COMMANDS
      case command
      when :blank
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :window_red, :window_grn, :window_blu
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :volume_bgm, :volume_bgs, :volume_sfx
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :autodash, :instantmsg, :animations
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :varmenu, :encyclopedia, :achievement, :stats, :overview, :cancel, :to_title, :shutdown
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :fullscreen
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      else
        process_custom_list(command)
        process_custom_switch(command)
        process_custom_variable(command)
      end
    end
  end
    
  #--------------------------------------------------------------------------
  # New * draw_custom_list
  #--------------------------------------------------------------------------
  def draw_custom_list(rect, index, ext)
    name = @list[index][:name]
    change_color(normal_color)
    draw_text(0, rect.y, contents.width/2, line_height, name, 1)
    #---
    value = $game_variables[YEA::SYSTEM::CUSTOM_LISTS[ext][0]]
    minimum = YEA::SYSTEM::CUSTOM_LISTS[ext][2]
    maximum = YEA::SYSTEM::CUSTOM_LISTS[ext][3]
    if minimum > value
      value = minimum
      $game_variables[YEA::SYSTEM::CUSTOM_LISTS[ext][0]] = value
    end
    pos = 0
    for i in minimum...maximum + 1
      dx = -120
      entry = YEA::SYSTEM::CUSTOM_LISTS[ext][pos + 7]
      color1 = text_color(YEA::SYSTEM::CUSTOM_LISTS[ext][5].to_i)
      change_color(color1)
      draw_text(dx + contents.width/2 + contents.width/maximum*pos/2, rect.y, contents.width/maximum, line_height, entry, 1)
      if value == i
        color2 = text_color(YEA::SYSTEM::CUSTOM_LISTS[ext][4].to_i)
        change_color(color2)
        entry = YEA::SYSTEM::CUSTOM_LISTS[ext][pos + 7]
        draw_text(dx + contents.width/2 + contents.width/maximum*pos/2, rect.y, contents.width/maximum, line_height, entry, 1)
      end
      pos += 1
    end
  end
  #--------------------------------------------------------------------------
  # cursor_change
  #--------------------------------------------------------------------------
  alias r2_cursor_change_92fkw  cursor_change
  def cursor_change(direction)
    r2_cursor_change_92fkw(direction)
    case current_symbol
    when :custom_list
      change_custom_lists(direction)
    end
  end
  
  #--------------------------------------------------------------------------
  # Overwrite * draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    reset_font_settings
    contents.font.size = 20
    rect = item_rect(index)
    contents.clear_rect(rect)
    case @list[index][:symbol]
    when :blank
    when :window_red, :window_grn, :window_blu
      draw_window_tone(rect, index, @list[index][:symbol])
    when :volume_bgm, :volume_bgs, :volume_sfx
      rect.y -= 3
      draw_volume(rect, index, @list[index][:symbol])
    when :autodash, :instantmsg, :animations
      draw_toggle(rect, index, @list[index][:symbol])
    when :custom_switch
      draw_custom_switch(rect, index, @list[index][:ext])
    when :custom_variable
      rect.y -= 3
      draw_custom_variable(rect, index, @list[index][:ext])
    when :fullscreen
      draw_toggle(rect, index, @list[index][:symbol])
    when :custom_list
      draw_custom_list(rect, index, @list[index][:ext])
    when :cancel, :varmenu, :encyclopedia, :achievement, :to_title, :shutdown, :stats, :overview
      draw_text(item_rect_for_text(index), command_name(index), 1)
    end
  end
  #--------------------------------------------------------------------------
  # new * change_custom_lists
  #--------------------------------------------------------------------------
  def change_custom_lists(direction)
    Sound.play_cursor
    value = direction == :left ? -1 : 1
    ext = current_ext
    var = YEA::SYSTEM::CUSTOM_LISTS[ext][0]
    minimum = YEA::SYSTEM::CUSTOM_LISTS[ext][2]
    maximum = YEA::SYSTEM::CUSTOM_LISTS[ext][3]
    $game_variables[var] += value
    $game_variables[var] = [[$game_variables[var], minimum].max, maximum].min
    draw_item(index)
  end
  
end # Window_SystemOptions

