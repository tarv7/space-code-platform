# frozen_string_literal: true

# Class that contains the algorithm to calculate the best routes for all pairs of planet.
# The class was implemented based on the classic Floyd Warshall algorithm.
class CalculateRoutes
  KEY_CACHE_BEST_PATHS = 'CalculateRoutes#best_paths'
  INFINITE = (1 << (1.size * 8 - 1)) - 1 # 9223372036854775807

  def initialize
    @costs = {}
    @paths = {}
  end

  def best_path(origin:, destiny:)
    {
      cost: best_paths[{ origin => destiny }][:cost],
      path: best_paths[{ origin => destiny }][:path]
    }
  end

  def self.best_path(origin:, destiny:)
    new.best_path(origin: origin, destiny: destiny)
  end

  private

  attr_accessor :costs, :paths, :sub_paths

  def best_paths
    Rails.cache.fetch(KEY_CACHE_BEST_PATHS) do
      calculate_routes

      costs.keys.inject({}) do |hash, route|
        hash.merge!(route => { cost: costs[route], path: paths[route] })
      end
    end
  end

  def calculate_routes
    calculate_costs
    calculate_paths
  end

  def calculate_costs
    @costs = travel_routes.inject({}) { |hash, value| hash.merge!(value) }

    initialize_sub_paths

    planets.each do |sub_planet|
      planets.each do |origin|
        planets.each do |destiny|
          @costs[{ origin => destiny }] = 0 if origin == destiny

          @costs[{ origin => destiny }] ||= INFINITE

          origin_destiny = @costs[{ origin => destiny }]
          origin_sub     = @costs[{ origin => sub_planet }]
          sub_destiny    = @costs[{ sub_planet => destiny }]

          next unless origin_sub + sub_destiny < origin_destiny

          @costs[{ origin => destiny }] = origin_sub + sub_destiny
          @sub_paths[{ origin => destiny }] = @sub_paths[{ sub_planet => destiny }]
        end
      end
    end

    @costs
  end

  def calculate_paths
    planets.each do |origin|
      planets.each do |destiny|
        @paths[{ origin => destiny }] = depth_first_search_path(origin, destiny)
      end
    end
  end

  def depth_first_search_path(origin, destiny, path = [])
    depth_first_search_path(origin, @sub_paths[{ origin => destiny }], path) if origin != destiny

    path << destiny

    path
  end

  def initialize_sub_paths
    @sub_paths = {}

    planets.each do |origin|
      planets.each do |destiny|
        @sub_paths[{ origin => destiny }] = origin
      end
    end
  end

  def planets
    @_planets ||= Planet.pluck(:name)
  end

  def travel_routes
    @_travel_routes ||= TravelRoute.all.includes(:origin, :destiny).map do |r|
      {
        { r.origin.name => r.destiny.name } => r.cost
      }
    end
  end
end
