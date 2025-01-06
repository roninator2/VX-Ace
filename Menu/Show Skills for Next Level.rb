# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Show skills for next level             ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Display the next 5 skills that              ╠════════════════════╣
# ║   are learned at upcoming levels              ║    25 Oct 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║        Display skills for next level                               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║     Plug and play                                                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 25 Oct 2022 - Script finished                               ║
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

module R2_Show_Next_Skills
  Amount = 5
  Use_R2_Method = true
end


class Window_SkillList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end
end

class Window_SkillNextList < Window_SkillList
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @actor = nil
    @stype_id = 0
    @data = []
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * Set Skill Type ID
  #--------------------------------------------------------------------------
  def stype_id=(stype_id)
    return if @stype_id == stype_id
    @stype_id = stype_id
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    R2_Show_Next_Skills::Amount
  end
  #--------------------------------------------------------------------------
  # * Include in Skill List?
  #--------------------------------------------------------------------------
  def include?(item)
    item && item.stype_id == @stype_id
  end
  #--------------------------------------------------------------------------
  # * Display Skill in Active State?
  #--------------------------------------------------------------------------
  def enable?(item)
    @actor && @actor.usable?(item)
  end
  
  if R2_Show_Next_Skills::Use_R2_Method
    #--------------------------------------------------------------------------
    # * Create Skill List
    #--------------------------------------------------------------------------
    def make_item_list
      @data = []
      cur_data = []
      @all_data = []
      aval_data = []
      cur_data = @actor ? @actor.skills.select {|skill| include?(skill) } : []
      @all_data = $data_classes[@actor.class_id].learnings
      for i in 0..@all_data.size - 1
        skill = $data_skills[@all_data[i].skill_id]
        found = false
        cur_data.each do |line|
          found = true if line.id == skill.id
        end
        next if found == true
        aval_data[i] = skill
      end
      aval_data.compact!
      for i in 0..item_max
        @data << aval_data[i] unless aval_data[i].nil?
      end
    end
    #--------------------------------------------------------------------------
    # * Draw Skill Use Cost
    #--------------------------------------------------------------------------
    def draw_skill_level(rect, skill)
      level = 0
      @all_data.each do |entry|
        level = entry.level if entry.skill_id == skill.id
      end
      change_color(text_color(18), true)
      text = "LV "+level.to_s
      draw_text(rect, text, 2)
    end
  else
    def level_next
      @actor.level + 1
    end
    def level_max
      @actor.level + 10
    end
    def make_item_list
      @data = []
      @all_data = {}
      learn_skills = $data_classes[@actor.class_id].learnings
      learn_skills.each do |learn|
        next if learn.level < level_next or learn.level > level_max
        @data << $data_skills[learn.skill_id]
        @all_data[learn.skill_id] = learn.level
        break if @data.size == item_max
      end
    end
    def draw_skill_level(rect, skill)
      level = @all_data[skill.id] || 0
      change_color(text_color(18), true)
      draw_text(rect, "LV#{level}", 2)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = @data[index]
    if skill
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(skill, rect.x, rect.y, enable?(skill))
      draw_skill_level(rect, skill)
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end

class Scene_Skill < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  alias r2_scene_skill_start_next_skills  start
  def start
    r2_scene_skill_start_next_skills
    create_next_window
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_next_window
    wx = Graphics.width / 2
    wy = @status_window.y + @status_window.height
    ww = Graphics.width / 2
    wh = Graphics.height - wy
    @next_window = Window_SkillNextList.new(wx, wy, ww, wh)
    @next_window.actor = @actor
    @next_window.viewport = @viewport
    @command_window.skill_window = @next_window
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    wx = 0
    wy = @status_window.y + @status_window.height
    ww = Graphics.width / 2
    wh = Graphics.height - wy
    @item_window = Window_SkillList.new(wx, wy, ww, wh)
    @item_window.actor = @actor
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @command_window.skill_window = @item_window
  end
end
