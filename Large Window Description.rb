# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Large Help Window                      ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Enlarge Help Window                         ║    05 Jan 2020     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Make Help Window Smaller or Larger                           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Make the help window show 4 lines or change to anything          ║
# ║   between 2-6                                                      ║
# ║                                                                    ║
# ║   This allows information written in the note box for anything     ║
# ║   from weapons to items to display more text.                      ║
# ║                                                                    ║
# ║   This window shows skill and item explanations along              ║
# ║   with actor status.                                               ║
# ║                                                                    ║
# ║   Requires placing a notetag in the item description               ║
# ║   <note desc>                                                      ║
# ║   third line                                                       ║
# ║   fourth line                                                      ║
# ║   </note desc>                                                     ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.02 - 05 Jan 2020 - Script finished                               ║
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

module R2_Help_Window_Lines
  Lines = 4
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Window_Help < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(line_number = R2_Help_Window_Lines::Lines)
    super(0, 0, Graphics.width, fitting_height(line_number))
  end
  def set_item(item)
    set_text(item ? item.description + "\n" + make_note_desc(item) : "")
  end
  def make_note_desc(item)
    @note_desc = nil
    results = item.note.scan(/<note[-_ ]*desc>(.*?)<\/note[-_ ]*desc>/imx)
    results.each do |res|
      res[0].strip.split("\r").each do |line|
        @note_desc = @note_desc.to_s + line.to_s
      end
    end
    return @note_desc.to_s
  end
end
