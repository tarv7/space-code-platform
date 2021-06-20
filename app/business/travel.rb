# frozen_string_literal: true

# class that contains the business rule necessary to carry out intergalactic travel
class Travel
  class TravelError < StandardError; end

  def initialize(contract:, ship_id:)
    @ship_id = ship_id
    @pilot = contract.pilot
    @contract = contract
  end

  def call!
    raise TravelError, I18n.t('errors.travel.no_exists_route') if cost >= CalculateRoutes::INFINITE
    raise TravelError, I18n.t('errors.ship.fuel_level_low') if ship.fuel_level < cost
    raise TravelError, I18n.t('errors.ship.payload_weight_greater') if ship.weight_capacity < contract.payload_weight

    travel
  end

  private

  attr_accessor :pilot, :contract, :ship_id

  def travel
    ActiveRecord::Base.transaction do
      contract.process!(path)
      contract.finish!

      pilot.update!(location: contract.destiny, credits: new_credits)
      ship.update!(fuel_level: new_fuel_level)
    end
  end

  def new_credits
    pilot.credits + contract.value
  end

  def new_fuel_level
    ship.fuel_level - cost
  end

  def cost
    best_path_pilot_to_origin[:cost] + best_path_contract[:cost]
  end

  def path
    (best_path_pilot_to_origin[:path] + best_path_contract[:path]).uniq
  end

  def ship
    @_ship ||= pilot.ships.find(ship_id)
  end

  def origin
    contract.origin.name
  end

  def destiny
    contract.destiny.name
  end

  def best_path_contract
    @_best_path_contract ||= CalculateRoutes.best_path(origin: origin, destiny: destiny)
  end

  def best_path_pilot_to_origin
    @_best_path_pilot_to_origin ||= CalculateRoutes.best_path(origin: pilot.location.name, destiny: origin)
  end
end
