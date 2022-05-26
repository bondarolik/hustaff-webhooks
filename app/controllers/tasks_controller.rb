# frozen_string_literal: true

# Exposes API for interacting with Tasks.
class TasksController < ApplicationController
  before_action :authenticate
  include DryController

  def index
    render json: TaskSerializer.new(@project.tasks).serializable_hash
  end

  def create
    result = TaskServices::Creator.call(@project, permitted_params)

    if result.success?
      render json: TaskSerializer.new(result.payload).serializable_hash
    else
      render json: { errors: result.payload.errors.full_messages }, status: result.status
    end
  end

  def update
    if @resource.update(task_params)
      render json: TaskSerializer.new(@resource).serializable_hash
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.permit(:name, :description)
  end
end
