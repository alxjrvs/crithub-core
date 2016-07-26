class Level < ActiveRecord::Base
  belongs_to :character
  validates :number, presence: true
  validates :class_name, presence: true
end
