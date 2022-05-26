# frozen_string_literal: true

# Exposes API for interacting with Tasks.
class TasksController < ApplicationController
  before_action :authenticate
  include FindOrganizationAndProject

  def index
    render json: TaskSerializer.new(@project.tasks).serializable_hash
  end

  def create
    @task = @project.tasks.build(task_params)

    if @task.save
      render json: TaskSerializer.new(@task).serializable_hash
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: TaskSerializer.new(@task).serializable_hash
  end

  def update
    if @task.update(task_params)
      render json: TaskSerializer.new(@task).serializable_hash
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    head :ok
  end

  private

  def task_params
    params.permit(:name, :description)
  end
end
