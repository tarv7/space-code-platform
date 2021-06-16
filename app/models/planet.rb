class Planet < ApplicationRecord
  validates :name, presence: true, length: { in: 2..255 }
end
