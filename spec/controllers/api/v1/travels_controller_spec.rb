# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TravelsController, type: :controller do
  let(:pilot) { create(:pilot_with_ships, location: planet_1) }
  let(:ship) { pilot.ships.first }
  let!(:planet_1) { create(:planet) }
  let!(:planet_2) { create(:planet) }
  let!(:contract) do
    create(:contract, :accepted, pilot: pilot, origin: planet_1, destiny: planet_2, value: 10, payload_weight: 1)
  end

  before do
    create(:travel_route, origin: planet_1, destiny: planet_2, cost: 1)
  end

  describe 'POST #create' do
    subject { post :create, params: { id: contract.id, ship_id: ship.id } }

    context 'when is successfully' do
      before { request.headers['auth-pilot-id'] = pilot.id.to_s }

      it 'returns http success' do
        subject

        expect(response).to have_http_status(:ok)
      end

      it 'returns fields if the contract' do
        subject

        body = JSON.parse(response.body)

        expect(body.keys).to match_array(%w[id description value payload state pilot origin destiny])
      end

      it 'should update contract, pilot and ship' do
        subject

        body = JSON.parse(response.body).deep_symbolize_keys

        expect(body[:state]).to eq('finished')
        expect(contract.reload.state).to eq('finished')

        expect(body[:pilot][:credits]).to eq(20)
        expect(pilot.reload.credits).to eq(20)

        expect(body[:pilot][:ships][0][:fuel_level]).to eq(9)
        expect(ship.reload.fuel_level).to eq(9)
      end
    end

    context 'when is fail' do
      shared_examples 'returns http code bad request' do
        it { expect(subject).to have_http_status(:bad_request) }
      end

      context 'when user is not logged' do
        it_behaves_like 'returns http code bad request'

        it 'returns message error' do
          subject

          body = JSON.parse(response.body)

          expect(body['message']).to eq('You need to log into the system')
        end
      end

      context 'when contract is not valid' do
        before { request.headers['auth-pilot-id'] = pilot.id.to_s }

        subject { post :create, params: { id: -1, ship_id: ship.id } }

        it_behaves_like 'returns http code bad request'

        it 'returns message error' do
          subject

          body = JSON.parse(response.body)

          expect(body['message']).to start_with('Couldn\'t find Contract with \'id\'=-1')
        end
      end

      context 'when the ship belongs to another pilot' do
        let(:another_ship_id) { create(:ship).id }

        before { request.headers['auth-pilot-id'] = pilot.id.to_s }

        subject { post :create, params: { id: contract.id, ship_id: another_ship_id } }

        it_behaves_like 'returns http code bad request'

        it 'returns message error' do
          subject

          body = JSON.parse(response.body)

          expect(body['message']).to start_with("Couldn't find Ship with 'id'=#{another_ship_id}")
        end
      end

      context 'when event raise error' do
        before do
          request.headers['auth-pilot-id'] = pilot.id.to_s

          allow_any_instance_of(Travel).to receive(:call!).and_raise(StandardError)
        end

        it_behaves_like 'returns http code bad request'

        it 'returns message error' do
          subject

          body = JSON.parse(response.body)

          expect(body['message']).to eq('StandardError')
        end
      end
    end
  end
end
