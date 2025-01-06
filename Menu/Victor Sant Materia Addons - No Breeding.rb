# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: Materia No Breeding option   ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║ Adds no breed option                ║    24 Jan 2022     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Use <no breed> to not have a materia not duplicate       ║
# ║ when mastered.                                           ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker except nudity             ║
# ╚══════════════════════════════════════════════════════════╝

class RPG::Armor < RPG::EquipItem
  def gain_ap(n, growth)
    old_level = level
    @ap += (n * growth).to_i
    breedoff = note =~ /<NO BREED>/i ? true : false
    if Materia_Breeding && old_level < max_level && level == max_level
      $game_party.gain_materia($data_armors[@id]) unless breedoff == true
    end
  end
end
