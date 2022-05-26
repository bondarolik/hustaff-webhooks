# frozen_string_literal: true

# Module: Projects
# Funcion: update project with given params
# Obligatory params: project_params
module ProjectServices
  class Updater < ApplicationService
    attr_reader :project, :permitted_params

    def initialize(project, params)
      @project = project
      @permitted_params = params
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