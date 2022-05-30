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
      super
    end

    def call
      @resource = @organization.projects.build(@permitted_params)
      @resource.save!
    rescue StandardError => e
      OpenStruct.new({ success?: false, payload: @resource, error: e, status: :unprocessable_entity })
    else
      OpenStruct.new({ success?: true, payload: @resource })
    end
  end
end
