class ACCalculator
  def initialize(character)
    @character = character
  end


  def calculate_ac
    if character.shield
      base_ac + 2
    else
      base_ac
    end
  end

  def armored?
    character.armor.present?
  end

  def base_ac
    if armored?
      self.send("#{character.armor}_ac")
    else
      10 + character.dex_mod
    end
  end

  def leather_armor_ac
    11 + character.dex_mod
  end

  def chain_shirt_ac
    13 + max_dex(2)
  end

  def plate_mail_ac
    18
  end

  def max_dex(max)
    if character.dex_mod >= max
      max
    else
      character.dex_mod
    end
  end

end
