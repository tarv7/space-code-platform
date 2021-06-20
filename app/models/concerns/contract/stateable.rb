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
        raise EventError, I18n.t('activerecord.errors.contract.pilot_already') if self.pilot.present?
        raise EventError, I18n.t('activerecord.errors.contract.missing_pilot') unless pilot.is_a?(Pilot)

        self.pilot = pilot
      end

      def after_accepted(_)
        reports.create(description: I18n.t('report.description.contract.was_accepted', description: description))
        pilot.reports.create(
          description: I18n.t('report.description.pilot.was_accepted', pilot: pilot.name, contract_id: id)
        )
      end

      def after_processing(path)
        path = path.join(' -> ')

        reports.create(
          description: I18n.t('report.description.contract.processing', description: description, path: path)
        )
      end

      def after_finished
        reports.create(description: I18n.t('report.description.contract.was_finished', description: description))
        reports.create(description: I18n.t('report.description.contract.paid', description: description, value: value))
        pilot.reports.create(description: I18n.t('report.description.pilot.received', pilot: pilot.name, value: value))
      end
    end
  end
end
