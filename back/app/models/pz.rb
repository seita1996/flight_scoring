class Pz < ApplicationRecord
  belongs_to :area
  has_one_attached :file
end
