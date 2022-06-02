# frozen_string_literal: true

# Reusable behavior across all our service objects
# Use ServiceName.call() instead of ServiceName.new(params).call
class ApplicationService
  def self.call(...)
    new(...).call
  end
end
