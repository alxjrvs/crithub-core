class Character < ActiveRecord::Base
  STR = "str"
  CON = "con"
  DEX = "dex"
  WIS = "wis"
  INT = "int"
  CHA = "cha"

  STATS = [
    STR,
    CON,
    DEX,
    WIS,
    INT,
    CHA,
  ]

  has_many :mods
  has_many :levels

  validates :race, presence: true

  def regenerate!
    static_mods.destroy_all
    case race
    when"Human"
      hash = JSON.parse(File.read("#{Rails.root}/data/human.json"))
      apply(hash)
    end

    levels.each do |l|
      case l.class_name
      when"Fighter"
        hash = JSON.parse(File.read("#{Rails.root}/data/fighter.json"))
        apply(hash[l.number.to_s])
      end
    end
  end

  def apply(hash)
    hash["mods"].each do |m| 
      digest_mod mod: m, 
        source: hash["source"]
    end
  end

  def remove(hash)
    hash["mods"].each do |m| 
      remove_mod mod: m, 
        source: hash["source"]
    end
  end

  STATS.each do |stat|
    define_method stat do
      numeric_value_for stat
    end

    define_method "#{stat}=" do |arg|
      mods.where(
        modifier: stat, 
        source: Mod::BASE_STAT
      ).first_or_initialize.tap do |mod|
        mod.value = arg 
        mod.memo = "Base Stat"
        mod.save!
      end
    end

    define_method "#{stat}_mod" do
      (send(stat) - 10) / 2
    end
  end

  def ac
    if !armor
      10 + dex_mod
    else
      armor.ac
    end
  end

  def proficiency_bonus
    numeric_value_for "proficiency_bonus"
  end

  def armor_proficiencies
    mods_for "armor_proficiency"
  end

  def weapon_proficiencies
    mods_for "weapon_proficiency"
  end

  def languages
    mods_for "language"
  end

  private

  def remove_mod(mod:, source:)
    mod = Mod.find_by(
      source: source,
      character: self,
      value: mod["value"],
      memo: mod["memo"],
      modifier: mod["modifier"],
      description: mod["description"]
    )
    mod.destroy if mod.present?
  end

  def digest_mod(mod:, source:)
    Mod.create(
      source: source,
      character: self,
      value: mod["value"],
      memo: mod["memo"],
      modifier: mod["modifier"],
      description: mod["description"]
    )
  end

  def armor
    false
  end

  def numeric_value_for(modifier)
    mods_for(modifier).
      pluck(:value).
      map(&:to_i).
      inject(:+)
  end

  def static_mods
    mods.where(dynamic: false)
  end

  def mods_for(modifier)
    mods.where(modifier: modifier)
  end
end
