# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Extract Events - Addon Event Specific  ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Get specific event details                  ║    20 Sep 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: EXTRACT EVENTS v1.01 by Shaz                             ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Output txt files for event commands                          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   This script extracts ALL event commands into a number            ║
# ║   of text files. These can be opened in a spreadsheet,             ║
# ║   split into columns, searched and sorted.                         ║
# ║                                                                    ║
# ║   The difference with this and the original script by Shaz is      ║
# ║   that this will run only with the event script command.           ║
# ║   be sure to disable the last line in Shaz's script before playing ║
# ║                                                                    ║
# ║   Data/Map(id)-Event(id)-Contents.txt                              ║
# ║      Contains ALL event commands                                   ║
# ║      - useful for perusing, searching for anything in any event    ║
# ║      - this also includes everything in the following two files    ║
# ║                                                                    ║
# ║   Data/Map(id)-Event(id)-Dialogue.txt                              ║
# ║      A subset of EventContents.txt                                 ║
# ║      Contains any event commands to do with text                   ║
# ║      - Show Text, Show Choices, actor names, etc                   ║
# ║      - useful for proofreading and translation                     ║
# ║        (there is no facility to replace text with translations     ║
# ║         - this is JUST an extract)                                 ║
# ║                                                                    ║
# ║   Data/Map(id)-Event(id)-SwitchesVariables.txt                     ║
# ║      A subset of EventContents.txt                                 ║
# ║      Contains any event commands and conditions to do with         ║
# ║      switches and variables                                        ║
# ║      - useful for finding where they've been used                  ║
# ║                                                                    ║
# ║   To Use:                                                          ║
# ║     You "call" this script command with a script command           ║
# ║     at the start of the event                                      ║
# ║        export_event                                                ║
# ║     The script will extract the event contents and export          ║
# ║     to text files in data folder                                   ║
# ║                                                                    ║
# ║   Once the files have been created, open them in a spreadsheet     ║
# ║   and use the Text to Columns feature to separate based            ║
# ║   on your chosen delimiter                                         ║
# ║                                                                    ║
# ║   Terms:                                                           ║
# ║     This is a DEVELOPMENT ONLY script.                             ║
# ║     You may use it when creating free or commercial games, but     ║
# ║     PLEASE remove the script before the game is released.          ║
# ║                                                                    ║
# ║   If you share this script, PLEASE keep this header intact,        ║
# ║   and include a link back to the original RPG Maker Web forum post.║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 20 Sep 2023 - Script finished                               ║
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

module EVExport
  @cb = ","
  def self.export_event(map, id)
    @file_all = File.open("Data/Map#{map}-Event#{id}-Contents.csv", 'w')
    @file_text = File.open("Data/Map#{map}-Event#{id}-Dialogue.csv", 'w')
    @event_seq = 3
    $game_map.setup($game_map.map_id)
    @event = $game_map.events[id]
    return if @event.nil? || @event.pages.nil?
    for page in 0..@event.pages.size - 1
      @event_tab = (page + 1).to_s
      @cond = @event.pages[page].condition
      @list = @event.pages[page].list
      self.export_event_list
    end
    @file_all.close
    @file_text.close
  end
  def self.export_command
    # get rid of any double spaces
    while @arg.gsub!(/  /) { " " } != nil
    end
    @expline += 1
    indchar = INDENT ? @ind * @indent : ""
    text = sprintf("%s%s%s%s%s",
      @cmd, @cb, indchar, @arg, @lb)
    @file_all.print(text)
    @file_text.print(text) if @text_export
  end
end
   
class Game_Interpreter
  def export_event
    EVExport.export_event(self.map_id, self.event_id)
  end
end
