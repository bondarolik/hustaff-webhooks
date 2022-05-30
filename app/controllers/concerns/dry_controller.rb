# frozen_string_literal: true

# Concerns to keep controllers dry & clean
# Contains:
# - Main CRUD actions
# - ModelClassSerializer
# - @resource_class on each controller method
# - Organization and Project
module DryController
  extend ActiveSupport::Concern

  included do
    before_action :set_resource_class
    before_action :serializer_class
    before_action :set_resource, only: %i[show update destroy]
    before_action :find_organization, if: :project?
    before_action :find_project, only: %i[show update destroy], if: :project?
    before_action :find_project, only: %i[index create], if: :task?
  end

  def index
    @resources = task? ? @project.tasks : @organization.projects
    render json: @serializer.new(@resources).serializable_hash
  end

  def show
    render json: @serializer.new(@resource).serializable_hash
  end

  def update; end

  def destroy
    @resource.destroy
    head :ok
  end

  private

  def resource_class
    controller_path.classify.constantize
  end

  def set_resource_class
    @resource_class = resource_class
  end

  def project?
    @resource_class.name.casecmp('Project').zero?
  end

  def task?
    @resource_class.name.casecmp('Task').zero?
  end

  def serializer_class
    @serializer = Kernel.const_get([resource_class, 'Serializer'].join.to_s)
  end

  def set_resource
    @resource = resource_class.find(params[:id])
  end

  def find_organization
    @organization = Organization.find(params[:organization_id])
  end

  def find_project
    @project = if project?
                 @organization.projects.find(params[:id])
               else
                 Project.find(params[:project_id])
               end
  end
end
