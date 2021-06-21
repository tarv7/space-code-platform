# frozen_string_literal: true

# class that contains the business rule necessary to supply ships
class RefilFuel < MainBusiness
  class RefilFuelError < StandardError; end

  UNIT_COST = 7

  def initialize(ship:, fuel_quantity:)
    @ship = ship
    @fuel_quantity = fuel_quantity
  end

  def call!
    raise RefilFuelError, I18n.t('errors.refil_fuel.need_be_positive') unless fuel_quantity.positive?

    Ship.transaction do
      ship.pilot.update!(credits: new_credits)
      ship.update!(fuel_level: new_fuel)

      create_report
    end
  end

  private

  attr_accessor :ship, :fuel_quantity

  def create_report
    ship.pilot.reports.create(
      description: I18n.t('report.description.pilot.bought', pilot: ship.pilot.name, value: decrease_credits)
    )
  end

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
