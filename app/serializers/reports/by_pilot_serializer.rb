# frozen_string_literal: true

# example:
# [
#   {...},
#   "pilot 2": {
#     "food": 35,
#     "water": 65
#   },
#   {...},
# ]
module Reports
  class ByPilotSerializer
    def serializable_hash
      Pilot.all.inject([]) do |array, pilot|
        hash = {}
        hash[pilot.name.to_sym] ||= {}

        Resource.all.each do |resource|
          quantity = pilot.quantity_resource(resource)

          hash[pilot.name.to_sym][resource.name.to_sym] = quantity if quantity.positive?
        end

        array << hash
      end
    end
  end
end
