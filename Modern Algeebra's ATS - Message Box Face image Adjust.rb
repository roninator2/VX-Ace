# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Face Align                   ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║ Adjust Face position for text       ║    01 Nov 2020     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ During a conversation you have the text centered         ║
# ║ * Modern Algeebra's ATS script                           ║
# ║ The face image will be on the left side                  ║
# ║ This will determine the size of the text written         ║
# ║ and move the face graphic towards the text               ║
# ╚══════════════════════════════════════════════════════════╝
# ╔═════════════════════════════════════╗
# ║ Terms of use:                       ║
# ║ Free for all uses in RPG Maker      ║
# ╚═════════════════════════════════════╝

class Window_Message < Window_Base
  def new_page(text, pos)
    contents.clear
    face_x = 0
    face_pos = 0
    for i in 0..$game_message.texts.size
      arrvalue = $game_message.texts[i]
      next if arrvalue.nil?
      result = arrvalue.to_s.clone
      result.gsub!(/\i\i\[\d+\]/)          { "" }
      parsetxt = convert_escape_characters(result)
      arrlgth = parsetxt.length * 10
      if arrlgth > face_pos
        face_pos = arrlgth
      end
    end
    face_pos = (Graphics.width - face_pos) / 2 - 20
    if face_pos <= 0; face_pos = 0; end
    draw_face($game_message.face_name, $game_message.face_index, face_pos, 0)
    reset_font_settings
    pos[:x] = new_line_x
    pos[:y] = 0
    pos[:new_x] = new_line_x
    pos[:height] = calc_line_height(text)
    clear_flags
  end
end
