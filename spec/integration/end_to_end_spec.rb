# frozen_string_literal: true

require 'swagger_helper'

describe 'Space Code Platform' do
  let!(:minerals) { create(:resource, name: 'minerals') }
  let!(:water) { create(:resource, name: 'water') }
  let!(:food) { create(:resource, name: 'food') }

  let!(:andvari) { create(:planet, name: 'Andvari') }
  let!(:demeter) { create(:planet, name: 'Demeter') }
  let!(:aqua) { create(:planet, name: 'Aqua') }
  let!(:calas) { create(:planet, name: 'Calas') }

  before do
    create(:travel_route, origin: andvari, destiny: aqua, cost: 13)
    create(:travel_route, origin: andvari, destiny: calas, cost: 23)
    create(:travel_route, origin: demeter, destiny: aqua, cost: 22)
    create(:travel_route, origin: demeter, destiny: calas, cost: 25)
    create(:travel_route, origin: aqua, destiny: demeter, cost: 30)
    create(:travel_route, origin: aqua, destiny: calas, cost: 12)
    create(:travel_route, origin: calas, destiny: andvari, cost: 20)
    create(:travel_route, origin: calas, destiny: demeter, cost: 25)
    create(:travel_route, origin: calas, destiny: aqua, cost: 15)
  end

  path '/api/v1/resources' do
    get 'List all resources' do
      tags 'Resource'
      consumes 'application/json'

      response '200', 'openeds' do
        run_test!
      end
    end
  end # GET /api/v1/resources - List all resources

  path '/api/v1/planets' do
    get 'List all planets' do
      tags 'Planet'
      consumes 'application/json'

      response '200', 'openeds' do
        run_test!
      end
    end
  end # GET /api/v1/planets - List all planets

  path '/api/v1/travel_routes' do
    get 'List all travel routes with cost and paths' do
      tags 'Travel route'
      consumes 'application/json'

      response '200', 'openeds' do
        run_test!
      end
    end
  end # GET /api/v1/travel_routes - List all routes possibles

  path '/api/v1/pilots' do
    post 'Add pilots and their ships to the system' do
      tags 'Pilot'
      consumes 'application/json'
      parameter name: :pilot, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          certification: { type: :string },
          age: { type: :integer },
          credits: { type: :integer },
          location_id: { type: :integer },
          ships_attributes: {
            type: :array,
            items: {
              properties: {
                fuel_capacity: { type: :integer },
                fuel_level: { type: :integer },
                weight_capacity: { type: :integer }
              },
              required: %w[fuel_capacity fuel_level weight_capacity]
            }
          }
        },
        required: %w[name certification age credits payload_id ships_attributes]
      }

      response '201', 'pilot and ships createds' do
        let(:pilot) do
          {
            name: 'Pilot Valid',
            certification: Luhn.generate(7),
            age: 40,
            credits: 13,
            location_id: andvari.id,
            ships_attributes: [attributes_for(:ship)]
          }
        end

        run_test!
      end

      response '400', 'bad request' do
        let(:pilot) do
          {
            name: 'Pilot Valid',
            certification: Luhn.generate(6),
            age: -40,
            credits: -13,
            ships_attributes: [attributes_for(:ship).merge(fuel_level: -10)]
          }
        end

        run_test!
      end
    end
  end # POST /api/v1/pilots - Add pilots and their ships to the system.

  path '/api/v1/contracts' do
    post 'Publish transport contracts' do
      tags 'Contract'
      consumes 'application/json'
      parameter name: :contract, in: :body, schema: {
        type: :object,
        properties: {
          description: { type: :string },
          value: { type: :integer },
          payload_weight: { type: :integer },
          payload_id: { type: :integer },
          origin_id: { type: :integer },
          destiny_id: { type: :integer }
        },
        required: %w[value payload_weight payload_id origin_id destiny_id]
      }

      response '201', 'contract created' do
        let(:contract) do
          {
            description: 'Description',
            value: 40,
            payload_weight: 13,
            payload_id: water.id,
            origin_id: andvari.id,
            destiny_id: calas.id
          }
        end

        run_test!
      end

      response '400', 'bad request' do
        let(:contract) do
          {
            description: 'Test invalid',
            value: -9,
            payload_weight: 13,
            payload_id: 1,
            origin_id: 1,
            destiny_id: 2
          }
        end

        run_test!
      end
    end
  end # POST /api/v1/contracts - Publish transport contracts

  path '/api/v1/contracts/opened' do
    get 'List open contracts' do
      tags 'Open Contracts'
      consumes 'application/json'

      response '200', 'openeds' do
        run_test!
      end
    end
  end # GET /api/v1/contracts/opened - List open contracts

  path '/api/v1/contracts/{id}/accept' do
    patch 'Accept transport contracts' do
      tags 'Accept Contracts'
      consumes 'application/json'

      parameter name: :'auth-pilot-id', in: :header, schema: { type: :string }
      parameter name: :id, in: :path, schema: { type: :integer }

      response '200', 'accepted' do
        before { pilot.ships.first.update(fuel_level: 100, fuel_capacity: 100) }

        let(:pilot) { create(:pilot_with_ships, location: aqua) }
        let(:contract) { create(:contract, :opened, origin: aqua, destiny: calas, payload_weight: 1) }

        let(:id) { contract.id }
        let(:'auth-pilot-id') { pilot.id }

        run_test!
      end

      response '400', 'bad request' do
        let(:pilot) { create(:pilot_with_ships, location: aqua) }
        let(:contract) { create(:contract, :opened, origin: aqua, destiny: calas) }

        let(:id) { contract.id }
        let(:'auth-pilot-id') { nil }

        run_test!
      end
    end
  end # PATCH /api/v1/contracts/{id}/accept - Accept transport contracts

  path '/api/v1/travels' do
    post 'Travel between planets and Grant credits to the pilot after fulfilling the contract' do
      tags 'Travel'
      consumes 'application/json'

      parameter name: :'auth-pilot-id', in: :header, schema: { type: :string }
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :integer },
          ship_id: { type: :integer }
        },
        required: %w[id ship_id]
      }

      response '200', 'traveled' do
        before { pilot.ships.first.update(fuel_level: 100, fuel_capacity: 100) }

        let(:pilot) { create(:pilot_with_ships, location: aqua) }
        let(:contract) { create(:contract, :accepted, origin: aqua, destiny: calas, pilot: pilot, payload_weight: 1) }

        let(:params) do
          {
            id: contract.id,
            ship_id: pilot.ships.first.id
          }
        end

        let(:'auth-pilot-id') { pilot.id }

        run_test!
      end

      response '400', 'bad request' do
        let(:pilot) { create(:pilot_with_ships, location: aqua) }
        let(:contract) { create(:contract, :accepted, origin: aqua, destiny: calas, pilot: pilot, payload_weight: 100) }

        let(:params) do
          {
            id: contract.id,
            ship_id: pilot.ships.first.id
          }
        end

        let(:'auth-pilot-id') { pilot.id }

        run_test!
      end
    end
  end # POST /api/v1/travels - Travel between planets and Grant credits to the pilot after fulfilling the contract

  path '/api/v1/ships/{id}/fuel' do
    patch 'Register a refill of the fuel' do
      tags 'Refil Fuel'
      consumes 'application/json'

      parameter name: :'auth-pilot-id', in: :header, schema: { type: :string }
      parameter name: :id, in: :path, schema: { type: :integer }
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          quantity: { type: :integer }
        },
        required: %w[quantity]
      }

      response '200', 'filled fuel' do
        before { pilot.ships.first.update(fuel_level: 10, fuel_capacity: 100) }

        let(:'auth-pilot-id') { pilot.id }
        let(:pilot) { create(:pilot_with_ships) }

        let(:id) { pilot.ships.first.id }
        let(:params) { { quantity: 1 } }

        run_test!
      end

      response '400', 'bad request' do
        let(:pilot) { create(:pilot_with_ships) }

        let(:'auth-pilot-id') { pilot.id }
        let(:id) { pilot.ships.first.id }
        let(:params) { { quantity: 100 } }

        run_test!
      end
    end
  end # PATCH /api/v1/ships/{id}/fuel - Register a refill of the fuel

  path '/api/v1/reports' do
    get 'Reports' do
      tags 'Reports'
      consumes 'application/json'

      parameter name: :type, in: :query, schema: { type: :string }

      response '200', 'reports' do
        let(:type) { 'by_planet' }

        run_test!
      end

      response '406', 'not acceptable' do
        let(:type) { 'code_injection' }

        run_test!
      end
    end
  end # GET /api/v1/reports - Reports
end
