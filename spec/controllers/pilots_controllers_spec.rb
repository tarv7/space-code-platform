require 'rails_helper'

RSpec.describe PilotsController, type: :controller do
  let(:planet) { create(:planet) }

  describe "POST #create" do
    subject { post :create, params: params }

    context "when is successfully" do
      let(:pilot_params) { attributes_for(:pilot).merge(location_id: planet.id) }
      let(:ship_params) { attributes_for(:ship) }
      let(:params) { { pilot: pilot_params.merge(ship_attributes: ship_params) } }
      let(:expected_response) { pilot_params.merge(location: { name: planet.name }).merge(ship: ship_params) }

      it "returns http success" do
        subject

        expect(response).to have_http_status(:created)
      end

      it 'match response body' do
        subject

        body = JSON.parse(response.body).deep_symbolize_keys

        expect(JSON.parse(response.body).keys).to match_array(%w[id certification name age credits location ship])
        expect(body[:certification]).to eq(expected_response[:certification])
        expect(body[:name]).to eq(expected_response[:name])
        expect(body[:age]).to eq(expected_response[:age])
        expect(body[:credits]).to eq(expected_response[:credits])
        expect(body[:location][:name]).to eq(expected_response[:location][:name])
        expect(body[:ship][:fuel_capacity]).to eq(expected_response[:ship][:fuel_capacity])
        expect(body[:ship][:fuel_level]).to eq(expected_response[:ship][:fuel_level])
        expect(body[:ship][:weight_capacity]).to eq(expected_response[:ship][:weight_capacity])
      end
    end

    context "when is fail" do
      let(:pilot_params) { attributes_for(:pilot) }
      let(:ship_params) { attributes_for(:ship) }
      let(:params) { { pilot: pilot_params.merge(ship_attributes: ship_params) } }
      let(:expected_response) { pilot_params.merge(location: { name: planet.name }).merge(ship: ship_params) }

      it "returns http success" do
        subject

        expect(response).to have_http_status(:bad_request)
      end

      it 'match response body' do
        subject

        body = JSON.parse(response.body).deep_symbolize_keys

        expect(body).to match(message: 'Validation failed: Location must exist')
      end
    end
  end
end
