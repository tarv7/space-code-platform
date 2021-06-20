# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Contracts::AcceptedsController, type: :controller do
  let!(:contract) { create(:contract, :opened) }
  let!(:pilot) { create(:pilot) }

  describe 'PATCH #update' do
    context 'when is successfully' do
      before { request.headers['auth-pilot-id'] = pilot.id.to_s }

      subject { patch :update, params: { id: contract.id } }

      it 'returns http success' do
        subject

        expect(response).to have_http_status(:ok)
      end

      it 'returns fields if the contract' do
        subject

        expect(body.keys).to match_array(%w[id description value payload state pilot origin destiny])
      end

      it 'should update state to accepted' do
        subject

        expect(body['state']).to eq('accepted')
        expect(contract.reload.state).to eq('accepted')
      end
    end

    context 'when is fail' do
      context 'when user is not logged' do
        subject { patch :update, params: { id: contract.id } }

        it 'returns http bad request (400)' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns message error' do
          subject

          expect(body['message']).to eq('You need to log into the system')
        end
      end

      context 'when contract is not valid' do
        before { request.headers['auth-pilot-id'] = pilot.id.to_s }

        subject { patch :update, params: { id: -1 } }

        it 'returns http bad request (400)' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns message error' do
          subject

          expect(body['message']).to eq('Couldn\'t find Contract with \'id\'=-1')
        end
      end

      context 'when event raise error' do
        before do
          request.headers['auth-pilot-id'] = pilot.id.to_s

          allow_any_instance_of(Contract).to receive(:accept!).and_raise(StandardError)
        end

        subject { patch :update, params: { id: contract.id } }

        it 'returns http bad request (400)' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns message error' do
          subject

          expect(body['message']).to eq('StandardError')
        end
      end
    end
  end
end
