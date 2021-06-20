# frozen_string_literal: true

# example:
# [
#   "...",
#   "Contract 2 Description paid: K936",
#   "Contract 3 Description paid: K1200",
#   "Han Solo bought fuel: K210",
#   "...",
# ]
module Reports
  class TransactionSerializer
    def serializable_hash
      Report.pluck(:description)
    end
  end
end
