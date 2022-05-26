# frozen_string_literal: true

# Exposes API for interacting with Projects.
class ProjectsController < ApplicationController
  before_action :authenticate
  include FindOrganizationAndProject

  def index
    render json: ProjectSerializer.new(@organization.projects).serializable_hash
  end

  def create
    result = ProjectServices::Creator.call(@organization, project_params)

    if result.success?
      render json: ProjectSerializer.new(result.payload).serializable_hash
    else
      render json: { errors: result.payload.errors.full_messages }, status: result.status
    end
  end

  def show
    render json: ProjectSerializer.new(@project).serializable_hash
  end

  def update
    result = ProjectServices::Updater.call(@project, project_params)

    if result.success?
      render json: ProjectSerializer.new(result.payload).serializable_hash
    else
      render json: { errors: result.payload.errors.full_messages }, status: result.status
    end
  end

  def destroy
    @project.destroy
    head :ok
  end

  private

  def project_params
    params.permit(:name, :organization_id)
  end
end
