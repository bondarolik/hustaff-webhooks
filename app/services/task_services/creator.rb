# frozen_string_literal: true

# Module: Task Service Layer
module TaskServices
  # Funcion: create new task
  # Obligatory params: project and task_params
  # Returns: object with success? true/false, payload, error and status if present
  class Creator < ApplicationService
    attr_reader :project, :permitted_params

    def initialize(project, params)
      @project = project
      @permitted_params = params
    end

    def call
      @resource = project.tasks.build(permitted_params)
      
      if @resource.save
        OpenStruct.new({ success?: true, payload: @resource })
      else
        OpenStruct.new({ success?: false, payload: @resource, status: :unprocessable_entity })
      end
    rescue StandardError => e
      OpenStruct.new({ success?: false, payload: @resource, error: e, status: :bad_request })
    end
  end
end
