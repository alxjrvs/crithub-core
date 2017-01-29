class Level < ActiveRecord::Base
  belongs_to :character, inverse_of: :levels
  validates :number, presence: true
  validates :class_name, presence: true
end
