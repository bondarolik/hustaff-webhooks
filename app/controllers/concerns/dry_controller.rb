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
    
    before_action :find_organization, if: :project?
    before_action :find_project, only: %i[show update destroy], if: :project?
    before_action :find_project, only: %i[index show create update destroy], if: :task?
    before_action :set_resource, only: %i[show update destroy]
  end

  def index
    @resources = task? ? @project.tasks : @organization.projects

    render json: @serializer.new(@resources).serializable_hash
  end

  def show
    if @resource.present?
      render json: @serializer.new(@resource).serializable_hash
    else
      render json: { error: 'Not Found' }, status: :not_found
    end
  end

  def create; end

  def update; end

  def destroy
    if @resource.destroy
      head :ok
    else
      render json: { error: 'Not Found' }, status: :not_found
    end
  end

  private

  def set_resource_class
    @resource_class = controller_path.classify.constantize
  end

  def serializer_class
    @serializer = Kernel.const_get([@resource_class, 'Serializer'].join.to_s)  
  end  

  def organization?
    @resource_class.name.casecmp('Organization').zero?
  end

  def project?
    @resource_class.name.casecmp('Project').zero?
  end

  def task?
    @resource_class.name.casecmp('Task').zero?
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

  def set_resource
    @resource = if task?
                  @project.tasks.find(params[:id])
                elsif project?
                  @organization.projects.find(params[:id])
                else
                  @resource_class.find(params[:id])
                end
  end  
end
