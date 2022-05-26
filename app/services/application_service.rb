# frozen_string_literal: true

# Reusable behavior across all our service objects
# Use ServiceName.call() instead of ServiceName.new(params).call
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end