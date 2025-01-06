# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Falco MMORPG Alchemy sounds  ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║     Play different sounds when      ╠════════════════════╣
# ║     crafting different items        ║    05 Feb 2022     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║   Place notetag on the crafted item, not the recipe item ║
# ║   <mix_potion>                                           ║
# ║   Change or add more as you desire                       ║
# ╚══════════════════════════════════════════════════════════╝
# ╔═════════════════════════════════════╗
# ║ Terms of use:                       ║
# ║ Free for all uses in RPG Maker      ║
# ╚═════════════════════════════════════╝

module R2_Falco_MMORPG_Alchemy_Sound
	Default = ""
	Potion = "Blind"
	Pot_regex = /<mix_potion>/i
	Material = "Bite"
	Mat_regex = /<mix_other>/i
  # add more if differnt items
end
class Scene_Alchemy < Scene_MenuBase
  def update_start
    default_snd = R2_Falco_MMORPG_Alchemy_Sound::Default
		craftquery = @recipes.item[1]
		craftid = @recipes.item[2]
		case craftquery
		when "Item"
		item = $data_items[craftid]
		when "Armor"
		item = $data_armours[craftid]
		when "Weapon"
		item = $data_weapons[craftid]
    end
		
    # find which sound file to use. Does the tag exist?
    potion = item.note =~ R2_Falco_MMORPG_Alchemy_Sound::Pot_regex ? true : false
    material = item.note =~ R2_Falco_MMORPG_Alchemy_Sound::Mat_regex ? true : false
		# add more for more sounds

		# Set sound file name
		snd = default_snd
		snd = R2_Falco_MMORPG_Alchemy_Sound::Potion if potion == true
		snd = R2_Falco_MMORPG_Alchemy_Sound::Material if material == true
		# add more for if tag is true
		
    RPG::SE.new(snd, 80, 100).play
    @ngrewindow.meter = 1
  end
end
