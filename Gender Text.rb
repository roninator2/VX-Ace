# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Gender Text                            ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Add escape code to message box              ╠════════════════════╣
# ║   Choose name based on variable               ║    20 May 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Allow conversations to change pronoun                        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║    Set Variable in the game to 0, 1 or 2                           ║
# ║    Can be more if you want                                         ║
# ║                                                                    ║
# ║    text boxes will be formated like this                           ║
# ║                                                                    ║
# ║    "I think that \lg[he, she, they] is funny"                      ║
# ║                                                                    ║
# ║     When the variable is 0 the text will show up as                ║
# ║    "I think that he is funny"                                      ║
# ║                                                                    ║
# ║     When the variable is 2 the text will show up as                ║
# ║    "I think that they is funny"                                    ║
# ║                                                                    ║
# ║      I picked lg as the code to mean life gender                   ║
# ║                                                                    ║
# ║    The text can also be longer. It is separated                    ║
# ║    by the comma. So you can write more than one word               ║
# ║    in the text box. As you saw in the example                      ║
# ║    'they is' is not really good english                            ║
# ║    So you can write longer conversations                           ║
# ║    "I think that \lg[he is,she is,they are] funny"                 ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 20 May 2022 - Script finished                               ║
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

module R2_Gender_Names
  Names_Var = 5 # variable that will hold the key value
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Window_Base < Window
  alias convert_escape_characters_r2_gender convert_escape_characters
  def convert_escape_characters(text)
    result = convert_escape_characters_r2_gender(text)
    result = convert_text_gender_variable(result)
    return result
  end
  def convert_text_gender_variable(result)
    result.gsub!(/\eLG\[(\w+(?:[, ]*\w*)*)\]/i) { gender_text_name($1) }
    return result
  end
  def gender_text_name(names)
    names.split(",").each_with_index do |name, i|
      if i == $game_variables[R2_Gender_Names::Names_Var]
        return name
      end
    end
  end
end
