# frozen_string_literal: true

# Helps us to keep our controllers cleaner
module DryController
  extend ActiveSupport::Concern

  included do
    before_action :set_resource_class
    before_action :find_organization, if: :is_project?
    before_action :find_project, only: %i[show update destroy], if: :is_project?
    before_action :find_project, only: :create, if: :is_task?
    before_action :set_resource, only: %i[show update destroy]
  end

  def show
    render json: serializer_class.new(@resource).serializable_hash
  end

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

  def is_project?
    @resource_class.name.downcase == 'Project'.downcase
  end

  def is_task?
    @resource_class.name.downcase == 'Task'.downcase
  end  

  def serializer_class
    eval([resource_class, "Serializer"].join('').to_s)
  end

  def set_resource
    @resource = resource_class.find(params[:id])
  end

  def find_organization
    @organization = Organization.find(params[:organization_id])  
  end
  
  def find_project
    @project = if is_project?
                @organization.projects.find(params[:id])
              else
                @project = @resource_class.find(params[:id])
              end
  end    
end
