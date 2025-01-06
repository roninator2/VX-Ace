# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: KFBQ Battle Log Override     ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   FFMQ Style Battle Log             ║    13 Mar 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║                                                          ║
# ║  none                                                    ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker - Except nudity           ║
# ╚══════════════════════════════════════════════════════════╝

#==============================================================================
# ** Window_BattleLog
#==============================================================================
class Window_BattleLog < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, window_width, window_height)
    self.z = -1 # <- added to hide window
    self.opacity = 0
    @lines = []
    @num_wait = 0
    create_back_bitmap
    create_back_sprite
    refresh
  end
  def max_line_number
    return 1
  end
end

#==============================================================================
# ** KFBQ_BattleLog
#==============================================================================
class KFBQ_BattleLog < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(20, Graphics.height - 148, window_width, window_height)
    self.z = 200
    self.opacity = 0
    self.back_opacity = 255
    @lines = []
    @num_wait = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width - 40
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(max_line_number)
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Number of Lines
  #--------------------------------------------------------------------------
  def max_line_number
    return 1
  end
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    @num_wait = 0
    @lines.clear
    self.opacity = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * Open Log Window
  #--------------------------------------------------------------------------
  def show_message
    self.opacity = 255
  end
  #--------------------------------------------------------------------------
  # * Get Number of Data Lines
  #--------------------------------------------------------------------------
  def line_number
    @lines.size
  end
  #--------------------------------------------------------------------------
  # * Go Back One Line
  #--------------------------------------------------------------------------
  def back_one
    @lines.pop
    refresh
  end
  #--------------------------------------------------------------------------
  # * Return to Designated Line
  #--------------------------------------------------------------------------
  def back_to(line_number)
    @lines.pop while @lines.size > line_number
    refresh
  end
  #--------------------------------------------------------------------------
  # * Add Text
  #--------------------------------------------------------------------------
  def add_text(text)
    @lines.push(text)
    show_message
    refresh
  end
  #--------------------------------------------------------------------------
  # * Replace Text
  #    Replaces the last line with different text.
  #--------------------------------------------------------------------------
  def replace_text(text)
    @lines.pop
    @lines.push(text)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Text From Last Line
  #--------------------------------------------------------------------------
  def last_text
    @lines[-1]
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    @lines.size.times {|i| draw_line(i) }
  end
  #--------------------------------------------------------------------------
  # * Draw Line
  #--------------------------------------------------------------------------
  def draw_line(line_number)
    rect = item_rect_for_text(line_number)
    contents.clear_rect(rect)
    draw_text_ex(rect.x, rect.y, @lines[line_number])
  end
  #--------------------------------------------------------------------------
  # * Set Wait Method
  #--------------------------------------------------------------------------
  def method_wait=(method)
    @method_wait = method
  end
  #--------------------------------------------------------------------------
  # * Set Wait Method for Effect Execution
  #--------------------------------------------------------------------------
  def method_wait_for_effect=(method)
    @method_wait_for_effect = method
  end
  #--------------------------------------------------------------------------
  # * Wait
  #--------------------------------------------------------------------------
  def wait
    @num_wait += 1
    if Input.press?(:A) || Input.press?(:B) || Input.press?(:C)
      @num_wait = message_speed
    end
    @method_wait.call(message_speed) if @method_wait
  end
  #--------------------------------------------------------------------------
  # * Wait Until Effect Execution Ends
  #--------------------------------------------------------------------------
  def wait_for_effect
    @method_wait_for_effect.call if @method_wait_for_effect
  end
  #--------------------------------------------------------------------------
  # * Get Message Speed
  #--------------------------------------------------------------------------
  def message_speed
    return 30
  end
  #--------------------------------------------------------------------------
  # * Wait and Clear
  #    Clear after inputing minimum necessary wait for the message to be read.
  #--------------------------------------------------------------------------
  def wait_and_clear
    wait while @num_wait < 2 if line_number > 0
    clear
  end
  #--------------------------------------------------------------------------
  # * Display Skill/Item Use
  #--------------------------------------------------------------------------
  def display_use_item(subject, item)
    if item.is_a?(RPG::Skill)
      if subject.is_a?(Game_Actor)
        weapon = (subject.equips[0].id).to_i
        wpn_name = $data_weapons[weapon].name
        if item.id == 1
          add_text(subject.name + " attacks with " + wpn_name)
          unless item.message2.empty?
            wait
            add_text(item.message2)
          end
        else
          add_text(subject.name + " uses " + item.name)
          unless item.message2.empty?
            wait
            add_text(item.message2)
          end
        end
      end
    else
      add_text(sprintf(Vocab::UseItem, subject.name, item.name))
    end
  end
  #--------------------------------------------------------------------------
  # * Display Skill/Item Use
  #--------------------------------------------------------------------------
  def defeat_enemy
    add_text(" Defeated the enemy. ")
  end
  #--------------------------------------------------------------------------
  # * Display Action Results
  #--------------------------------------------------------------------------
  def display_action_results(target, item)
    if target.result.used
      last_line_number = line_number
      wait if line_number > last_line_number
      back_to(last_line_number)
    end
  end
  #--------------------------------------------------------------------------
  # * Display Action Results
  #--------------------------------------------------------------------------
  def display_enemy_weakness(name, state, value1, value2)
    strong = "strong"
    weak = "weak"
    value = ((value1 + value2) / 2)
    if value != 1.00
      defense = value > 1.00 ? weak : strong
      state_name = $data_states[state].name
      text = sprintf("%s is %s against %s attack", name, defense, state_name)
      add_text(text)
    end
  end
end
