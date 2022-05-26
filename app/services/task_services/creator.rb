# frozen_string_literal: true

# Module: Projects
# Funcion: create new project
# Obligatory params: organization and project_params
module TaskServices
  class Creator < ApplicationService
    attr_reader :project, :permitted_params

    def initialize(project, params)
      @project = project
      @permitted_params = params
    end

    def call
      @resource = @project.tasks.build(@permitted_params)
      @resource.save!
    rescue StandardError => e
      OpenStruct.new({ success?: false, payload: @resource, error: e, status: :unprocessable_entity })
    else
      OpenStruct.new({ success?: true, payload: @resource })
    end
  end
end