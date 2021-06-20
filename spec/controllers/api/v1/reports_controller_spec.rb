# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ReportsController, type: :controller do
  let(:planet_1) { create(:planet, name: 'planet 1') }
  let(:planet_2) { create(:planet, name: 'planet 2') }
  let(:pilot_1) { create(:pilot, name: 'Pilot 1', location: planet_1) }
  let(:pilot_2) { create(:pilot, name: 'Pilot 2', location: planet_2) }

  let(:water) { create(:resource, name: 'water') }
  let(:food) { create(:resource, name: 'food') }
  let(:minerals) { create(:resource, name: 'minerals') }

  let!(:contract_1) do
    create(:contract, :finished, pilot: pilot_1, origin: planet_1, destiny: planet_2, payload: water, payload_weight: 1)
  end
  let!(:contract_2) do
    create(:contract, :finished, pilot: pilot_1, origin: planet_1, destiny: planet_2, payload: food, payload_weight: 1)
  end

  before do
    create_list(:contract, 4, :finished, pilot: pilot_2, origin: planet_1, destiny: planet_2, payload: food,
                                         payload_weight: 1)
    create_list(:contract, 8, :finished, pilot: pilot_2, origin: planet_2, destiny: planet_1, payload: water,
                                         payload_weight: 1)
    create_list(:contract, 16, :finished, pilot: pilot_2, origin: planet_2, destiny: planet_1, payload: minerals,
                                          payload_weight: 1)
  end

  let!(:report_1) do
    create(:report, reportable: planet_1, description: "#{planet_1.name} receveid food: +₭210",
                    created_at: Date.today.ago(2.years))
  end
  let!(:report_2) do
    create(:report, reportable: contract_1, description: "#{contract_1.description} paid: +₭936",
                    created_at: Date.today.ago(3.years))
  end
  let!(:report_3) do
    create(:report, reportable: contract_2, description: "#{contract_2.description} paid: +₭1200",
                    created_at: Date.today.ago(1.years))
  end

  describe 'GET #index' do
    subject { get :index, params: { type: type } }

    shared_examples 'returns http success' do
      it do
        subject

        expect(response).to have_http_status(:ok)
      end
    end

    shared_examples 'returns response expected' do
      it do
        subject

        expect(body).to match(expected)
      end
    end

    describe '#by_planet' do
      let(:type) { 'by_planet' }
      let(:expected) do
        [
          {
            planet_1.name => {
              'sent' => {
                'water' => 1,
                'food' => 5
              },
              'received' => {
                'water' => 8,
                'minerals' => 16
              }
            }
          },
          {
            planet_2.name => {
              'sent' => {
                'water' => 8,
                'minerals' => 16
              },
              'received' => {
                'water' => 1,
                'food' => 5
              }
            }
          }
        ]
      end

      it_behaves_like 'returns http success'
      it_behaves_like 'returns response expected'
    end

    describe '#by_pilot' do
      let(:type) { 'by_pilot' }
      let(:expected) do
        [
          {
            pilot_1.name => {
              'food' => 1,
              'water' => 1
            }
          },
          {
            pilot_2.name => {
              'water' => 8,
              'minerals' => 16,
              'food' => 4
            }
          }
        ]
      end

      it_behaves_like 'returns http success'
      it_behaves_like 'returns response expected'
    end

    describe '#transaction' do
      let(:type) { 'transaction' }
      let(:expected) do
        [
          report_2.description,
          report_1.description,
          report_3.description
        ]
      end

      it_behaves_like 'returns http success'
      it_behaves_like 'returns response expected'
    end

    context 'when type is not allowed' do
      let(:type) { 'code_injection' }

      it 'returns http success' do
        subject

        expect(response).to have_http_status(:not_acceptable)
      end

      it 'returns response expected' do
        subject

        expect(body).to match({ 'message' => 'Type no exists' })
      end
    end
  end
end
