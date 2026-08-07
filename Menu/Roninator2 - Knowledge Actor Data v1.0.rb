# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Knowledge Actor Data                   ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Detail data for actors                      ║    17 Jul 2026     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Knowledge System Base script                             ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ This is where you set the actor data for skills, states, stat      ║
# ║ bonuses. Also includes switches and variables if needed            ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   See Instructions below                                           ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 17 Jul 2026 - Script finished                               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Yazik                                                            ║
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

module R2_Knowledge_Menu
  module Actor_Data
    # Actor's Skill Shop Database
    Knowledgebase = {}
    
  # Database[actor_id] = [[skill_id, point cost], ..., [skill_id, point cost]],
  #
  # Skill item format : [skill_id, point cost, :skill]
  #
  # State item format : [state_id, point cost, :state, "Description."]
  #
  # Switch item format : [switch_id, price, :switch, "Description", icon index],
  #   icon index for (switches and variables and stats) is used to pull in an
  #   icon for drawing the icon. Skills and States get the icon from the database
  #
  # Variable item format : [var_id, price, :variable, "Description", 
  #                         icon index, amount, limit changes (0 is unlimited),
  #                          cost increase],
  #
  # Stat item format : [stat_id, point cost, :stat, "Description", icon index, 
  #                     amount increased, stat id decreased, Decrease amount, 
  #                     change by, subtract amount, limited uses, cost increase],
  #   Amount increased is how much the stat increases, changed with subtract amount
  #     This is so that additional purchases will not add as much.
  #     so if the first add is 15 and subtract by 3, then the second will add 12
  #     use carefully with amount of times to use. 
  #     Can go negative if too many times used
  #   Stat_id options are 0,   1,   2,   3,   4,   5,   6,    7
  #                      MHP, MMP, ATK, DEF, MAT, MDF, AGI, LUK
  #   Stat ID Decreased is to cause other stats to change if desired. 
  #      set to -1 for no effect
  #   Decrease Amount is how much to lower the other stat
  #   Change by is the point which further purchases would reduce the 
  #     amount gained by the subtract amount. 2 means buy twice then start reducing
  #   Subtract amount is how much to remove from the amount increased
  #   Limited uses is how many times it can be purchased
  #   Cost increase is how much to add onto the purchase cost for additional purchases
    
    # Actor 0 - example
    Knowledgebase[0] = [
      # skill id, cost, :skill
      [19, 2, :skill], [14, 2, :skill], [13, 3, :skill], [12, 3, :skill], 
      # state id, cost, :state, Description
      [5,  4, :state, "Passive state 5."], # if you use a passive state script
      [11, 8, :state, "Passive state 11.\nNew line"], 
      # switch id, cost, :switch, icon index
      [15, 2, :switch, "Switch 15", 16],
# variable id, cost, :variable, :description, icon index, amount changed, limited uses, cost increase
      [23, 2, :variable, "Variable 23 change.\ntest new line", 17, 1, 3, 1], # used when you have a system
      [24, 2, :variable, "Variable 24 change.", 17, 1, -1, 1], # that uses variable data
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Try to explain stats                                               ║
# ╚════════════════════════════════════════════════════════════════════╝
# stat id, cost, :stat, description,        icon index, amount increased, 
  [0,       1,  :stat, "Maximum HP Increased", 18,           40, 
# Stat id decreased, decrease amount, change by, subtract amount, 
        -1,               0,            1,              5,
# limited uses, cost increaase for additional purchases
        3,              0],
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Try to explain stats                                               ║
# ╚════════════════════════════════════════════════════════════════════╝
      [1, 1, :stat, "Stat 1 change", 18, 30, -1, 0, 1, 5, 2, 1], 
      ]
      
    # Actor 1
    Knowledgebase[1] = [
      # skill id, cost, :skill
      [19, 2, :skill], [14, 2, :skill], [13, 3, :skill], [12, 3, :skill], 
      [51, 3, :skill], [52, 2, :skill], [50, 3, :skill], [8, 2, :skill], 
      [35, 4, :skill], [60, 1, :skill], [22, 1, :skill], [28, 1, :skill],
      [29, 1, :skill], [40, 2, :skill], [53, 1, :skill], [54, 1, :skill], 
      [55, 1, :skill], [56, 1, :skill], [57, 1, :skill], [44, 1, :skill], 
      [24, 1, :skill], [97, 1, :skill], [92, 1, :skill], 
      [5,  4, :state, "Passive state 5."],
      [7,  2, :state, "Passive state 7."],
      [12, 1, :state, "Passive state 12."],
      [11, 8, :state, "Passive state 11.\nNew line"], 
      [15, 2, :state, "Passive state 15."], 
      [14, 5, :state, "Passive state 14."],
      [17, 6, :state, "Passive state 17."], 
      [8,  4, :state, "Passive state 8."], 
      [4,  4, :state, "Passive state 4."],
      [16, 3, :state, "Passive state 16."], 
      [20, 4, :state, "Passive state 20."],
      [15, 2, :switch, "Switch 15", 16],
      [23, 2, :variable, "Variable 23 change.\nUnlock access to secret room", 17, 1, 3, 1],
      [24, 2, :variable, "Variable 24 change.", 19, 1, -1, 1],
      [0, 1, :stat, "Maximum HP Increased.\nGain 40 HP.", 18, 40, -1, 0, 1, 5, 3, 0],
      [1, 1, :stat, "Maximum MP Increased.\Gain 30 MP.\nDecreased with each level.", 18, 30, -1, 0, 1, 5, 2, 1], 
      [2, 1, :stat, "Attack power increased.\nGain 15 Points.", 18, 15, -1, 0, 0, 1, 5, 1],
      [3, 1, :stat, "Defense power increased.\nGain 15 points.", 18, 15, -1, 0, 1, 1, 1, 1],
      [4, 1, :stat, "Magic Attack increased.\nGain 15 points.", 18, 15, -1, 0, -1, 1, 1, 1], 
      [5, 1, :stat, "Magic Defense increased.\nGain 15 points.", 18, 15, -1, 0, -1, 1, 1, 1],
      [6, 1, :stat, "Agility increased.\nGain 10 points.", 18, 10, 0, 10, 1, 5, 2, 1], 
      [7, 1, :stat, "Luck increased.\nGain 10 points.", 18, 10, 0, 10, 1, 5, 2, 1],
      ]
      
    # Actor 2
    Knowledgebase[2] = [
      [51, 1, :skill], [53, 2, :skill], [54, 3, :skill], [67, 1, :skill], 
      [68, 2, :skill], [55, 1, :skill], [57, 2, :skill], [59, 1, :skill], 
      [61, 2, :skill],
      [10, 4, :state, "Passive state 10."],
      [12, 2, :switch, "Switch 12", 16],
      [13, 2, :variable, "Variable 13 change.", 17, 1, 3, 1],
      [0, 1, :stat, "Maximum HP Increased.\nGain 10 HP.", 16, 10, -1, 0, 1, 1, 3, 0],
      [1, 1, :stat, "Maximum MP Increased.\Gain 10 MP.", 17, 10, -1, 0, 1, 1, 2, 1], 
      [2, 1, :stat, "Attack power increased.\nGain 15 Points.", 18, 15, -1, 0, 0, 1, 5, 1],
      ]
            
    # Actor 3
    Knowledgebase[3] = [
      [51, 1, :skill], [53, 2, :skill], [54, 3, :skill], [67, 1, :skill], 
      [68, 2, :skill], [55, 1, :skill], [57, 2, :skill], [59, 1, :skill], 
      [61, 2, :skill],
      [10, 4, :state, "Passive state 10."],
      [21, 1, :state, "Line 1 Description.\nLine 2 Description.\nLine 3 Description."],
      [23, 1, :state, "Line 1 Description.\nLine 2 Description.\nLine 3 Description."],
      [12, 2, :switch, "Switch 12", 16],
      [15, 2, :switch, "Switch 15", 16],
      [ 9, 2, :switch, "Switch 9", 16],
      [ 2, 2, :switch, "Switch 2", 16],
      [11, 2, :switch, "Switch 11", 16],
      [23, 2, :variable, "Variable 23 change.\nUnlock access to secret room", 17, 1, 3, 1],
      [13, 2, :variable, "Variable 13 change.", 17, 1, 3, 1],
      [0, 1, :stat, "Maximum HP Increased.\nGain 10 HP.", 16, 10, -1, 0, 1, 1, 3, 0],
      [1, 1, :stat, "Maximum MP Increased.\Gain 10 MP.", 17, 10, -1, 0, 1, 1, 2, 1], 
      [2, 1, :stat, "Attack power increased.\nGain 15 Points.", 18, 15, -1, 0, 0, 1, 5, 1],
      ]
            
    # Actor 8
    Knowledgebase[8] = [
      [51, 1, :skill], [53, 2, :skill], [54, 3, :skill], [67, 1, :skill], 
      [68, 2, :skill],
      [21, 1, :state, "Line 1 Description.\nLine 2 Description.\nLine 3 Description."],
      [22, 1, :state, "Line 1 Description.\nLine 2 Description."+
"\nLine 3 Description."],
      [23, 1, :state, "Line 1 Description.\nLine 2 Description.\nLine 3 Description."],
      [55, 1, :skill], [57, 2, :skill], [59, 1, :skill], [61, 2, :skill],
      [ 9, 2, :switch, "Switch 9", 16],
      [ 2, 2, :switch, "Switch 2", 16],
      [11, 2, :switch, "Switch 11", 16],
      [33, 2, :variable, "Variable 33 change.", 17, 1, 3, 1],
      [0, 1, :stat, "Maximum HP Increased.\nGain 10 HP.", 18, 10, -1, 0, 1, 1, 3, 0],
      [1, 1, :stat, "Maximum MP Increased.\Gain 10 MP.", 18, 10, -1, 0, 1, 1, 2, 1], 
      ]
          
  end
  
  module Knowledge_Scene
    
    # specify if individual settings are used for each actor
    # if this is false, system will use default settings in main script
    USE_UNIQUE_CONFIGS = true
    
    # Hash value to supplu unique settings
    UNIQUE_ACTOR_CONFIGS = {}
    
		# start of actor configs. Template
    UNIQUE_ACTOR_CONFIGS[0] = {

    # Skill Point Symbol
    :pointsymbol => ' KP',
    
    # Total Skill Point Text
    :totalpointtext1 => 'Knowledge',
    :totalpointtext2 => 'Points:',
    
    # Vocab on Option Window
    :vocabbuy => 'Buy',
    :vocabcancel => 'Cancel',
    :confirm_text => "Apply Points?",
    
    # This determines the design layout for the skill tree
    :tree_pattern => 2,
    # Possible options are 
    # 0 - left to right with each item showing to the right of the last item
    # 1 - Top to bottome. Same as 0 just going down.
    # 2 - 4 groups. Skills up, States right, 
    #               Switches and Variables down, Stats left
    # 3 - default item list layout. displays in order. 
    #     Skills, States, Switch, Variable, Stat
    
    # Tree Group Names
    :tree_group1 => "Skills",
    :tree_group2 => "States",
    :tree_group3 => "Switches",
    :tree_group4 => "Variables",
    :tree_group5 => "Stats",
    
    # Specify which way they go. For pattern 2
    # 0 = Up, 1 = right, 2 = down, 3 = left
    :tree_group1_place => 0, # up -> "Skills"
    :tree_group2_place => 1, # right -> "States"
    :tree_group3_place => 2, # down -> "Switches"
    :tree_group4_place => 2, # down -> "Variables"
    :tree_group5_place => 3, # left -> "Stats"
    
    # direction arrow for tree pattern 2
    :show_arrow => true,
    # arrow image files
    :arrow_up     => "Arrow_U24",
    :arrow_right  => "Arrow_R24",
    :arrow_down   => "Arrow_D24",
    :arrow_left   => "Arrow_L24",
    
    # Columns to show for Tree_Pattern 3
    # recommended 4 for 540x416, recommend 5 for 640x480
    :knowledgewindow_column => 5,
    
    # specify if you want to use a background image
    :use_background => true,
    
    # Actor's Skill Shop Group Background
    # Place background graphic in Graphics/Pictures folder
    :skillbackground => "BG_Knowledge_Actor",
    # + actor_id = BG_Knowledge_Actor1
    # If not using an image, use a background colour. Default black
    # only useful if opacity of the windows is low.
    :knowledgebackground_red   => 0,
    :knowledgebackground_green => 0,
    :knowledgebackground_blue  => 0,
    :knowledgebackground_alpha => 255,
    }
    
		# Actor 1 config
    UNIQUE_ACTOR_CONFIGS[1] = {

    # Skill Point Symbol
    :pointsymbol => ' RTP',
    
    # Total Skill Point Text
    :totalpointtext1 => 'Soldier',
    :totalpointtext2 => 'Points:',
    
    # Vocab on Option Window
    :vocabbuy => 'Buy',
    :vocabcancel => 'Cancel',
    :confirm_text => "Apply Points?",
    
    # This determines the design layout for the skill tree
    :tree_pattern => 3,
    
    # Tree Group Names
    :tree_group1 => "Skills",
    :tree_group2 => "States",
    :tree_group3 => "Switches",
    :tree_group4 => "Variables",
    :tree_group5 => "Stats",
    
    # Specify which way they go. For pattern 2
    # 0 = Up, 1 = right, 2 = down, 3 = left
    :tree_group1_place => 0, # up -> "Skills"
    :tree_group2_place => 1, # right -> "States"
    :tree_group3_place => 2, # down -> "Switches"
    :tree_group4_place => 2, # down -> "Variables"
    :tree_group5_place => 3, # left -> "Stats"
    
    # direction arrow for tree pattern 2
    :show_arrow => true,
    # arrow image files
    :arrow_up     => "Arrow_U24",
    :arrow_right  => "Arrow_R24",
    :arrow_down   => "Arrow_D24",
    :arrow_left   => "Arrow_L24",
    
    # recommended 4 for 540x416, recommend 5 for 640x480
    :knowledgewindow_column => 5,
    
    # specify if you want to use a background image
    :use_background => true,
    
    # Actor's Skill Shop Group Background
    # Place background graphic in Graphics/Pictures folder
    :skillbackground => "BG_Knowledge_Actor1",
    # + actor_id = BG_Knowledge_Actor1
    # If not using an image, use a background colour. Default black
    # only useful if opacity of the windows is low.
    :knowledgebackground_red   => 0,
    :knowledgebackground_green => 0,
    :knowledgebackground_blue  => 0,
    :knowledgebackground_alpha => 255,
    }
    
		# Actor 2 config
    UNIQUE_ACTOR_CONFIGS[2] = {

    # Skill Point Symbol
    :pointsymbol => ' KP',
    
    # Total Skill Point Text
    :totalpointtext1 => 'Known',
    :totalpointtext2 => 'Points:',
    
    # Vocab on Option Window
    :vocabbuy => 'Buy',
    :vocabcancel => 'Cancel',
    :confirm_text => "Apply Points?",
    
    # This determines the design layout for the skill tree
    :tree_pattern => 2,
    
    # Tree Group Names
    :tree_group1 => "Skills",
    :tree_group2 => "States",
    :tree_group3 => "Switches",
    :tree_group4 => "Variables",
    :tree_group5 => "Stats",
    
    # Specify which way they go. For pattern 2
    # 0 = Up, 1 = right, 2 = down, 3 = left
    :tree_group1_place => 0, # up -> "Skills"
    :tree_group2_place => 1, # right -> "States"
    :tree_group3_place => 1, # down -> "Switches"
    :tree_group4_place => 1, # down -> "Variables"
    :tree_group5_place => 3, # left -> "Stats"
    
    # direction arrow for tree pattern 2
    :show_arrow => true,
    # arrow image files
    :arrow_up     => "Arrow_U24",
    :arrow_right  => "Arrow_R24",
    :arrow_down   => "Arrow_D24",
    :arrow_left   => "Arrow_L24",
    
    # recommended 4 for 540x416, recommend 5 for 640x480
    :knowledgewindow_column => 5,
    
    # specify if you want to use a background image
    :use_background => true,
    
    # Actor's Skill Shop Group Background
    # Place background graphic in Graphics/Pictures folder
    :skillbackground => "BG_Knowledge_Actor2",
    # + actor_id = BG_Knowledge_Actor1
    # If not using an image, use a background colour. Default black
    # only useful if opacity of the windows is low.
    :knowledgebackground_red   => 0,
    :knowledgebackground_green => 0,
    :knowledgebackground_blue  => 0,
    :knowledgebackground_alpha => 255,
    }
    
		# Actor 3 config
    UNIQUE_ACTOR_CONFIGS[3] = {

    # Skill Point Symbol
    :pointsymbol => ' AP',
    
    # Total Skill Point Text
    :totalpointtext1 => 'Ability',
    :totalpointtext2 => 'Points:',
    
    # Vocab on Option Window
    :vocabbuy => 'Buy',
    :vocabcancel => 'Cancel',
    :confirm_text => "Apply Points?",
    
    # This determines the design layout for the skill tree
    :tree_pattern => 0,
    
    # Tree Group Names
    :tree_group1 => "Skills",
    :tree_group2 => "States",
    :tree_group3 => "Switches",
    :tree_group4 => "Variables",
    :tree_group5 => "Stats",
    
    # Specify which way they go. For pattern 2
    # 0 = Up, 1 = right, 2 = down, 3 = left
    :tree_group1_place => 0, # up -> "Skills"
    :tree_group2_place => 1, # right -> "States"
    :tree_group3_place => 1, # down -> "Switches"
    :tree_group4_place => 1, # down -> "Variables"
    :tree_group5_place => 3, # left -> "Stats"
    
    # direction arrow for tree pattern 2
    :show_arrow => true,
    # arrow image files
    :arrow_up     => "Arrow_U24",
    :arrow_right  => "Arrow_R24",
    :arrow_down   => "Arrow_D24",
    :arrow_left   => "Arrow_L24",
    
    # recommended 4 for 540x416, recommend 5 for 640x480
    :knowledgewindow_column => 5,
    
    # specify if you want to use a background image
    :use_background => false,
    
    # Actor's Skill Shop Group Background
    # Place background graphic in Graphics/Pictures folder
    :skillbackground => "BG_Knowledge_Actor",
    # + actor_id = BG_Knowledge_Actor1
    # If not using an image, use a background colour. Default black
    # only useful if opacity of the windows is low.
    :knowledgebackground_red   => 20,
    :knowledgebackground_green => 50,
    :knowledgebackground_blue  => 100,
    :knowledgebackground_alpha => 255,
    }
    
		# Actor 8 config
    UNIQUE_ACTOR_CONFIGS[8] = {

    # Skill Point Symbol
    :pointsymbol => ' LP',
    
    # Total Skill Point Text
    :totalpointtext1 => 'Lesson',
    :totalpointtext2 => 'Points:',
    
    # Vocab on Option Window
    :vocabbuy => 'Learn',
    :vocabcancel => 'Cancel',
    :confirm_text => "Take Knowledge",
    
    # This determines the design layout for the skill tree
    :tree_pattern => 1,
    
    # Tree Group Names
    :tree_group1 => "Skills",
    :tree_group2 => "States",
    :tree_group3 => "Switches",
    :tree_group4 => "Variables",
    :tree_group5 => "Stats",
    
    # Specify which way they go. For pattern 2
    # 0 = Up, 1 = right, 2 = down, 3 = left
    :tree_group1_place => 0, # up -> "Skills"
    :tree_group2_place => 1, # right -> "States"
    :tree_group3_place => 3, # down -> "Switches"
    :tree_group4_place => 3, # down -> "Variables"
    :tree_group5_place => 3, # left -> "Stats"
    
    # direction arrow for tree pattern 2
    :show_arrow => true,
    # arrow image files
    :arrow_up     => "Arrow_U24",
    :arrow_right  => "Arrow_R24",
    :arrow_down   => "Arrow_D24",
    :arrow_left   => "Arrow_L24",
    
    # recommended 4 for 540x416, recommend 5 for 640x480
    :knowledgewindow_column => 5,
    
    # specify if you want to use a background image
    :use_background => false,
    
    # Actor's Skill Shop Group Background
    # Place background graphic in Graphics/Pictures folder
    :skillbackground => "BG_Knowledge_Actor",
    # + actor_id = BG_Knowledge_Actor1
    # If not using an image, use a background colour. Default black
    # only useful if opacity of the windows is low.
    :knowledgebackground_red   => 100,
    :knowledgebackground_green => 100,
    :knowledgebackground_blue  => 100,
    :knowledgebackground_alpha => 255,
    }
    
  end
  
end
