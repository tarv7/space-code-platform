module Reports
  class TransactionSerializer
    def serializable_hash
      Report.pluck(:description)
    end
  end
end