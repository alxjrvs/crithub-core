class Level < ActiveRecord::Base
  belongs_to :character
  validates :number, required: true
  validates :class_name, required: true
end
