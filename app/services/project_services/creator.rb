# frozen_string_literal: true

# Module: Project Service Layer
module ProjectServices
  # Funcion: create new project
  # Obligatory params: organization and project_params
  # Returns: object with success? true/false, payload, error and status if present
  class Creator < ApplicationService
    attr_reader :organization, :permitted_params

    def initialize(organization, params)
      @organization = organization
      @permitted_params = params
    end

    def call
      @resource = organization.projects.build(permitted_params)

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
