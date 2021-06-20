# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true

  default_scope { order(created_at: :asc) }

  validates :description, presence: true, length: { in: 2..5000 }
end
