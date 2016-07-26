class Mod < ActiveRecord::Base
  BASE_STAT = "Base Stat Roll"
  CLASS_FEAURE = "Class Feature"
  RACIAL_TRAIT = "Racial Trait" 

  ALLOWED_SOURCES = [
    BASE_STAT,
    CLASS_FEAURE,
    RACIAL_TRAIT
  ].freeze

  belongs_to :character

  validates :source, inclusion: { in: ALLOWED_SOURCES }, presence: true
  validates :modifier, presence: true
  validates :value, presence: true
  validates :memo, presence: true

end
