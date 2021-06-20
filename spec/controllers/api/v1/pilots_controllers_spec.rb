require 'rails_helper'

RSpec.describe Api::V1::PilotsController, type: :controller do
  let(:planet) { create(:planet) }

  describe "POST #create" do
    let(:ship_params) { attributes_for_list(:ship, 3) }
    let(:params) { { pilot: pilot_params.merge(ships_attributes: ship_params) } }

    subject { post :create, params: params }

    context "when is successfully" do
      let(:pilot_params) { attributes_for(:pilot).merge(location_id: planet.id) }
      let(:expected_response) { pilot_params }

      it "returns http success" do
        subject

        expect(response).to have_http_status(:created)
      end

      it 'match response body' do
        subject

        body = JSON.parse(response.body).deep_symbolize_keys

        expect(body.keys).to match_array(%i[id certification name age credits location ships])
        expect(body[:certification]).to eq(expected_response[:certification])
        expect(body[:name]).to eq(expected_response[:name])
        expect(body[:age]).to eq(expected_response[:age])
        expect(body[:credits]).to eq(expected_response[:credits])
      end
    end

    context "when is fail" do
      let(:pilot_params) { attributes_for(:pilot) }

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
