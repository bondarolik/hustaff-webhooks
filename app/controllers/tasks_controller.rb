# frozen_string_literal: true

# Exposes API for interacting with Tasks.
class TasksController < ApplicationController
  before_action :authenticate
  include DryController

  def create
    super
    result = TaskServices::Creator.call(@project, permitted_params)

    if result.success?
      render json: @serializer.new(result.payload).serializable_hash
    else
      render json: { errors: result.payload.errors.full_messages }, status: result.status
    end
  end

  def update
    super
    result = TaskServices::Updater.call(@resource, permitted_params)

    if result.success?
      render json: @serializer.new(result.payload).serializable_hash
    else
      render json: { errors: result.payload.errors.full_messages }, status: result.status
    end
  end

  private

  def permitted_params
    params.permit(:name, :description, :project_id)
  end
end
