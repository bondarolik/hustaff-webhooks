# frozen_string_literal: true

# Module: Task Service Layer
module TaskServices
  # Funcion: update project with given params
  # Obligatory params: task_params
  # Returns: object with success? true/false, payload, error and status if present
  class Updater < ApplicationService
    attr_reader :task, :permitted_params

    def initialize(task, params)
      @task = task
      @permitted_params = params
    end

    def call
      if @task.update(permitted_params)
        OpenStruct.new({ success?: true, payload: @task })
      else
        OpenStruct.new({ success?: false, payload: @task, status: :unprocessable_entity })
      end
    rescue StandardError => e
      OpenStruct.new({ success?: false, payload: @task, error: e, status: :bad_request })
    end
  end
end
