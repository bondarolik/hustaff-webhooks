# frozen_string_literal: true

# Module: Project Services Layer
module ProjectServices
  # Funcion: update project with given params
  # Obligatory params: project_params
  # Returns: object with success? true/false, payload, error and status if present
  class Updater < ApplicationService
    attr_reader :project, :permitted_params

    def initialize(project, params)
      @project = project
      @permitted_params = params
      super
    end

    def call
      @project.update(@permitted_params)
    rescue StandardError => e
      OpenStruct.new({ success?: false, payload: @project, error: e, status: :unprocessable_entity })
    else
      OpenStruct.new({ success?: true, payload: @project })
    end
  end
end
