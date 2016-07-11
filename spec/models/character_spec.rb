require 'rails_helper'

describe Character do
  let(:character) { create :character }
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
