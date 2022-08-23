class TaskTypesController < ApplicationController
  def index
    @task_types = TaskType.all

    render json: @task_types
  end
end
