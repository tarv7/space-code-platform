# frozen_string_literal: true

class TravelRouteSerializer
  def serializable_hash
    routes = []

    planets.each do |origin|
      planets.each do |destiny|
        route = route_hash(origin, destiny)

        routes << route if origin != destiny && route[:cost] < CalculateRoutes::INFINITE
      end
    end

    routes
  end

  private

  def route_hash(origin, destiny)
    { origin: origin, destiny: destiny }.merge(cost_and_path(origin, destiny))
  end

  def cost_and_path(origin, destiny)
    CalculateRoutes.best_path(origin: origin, destiny: destiny)
  end

  def planets
    @_planets ||= Planet.pluck(:name)
  end
end
