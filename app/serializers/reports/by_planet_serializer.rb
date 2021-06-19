module Reports
  class ByPlanetSerializer
    def serializable_hash
      Planet.all.inject([]) do |array, planet|
        planet_name = planet.name.to_sym

        hash ||= {}
        hash[planet_name] ||= {}

        hash[planet_name][:sent] ||= {}
        hash[planet_name][:received] ||= {}

        Resource.all.each do |resource|
          sent = planet.quantity_resource_sent(resource)
          received = planet.quantity_resource_received(resource)

          hash[planet_name][:sent][resource.name.to_sym] = sent if sent.positive?
          hash[planet_name][:received][resource.name.to_sym] = received if received.positive?
        end

        hash[planet_name].delete(:sent) if hash[planet_name][:sent].empty?
        hash[planet_name].delete(:received) if hash[planet_name][:received].empty?

        array << hash
      end
    end
  end
end