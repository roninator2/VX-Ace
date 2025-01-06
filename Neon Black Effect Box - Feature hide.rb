# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Effect Box Feature hide      ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║ Neon Black Effect Box -             ╠════════════════════╣
# ║ Hide Features from effect box       ║    01 Nov 2020     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ A mod to Neon Blacks Effect Box                          ║
# ║ Allows to hide effects (features)                        ║
# ║                                                          ║
# ║ Use notetag on items, weapons, armours or skills         ║
# ║ <no effect: X>                                           ║
# ║ where X is the number for the effect                     ║
# ║ *The first effect is 1 the second 2, etc.                ║
# ║ Useful for things like calling common events             ║
# ╚══════════════════════════════════════════════════════════╝
# ╔═════════════════════════════════════╗
# ║ Terms of use:                       ║
# ║ Follow the Original Authors terms   ║
# ╚═════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Notes                                                    ║
# ║ If an item has no effects and an empty note box,         ║
# ║ no effect box will be shown.                             ║
# ║ If you have one effect and nothing in the note box,      ║
# ║ then effect box will be shown even if you use            ║
# ║ <no effect: 1> it will just be empty                     ║
# ║ In those circumstances put the normal <effect note>      ║
# ║ in the note box with some info, then it won't look as bad║
# ╚══════════════════════════════════════════════════════════╝

# also fixed some bugs from the original script

module R2
  module Effect_Box
    Regex = /<no[-_ ]effect:[-_ ]\s*(\d+)\s*>/imx
  end
end
  
class Window_Selectable < Window_Base
  def key_show_features_box
    case CP::EFFECTS_WINDOW::SHOW_TYPE
    when 0
      return Input.press?(CP::EFFECTS_WINDOW::BOX_KEY)
    when 1
      @show = !@show if Input.trigger?(CP::EFFECTS_WINDOW::BOX_KEY)
      return @show 
    when 2
      return true
    else
      return false
    end
  end
end

class Window_FeaturesShow < Window_Base

  def notes
    @item.effect_desc
  end

  def effects
    if @item.is_a?(RPG::EquipItem)
      @item.features
    elsif @item.is_a?(RPG::UsableItem)
      @item.effects
    end
  end

  def seps
    i = 0
    i += 1 unless effects.empty?
    i += 1 unless notes.empty?
    i += 1 unless stats.empty?
    return [i, 0].max
  end

  def draw_all_items
    contents.clear
    y = 0
    notes.each do |l|
      draw_text(1, y, contents.width, line_height, l)
      y += line_height
    end
    y += line_height / 2 unless y == 0
    unless stats.empty?
      w = stats.collect{|s| contents.text_size(s).width}.max + 2
      xt = contents.width / w
      xw = contents.width / xt
      xn = 0
      y -= line_height
      stats.each_with_index do |s, index|
        y += line_height if index % xt == 0
        case s
        when /(.*)   (-?)(\d+)/i
          draw_text(xw * (index % xt) + 1, y, xw, line_height, "#{$1.to_s}")
          draw_text(xw * (index % xt) + 1, y, xw, line_height,
                    "#{$2.to_s}#{$3.to_s}  ", 2)
        end
      end
      y += line_height
    end
    y += line_height / 2 unless y == 0
    # Start of my code
    effcount = 1
    effects.each_with_index do |e, effnum|
      item = $data_items[@item.id]
      results = item.note.scan(R2::Effect_Box::Regex)
      results.each do |res|
        effid = res[0].to_i - 1
        if effnum == effid
          effcount = 2
          self.height -= line_height
        end
      end
      item = $data_weapons[@item.id]
      results = item.note.scan(R2::Effect_Box::Regex)
      results.each do |res|
        effid = res[0].to_i - 1
        if effnum == effid
          effcount = 2
          self.height -= line_height
        end
      end
      item = $data_armors[@item.id]
      results = item.note.scan(R2::Effect_Box::Regex)
      results.each do |res|
        effid = res[0].to_i - 1
        if effnum == effid
          effcount = 2
          self.height -= line_height
        end
      end
      skill = $data_skills[@item.id]
      results = skill.note.scan(R2::Effect_Box::Regex)
      results.each do |res|
        effid = res[0].to_i - 1
        if effnum == effid
          effcount = 2
          self.height -= line_height
        end
      end
#~       if item.class == RPG::Skill
#~         @skill = item
#~         data_id = @item.effects[effnum].data_id
#~         if data_id == 0; self.height -= line_height; next; end
#~       end
      if effcount == 1
          draw_text(1, y, contents.width, line_height, e.vocab)
          y += line_height
      else
        effcount = 1
      end
    end
  end
end

class RPG::UsableItem < RPG::BaseItem
  
  def effect_desc
    make_effect_desc if @effect_desc.nil?
    return @effect_desc
  end
  
  def make_effect_desc
    @effect_desc = [] 
    results = self.note.scan(/<effect[-_ ]*note>(.*?)<\/effect[-_ ]*note>/imx)
    results.each do |res|
      res[0].strip.split("\r\n").each do |line| 
      @effect_desc.push("#{line}") 
      end
    end
  end

end

class RPG::EquipItem < RPG::BaseItem
  
  def effect_desc
    make_effect_desc if @effect_desc.nil?
    return @effect_desc
  end
  
  def make_effect_desc
    @effect_desc = [] 
    results = self.note.scan(/<effect[-_ ]*note>(.*?)<\/effect[-_ ]*note>/imx)
    results.each do |res|
      res[0].strip.split("\r\n").each do |line| 
      @effect_desc.push("#{line}") 
      end
    end
  end

end

class RPG::Skill < RPG::UsableItem
  
  def effect_desc
    make_effect_desc if @effect_desc.nil?
    return @effect_desc
  end
  
  def make_effect_desc
    @effect_desc = [] 
    results = self.note.scan(/<effect[-_ ]*note>(.*?)<\/effect[-_ ]*note>/imx)
    results.each do |res|
      res[0].strip.split("\r\n").each do |line| 
      @effect_desc.push("#{line}") 
      end
    end
  end

end

###--------------------------------------------------------------------------###
#  End of script.                                                              #
###--------------------------------------------------------------------------###
