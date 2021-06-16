class Report < ApplicationRecord
  belongs_to :reportable

  validates :description, presence: true, length: { in: 2..5000 }
end
