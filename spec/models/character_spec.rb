require 'rails_helper'

describe Character do
  let(:character) { create :character }
  let(:modify_hash) do
    JSON.parse(File.read("#{Rails.root}/spec/support/test_rule.json"))
  end

  describe '.regenerate!' do
    let(:character) { create :character, race: "Human" } 
    let!(:level) { create :level, number: "1", class_name: "Fighter"}
    it "regenerates all static modifiers based on race and class" do 
      expect{character.regenerate!}.to change{Mod.count}
    end

  end

  describe ".remove" do 
    before do
      modify_hash["mods"].each do |mod|
        Mod.create(
          modifier: mod["modifier"],
          value: mod["value"],
          memo: mod["memo"],
          source: modify_hash["source"],
          character: character,
        )
      end
    end

    it "correctly removes the given modifiers" do
      expect{character.remove(modify_hash)}.to change{Mod.count}.by -6
      modify_hash["mods"].each do |mod|
        mod = Mod.find_by(
          modifier: mod["modifier"],
          value: mod["value"],
          memo: mod["memo"],
          source: modify_hash["source"],
          character: character,
        )
        expect(mod).to_not be_present
      end
    end

  end

  describe ".apply" do 
    it "correctly applies the modifiers" do
      expect{character.apply(modify_hash)}.to change{Mod.count}.by 6

      modify_hash["mods"].each do |mod|
        mod = Mod.find_by(
          modifier: mod["modifier"],
          value: mod["value"],
          memo: mod["memo"],
          source: modify_hash["source"],
          character: character,
        )
        expect(mod).to be_present
      end
    end

  end

  Character::STATS.each do |stat|
    let(:total) do
      [base_stat, race_trait].
        map(&:value).
        map(&:to_i).
        inject(:+)
    end

    describe ".#{stat}" do
      let!(:base_stat) do
         create :mod, 
          modifier: stat, 
          value: "15", 
          character: character 
      end

      let!(:race_trait) do
        create :mod, 
          modifier: stat, 
          value: "2", 
          character: character, 
          memo: "Your race is great at #{stat}",
          source: Mod::RACIAL_TRAIT
      end

			it "returns the value of the compiled stats" do
        expect(character.send(stat)).to eq total
			end
    end
    describe ".#{stat}=" do
      describe "with an existing base_stat" do 
        let!(:base_stat) do
           create :mod, 
            modifier: stat, 
            value: "15", 
            character: character 
        end

        it "updates the existing base stat to the new value" do
          expect{character.send("#{stat}=", 10)}.to change{Mod.count}.by(0)
          expect(base_stat.reload.value).to eq 10.to_s
        end

      end

      describe "without an existing base_stat" do
        let(:mod) { Mod.find_by(source: Mod::BASE_STAT, modifier: stat) } 

        it "creates a new mod for that stat and sets it to the new value" do
          expect{character.send("#{stat}=", 10)}.to change{Mod.count}.by(1)
          expect(mod.value).to eq 10.to_s
        end

      end
    end

    describe ".#{stat}_mod" do
      let!(:base_stat) do
         create :mod, 
          modifier: stat, 
          value: "15", 
          character: character 
      end

      let!(:race_trait) do
        create :mod, 
          modifier: stat, 
          value: "2", 
          character: character, 
          memo: "Your race is great at #{stat}",
          source: Mod::RACIAL_TRAIT
      end

      it "calculates the modifier" do
        expect(character.send("#{stat}_mod")).to eq ((total - 10) / 2)
      end

    end
  end
end
