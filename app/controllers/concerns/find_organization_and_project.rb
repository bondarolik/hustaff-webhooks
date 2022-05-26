# frozen_string_literal: true

# Helps us to keep our controllers cleaner
module FindOrganizationAndProject
  extend ActiveSupport::Concern

  included do
    before_action :set_resource_class
    before_action :find_organization, if: :is_project?
    before_action :find_project, only: [:show, :update, :destroy]
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