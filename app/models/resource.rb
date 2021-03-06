# frozen_string_literal: true

class Resource < ApplicationRecord
  validates :name, presence: true, length: { in: 2..255 }
end
