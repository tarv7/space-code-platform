# frozen_string_literal: true

module Reports
  class TransactionSerializer
    def serializable_hash
      Report.pluck(:description)
    end
  end
end
