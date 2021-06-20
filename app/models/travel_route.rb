# frozen_string_literal: true

class TravelRoute < ApplicationRecord
  belongs_to :origin, class_name: 'Planet'
  belongs_to :destiny, class_name: 'Planet'

  validates :cost, presence: true, numericality: { greater_than: 0 }

  after_save :clear_cache_best_paths

  private

  def clear_cache_best_paths
    Rails.cache.delete(CalculateRoutes::KEY_CACHE_BEST_PATHS)
  end
end
