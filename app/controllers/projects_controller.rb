# frozen_string_literal: true

# Exposes API for interacting with Projects.
class ProjectsController < ApplicationController
  before_action :authenticate
  include FindOrganizationAndProject

  def index
    render json: ProjectSerializer.new(@organization.projects).serializable_hash
  end

  def create
    @project = @organization.projects.build(project_params)

    if @project.save
      render json: ProjectSerializer.new(@project).serializable_hash
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: ProjectSerializer.new(@project).serializable_hash
  end

  def update
    if @project.update(project_params)
      render json: ProjectSerializer.new(@project).serializable_hash
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    head :ok
  end

  private

  def project_params
    params.permit(:name)
  end
end
