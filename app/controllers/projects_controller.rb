# frozen_string_literal: true

# Exposes API for interacting with Projects.
class ProjectsController < ApplicationController
  before_action :authenticate
  include DryController

  def index
    render json: ProjectSerializer.new(@organization.projects).serializable_hash
  end

  def create
    result = ProjectServices::Creator.call(@organization, permitted_params)

    if result.success?
      render json: ProjectSerializer.new(result.payload).serializable_hash
    else
      render json: { errors: result.payload.errors.full_messages }, status: result.status
    end
  end

  def update
    result = ProjectServices::Updater.call(@resource, permitted_params)

    if result.success?
      render json: ProjectSerializer.new(result.payload).serializable_hash
    else
      render json: { errors: result.payload.errors.full_messages }, status: result.status
    end
  end

  private

  def permitted_params
    params.permit(:name, :organization_id)
  end
end
