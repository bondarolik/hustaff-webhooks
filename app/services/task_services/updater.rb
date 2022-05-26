# frozen_string_literal: true

# Module: Projects
# Funcion: update project with given params
# Obligatory params: project_params
module TaskServices
  class Updater < ApplicationService
    attr_reader :task, :permitted_params

    def initialize(task, params)
      @task = task
      @permitted_params = params
    end

    def call
      @task.update(@permitted_params)
    rescue StandardError => e
      OpenStruct.new({ success?: false, payload: @task, error: e, status: :unprocessable_entity })
    else
      OpenStruct.new({ success?: true, payload: @task })
    end
  end
end