# Show state features in CSCA encyclopedia
# Roninator2 
# requires 
# CSCA Core
# CSCA Menu organizer (for menu command, unless you have your own way.)
# CSCA encyclopedia
# Kread-Ex Traits Namer

class CSCA_Window_EncyclopediaInfo < Window_Base
  include KRX::TraitsNamer

  def draw_state_information(item)
    csca_draw_icon(item)
    csca_draw_name(item)
    contents.font.size = 16
    change_color(system_color)
    draw_text(72,line_height,contents.width,line_height,"Restriction:")
    draw_text(72,line_height*2-4,contents.width,line_height,"Priority:")
    draw_text(0,line_height*3,contents.width,line_height,"Minimum Turns:")
    draw_text(0,line_height*4-4,contents.width,line_height,"Maximum Turns:")
    change_color(normal_color)
    restriction_string = item.restriction
    case restriction_string
    when 0; restriction_string = "None"
    when 1; restriction_string = "Attack Enemies"
    when 2; restriction_string = "Attack Anyone"
    when 3; restriction_string = "Attack Allies"
    when 4; restriction_string = "Can't Move"
    end
    if item.auto_removal_timing != 1 && item.auto_removal_timing != 2
      max_turn = "N/A"
      min_turn = "N/A"
    else
      max_turn = item.max_turns.to_s
      min_turn = item.min_turns.to_s
    end
    item.remove_at_battle_end ? b_remove = "Yes" : b_remove = "No"
    item.remove_by_restriction ? r_remove = "Yes" : r_remove = "No"
    if item.remove_by_damage
      d_remove = "Yes"
      d_chance = item.chance_by_damage.to_s + "%"
    else
      d_remove = "No"
      d_chance = "N/A"
    end
    if item.remove_by_walking
      w_remove = "Yes"
      w_steps = item.steps_to_remove.to_s
    else
      w_remove = "No"
      w_steps = "N/A"
    end
    draw_text(170,line_height,contents.width,line_height,restriction_string)
    draw_text(147,line_height*2-4,contents.width,line_height,item.priority.to_s)
    draw_text(115,line_height*3,contents.width,line_height,min_turn)
    draw_text(115,line_height*4-4,contents.width,line_height,max_turn)
    d = line_height * 5 - 5 unless d == 0
		@item = item
    item.features.each_with_index do |data, e|
      code = @item.features[e].code
      data_id = @item.features[e].data_id
      value = @item.features[e].value
      string = KRX::TraitsNamer.feature_name(code, data_id, value)
      draw_text(5, d, contents.width, line_height, string)
      d += line_height - 5
    end
    csca_draw_custom_note(0,line_height*11-12,contents.width,line_height,item)
  end
end
