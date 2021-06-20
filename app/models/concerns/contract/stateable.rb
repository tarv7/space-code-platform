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
        raise EventError, "Contract already has a pilot. Event: opened to accepted" if self.pilot.present?
        raise EventError, "Missing pilot. Event: opened to accepted" unless pilot.is_a?(Pilot)

        self.pilot = pilot
      end

      def after_accepted(_)
        self.reports.create(description: "#{self.description} was accepted")
        self.pilot.reports.create(description: "#{self.pilot.name} accepted the contract")
      end

      def after_processing(path)
        self.reports.create(description: "#{self.description} is on transport route. path: #{path.join(' -> ')}")
      end

      def after_finished
        self.reports.create(description: "#{self.description} was finished")
        self.reports.create(description: "#{self.description} paid: -₭#{self.value}")
        self.pilot.reports.create(description: "#{self.pilot.name} received: -₭#{self.value}")
      end
    end
  end
end