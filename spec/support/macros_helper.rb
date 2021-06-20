# frozen_string_literal: true

module Macros
  def body
    ActiveSupport::JSON.decode(response.body)
  end
end

RSpec.configure do |config|
  config.include Macros
end
