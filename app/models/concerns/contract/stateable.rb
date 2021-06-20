# frozen_string_literal: true

class Contract < ApplicationRecord
  module Stateable
    extend ActiveSupport::Concern

    included do
      class EventError < StandardError; end

      include AASM

      aasm column: 'state' do
        state :opened, initial: true
        state :accepted, :processing, :finished

        event :accept do
          before :before_accept_event
          after_commit :after_accepted

          transitions from: :opened, to: :accepted
        end

        event :process do
          after_commit :after_processing

          transitions from: :accepted, to: :processing
        end

        event :finish do
          after_commit :after_finished

          transitions from: :processing, to: :finished
        end
      end

      private

      #
      # Callbacks
      #

      def before_accept_event(pilot)
        raise EventError, 'Contract already has a pilot. Event: opened to accepted' if self.pilot.present?
        raise EventError, 'Missing pilot. Event: opened to accepted' unless pilot.is_a?(Pilot)

        self.pilot = pilot
      end

      def after_accepted(_)
        reports.create(description: "#{description} was accepted")
        pilot.reports.create(description: "#{pilot.name} accepted the contract")
      end

      def after_processing(path)
        reports.create(description: "#{description} is on transport route. path: #{path.join(' -> ')}")
      end

      def after_finished
        reports.create(description: "#{description} was finished")
        reports.create(description: "#{description} paid: -₭#{value}")
        pilot.reports.create(description: "#{pilot.name} received: -₭#{value}")
      end
    end
  end
end
