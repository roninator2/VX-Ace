# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Knowledge System Base                  ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Create a Skill & Stat purchase system       ║    17 Jul 2026     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Knowledge Actor Data script                              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ This will similate a skill buy system & stat bonuses               ║
# ║ that is seen in many games.                                        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Configure settings below                                         ║
# ║                                                                    ║
# ║   Accessing Actor data for personal switches or variables is as    ║
# ║   follows                                                          ║
# ║                                                                    ║
# ║   get_knowledge_data(actor_id, type, num)                          ║
# ║                                                                    ║
# ║   will return the value of the actors data                         ║
# ║     Two options for switch or variable                             ║
# ║   example                                                          ║
# ║     get_knowledge_data(2, :switch, 3)                              ║
# ║     get_knowledge_data(5, :variable, 24)                           ║
# ║                                                                    ║
# ║   set_knowledge_data(actor_id, type, num, value)                   ║
# ║                                                                    ║
# ║   Example                                                          ║
# ║     set_knowledge_data(2, :switch, 3, true)                        ║
# ║     set_knowledge_data(5, :variable, 24, 15)                       ║
# ║                                                                    ║
# ║   Actor's Add Points                                               ║
# ║     add_knowledge_points(actor_id, points)                         ║
# ║                                                                    ║
# ║   Example                                                          ║
# ║     add_knowledge_points(7, 3)                                     ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 17 Jul 2026 - Script finished                               ║
# ║ 1.01 - 22 Jul 2026 - Added tree formations                         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Yazik - Based off of Yazik's Skill shop                          ║
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

$imported = {} if $imported.nil?
$imported[:r2_kmb] = 1.00          # Knowledge Menu Base

module R2_Knowledge_Menu
  
  # Main Menu command name for skills
  MENU_COMMAND = "Knowledge Tree"
  
  # Command Index in Main Menu
  MENU_INDEX = 1
    
  # Starting Points (When Actor at Level 1)
  StartingPoint = 1
  
  # Point Gain (When Actor Leveled Up)
  PointGain = 1
  
  # change if you have an alternate line height
  Knowledge_LineHeight = 24
  
  # set to true if switches and variables are individually for each actor
  # not global switches or variables
  Knowledge_Actor_Variables = true
    
  # Draw Actor Class and Level
  Knowledge_Actor_Class = false
    
  module Knowledge_Scene 
  # ╔═════════════════════════════════════════════════════════════════════╗
  # ║ These are default settings if individual actor configs are not used ║
  # ╚═════════════════════════════════════════════════════════════════════╝

    # Skill Point Symbol
    PointSymbol = ' KP'
    
    # Total Skill Point Text
    TotalPointText1 = 'Knowledge'
    TotalPointText2 = 'Points:'
    
    # Vocab on Option Window
    VocabBuy = 'Buy'
    VocabCancel = 'Cancel'
    Confirm_Text = "Apply Points?"
    
    # This determines the design layout for the skill tree
    Tree_Pattern = 2
    # Possible options are 
    # 0 - left to right with each item showing to the right of the last item
    # 1 - Top to bottome. Same as 0 just going down.
    # 2 - 4 groups. Skills up, States right, 
    #               Switches and Variables down, Stats left
    # 3 - default item list layout. displays in order. 
    #     Skills, States, Switch, Variable, Stat
    
    Tree_Group1 = "Skills"
    Tree_Group2 = "States"
    Tree_Group3 = "Switches"
    Tree_Group4 = "Variables"
    Tree_Group5 = "Stats"
    
    # Specify which way they go. For pattern 2
    # 0 = Up, 1 = right, 2 = down, 3 = left
    Tree_Group1_Place = 0 # up -> "Skills"
    Tree_Group2_Place = 2 # right -> "States"
    Tree_Group3_Place = 3 # down -> "Switches"
    Tree_Group4_Place = 3 # down -> "Variables"
    Tree_Group5_Place = 1 # left -> "Stats"
    
    # direction arrow for tree pattern 2
    SHOW_ARROW = true
    # arrow image files
    ARROW_UP    = "Arrow_U24"
    ARROW_RIGHT = "Arrow_R24"
    ARROW_DOWN  = "Arrow_D24"
    ARROW_LEFT  = "Arrow_L24"
    
    # Columns to show for Tree_Pattern 3
    # recommended 4 for 540x416, recommend 5 for 640x480
    KnowledgeWindow_Column = 5
    
    # specify if you want to use a background image
    # only relevant if individual actor configs is not sued
    Use_Background = false
    
    # Actor's Skill Shop Group Background
    # if false then actors will use the same image
    Seperate_Images = false
    # Place background graphic in Graphics/Pictures folder
    SkillBackground = "BG_Knowledge_Actor" 
    # + actor_id = BG_Knowledge_Actor1
    # If not using an image, use a background colour. Default black
    # only useful if opacity of the windows is low.
    KnowledgeBackground_Red   = 0
    KnowledgeBackground_Green = 0
    KnowledgeBackground_Blue  = 0
    KnowledgeBackground_Alpha = 255
    
  end
  
# ╔════════════════════════════════════════════════════════════════════╗
# ║       Don't edit below unless you know what you are doing          ║
# ╚════════════════════════════════════════════════════════════════════╝

  module Window_Settings
    # Points Window Settings
    Knowledge_Points_Window_Opacity = 0
    Knowledge_Points_Window_Width = 160
    Knowledge_Points_Window_Height = 96
    Knowledge_Points_Window_X = Graphics.width - Knowledge_Points_Window_Width
    Knowledge_Points_Window_Y = Graphics.height - 96
    Knowledge_Points_Window_Z = 3
    
    # Help Window Settings
    KnowledgeHelp_Window_Opacity = 0
    KnowledgeHelp_LineNumber = 3
    KnowledgeHelp_Window_X = 0
    KnowledgeHelp_Window_Y = 0
    KnowledgeHelp_Window_Z = 200
    KnowledgeHelp_Window_Width = Graphics.width
    
    # Confirm Window Settings
    Knowledge_Confirm_Window_Opacity = 0
    Knowledge_Confirm_Window_X = Graphics.width - 160
    Knowledge_Confirm_Window_Y = Knowledge_Points_Window_Height + R2_Knowledge_Menu::Knowledge_LineHeight
    Knowledge_Confirm_Window_Z = 300
    Knowledge_Confirm_Window_Width = 160
    Knowledge_Confirm_Window_Height = 96
    
    # Actor Window Settings
    KnowledgeActor_Window_Opacity = 0
    KnowledgeActor_Window_Width = 160
    KnowledgeActor_Window_Y = KnowledgeHelp_LineNumber * R2_Knowledge_Menu::Knowledge_LineHeight + 24
    KnowledgeActor_Window_Height = Graphics.height - KnowledgeActor_Window_Y
    KnowledgeActor_Window_X = Graphics.width - KnowledgeActor_Window_Width
    KnowledgeActor_Window_Z = 2
    
    # Knowledge Window Settings
    KnowledgeWindow_Opacity = 0
    KnowledgeWindow_X = 0
    KnowledgeWindow_Y = (KnowledgeHelp_LineNumber + 1) * R2_Knowledge_Menu::Knowledge_LineHeight
    KnowledgeWindow_Z = 1
    KnowledgeWindow_Width = Graphics.width - KnowledgeActor_Window_Width
    KnowledgeWindow_Height = Graphics.height - KnowledgeWindow_Y
  end
  
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║               End of Editable region                               ║
# ╚════════════════════════════════════════════════════════════════════╝

module Vocab
  def self.knowledge
    return R2_Knowledge_Menu::MENU_COMMAND
  end
end

#==============================================================================
# ** Game_Interpreter
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Add Points
  #--------------------------------------------------------------------------
  def add_knowledge_points(actor_id, points)
    $game_actors[actor_id].knowledge_point += points
  end
  #--------------------------------------------------------------------------
  # * Get actor switch / variable
  #--------------------------------------------------------------------------
  def get_knowledge_data(actor_id, type, num)
    if type == :switch
      return $game_actors[actor_id].knowledge_switches[num]
    elsif type == :variable
      return $game_actors[actor_id].knowledge_variables[num]
    else
      $game_message.add("Invalid Command. Please check if you correctly entered the data.\n Is it a :switch or :variable?")
    end
  end
  #--------------------------------------------------------------------------
  # * Change actor switch / variable
  #--------------------------------------------------------------------------
  def set_knowledge_data(actor_id, type, num, value)
    if type == :switch
      return $game_actors[actor_id].knowledge_switches[num] = value
    elsif type == :variable
      return $game_actors[actor_id].knowledge_variables[num] = value
    else
      $game_message.add("Invalid Command. Please check if you correctly entered the data.\n Is it a :switch or :variable?")
    end
  end
end

#==============================================================================
# ** Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Variables
  #--------------------------------------------------------------------------
  attr_accessor :knowledge_point
  attr_accessor :knowledge_groups
  attr_accessor :knowledge_switches
  attr_accessor :knowledge_variables
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  alias :r2_knowledge_setup :setup
  def setup(actor_id)
    r2_knowledge_setup(actor_id)
    @knowledge_switches = []
    @knowledge_variables = []
    if @level > 1
      sp = R2_Knowledge_Menu::StartingPoint
      @knowledge_point = sp + R2_Knowledge_Menu::PointGain * (@level - 1)
    else
      @knowledge_point = R2_Knowledge_Menu::StartingPoint
    end
    @knowledge_groups = {
      :skill => [],
      :state => [],
      :switch => [],
      :variable => [],
      :stat => []
    }
    j = 0; k = 0; l = 0; m = 0; n = 0
    db = R2_Knowledge_Menu::Actor_Data::Knowledgebase[actor_id]
    for i in 0...db.size
      next if db[i].nil?
      if db[i][2] == :skill
        @knowledge_groups[:skill][j] = [db[i][0], db[i][1], db[i][2], false]
        j += 1
      elsif db[i][2] == :state
        @knowledge_groups[:state][k] = [db[i][0], db[i][1], db[i][2], db[i][3], false]
        k += 1
      elsif db[i][2] == :switch
        @knowledge_groups[:switch][l] = [db[i][0], db[i][1], db[i][2], db[i][3], db[i][4], false]
        if R2_Knowledge_Menu::Knowledge_Actor_Variables
          @knowledge_switches[db[i][0]] = false if @knowledge_switches[db[i][0]] == nil
        end
        l += 1
      elsif db[i][2] == :variable
        @knowledge_groups[:variable][m] = [db[i][0], db[i][1], db[i][2], db[i][3], db[i][4], db[i][5], db[i][6], db[i][7], 0]
        if R2_Knowledge_Menu::Knowledge_Actor_Variables
          @knowledge_variables[db[i][0]] = 0 if @knowledge_variables[db[i][0]] == nil
        end
        m += 1
      elsif db[i][2] == :stat
        @knowledge_groups[:stat][n] = [db[i][0], db[i][1], db[i][2], db[i][3], db[i][4], db[i][5], db[i][6], db[i][7], db[i][8], db[i][9], db[i][10], db[i][11], 0]
        n += 1
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Level Up
  #--------------------------------------------------------------------------
  alias :r2_knowledge_level_up :level_up
  def level_up
    r2_knowledge_level_up
    @knowledge_point += R2_Knowledge_Menu::PointGain
  end
end

#==============================================================================
# ** Window_MenuCommand
#==============================================================================

class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def insert_command(index, name, symbol, enabled = true, ext = nil)
    cmd = {:name=>name, :symbol=>symbol, :enabled=>enabled, :ext=>ext}
    @list.insert(index, cmd)
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  alias :yazik_lst_make_command_list :make_command_list
  def make_command_list
    yazik_lst_make_command_list
    cmd_index = R2_Knowledge_Menu::MENU_INDEX
    cmd_name = R2_Knowledge_Menu::MENU_COMMAND
    insert_command(cmd_index, cmd_name, :knowledge, main_commands_enabled)
  end
end

#==============================================================================
# ** Window_KnowledgeStatus
#==============================================================================

class Window_KnowledgeStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, w, h)
    super(x, y, w, h)
    self.opacity = R2_Knowledge_Menu::Window_Settings::KnowledgeActor_Window_Opacity
    self.contents_opacity = 255
    self.z = R2_Knowledge_Menu::Window_Settings::KnowledgeActor_Window_Z
    @actor = nil
  end
  #--------------------------------------------------------------------------
  # * Actor Settings
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return unless @actor
    draw_actor_face(@actor, 0, 0)
    if Graphics.height < 480
      if R2_Knowledge_Menu::Knowledge_Actor_Class
        draw_actor_name(@actor, 0, line_height * 4)
        draw_actor_level(@actor, 0, line_height * 5)
        draw_actor_class(@actor, 0, line_height * 6)
        draw_actor_hp(@actor, 0, line_height * 7)
        draw_actor_mp(@actor, 0, line_height * 8)
      else
        draw_actor_name(@actor, 0, line_height * 4)
        draw_actor_hp(@actor, 0, line_height * 5)
        draw_actor_mp(@actor, 0, line_height * 6)
      end
    else
      if R2_Knowledge_Menu::Knowledge_Actor_Class
        draw_actor_name(@actor, 0, 0)
        draw_actor_level(@actor, 0, line_height * 3)
        draw_actor_class(@actor, 0, line_height * 4)
        draw_actor_hp(@actor, 0, line_height * 5)
        draw_actor_mp(@actor, 0, line_height * 6)
        6.times {|i| draw_actor_param(@actor, 0, line_height * i + line_height * 7, i + 2) }
      else
        draw_actor_name(@actor, 0, line_height * 4)
        draw_actor_hp(@actor, 0, line_height * 5)
        draw_actor_mp(@actor, 0, line_height * 6)
        6.times {|i| draw_actor_param(@actor, 0, line_height * i + line_height * 7, i + 2) }
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Parameters
  #--------------------------------------------------------------------------
  def draw_actor_param(actor, x, y, param_id)
    change_color(system_color)
    draw_text(x, y, 120, line_height, Vocab::param(param_id))
    change_color(normal_color)
    draw_text(x + 90, y, 36, line_height, actor.param(param_id), 2)
  end
end

#==============================================================================
# ** Window_Knowledge_Actor
#==============================================================================

class Window_Knowledge_Actor < Window_ItemList
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, w, h)
    @col_max = 1
    @row_max = 1
    super(x, y, w, h)
    self.opacity = R2_Knowledge_Menu::Window_Settings::KnowledgeWindow_Opacity
    self.contents_opacity = 255
    self.z = R2_Knowledge_Menu::Window_Settings::KnowledgeWindow_Z
  end
  #--------------------------------------------------------------------------
  # * Actor Settings
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    dispose_arrows
    refresh
  end
  #--------------------------------------------------------------------------
  # * actor data
  #--------------------------------------------------------------------------
  def actor_group_size(group)
    return 0 if @actor.nil?
    i = 0
    @actor.knowledge_groups[group].each do |d|
      i += 1 if !d.nil?
    end
    return i
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
    end
    case val
    when 0 # left to right
      max = actor_group_size(:skill)
      max = actor_group_size(:state) if actor_group_size(:state) > max
      max = actor_group_size(:switch) if actor_group_size(:switch) > max
      max = actor_group_size(:variable) if actor_group_size(:variable) > max
      max = actor_group_size(:stat) if actor_group_size(:stat) > max
      max = 1 if max == 0
      @col_max = max
    when 1 # Top to bottome
      @col_max = 5
    when 2 # 4 groups
      @col_max = @group2_dimension[1][0] + @group2_dimension[3][0] + 2
    when 3 # Default item list layout
      if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
        @col_max = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:knowledgewindow_column]
      else
        @col_max = R2_Knowledge_Menu::Knowledge_Scene::KnowledgeWindow_Column
      end
    else
      @col_max = 1
    end
  end
  #--------------------------------------------------------------------------
  # * Get Row Count
  #--------------------------------------------------------------------------
  def row_max
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
    end
    case val
    when 0 # left to right
      @row_max = 5
    when 1 # Top to bottom
      max = actor_group_size(:skill)
      max = actor_group_size(:state) if actor_group_size(:state) > max
      max = actor_group_size(:switch) if actor_group_size(:switch) > max
      max = actor_group_size(:variable) if actor_group_size(:variable) > max
      max = actor_group_size(:stat) if actor_group_size(:stat) > max
      max = 1 if max == 0
      @row_max = max - 2
    when 2 # 4 groups
      @row_max = @group2_dimension[0][0] + @group2_dimension[2][0] + 3
    when 3 # Default item list layout
      @row_max = [(item_max + @col_max - 1) / @col_max, 1].max
    else
      @row_max = 1
    end
  end
  #--------------------------------------------------------------------------
  # * Calculate Width of Window Contents
  #--------------------------------------------------------------------------
  def contents_width
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
    end
    case val
    when 0 # left to right
      (item_width + spacing) * @col_max - standard_padding * 2
    when 1 # Top to bottom
      item_width * @col_max + 64 - standard_padding * 2
    when 2 # 4 groups
      (item_width + spacing) * (@col_max + 2) + spacing
    when 3 # Default item list layout
      width - standard_padding * 2
    end
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  def contents_height
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
    end
    case val
    when 0 # left to right
      item_height * @row_max * 3 - standard_padding * 2
    when 1 # Top to bottom
      item_height * @row_max - standard_padding * 2 + 104
    when 2 # 4 groups
      item_height * (@row_max + 3)- standard_padding * 2 
    when 3 # Default item list layout
      [super - super % item_height, @row_max * item_height].max
    end
  end
  #--------------------------------------------------------------------------
  # * Update Contents Width
  #--------------------------------------------------------------------------
  def update_contents_width
    @contents_width = item_width * (@col_max + 1)
  end
  #--------------------------------------------------------------------------
  # * Update Contents Height
  #--------------------------------------------------------------------------
  def update_contents_height
    @contents_height = item_height * (@row_max + 1)
  end
  #--------------------------------------------------------------------------
  # * Draw All Items
  #--------------------------------------------------------------------------
  def draw_all_items
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
      word1 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group1]
      word2 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group2]
      word3 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group3]
      word4 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group4]
      word5 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group5]
      pos1 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group1_place]
      pos2 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group2_place]
      pos3 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group3_place]
      pos4 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group4_place]
      pos5 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group5_place]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
      word1 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group1
      word2 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group2
      word3 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group3
      word4 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group4
      word5 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group5
      pos1 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group1_Place
      pos2 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group2_Place
      pos3 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group3_Place
      pos4 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group4_Place
      pos5 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group5_Place
    end
    case val
    when 0 # left to right
      change_color(system_color)
      draw_text(0, 8, 120, line_height, word1) if @col1 > 0
      draw_text(0, 72, 120, line_height, word2) if @col2 > 0
      draw_text(0, 136, 120, line_height, word3) if @col3 > 0
      draw_text(0, 200, 120, line_height, word4) if @col4 > 0
      draw_text(0, 264, 120, line_height, word5) if @col5 > 0
      change_color(normal_color)
      item_max.times {|i| draw_item(i) }
    when 1 # Top to bottom
      change_color(system_color)
      draw_text(0, 0, 120, line_height, word1) if @col1 > 0
      draw_text(90, 0, 120, line_height, word2) if @col2 > 0
      draw_text(180, 0, 120, line_height, word3) if @col3 > 0
      draw_text(260, 0, 120, line_height, word4) if @col4 > 0
      draw_text(350, 0, 120, line_height, word5) if @col5 > 0
      change_color(normal_color)
      item_max.times {|i| draw_item(i) }
    when 2 # 4 groups
      arry = [[],[],[],[]]
      arry[pos1] << pos1
      arry[pos2] << pos2
      arry[pos3] << pos3
      arry[pos4] << pos4
      arry[pos5] << pos5
      w = @group2_dimension[3][0]
      h = @group2_dimension[0][0]
      cw = w * (item_width + spacing)
      ch = h * item_height
      xright = (cw + item_width)
      ydown = (ch - item_height)
      change_color(system_color)
      case pos1
      when 0
        if arry[0].size > 1
          adj = 0
          arry[0].size.times do |i|
            adj += 1 if arry[0][i] == nil
          end
          x = xright
          x = xright - (item_width + spacing) * 2 if adj.even?
          y = ydown - item_height * adj
          draw_text(x, y, 120, line_height, word1)
          arry[0][adj] = nil
        else
          x = xright - (item_width + spacing) * 2
          draw_text(x, ydown, 120, line_height, word1)
        end
      when 1
        if arry[1].size > 1
          adj = 0
          arry[1].size.times do |i|
            adj += 1 if arry[1][i] == nil
          end
          x = xright + (item_width + spacing) * adj
          y = ydown
          y = ydown + item_height * 2 if adj.odd?
          draw_text(x, y, 120, line_height, word1)
          arry[1][adj] = nil
        else
          draw_text(xright, ydown, 120, line_height, word1)
        end
      when 2
        if arry[2].size > 1
          adj = 0
          arry[2].size.times do |i|
            adj += 1 if arry[2][i] == nil
          end
          x = xright
          x = xright - (item_width + spacing) * 2 if adj.odd?
          y = ydown + item_height * (adj + 2)
          draw_text(x, y, 120, line_height, word1)
          arry[2][adj] = nil
        else
          y = ydown + item_height * 2
          draw_text(xright, ydown, 120, line_height, word1)
        end
      when 3
        if arry[3].size > 1
          adj = 0
          arry[3].size.times do |i|
            adj += 1 if arry[3][i] == nil
          end
          x = xright - (item_width + spacing) * (adj + 2)
          y = ydown
          y = ydown + item_height * 2 if adj.even?
          draw_text(x, y, 120, line_height, word1)
          arry[3][adj] = nil
        else
          x = xright - (item_width + spacing) * 2
          y = ydown + item_height * 2
          draw_text(x, y, 120, line_height, word1)
        end
      end
      case pos2
      when 0
        if arry[0].size > 1
          adj = 0
          arry[0].size.times do |i|
            adj += 1 if arry[0][i] == nil
          end
          x = xright
          x = xright - (item_width + spacing) * 2 if adj.even?
          y = ydown - item_height * adj
          draw_text(x, y, 120, line_height, word2)
          arry[0][adj] = nil
        else
          x = xright - (item_width + spacing) * 2
          draw_text(x, ydown, 120, line_height, word2)
        end
      when 1
        if arry[1].size > 1
          adj = 0
          arry[1].size.times do |i|
            adj += 1 if arry[1][i] == nil
          end
          x = xright + (item_width + spacing) * adj
          y = ydown
          y = ydown + item_height * 2 if adj.odd?
          draw_text(x, y, 120, line_height, word2)
          arry[1][adj] = nil
        else
          draw_text(xright, ydown, 120, line_height, word2)
        end
      when 2
        if arry[2].size > 1
          adj = 0
          arry[2].size.times do |i|
            adj += 1 if arry[2][i] == nil
          end
          x = xright
          x = xright - (item_width + spacing) * 2 if adj.odd?
          y = ydown + item_height * (adj + 2)
          draw_text(x, y, 120, line_height, word2)
          arry[2][adj] = nil
        else
          y = ydown + item_height * 2
          draw_text(xright, y, 120, line_height, word2)
        end
      when 3
        if arry[3].size > 1
          adj = 0
          arry[3].size.times do |i|
            adj += 1 if arry[3][i] == nil
          end
          x = xright - (item_width + spacing) * (adj + 2)
          y = ydown
          y = ydown + item_height * 2 if adj.even?
          draw_text(x, y, 120, line_height, word2)
          arry[3][adj] = nil
        else
          x = xright - (item_width + spacing) * 2
          y = ydown + item_height * 2
          draw_text(x, y, 120, line_height, word2)
        end
      end
      case pos3
      when 0
        if arry[0].size > 1
          adj = 0
          arry[0].size.times do |i|
            adj += 1 if arry[0][i] == nil
          end
          x = xright
          x = xright - (item_width + spacing) * 2 if adj.even?
          y = ydown - item_height * adj
          draw_text(x, y, 120, line_height, word3)
          arry[0][adj] = nil
        else
          x = xright - (item_width + spacing) * 2
          draw_text(x, ydown, 120, line_height, word3)
        end
      when 1
        if arry[1].size > 1
          adj = 0
          arry[1].size.times do |i|
            adj += 1 if arry[1][i] == nil
          end
          x = xright + (item_width + spacing) * adj
          y = ydown
          y = ydown + item_height * 2 if adj.odd?
          draw_text(x, y, 120, line_height, word3)
          arry[1][adj] = nil
        else
          draw_text(xright, ydown, 120, line_height, word3)
        end
      when 2
        if arry[2].size > 1
          adj = 0
          arry[2].size.times do |i|
            adj += 1 if arry[2][i] == nil
          end
          x = xright
          x = xright - (item_width + spacing) * 2 if adj.odd?
          y = ydown + item_height * (adj + 2)
          draw_text(x, y, 120, line_height, word3)
          arry[2][adj] = nil
        else
          y = ydown + item_height * 2
          draw_text(xright, y, 120, line_height, word3)
        end
      when 3
        if arry[3].size > 1
          adj = 0
          arry[3].size.times do |i|
            adj += 1 if arry[3][i] == nil
          end
          x = xright - (item_width + spacing) * (adj + 2)
          y = ydown
          y = ydown + item_height * 2 if adj.even?
          draw_text(x, y, 120, line_height, word3)
          arry[3][adj] = nil
        else
          x = xright - (item_width + spacing) * 2
          y = ydown + item_height * 2
          draw_text(x, y, 120, line_height, word3)
        end
      end
      case pos4
      when 0
        if arry[0].size > 1
          adj = 0
          arry[0].size.times do |i|
            adj += 1 if arry[0][i] == nil
          end
          x = xright
          x = xright - (item_width + spacing) * 2 if adj.even?
          y = ydown - item_height * adj
          draw_text(x, y, 120, line_height, word4)
          arry[0][adj] = nil
        else
          x = xright - (item_width + spacing) * 2
          draw_text(x, ydown, 120, line_height, word4)
        end
      when 1
        if arry[1].size > 1
          adj = 0
          arry[1].size.times do |i|
            adj += 1 if arry[1][i] == nil
          end
          x = xright + (item_width + spacing) * adj
          y = ydown
          y = ydown + item_height * 2 if adj.odd?
          draw_text(x, y, 120, line_height, word4)
          arry[1][adj] = nil
        else
          draw_text(xright, ydown, 120, line_height, word4)
        end
      when 2
        if arry[2].size > 1
          adj = 0
          arry[2].size.times do |i|
            adj += 1 if arry[2][i] == nil
          end
          x = xright
          x = xright - (item_width + spacing) * 2 if adj.odd?
          y = ydown + item_height * (adj + 2)
          draw_text(x, y, 120, line_height, word4)
          arry[2][adj] = nil
        else
          y = ydown + item_height * 2
          draw_text(xright, y, 120, line_height, word4)
        end
      when 3
        if arry[3].size > 1
          adj = 0
          arry[3].size.times do |i|
            adj += 1 if arry[3][i] == nil
          end
          x = xright - (item_width + spacing) * (adj + 2)
          y = ydown
          y = ydown + item_height * 2 if adj.even?
          draw_text(x, y, 120, line_height, word4)
          arry[3][adj] = nil
        else
          x = xright - (item_width + spacing) * 2
          y = ydown + item_height * 2
          draw_text(x, y, 120, line_height, word4)
        end
      end
      case pos5
      when 0
        if arry[0].size > 1
          adj = 0
          arry[0].size.times do |i|
            adj += 1 if arry[0][i] == nil
          end
          x = xright
          x = xright - (item_width + spacing) * 2 if adj.even?
          y = ydown - item_height * adj
          draw_text(x, y, 120, line_height, word5)
          arry[0][adj] = nil
        else
          x = xright - (item_width + spacing) * 2
          draw_text(x, ydown, 120, line_height, word5)
        end
      when 1
        if arry[1].size > 1
          adj = 0
          arry[1].size.times do |i|
            adj += 1 if arry[1][i] == nil
          end
          x = xright + (item_width + spacing) * adj
          y = ydown
          y = ydown + item_height * 2 if adj.odd?
          draw_text(x, y, 120, line_height, word5)
          arry[1][adj] = nil
        else
          draw_text(xright, ydown, 120, line_height, word5)
        end
      when 2
        if arry[2].size > 1
          adj = 0
          arry[2].size.times do |i|
            adj += 1 if arry[2][i] == nil
          end
          x = xright
          x = xright - (item_width + spacing) * 2 if adj.odd?
          y = ydown + item_height * (adj + 2)
          draw_text(x, y, 120, line_height, word5)
          arry[2][adj] = nil
        else
          y = ydown + item_height * 2
          draw_text(xright, y, 120, line_height, word5)
        end
      when 3
        if arry[3].size > 1
          adj = 0
          arry[3].size.times do |i|
            adj += 1 if arry[3][i] == nil
          end
          x = xright - (item_width + spacing) * (adj + 2)
          y = ydown
          y = ydown + item_height * 2 if adj.even?
          draw_text(x, y, 120, line_height, word5)
          arry[3][adj] = nil
        else
          x = xright - (item_width + spacing) * 2
          y = ydown + item_height * 2
          draw_text(x, y, 120, line_height, word5)
        end
      end
      change_color(normal_color)
      if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
        val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:show_arrow]
      else
        val = R2_Knowledge_Menu::Knowledge_Scene::SHOW_ARROW
      end
      draw_arrow_directions(item_rect(0)) if val
      item_max.times {|i| draw_item(i) }
    when 3 # Default item list layout
      item_max.times {|i| draw_item(i) }
    end
  end
  #--------------------------------------------------------------------------
  # * Get Item Width
  #--------------------------------------------------------------------------
  def item_width
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
    end
    case val
    when 0 # left to right
      return (92 - standard_padding * 2 + spacing)
    when 1 # Top to bottom
      return (width - standard_padding * 2 + spacing) / col_max - spacing
    when 2 # 4 groups
      return (92 - standard_padding * 2 + spacing)
    when 3 # Default item list layout
      return (width - standard_padding * 2 + spacing) / col_max - spacing
    end
  end
  #--------------------------------------------------------------------------
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    line_height
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * Include in Skill List? 
  #--------------------------------------------------------------------------
  def include?(item)
    return item
  end
  #--------------------------------------------------------------------------
  # * Display Skill in Active State?
  #--------------------------------------------------------------------------
  def enable?(data)
    need = false
    if data[2] == :skill
      @actor.knowledge_groups[:skill].each_with_index do |ent, i|
        next if ent == nil
        if ent == data
          need = true if @actor.knowledge_groups[:skill][i][3] == false
        end
      end
    elsif data[2] == :state
      @actor.knowledge_groups[:state].each_with_index do |ent, i|
        next if ent == nil
        if ent == data
          need = true if @actor.knowledge_groups[:state][i][4] == false
        end
      end
    elsif data[2] == :switch
      @actor.knowledge_groups[:switch].each_with_index do |ent, i|
        next if ent == nil
        if ent == data
          need = true if @actor.knowledge_groups[:switch][i][5] == false
        end
      end
    elsif data[2] == :variable
      @actor.knowledge_groups[:variable].each_with_index do |ent, i|
        next if ent == nil
        if ent == data
          need = true if @actor.knowledge_groups[:variable][i][6] > 1
          need = true if @actor.knowledge_groups[:variable][i][6] == -1
        end
      end
    elsif data[2] == :stat
      @actor.knowledge_groups[:stat].each_with_index do |ent, i|
        next if ent == nil
        if ent == data
          need = true if @actor.knowledge_groups[:stat][i][10] > 0
          need = true if @actor.knowledge_groups[:stat][i][10] == -1
        end
      end
    elsif data[2] == :center
      return false
    end
    return need
  end
  #--------------------------------------------------------------------------
  # * Create Abilities List
  #--------------------------------------------------------------------------
  def make_item_list
    if @actor
      @center = [0, 0]
      @col1, @col2, @col3, @col4, @col5 = 0, 0, 0, 0, 0
      @group2_dimension = [[0,[]], [0,[]], [0,[]], [0,[]]]
      @group2_order = {}
      @group2_order[:skill] = [0,[]]
      @group2_order[:state] = [0,[]]
      @group2_order[:switch] = [0,[]]
      @group2_order[:variable] = [0,[]]
      @group2_order[:stat] = [0,[]]
      data = []
      db = @actor.knowledge_groups
      db.each do |key, value|
        if key == :skill
          next if value == []
          value.each do |i|
            if @actor.added_skill_types.include?($data_skills[i[0]].stype_id)
              data << i
              @col1 += 1
              tree_two(:skill, i)
            end
          end
        elsif key == :state
          next if value == []
          value.each do |i|
            if @actor.state_addable?(i[0])
              data << i
              @col2 += 1
              tree_two(:state, i)
            end
          end
        elsif key == :switch
          next if value == []
          value.each do |i|
            data << i
            @col3 += 1
            tree_two(:switch, i)
          end
        elsif key == :variable
          next if value == []
          value.each do |i|
            data << i
            @col4 += 1
            tree_two(:variable, i)
          end
        elsif key == :stat
          next if value == []
          value.each do |i|
            data << i
            @col5 += 1
            tree_two(:stat, i)
          end
        end
      end
      @data = data
      if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
        val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
      else
        val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
      end
      @data.insert(0, @center) if val == 2
      order_group_2 if val == 2
    else
      @data = []
    end
  end
  #--------------------------------------------------------------------------
  # * Include in Skill List? 
  #--------------------------------------------------------------------------
  def tree_two(group, id)
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
      pos1 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group1_place]
      pos2 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group2_place]
      pos3 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group3_place]
      pos4 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group4_place]
      pos5 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group5_place]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
      pos1 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group1_Place
      pos2 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group2_Place
      pos3 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group3_Place
      pos4 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group4_Place
      pos5 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group5_Place
    end
    if val == 2
      case group
      when :skill
        direction = pos1
        @group2_order[:skill][0] = direction
        @group2_order[:skill][1][@group2_order[:skill][1].size] = id
      when :state
        direction = pos2
        @group2_order[:state][0] = direction
        @group2_order[:state][1][@group2_order[:state][1].size] = id
      when :switch
        direction = pos3
        @group2_order[:switch][0] = direction
        @group2_order[:switch][1][@group2_order[:switch][1].size] = id
      when :variable
        direction = pos4
        @group2_order[:variable][0] = direction
        @group2_order[:variable][1][@group2_order[:variable][1].size] = id
      when :stat
        direction = pos5
        @group2_order[:stat][0] = direction
        @group2_order[:stat][1][@group2_order[:stat][1].size] = id
      end
      @col_max = @group2_dimension[1][0] + @group2_dimension[3][0] + 1
      @row_max = @group2_dimension[0][0] + @group2_dimension[2][0] + 1
      @center = [@group2_dimension[0][0] + 1, @group2_dimension[3][0] + 1, :center]
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def order_group_2
    @group2_order.each do |key, value|
      case key
      when :skill
        @group2_dimension[value[0]][0] += @col1
        @group2_dimension[value[0]][1].push(:skill)
      when :state
        @group2_dimension[value[0]][0] += @col2
        @group2_dimension[value[0]][1].push(:state)
      when :switch
        @group2_dimension[value[0]][0] += @col3
        @group2_dimension[value[0]][1].push(:switch)
      when :variable
        @group2_dimension[value[0]][0] += @col4
        @group2_dimension[value[0]][1].push(:variable)
      when :stat
        @group2_dimension[value[0]][0] += @col5
        @group2_dimension[value[0]][1].push(:stat)
      end
    end
    @draw_group = [[0, 0, 0, 1], [0, 0, 0, 1], [0, 0, 0, 1], [0, 0, 0, 1]] # number, current croup
    @group2_dimension.each_with_index do |a, i|
      @draw_group[i][0] = a[0]
      @draw_group[i][1] += a[1].size
    end
    @posg = 0 
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    if @data
      data = @data[index]
      rect = item_rect(index)
      rect.width -= 4
      enabled = enable?(data)
      if data[2] == :skill
        draw_knowledge_icon($data_skills[data[0]].icon_index, rect.x, rect.y, enabled)
      elsif data[2] == :state
        draw_knowledge_icon($data_states[data[0]].icon_index, rect.x, rect.y, enabled)
      else
        return if data[2] == :center
        draw_knowledge_icon(data[4], rect.x, rect.y, enabled)
      end
      draw_knowledge_price(rect, data[1], enabled)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item Icon
  #--------------------------------------------------------------------------
  def draw_knowledge_icon(id, x, y, enabled)
    return unless id
    draw_icon(id, x, y, enabled)
  end
  #--------------------------------------------------------------------------
  # * Draw Knowledge Price
  #--------------------------------------------------------------------------
  def draw_knowledge_price(rect, price, enabled)
    draw_text(rect.x + 16, rect.y, 36, line_height, price.to_s, 1) if enabled
    change_color(system_color)
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      word = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:pointsymbol]
      draw_text(rect.x + 32, rect.y, 44, line_height, word, 2) if enabled
    else
      draw_text(rect.x + 32, rect.y, 44, line_height, R2_Knowledge_Menu::Knowledge_Scene::PointSymbol, 2) if enabled
    end
    change_color(normal_color)
  end
  #-----------------------------------------------------------------------------
  # Draw Arrow Graphics
  #-----------------------------------------------------------------------------
  def draw_arrow_directions(center)
    step = item_width + spacing
    draw_arrow(:arrow_up,    center.x + item_width - step - 48, center.y - item_height * 2) if @group2_dimension[0][1].size > 0
    draw_arrow(:arrow_right, center.x + item_width + step, center.y - item_height) if @group2_dimension[1][1].size > 0
    draw_arrow(:arrow_down,  center.x + item_width + spacing, center.y + item_height * 2) if @group2_dimension[2][1].size > 0
    draw_arrow(:arrow_left,  center.x - step - 48, center.y + item_height) if @group2_dimension[3][1].size > 0
  end

  #-----------------------------------------------------------------------------
  # Draw Arrow
  #-----------------------------------------------------------------------------
  def draw_arrow(key, x, y)
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      filename = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][key]
    else
      filename = case key
      when :arrow_left  then R2_Knowledge_Menu::Knowledge_Scene::ARROW_LEFT
      when :arrow_right then R2_Knowledge_Menu::Knowledge_Scene::ARROW_RIGHT
      when :arrow_up    then R2_Knowledge_Menu::Knowledge_Scene::ARROW_UP
      when :arrow_down  then R2_Knowledge_Menu::Knowledge_Scene::ARROW_DOWN
      end
    end
    bitmap = Cache.system(filename)
    contents.blt(x, y, bitmap, bitmap.rect)
  end
  #-----------------------------------------------------------------------------
  #
  #-----------------------------------------------------------------------------
  def dispose_arrows
    [@leftarrow, @rightarrow, @uparrow, @downarrow].compact.each(&:dispose)
    @leftarrow = @rightarrow = @uparrow = @downarrow = nil
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    return rect if @data == []
    data = @data[index]
    pos = 0
    type = data[2]
    if type != :center
      db = @actor.knowledge_groups[type]
      for i in 0...db.size
        next if db[i].nil?
        pos = i if db[i][0] == data[0]
      end
    end
    rect.width = item_width
    rect.height = item_height
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
      pos1 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group1_place]
      pos2 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group2_place]
      pos3 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group3_place]
      pos4 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group4_place]
      pos5 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_group5_place]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
      pos1 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group1_Place
      pos2 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group2_Place
      pos3 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group3_Place
      pos4 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group4_Place
      pos5 = R2_Knowledge_Menu::Knowledge_Scene::Tree_Group5_Place
    end
    case val
    when 0 # left to right
      case type
      when :skill
        rect.y = 32
        @row = 0
      when :state
        rect.y = 96
        @row = 1
      when :switch
        rect.y = 160
        @row = 2
      when :variable
        rect.y = 224
        @row = 3
      when :stat
        rect.y = 288
        @row = 4
      end
      rect.x = pos * (item_width + spacing)
    when 1 # top to bottom
      rect.y = R2_Knowledge_Menu::Knowledge_LineHeight * pos + 32
      case type
      when :skill
        rect.x = 0
        @col = 0
      when :state
        rect.x = 90
        @col = 1
      when :switch
        rect.x = 180
        @col = 2
      when :variable
        rect.x = 270
        @col = 3
      when :stat
        rect.x = 360
        @col = 4
      end
    when 2 # 4 groups - switches and variables together
      # design is like a plus sign
      case type
      when :skill
        direction = pos1
      when :state
        direction = pos2
      when :switch
        direction = pos3
      when :variable
        direction = pos4
      when :stat
        direction = pos5
      when :center
        rect.x = (@group2_dimension[3][0]) * (item_width + spacing)
        rect.y = item_height * (@group2_dimension[0][0])
        return rect
      end
      pos = @draw_group[direction][2]
      @draw_group[direction][2] += 1
      case direction
      when 0
        rect.x = (@group2_dimension[3][0]) * (item_width + spacing)
        rect.y = (item_height * @group2_dimension[0][0]) - (item_height * (pos + 1))
      when 1
        rect.x = (pos + 1) * (item_width + spacing) + @group2_dimension[3][0] * (item_width + spacing)
        rect.y = item_height * (@group2_dimension[0][0])
      when 2
        rect.x = (@group2_dimension[3][0]) * (item_width + spacing)
        rect.y = item_height * @group2_dimension[0][0] + item_height * (pos + 1)
      when 3
        pos = pos - @draw_group[direction][0]
        rect.x = -(((@group2_dimension[3][0] + pos) * (item_width + spacing)) - ((@group2_dimension[3][0] - 1) * (item_width + spacing)))
        rect.y = item_height * (@group2_dimension[0][0])
      end
    when 3 # default
      rect.x = index % @col_max * (item_width + spacing)
      rect.y = index / @col_max * item_height
    end
    return rect
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item) if @help_window
  end
  #--------------------------------------------------------------------------
  # * Get Spacing for Items Arranged Side by Side
  #--------------------------------------------------------------------------
  def spacing
    return 12
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Increase Index Position for Multi Array
  #--------------------------------------------------------------------------
  def move_index_up
    @index += 1
    @posg += 1
    select(@index)
  end
  #--------------------------------------------------------------------------
  # * Increase Index Position for Multi Array
  #--------------------------------------------------------------------------
  def move_index_down
    @index -= 1
    @posg -= 1
    select(@index)
  end
  #--------------------------------------------------------------------------
  # * Find current position for direction
  #--------------------------------------------------------------------------
  def get_current_location(dir, rev)
    data = @data[@index]
    group_data = []
    grp = @group2_dimension[dir][1].size
    grp.times do |gp|
      case @group2_dimension[dir][1][gp]
      when :skill
        group_data << :skill
      when :state
        group_data << :state
      when :switch
        group_data << :switch
      when :variable
        group_data << :variable
      when :stat
        group_data << :stat
      end
    end
    if group_data.include?(data[2])
      return dir
    else
      return rev
    end
  end
  #--------------------------------------------------------------------------
  # * Increase Index Position for Multi Array
  #--------------------------------------------------------------------------
  def move_multi_index_up(dir, rev)
    move = get_current_location(dir, rev)
    gpamt = get_group_info(move)
    cnt = 0
    gpamt.size.times do |a|
      cnt += gpamt[a]
      if (@posg + 1) > cnt
        next
      else
        chggrp = @group2_dimension[move][1][a + 1]
        chgpos = []
        @data.each_with_index do |b, c|
          if b[2] == chggrp
            chgpos << c
          end
        end
        return if chggrp == nil
        @index = chgpos[0]
        @posg += 1
        select(@index)
        return
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Decrease Index Position for Multi Array
  #--------------------------------------------------------------------------
  def move_multi_index_down(dir, rev)
    move = get_current_location(dir, rev)
    gpamt = get_group_info(move)
    cnt = 0
    gpamt.size.times do |a|
      cnt += gpamt[a]
      if (@posg) == cnt
        chggrp = @group2_dimension[move][1][a]
        chgpos = []
        @data.each_with_index do |b, c|
          if b[2] == chggrp
            chgpos << c
          end
        end
        return if chggrp == nil
        @index = chgpos[-1]
        @posg -= 1
        select(@index)
        return
      else
        next
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Get Index Item
  #--------------------------------------------------------------------------
  def get_group_info(dir)
    gpamt = []
    grp = @group2_dimension[dir][1].size
    grp.times do |gp|
      case @group2_dimension[dir][1][gp]
      when :skill
        gpamt[gp] = @col1
      when :state
        gpamt[gp] = @col2
      when :switch
        gpamt[gp] = @col3
      when :variable
        gpamt[gp] = @col4
      when :stat
        gpamt[gp] = @col5
      end
    end
    return gpamt
  end
  #--------------------------------------------------------------------------
  # * Get Index Item
  #--------------------------------------------------------------------------
  def item_index(index, dir)
    data = @data[index]
    pos = 0
    type = data[2]
    if type != :center
      db = @actor.knowledge_groups[type]
      for i in 0...db.size
        next if db[i].nil?
        pos = i if db[i][0] == data[0]
      end
    end
    case dir
    when 0
      reverse = 2
    when 1
      reverse = 3
    when 2
      reverse = 0
    when 3
      reverse = 1
    end
    count = 0
    multi = false
    amt = 0
    if (@group2_dimension[dir][1].size > 1) &&
        (@group2_dimension[dir][1].any? {|gp| gp == type} ) && 
        (@group2_dimension[reverse][1].size <= 1)
      multi = true
      @group2_dimension[dir][1].each do |i|
        @group2_order[i][1].each do |j|
          count += 1 if i == j[2]
        end
      end
    elsif (@group2_dimension[reverse][1].size > 1) && 
        (@group2_dimension[reverse][1].any? {|gp| gp == type} ) && 
        (@group2_dimension[dir][1].size <= 1)
      multi = true
      @group2_dimension[reverse][1].each do |i|
        @group2_order[i][1].each do |j|
          count += 1 if i == j[2]
        end
      end
    elsif (@group2_dimension[dir][1].size > 1) && 
        (@group2_dimension[reverse][1].size > 1)
      multi = true
      msgbox('both ways')
    else
      @group2_dimension.each do |aa|
        amt = aa[0] if type == aa[1][0]
      end
    end
    if index == 0
      case dir
      when 0
        return if @group2_dimension[0][1][0] == nil
        item = @group2_order[@group2_dimension[0][1][0]][1][0]
      when 1
        return if @group2_dimension[1][1][0] == nil
        item = @group2_order[@group2_dimension[1][1][0]][1][0]
      when 2
        return if @group2_dimension[2][1][0] == nil
        item = @group2_order[@group2_dimension[2][1][0]][1][0]
      when 3
        return if @group2_dimension[3][1][0] == nil
        item = @group2_order[@group2_dimension[3][1][0]][1][0]
      end
      @data.each_with_index do |it, k|
        @index = k if it == item
        select(k) if it == item
      end
    else
      case dir
      when 0
        if multi == true
          if (@group2_dimension[1][1].any? {|gp| gp == type} ) || 
             (@group2_dimension[3][1].any? {|gp| gp == type} )
            return
          elsif (type == @group2_dimension[0][1][-1]) && (@posg == count - 1)
            return
          elsif (type == @group2_dimension[2][1][0]) && (@posg == 0)
            select(0)
            @index = 0
          elsif (@group2_dimension[2][1].any? {|gp| gp == type} ) && (@posg > 0)
            if @data[@index][2] == @data[@index - 1][2]
              move_index_down
            else
              move_multi_index_down(dir, reverse)
            end
          elsif (@group2_dimension[0][1].any? {|gp| gp == type} ) && (@posg < count - 1)
            if @data[@index][2] == @data[@index + 1][2]
              move_index_up
            else
              move_multi_index_up(dir, reverse)
            end
          else
            msgbox("outside known parameters 0 multi")
          end
        else
          if pos == 0 && type == @group2_dimension[2][1][0]
            select(0)
            @index = 0
          elsif (@group2_dimension[1][1].any? {|gp| gp == type} ) || 
                (@group2_dimension[3][1].any? {|gp| gp == type} )
            return
          elsif (type == @group2_dimension[0][1][0]) && (pos == amt - 1)
            return
          elsif (type == @group2_dimension[0][1][0]) && (pos < amt - 1)
            @index += 1
            select(@index)
          elsif (type == @group2_dimension[2][1][0]) && (pos > 0)
            @index -= 1
            select(@index)
          else
            msgbox("outside known parameters 0")
          end
        end
      when 1
        if multi == true
          if (@group2_dimension[2][1].any? {|gp| gp == type} ) || 
             (@group2_dimension[0][1].any? {|gp| gp == type} )
            return
          elsif (type == @group2_dimension[1][1][-1]) && (@posg == count - 1)
            return
          elsif (type == @group2_dimension[3][1][0]) && (@posg == 0)
            select(0)
            @index = 0
          elsif (@group2_dimension[3][1].any? {|gp| gp == type} ) && (@posg > 0)
            if @data[@index][2] == @data[@index - 1][2]
              move_index_down
            else
              move_multi_index_down(dir, reverse)
            end
          elsif (@group2_dimension[1][1].any? {|gp| gp == type} ) && (@posg < count - 1)
            if @data[@index][2] == @data[@index + 1][2]
              move_index_up
            else
              move_multi_index_up(dir, reverse)
            end
          else
            msgbox("outside known parameters 1 multi")
          end
        else
          if pos == 0 && type == @group2_dimension[3][1][0]
            select(0)
            @index = 0
          elsif (@group2_dimension[2][1].any? {|gp| gp == type} ) || 
                (@group2_dimension[0][1].any? {|gp| gp == type} )
            return
          elsif (type == @group2_dimension[1][1][0]) && (pos == amt - 1)
            return
          elsif (type == @group2_dimension[1][1][0]) && (pos < amt - 1)
            @index += 1
            select(@index)
          elsif (type == @group2_dimension[3][1][0]) && (pos > 0)
            @index -= 1
            select(@index)
          else
            msgbox("outside known parameters 1")
          end
        end
      when 2
        if multi == true
          if (@group2_dimension[1][1].any? {|gp| gp == type} ) || 
             (@group2_dimension[3][1].any? {|gp| gp == type} )
          elsif (type == @group2_dimension[2][1][-1]) && (@posg == count - 1)
            return
          elsif (type == @group2_dimension[0][1][0]) && (@posg == 0)
            select(0)
            @index = 0
          elsif (@group2_dimension[0][1].any? {|gp| gp == type} ) && (@posg > 0)
            if @data[@index][2] == @data[@index - 1][2]
              move_index_down
            else
              move_multi_index_down(dir, reverse)
            end
          elsif (@group2_dimension[2][1].any? {|gp| gp == type} ) && (@posg < count - 1)
            if @data[@index][2] == @data[@index + 1][2]
              move_index_up
            else
              move_multi_index_up(dir, reverse)
            end
          else
            msgbox("outside known parameters 2 multi")
          end
        else
          if pos == 0 && type == @group2_dimension[0][1][0]
            select(0)
            @index = 0
          elsif (@group2_dimension[1][1].any? {|gp| gp == type} ) || 
                (@group2_dimension[3][1].any? {|gp| gp == type} )
            return
          elsif (type == @group2_dimension[2][1][0]) && (pos == amt - 1)
            return
          elsif (type == @group2_dimension[2][1][0]) && (pos < amt - 1)
            @index += 1
            select(@index)
          elsif (type == @group2_dimension[0][1][0]) && (pos > 0)
            @index -= 1
            select(@index)
          else
            msgbox("outside known parameters 2")
          end
        end
      when 3
        if multi == true
          if (@group2_dimension[0][1].any? {|gp| gp == type} ) || 
             (@group2_dimension[2][1].any? {|gp| gp == type} )
            return
          elsif (type == @group2_dimension[3][1][-1]) && (@posg == count - 1)
            return
          elsif (type == @group2_dimension[1][1][0]) && (@posg == 0)
            select(0)
            @index = 0
          elsif (@group2_dimension[1][1].any? {|gp| gp == type} ) && (@posg > 0)
            if @data[@index][2] == @data[@index - 1][2]
              move_index_down
            else
              move_multi_index_down(dir, reverse)
            end
          elsif (@group2_dimension[3][1].any? {|gp| gp == type} ) && (@posg < count - 1)
            if @data[@index][2] == @data[@index + 1][2]
              move_index_up
            else
              move_multi_index_up(dir, reverse)
            end
          else
            msgbox("outside known parameters 3 multi")
          end
        else
          if pos == 0 && type == @group2_dimension[1][1][0]
            select(0)
            @index = 0
          elsif (@group2_dimension[0][1].any? {|gp| gp == type} ) || 
                (@group2_dimension[2][1].any? {|gp| gp == type} )
            return
          elsif (type == @group2_dimension[3][1][0]) && (pos == amt - 1)
            return
          elsif (type == @group2_dimension[3][1][0]) && (pos < amt - 1)
            @index += 1
            select(@index)
          elsif (type == @group2_dimension[1][1][0]) && (pos > 0)
            @index -= 1
            select(@index)
          else
            msgbox("outside known parameters 3")
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
    end
    case val
    when 0 # left to right
      case row
      when 0
        if @col2 >= index + 1
          select(index + @col1)
        else
          if @col3 >= index + 1
            select(index + @col1 + @col2)
          else
            if @col4 >= index + 1
              select(index + @col1 + @col2 + @col3)
            else
              if @col5 >= index + 1
                select(index + @col1 + @col2 + @col3 + @col4)
              else
                return
              end
            end
          end
        end
      when 1
        dif = index - @col1 + 1
        if @col3 >= dif
          select(dif + @col1 + @col2 - 1)
        else
          if @col4 >= dif
            select(dif + @col1 + @col2 + @col3 - 1)
          else
            if @col5 >= dif
              select(dif + @col1 + @col2 + @col3 + @col4 - 1)
            else
              return
            end
          end
        end
      when 2
        dif = index - @col1 - @col2 + 1
        if @col4 >= dif
          select(dif + @col1 + @col2 + @col3 - 1)
        else
          if @col5 >= dif
            select(dif + @col1 + @col2 + @col3 + @col4 - 1)
          else
            return
          end
        end
      when 3
        dif = index - @col1 - @col2 - @col3 + 1
        if @col5 >= dif
          select(dif + @col1 + @col2 + @col3 + @col4 - 1)
        else
          return
        end
      when 4
        return
      end
    when 1 # Top to bottom
      case col
      when 0
        if index < @col1 - 1
          select(index + 1)
        else
          return
        end
      when 1
        if index < (@col1 + @col2 - 1)
          select(index + 1)
        else
          return
        end
      when 2
        if index < (@col1 + @col2 + @col3 - 1)
          select(index + 1)
        else
          return
        end
      when 3
        if index < (@col1 + @col2 + @col3 + @col4 - 1)
          select(index + 1)
        else
          return
        end
      when 4
        if index < (@col1 + @col2 + @col3 + @col4 + @col5 - 1)
          select(index + 1)
        else
          return
        end
      end
    when 2 # 4 groups
      item_index(index, 2)
    when 3 # Default item list layout
      if index < item_max - col_max || (wrap && col_max == 1)
        select((index + col_max) % item_max)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
    end
    case val
    when 0 # left to right
      case row
      when 0
        return
      when 1
        dif = (index - @col1 + 1)
        if @col1 >= dif
          select(dif - 1)
        else
          return
        end
      when 2
        dif = (index - @col1 - @col2 + 1)
        if @col2 >= dif
          select(dif + @col1 - 1)
        else
          if @col1 >= dif
            select(dif - 1)
          else
            return
          end
        end
      when 3
        dif = (index - @col1 - @col2 - @col3 + 1)
        if @col3 >= dif
          select(dif + @col1 + @col2 - 1)
        else
          if @col2 >= dif
            select(dif + @col1 - 1)
          else
            if @col1 >= dif
              select(dif - 1)
            else
              return
            end
          end
        end
      when 4
        dif = (index - @col1 - @col2 - @col3 - @col4 + 1)
        if @col4 >= dif
          select(dif + @col1 + @col2 + @col3 - 1)
        else
          if @col3 >= dif
            select(dif + @col1 + @col2 - 1)
          else
            if @col2 >= dif
              select(dif + @col1 - 1)
            else
              if @col1 >= dif
                select(dif - 1)
              else
                return
              end
            end
          end
        end
      end
    when 1 # Top to bottom
      case col
      when 0
        if index == 0
          return
        elsif index <= @col1 - 1
          select(index - 1)
        else
          return
        end
      when 1
        if index == @col1
          return
        elsif index <= (@col1 + @col2 - 1)
          select(index - 1)
        else
          return
        end
      when 2
        if index == @col1 + @col2
          return
        elsif index <= (@col1 + @col2 + @col3 - 1)
          select(index - 1)
        else
          return
        end
      when 3
        if index == @col1 + @col2 + @col3
          return
        elsif index <= (@col1 + @col2 + @col3 + @col4 - 1)
          select(index - 1)
        else
          return
        end
      when 4
        if index == @col1 + @col2 + @col3 + @col4
          return
        elsif index <= (@col1 + @col2 + @col3 + @col4 + @col5 - 1)
          select(index - 1)
        else
          return
        end
      end
    when 2 # 4 groups
      item_index(index, 0)
    when 3 # Default item list layout
      if index >= col_max || (wrap && col_max == 1)
        select((index - col_max + item_max) % item_max)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
    end
    case val
    when 0 # left to right
      case row
      when 0
        if index < @col1 - 1
          select(index + 1)
        else
          return
        end
      when 1
        if index < (@col1 + @col2 - 1)
          select(index + 1)
        else
          return
        end
      when 2
        if index < (@col1 + @col2 + @col3 - 1)
          select(index + 1)
        else
          return
        end
      when 3
        if index < (@col1 + @col2 + @col3 + @col4 - 1)
          select(index + 1)
        else
          return
        end
      when 4
        if index < (@col1 + @col2 + @col3 + @col4 + @col5 - 1)
          select(index + 1)
        else
          return
        end
      end
    when 1 # Top to bottom
      case col
      when 0
        if @col2 >= index + 1
          select(index + @col1)
        else
          if @col3 >= index + 1
            select(index + @col1 + @col2 - 1)
          else
            if @col4 >= index + 1
              select(index + @col1 + @col2 + @col3 - 1)
            else
              if @col5 >= index + 1
                select(index + @col1 + @col2 + @col3 + @col4 - 1)
              else
                return
              end
            end
          end
        end
      when 1
        dif = index - @col1 + 1
        if @col3 >= dif
          select(dif + @col1 + @col2 - 1)
        else
          if @col4 >= dif
            select(dif + @col1 + @col2 + @col3 - 1)
          else
            if @col5 >= dif
              select(dif + @col1 + @col2 + @col3 + @col4 - 1)
            else
              return
            end
          end
        end
      when 2
        dif = index - @col1 - @col2 + 1
        if @col4 >= dif
          select(dif + @col1 + @col2 + @col3 - 1)
        else
          if @col5 >= dif
            select(dif + @col1 + @col2 + @col3 + @col4 - 1)
          else
            return
          end
        end
      when 3
        dif = index - @col1 - @col2 - @col3 + 1
        if @col5 >= dif
          select(dif + @col1 + @col2 + @col3 + @col4 - 1)
        else
          return
        end
      when 4
        return
      end
    when 2 # 4 groups
      item_index(index, 1)
    when 3 # Default item list layout
      if col_max >= 2 && (index < item_max - 1 || (wrap && horizontal?))
        select((index + 1) % item_max)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
    end
    case val
    when 0 # left to right
      case row
      when 0
        if index == 0
          return
        elsif index <= @col1 - 1
          select(index - 1)
        else
          return
        end
      when 1
        if index == @col1
          return
        elsif index <= (@col1 + @col2 - 1)
          select(index - 1)
        else
          return
        end
      when 2
        if index == @col1 + @col2
          return
        elsif index <= (@col1 + @col2 + @col3 - 1)
          select(index - 1)
        else
          return
        end
      when 3
        if index == @col1 + @col2 + @col3
          return
        elsif index <= (@col1 + @col2 + @col3 + @col4 - 1)
          select(index - 1)
        else
          return
        end
      when 4
        if index == @col1 + @col2 + @col3 + @col4
          return
        elsif index <= (@col1 + @col2 + @col3 + @col4 + @col5 - 1)
          select(index - 1)
        else
          return
        end
      end
    when 1 # Top to bottom
      case col
      when 0
        return
      when 1
        dif = (index - @col1 + 1)
        if @col1 >= dif
          select(dif - 1)
        else
          return
        end
      when 2
        dif = (index - @col1 - @col2 + 1)
        if @col2 >= dif
          select(dif + @col1 - 1)
        else
          if @col1 >= dif
            select(dif - 1)
          else
            return
          end
        end
      when 3
        dif = (index - @col1 - @col2 - @col3 + 1)
        if @col3 >= dif
          select(dif + @col1 + @col2 - 1)
        else
          if @col2 >= dif
            select(dif + @col1 - 1)
          else
            if @col1 >= dif
              select(dif - 1)
            else
              return
            end
          end
        end
      when 4
        dif = (index - @col1 - @col2 - @col3 - @col4 + 1)
        if @col4 >= dif
          select(dif + @col1 + @col2 + @col3 - 1)
        else
          if @col3 >= dif
            select(dif + @col1 + @col2 - 1)
          else
            if @col2 >= dif
              select(dif + @col1 - 1)
            else
              if @col1 >= dif
                select(dif - 1)
              else
                return
              end
            end
          end
        end
      end
    when 2 # 4 groups
      item_index(index, 3)
    when 3 # Default item list layout
      if col_max >= 2 && (index > 0 || (wrap && horizontal?))
        select((index - 1 + item_max) % item_max)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Get Current Line
  #--------------------------------------------------------------------------
  def row
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
    end
    case val
    when 0 # left to right
      if index > (@col1 + @col2 + @col3 + @col4 - 1)
        return 4
      elsif index > (@col1 + @col2 + @col3 - 1)
        return 3
      elsif index > (@col1 + @col2 - 1)
        return 2
      elsif index > (@col1 - 1)
        return 1
      else
        return 0
      end
    when 1 # Top to bottom
      data = @data[index]
      pos = 0
      type = data[2]
      db = @actor.knowledge_groups[type]
      for i in 0...db.size
        next if db[i].nil?
        pos = i if db[i][0] == data[0]
      end
      return pos
    when 2 # 4 groups
      data = @data[index]
      pos = 0
      type = data[2]
      return 0 if type == :center
      db = @actor.knowledge_groups[type]
      for i in 0...db.size
        next if db[i].nil?
        pos = i if db[i][0] == data[0]
      end
      return pos
    when 3 # Default item list layout
      index / col_max
    end
  end
  #--------------------------------------------------------------------------
  # * Get Current Column
  #--------------------------------------------------------------------------
  def col
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
    end
    case val
    when 1 # Top to bottom
      if index > (@col1 + @col2 + @col3 + @col4 - 1)
        return 4
      elsif index > (@col1 + @col2 + @col3 - 1)
        return 3
      elsif index > (@col1 + @col2 - 1)
        return 2
      elsif index > (@col1 - 1)
        return 1
      else
        return 0
      end
    when 2 # 4 groups
      data = @data[index]
      pos = 0
      type = data[2]
      return 0 if type == :center
      db = @actor.knowledge_groups[type]
      for i in 0...db.size
        next if db[i].nil?
        pos = i if db[i][0] == data[0]
      end
      return pos
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Down
  #--------------------------------------------------------------------------
  def cursor_pagedown
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Up
  #--------------------------------------------------------------------------
  def cursor_pageup
  end
  #--------------------------------------------------------------------------
  # * Get Leading Digits
  #--------------------------------------------------------------------------
  def top_col
    ox / (item_width + spacing)
  end
  #--------------------------------------------------------------------------
  # * Set Leading Digits
  #--------------------------------------------------------------------------
  def top_col=(column)
    self.ox = column * (item_width + spacing)
  end
  #--------------------------------------------------------------------------
  # * Get Trailing Digits
  #--------------------------------------------------------------------------
  def bottom_col
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      return top_col + R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:knowledgewindow_column] - 1
    else
      return top_col + R2_Knowledge_Menu::Knowledge_Scene::KnowledgeWindow_Column - 1
		end
  end
  #--------------------------------------------------------------------------
  # * Set Trailing Digits
  #--------------------------------------------------------------------------
  def bottom_col=(column)
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      self.top_col = column - R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:knowledgewindow_column] + 1
    else
      self.top_col = column - R2_Knowledge_Menu::Knowledge_Scene::KnowledgeWindow_Column + 1
		end
  end
  #--------------------------------------------------------------------------
  # * Scroll Cursor to Position Within Screen
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
    end
    case val
    when 0 # left to right
      case row
      when 0
        self.top_col = index if index < top_col 
        self.bottom_col = index if index > bottom_col
      when 1
        pos = index - @col1
        self.top_col = pos if pos < top_col 
        self.bottom_col = pos if pos > bottom_col
      when 2
        pos = index - @col1 - @col2
        self.top_col = pos if pos < top_col 
        self.bottom_col = pos if pos > bottom_col
      when 3
        pos = index - @col1 - @col2 - @col3
        self.top_col = pos if pos < top_col 
        self.bottom_col = pos if pos > bottom_col
      when 4
        pos = index - @col1 - @col2 - @col3 - @col4
        self.top_col = pos if pos < top_col 
        self.bottom_col = pos if pos > bottom_col
      end
    when 1 # Top to bottom
      self.top_row = row if row < top_row
      self.bottom_row = row if row > bottom_row
    when 2 # 4 groups
      data = @data[@index]
      pos = 0
      type = data[2]
      if type != :center
        db = @actor.knowledge_groups[type]
        for i in 0...db.size
          next if db[i].nil?
          pos = i if db[i][0] == data[0]
        end
      end
      if @index == 0
        @help_window.clear
        self.ox = 0
        self.oy = 0
        w = @group2_dimension[3][0]
        h = @group2_dimension[0][0]
        hw = self.width / 2
        hh = self.height / 2
        cw = w * (item_width + spacing)
        ch = h * item_height
        cr = cw - hw
        self.ox += (cr + (item_width / 2))
        cr = ch - hh
        self.oy += (cr + item_height)
        @oy_saved = self.oy if @oy_saved.nil?
        @ox_saved = self.ox if @ox_saved.nil?
      end
      shiftx = 0
      shifty = 0
      case type
      when :skill
        dir = @group2_order[:skill][0]
        shiftx = get_ox_adjust(:skill, pos, dir)
        shifty = get_oy_adjust(:skill, pos, dir)
      when :state
        dir = @group2_order[:state][0]
        shiftx = get_ox_adjust(:state, pos, dir)
        shifty = get_oy_adjust(:state, pos, dir)
      when :switch
        dir = @group2_order[:switch][0]
        shiftx = get_ox_adjust(:switch, pos, dir)
        shifty = get_oy_adjust(:switch, pos, dir)
      when :variable
        dir = @group2_order[:variable][0]
        shiftx = get_ox_adjust(:variable, pos, dir)
        shifty = get_oy_adjust(:variable, pos, dir)
      when :stat
        dir = @group2_order[:stat][0]
        shiftx = get_ox_adjust(:stat, pos, dir)
        shifty = get_oy_adjust(:stat, pos, dir)
      when :center
        return
      end
      case dir
      when 0, 2
        shift = shifty * item_height
        self.oy += shift
        new_cursor_pos(shift,true)
      else
        shift = shiftx * (item_width + spacing)
        self.ox += shift
        new_cursor_pos(shift,false)
      end
    when 3 # Default item list layout
      self.top_row = row if row < top_row
      self.bottom_row = row if row > bottom_row
    end
  end
  #--------------------------------------------------------------------------
  # * Find Cursor Position
  #--------------------------------------------------------------------------
  def get_ox_adjust(key, pos, dir)
    case dir
    when 0, 2
      return 0
    else
      @group2_dimension.each do |a|
        if a[1].any? {|gp| gp == key}
          if a[1].size == 1
            return (pos + 1) if dir == 1
            return (a[0] - pos - 1 - a[0])
          else
            x1, x2, x3, x4, x5 = 0, 0, 0, [], 0
            a[1].each { |ar| x4 << ar }
            a[1].each_with_index do |b, i|
              if b == key
                x1 = @group2_order[key][1].size
                x2 = i
              end
            end
            x2.times do |g|
              x3 += @group2_order[x4[g]][1].size
            end
            x5 = pos + x3 + 1
            return x5 if dir == 1
            return -x5 if dir == 3
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Find Cursor Position
  #--------------------------------------------------------------------------
  def get_oy_adjust(key, pos, dir)
    case dir
    when 1, 3
      return 0
    else
    @group2_dimension.each do |a|
      if a[1].any? {|gp| gp == key}
        if a[1].size == 1
          return (-pos - 1) if dir == 0
          return (pos + 1)
        else
          x1, x2, x3, x4, x5 = 0, 0, 0, [], 0
          a[1].each { |ar| x4 << ar }
          a[1].each_with_index do |b, i|
            if b == key
              x1 = @group2_order[key][1].size
              x2 = i
            end
          end
          x2.times do |g|
            x3 += @group2_order[x4[g]][1].size
          end
          x5 = pos + x3 + 1
          return x5 if dir == 2
          return -x5 if dir == 0
        end
      end
    end
    end
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
    end
    if val == 2
      if @index < 0
        cursor_rect.empty
      else
        self.oy = @oy_saved == nil ? 0 : @oy_saved
        self.ox = @ox_saved == nil ? 0 : @ox_saved
        cursor_rect.set(item_rect(0))
        ensure_cursor_visible
      end
    else
      if @cursor_all
        cursor_rect.set(0, 0, contents.width, row_max * item_height)
        self.top_row = 0
      elsif @index < 0
        cursor_rect.empty
      else
        ensure_cursor_visible
        cursor_rect.set(item_rect(@index))
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Adjust Cursor Rext Y
  #--------------------------------------------------------------------------
  def new_cursor_pos(shift, adj)
    rect = Rect.new
    rect.x = cursor_rect.x
    rect.y = cursor_rect.y
    rect.width = cursor_rect.width
    rect.height = cursor_rect.height
    rect.y += shift if adj == true
    rect.x += shift if adj == false
    cursor_rect.set(rect)
  end
  #--------------------------------------------------------------------------
  # * Adjust Cursor Rext Y
  #--------------------------------------------------------------------------
  def page_col_max
    (width - padding ) / item_width
  end
  #--------------------------------------------------------------------------
  # * Get Number of Rows Displayable on 1 Page
  #--------------------------------------------------------------------------
  def page_row_max
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:tree_pattern]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Tree_Pattern
    end
    if val == 1
      (height - padding - padding_bottom - 32) / item_height
    else
      (height - padding - padding_bottom) / item_height
    end
  end
  #--------------------------------------------------------------------------
  # * Get Number of Rows Displayable on 1 Page
  #--------------------------------------------------------------------------
  def page_col_max
    (width - padding ) / item_width
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items Displayable on 1 Page
  #--------------------------------------------------------------------------
  def page_item_max
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:knowledgewindow_column]
    else
      val = page_row_max * R2_Knowledge_Menu::Knowledge_Scene::KnowledgeWindow_Column
		end
    return val
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return unless @actor
    make_item_list
    col_max
    row_max
    update_contents_width
    update_contents_height
    create_contents
    draw_all_items
  end
end

#==============================================================================
# ** Window_KnowledgeHelp
#==============================================================================

class Window_KnowledgeHelp < Window_Help
  #--------------------------------------------------------------------------
  # * Inicialização
  #--------------------------------------------------------------------------
  def initialize(line_number = R2_Knowledge_Menu::Window_Settings::KnowledgeHelp_LineNumber)
    super(R2_Knowledge_Menu::Window_Settings::KnowledgeHelp_LineNumber)
    self.x = R2_Knowledge_Menu::Window_Settings::KnowledgeHelp_Window_X
    self.y = R2_Knowledge_Menu::Window_Settings::KnowledgeHelp_Window_Y
    self.width = R2_Knowledge_Menu::Window_Settings::KnowledgeHelp_Window_Width
    self.opacity = R2_Knowledge_Menu::Window_Settings::KnowledgeHelp_Window_Opacity
    self.contents_opacity = 255
    self.z = R2_Knowledge_Menu::Window_Settings::KnowledgeHelp_Window_Z
    @item_name = ''
  end
  #--------------------------------------------------------------------------
  # * Actor Settings
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #--------------------------------------------------------------------------
  def set_text(text)
    if text != @text
      @text = text
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #--------------------------------------------------------------------------
  def set_item(ary)
    text = ""
    case ary[2]
    when :skill
      item = $data_skills[ary[0]]
      set_text("#{item.name}"+"\n"+"#{item.description}")
    when :state
      for ent in 0..@actor.knowledge_groups[:state].size
        next if @actor.knowledge_groups[:state][ent].nil?
        text = @actor.knowledge_groups[:state][ent][3] if @actor.knowledge_groups[:state][ent][0] == ary[0]
      end
      set_text(text)
    when :switch
      for ent in 0..@actor.knowledge_groups[:switch].size
        next if @actor.knowledge_groups[:switch][ent].nil?
        text = @actor.knowledge_groups[:switch][ent][3] if @actor.knowledge_groups[:switch][ent][0] == ary[0]
      end
      set_text(text)
    when :variable
      for ent in 0..@actor.knowledge_groups[:variable].size
        next if @actor.knowledge_groups[:variable][ent].nil?
        text = @actor.knowledge_groups[:variable][ent][3] if @actor.knowledge_groups[:variable][ent][0] == ary[0]
      end
      set_text(text)
    when :stat
      for ent in 0..@actor.knowledge_groups[:stat].size
        next if @actor.knowledge_groups[:stat][ent].nil?
        text = @actor.knowledge_groups[:stat][ent][3] if @actor.knowledge_groups[:stat][ent][0] == ary[0]
      end
      set_text(text)
    end
  end
end

#==============================================================================
# ** Window_KnowledgePoint
#==============================================================================

class Window_KnowledgePoint < Window_Base
  #--------------------------------------------------------------------------
  # * Inicialização
  #--------------------------------------------------------------------------
  def initialize(x,y,w,h)
    super(x, y, w, h)
    @actor = nil
    self.z = R2_Knowledge_Menu::Window_Settings::Knowledge_Points_Window_Z
    self.opacity = R2_Knowledge_Menu::Window_Settings::Knowledge_Points_Window_Opacity
    self.contents_opacity = 255
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Atualização
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      txt1 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:totalpointtext1]
      txt2 = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:totalpointtext2]
    else
      txt1 = R2_Knowledge_Menu::Knowledge_Scene::TotalPointText1
      txt2 = R2_Knowledge_Menu::Knowledge_Scene::TotalPointText2
    end
    points = @actor.knowledge_point.to_s
    change_color(system_color)
    draw_text(0, line_height, contents.width, line_height, txt1)
    draw_text(0, line_height * 2, contents.width, line_height, txt2)
    change_color(normal_color)
    draw_text(0, line_height * 2, contents.width, line_height, points, 2)
  end
end

#==============================================================================
# ** Window_Confirm
#==============================================================================

class Window_Knowledge_Confirm < Window_Command
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize(x,y,w,h)
    @width = w
    @height = h
    super(x,y)
    self.opacity = R2_Knowledge_Menu::Window_Settings::Knowledge_Confirm_Window_Opacity
    self.contents_opacity = 255
    self.z = R2_Knowledge_Menu::Window_Settings::Knowledge_Confirm_Window_Z
    self.openness = 0
  end
  #--------------------------------------------------------------------------
  # * Set Window Width
  #--------------------------------------------------------------------------
  def window_width
    return @width
  end
  #--------------------------------------------------------------------------
  # * Set Window Height
  #--------------------------------------------------------------------------
  def window_height
    return @height
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
  end
  #--------------------------------------------------------------------------
  # * Make Command List
  #--------------------------------------------------------------------------
  def make_command_list
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      buy = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:vocabbuy]
      can = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:vocabcancel]
      add_command(buy, :confirm_buy, true)
      add_command(can, :confirm_cancel, true)
    else
      add_command(R2_Knowledge_Menu::Knowledge_Scene::VocabBuy, :confirm_buy, true)
      add_command(R2_Knowledge_Menu::Knowledge_Scene::VocabCancel, :confirm_cancel, true)
    end
  end
  #--------------------------------------------------------------------------
  # * Get Alignment
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  #--------------------------------------------------------------------------
  # * Draw All Items
  #--------------------------------------------------------------------------
  def draw_all_items
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      txt = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:confirm_text]
    else
      txt = R2_Knowledge_Menu::Knowledge_Scene::Confirm_Text
    end
    draw_text(0, 0, contents.width, line_height, txt, 1)
    item_max.times {|i| draw_item(i) }
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items (for Text)
  #--------------------------------------------------------------------------
  def item_rect_for_text(index)
    rect = item_rect(index)
    rect.x += 4
    rect.y += 24
    rect.width -= 8
    rect
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @cursor_all
      cursor_rect.set(0, 0, contents.width, row_max * item_height)
      self.top_row = 0
    elsif @index < 0
      cursor_rect.empty
    else
      ensure_cursor_visible
      cursor_rect.set(item_rect(@index))
      cursor_rect.y += 24
    end
  end
end

#==============================================================================
# ** Scene_Menu
#==============================================================================

class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  alias :r2_knowledge_create_command_window :create_command_window
  def create_command_window
    r2_knowledge_create_command_window
    @command_window.set_handler(:knowledge, method(:command_personal))
  end
  #--------------------------------------------------------------------------
  # * [OK] Personal Command
  #--------------------------------------------------------------------------
  alias :r2_on_personal_ok_skill :on_personal_ok
  def on_personal_ok
    case @command_window.current_symbol
    when :knowledge
      SceneManager.call(Scene_Knowledge)
    else
      r2_on_personal_ok_skill
    end
  end
end

#==============================================================================
# ** Scene_Knowledge
#==============================================================================

class Scene_Knowledge < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Initialization
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_background_image
    create_background
    create_points_window
    create_confirm_window
    create_actor_window
    create_item_window
    on_actor_change
  end
  #--------------------------------------------------------------------------
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @knowledge_help = Window_KnowledgeHelp.new(R2_Knowledge_Menu::Window_Settings::KnowledgeHelp_LineNumber)
    @knowledge_help.viewport = @viewport
    @knowledge_help.actor = @actor
  end
  #--------------------------------------------------------------------------
  # * Create Actor Window
  #--------------------------------------------------------------------------
  def create_actor_window
    wx = R2_Knowledge_Menu::Window_Settings::KnowledgeActor_Window_X
    wy = R2_Knowledge_Menu::Window_Settings::KnowledgeActor_Window_Y
    ww = R2_Knowledge_Menu::Window_Settings::KnowledgeActor_Window_Width
    wh = R2_Knowledge_Menu::Window_Settings::KnowledgeActor_Window_Height
    @actor_window = Window_KnowledgeStatus.new(wx,wy,ww,wh)
    @actor_window.actor = @actor
  end
  #--------------------------------------------------------------------------
  # * Create Background Image
  #--------------------------------------------------------------------------
  def create_background_image
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:use_background]
      bg = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:skillbackground]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Use_Background
      image = R2_Knowledge_Menu::Knowledge_Scene::SkillBackground
      if R2_Knowledge_Menu::Knowledge_Scene::Seperate_Images
        bg = "#{image}"+"#{@actor.id}"
      else
        bg = image
      end
		end
    return if val == false
    dispose_actor_change_background if @background_image
    @background_image = Sprite.new
    @background_image.bitmap = Cache.picture(bg)
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:use_background]
      r = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:knowledgebackground_red]
      g = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:knowledgebackground_green]
      b = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:knowledgebackground_blue]
      a = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:knowledgebackground_alpha]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Use_Background
      r = R2_Knowledge_Menu::Knowledge_Scene::KnowledgeBackground_Red
      g = R2_Knowledge_Menu::Knowledge_Scene::KnowledgeBackground_Green
      b = R2_Knowledge_Menu::Knowledge_Scene::KnowledgeBackground_Blue
      a = R2_Knowledge_Menu::Knowledge_Scene::KnowledgeBackground_Alpha
		end
    return if val == true
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(r, g, b, 255)
    @background_sprite.z = 1
  end
  #--------------------------------------------------------------------------
  # * Free Background
  #--------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose if !@background_sprite.disposed?
  end
  #--------------------------------------------------------------------------
  # * Create Confirm Window
  #--------------------------------------------------------------------------
  def create_confirm_window
    wx = R2_Knowledge_Menu::Window_Settings::Knowledge_Confirm_Window_X
    wy = R2_Knowledge_Menu::Window_Settings::Knowledge_Confirm_Window_Y
    ww = R2_Knowledge_Menu::Window_Settings::Knowledge_Confirm_Window_Width
    wh = R2_Knowledge_Menu::Window_Settings::Knowledge_Confirm_Window_Height
    @confirm_window = Window_Knowledge_Confirm.new(wx, wy, ww, wh)
    @confirm_window.actor = @actor
    @confirm_window.set_handler(:confirm_buy, method(:buy_item))
    @confirm_window.set_handler(:confirm_cancel, method(:activate_knowledge_window))
    @confirm_window.set_handler(:cancel, method(:activate_knowledge_window))
    @confirm_window.close
    @confirm_window.deactivate
  end
  #--------------------------------------------------------------------------
  # * Create Info Window
  #--------------------------------------------------------------------------  
  def create_points_window
    wx = R2_Knowledge_Menu::Window_Settings::Knowledge_Points_Window_X
    wy = R2_Knowledge_Menu::Window_Settings::Knowledge_Points_Window_Y
    ww = R2_Knowledge_Menu::Window_Settings::Knowledge_Points_Window_Width
    wh = R2_Knowledge_Menu::Window_Settings::Knowledge_Points_Window_Height
    @point_window = Window_KnowledgePoint.new(wx,wy,ww,wh)
    @point_window.actor = @actor
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    wx = R2_Knowledge_Menu::Window_Settings::KnowledgeWindow_X
    wy = R2_Knowledge_Menu::Window_Settings::KnowledgeWindow_Y
    ww = R2_Knowledge_Menu::Window_Settings::KnowledgeWindow_Width
    wh = R2_Knowledge_Menu::Window_Settings::KnowledgeWindow_Height
    @item_window = Window_Knowledge_Actor.new(wx, wy, ww, wh)
    @item_window.actor = @actor
    @item_window.viewport = @viewport
    @item_window.help_window = @knowledge_help
    @item_window.set_handler(:ok,       method(:on_item_ok))
    @item_window.set_handler(:cancel,   method(:return_scene))
    @item_window.set_handler(:pagedown, method(:next_actor))
    @item_window.set_handler(:pageup,   method(:prev_actor))
    @item_window.select(0)
    @item_window.activate
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    item = @item_window.item
    good_buy = false
    good_buy = true if (item[2] == :skill) && (item[3] == false) && 
      (item[1] <= @actor.knowledge_point)
    good_buy = true if (item[2] == :state) && (item[4] == false) && 
      (item[1] <= @actor.knowledge_point)
    good_buy = true if (item[2] == :switch) && (item[5] == false) && 
      (item[1] <= @actor.knowledge_point)
    good_buy = true if (item[2] == :variable) && ((item[7] > 0) || (item[7] == -1)) && 
      (item[1] <= @actor.knowledge_point)
    good_buy = true if (item[2] == :stat) && ((item[10] > 0) || (item[10] == -1)) && 
      (item[1] <= @actor.knowledge_point)
    if good_buy == true
      @confirm_window.open
      @confirm_window.select(0)
      @confirm_window.activate
    else
      Sound.play_buzzer
      @item_window.activate
    end
  end
  #--------------------------------------------------------------------------
  # * Activate Knowledge Window
  #--------------------------------------------------------------------------
  def activate_knowledge_window
    @confirm_window.close
    @confirm_window.deactivate
    @item_window.refresh
    @item_window.activate
  end
  #--------------------------------------------------------------------------
  # * Buy Skill or State
  #--------------------------------------------------------------------------
  def buy_item
    item = @item_window.item
    case item[2]
    when :skill
      @actor.learn_skill(item[0])
      @actor.knowledge_point -= item[1]
      @actor.knowledge_groups[:skill].each do |ent|
        ent[3] = true if ent == item
      end
    when :state
      @actor.add_state(item[0])
      @actor.knowledge_point -= item[1]
      @actor.knowledge_groups[:state].each do |ent|
        ent[4] = true if ent == item
      end
    when :switch
      $game_switches[item[0]] = true
      @actor.knowledge_point -= item[1]
      @actor.knowledge_groups[:switch].each do |ent|
        ent[5] = true if ent == item
      end
    when :variable
      $game_variables[item[0]] += item[5]
      @actor.knowledge_point -= item[1]
      @actor.knowledge_groups[:variable].each do |ent|
        if ent == item
          ent[1] += ent[7]
          ent[6] -= 1 if (ent[6] != -1) || (ent[6] > 0)
          ent[8] += 1 if ent[6] != -1
        end
      end
    when :stat
      @actor.add_param(item[0],item[5])
      @actor.add_param(item[6],-item[7])
      @actor.knowledge_point -= item[1]
      @actor.knowledge_groups[:stat].each do |ent|
        if ent == item
          ent[1] += ent[11]
          ent[5] -= ent[9] if ent[8] >= ent[12]
          ent[10] -= 1 if (ent[10] != -1) && (ent[10] > 0)
          ent[12] += 1 if (ent[10] != -1) && (ent[10] > 0)
        end
      end
    end
    @point_window.refresh
    @actor_window.refresh
    @confirm_window.close
    @confirm_window.deactivate
    @item_window.refresh
    @item_window.activate
  end
  #--------------------------------------------------------------------------
  # * Terminate
  #--------------------------------------------------------------------------
  def terminate
    @item_window.dispose_arrows
    super
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:use_background]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Use_Background
		end
    return if val == false
    if val == true
      dispose_background
      @background_image.bitmap.dispose
      @background_image.dispose
      @background_image = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose Background
  #--------------------------------------------------------------------------
  def dispose_actor_change_background
    if R2_Knowledge_Menu::Knowledge_Scene::USE_UNIQUE_CONFIGS && @actor
      val = R2_Knowledge_Menu::Knowledge_Scene::UNIQUE_ACTOR_CONFIGS[@actor.id][:use_background]
    else
      val = R2_Knowledge_Menu::Knowledge_Scene::Use_Background
		end
    if val == true
      @background_image.bitmap.dispose
      @background_image.dispose
      @background_image = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Switch to Next Actor
  #--------------------------------------------------------------------------
  alias :r2_actor_next_change :next_actor
  def next_actor
    dispose_actor_change_background
    r2_actor_next_change
  end
  #--------------------------------------------------------------------------
  # * Switch to Previous Actor
  #--------------------------------------------------------------------------
  alias :r2_actor_prev_change :prev_actor
  def prev_actor
    dispose_actor_change_background
    r2_actor_prev_change
  end
  #--------------------------------------------------------------------------
  # * Actor change terminate
  #--------------------------------------------------------------------------
  def change_window_terminate
    @item_window.dispose_arrows
    @item_window.dispose
    create_item_window
  end
  #--------------------------------------------------------------------------
  # * Change Actors
  #--------------------------------------------------------------------------
  def on_actor_change
    dispose_background
    create_background_image
    create_background
    @point_window.actor = @actor
    @actor_window.actor = @actor
    @knowledge_help.actor = @actor
    change_window_terminate
    @item_window.select(0)
    @item_window.activate
  end
end
