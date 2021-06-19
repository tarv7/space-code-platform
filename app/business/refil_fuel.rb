# frozen_string_literal: true

class RefilFuel
  class RefilFuelError < StandardError; end

  UNIT_COST = 7
  
  def initialize(ship, fuel_quantity)
    @ship = ship
    @fuel_quantity = fuel_quantity
  end

  def call!
    raise RefilFuelError, 'Amount of refill needs to be positive' unless fuel_quantity.positive?

    Ship.transaction do
      ship.pilot.update!(credits: new_credits)
      ship.update!(fuel_level: new_fuel)

      ship.pilot.reports.create(description: "#{ship.pilot.name} bought: -₭#{decrease_credits}")
    end
  end

  def self.call!(ship, fuel_quantity)
    self.new(ship, fuel_quantity).call!
  end

  private

  attr_accessor :ship, :fuel_quantity

  def new_fuel
    ship.fuel_level + fuel_quantity
  end

  def decrease_credits
    fuel_quantity * UNIT_COST
  end

  def new_credits
    ship.pilot.credits - decrease_credits
  end
end