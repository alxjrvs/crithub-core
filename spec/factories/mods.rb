FactoryGirl.define do
  factory :mod do
    character
    value 12
    modifier Character::STR 
    source Mod::BASE_STAT
    memo "Base stat"
  end
end
