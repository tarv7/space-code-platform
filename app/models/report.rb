class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true

  validates :description, presence: true, length: { in: 2..5000 }
end
