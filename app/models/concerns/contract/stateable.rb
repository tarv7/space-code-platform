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

          transitions from: :opened, to: :accepted
        end

        event :process do
          before :before_process_event

          transitions from: :accepted, to: :processing
        end

        event :finish do
          transitions from: :processing, to: :finished
        end
      end

      #
      # Callbacks
      #

      def before_accept_event(pilot)
        raise EventError, "Contract already has a pilot. Event: opened to accepted" if self.pilot.present?
        raise EventError, "Missing pilot. Event: opened to accepted" if pilot.blank?

        self.pilot = pilot
      end

      def before_process_event(path); end
    end
  end
end