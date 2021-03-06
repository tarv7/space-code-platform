# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ContractsController, type: :controller do
  let!(:resource) { create(:resource) }
  let!(:origin) { create(:planet) }
  let!(:destiny) { create(:planet) }

  describe 'POST #create' do
    let(:params) { { contract: contract_params } }

    subject { post :create, params: params }

    context 'when is successfully' do
      let(:contract_params) do
        attributes_for(:contract, payload_id: resource.id, origin_id: origin.id, destiny_id: destiny.id)
      end

      let(:expected_response) { contract_params }

      it 'returns http success' do
        subject

        expect(response).to have_http_status(:created)
      end

      it 'match response body' do
        subject

        expect(body.keys).to match_array(%w[id description value state payload origin destiny pilot])
        expect(body['description']).to eq(expected_response[:description])
        expect(body['value']).to eq(expected_response[:value])
        expect(body['state']).to eq(expected_response[:state])
      end
    end

    context 'when is fail' do
      let(:contract_params) { attributes_for(:contract, origin_id: origin.id) }

      it 'returns http bad_request' do
        subject

        expect(response).to have_http_status(:bad_request)
      end

      it 'match response body' do
        subject

        expect(body).
          to match('message' => 'Validation failed: Payload must exist, Destiny must exist')
      end
    end
  end
end
