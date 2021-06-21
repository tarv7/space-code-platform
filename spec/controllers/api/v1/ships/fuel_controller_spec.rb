# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Ships::FuelController, type: :controller do
  let!(:ship) { create(:ship) }
  let!(:pilot) { create(:pilot) }

  describe 'PATCH #update' do
    before { request.headers['auth-pilot-id'] = pilot.id.to_s }

    let(:params) { { id: ship.id, quantity: 1 } }

    subject { patch :update, params: params }

    context 'when is successfully' do
      let!(:ship) { create(:ship, pilot: pilot, fuel_level: 0) }

      it 'returns http code ok' do
        subject

        expect(response).to have_http_status(:ok)
      end

      it 'match response body' do
        subject

        expect(body.keys).to match_array(%w[id fuel_capacity fuel_level weight_capacity pilot])
        expect(body['id']).to eq(ship.id)
        expect(body['fuel_level']).to eq(1)
        expect(body['fuel_capacity']).to eq(ship.fuel_capacity)
        expect(body['weight_capacity']).to eq(ship.weight_capacity)
      end

      it 'should update field fuel_level and credits' do
        expect { subject }.
          to change { ship.reload.fuel_level }.from(0).to(1).
          and change { ship.pilot.reload.credits }.from(10).to(3)
      end

      it 'should call business class' do
        expect(RefilFuel).to receive(:call!).with(ship: ship, fuel_quantity: 1)

        subject
      end
    end

    context 'when is fail' do
      context 'when ship not exists' do
        let(:params) { { id: -1, quantity: 1 } }

        it 'returns http code bad request' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'match response body' do
          subject

          expect(body['message']).to start_with('Couldn\'t find Ship with \'id\'=-1')
        end
      end

      context 'when event raise error' do
        let!(:ship) { create(:ship, pilot: pilot) }

        before { allow(RefilFuel).to receive(:call!).and_raise(StandardError) }

        it 'returns http bad request' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns message error' do
          subject

          expect(body['message']).to eq('StandardError')
        end
      end

      context 'when user is not logged' do
        before { request.headers['auth-pilot-id'] = nil }

        it 'returns http bad request' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns message error' do
          subject

          expect(body['message']).to eq('You need to log into the system')
        end
      end
    end
  end
end
