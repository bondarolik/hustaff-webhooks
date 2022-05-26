# frozen_string_literal: true

# Module: Projects
# Funcion: create new project
# Obligatory params: organization and project_params
module ProjectServices
  class Creator < ApplicationService
    attr_reader :organization, :permitted_params

    def initialize(organization, params)
      @organization = organization
      @permitted_params = params
    end

    def call
      @project = @organization.projects.build(@permitted_params)
      @project.save!
    rescue StandardError => e
      OpenStruct.new({ success?: false, payload: @project, error: e, status: :unprocessable_entity })
    else
      OpenStruct.new({ success?: true, payload: @project })
    end
  end
end