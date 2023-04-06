class TaskTypesController < ApplicationController
  before_action :set_task_type, only: %i[show update destroy]

  def index
    @task_types = TaskType.all

    render json: @task_types
  end


  # GET /task_types/1
  def show
    render json: @task_types
  end

  def create
    @task_types = TaskType.new(task_type_params)

    if @task_types.save
      render json: @task_types, status: :created, location: @task_types
    else
      render json: @task_types.errors, status: :unprocessable_entity
    end
  end

  def update
    if @task_types.update(task_type_params)
      render json: @task_types
    else
      render json: @task_types.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @task_types.destroy
      render json: @task_types, status: 200
    else
      render json: @task_types.errors, status: :unprocessable_entity
    end
  end

  private

  def set_task_type
    @task_types = TaskType.find(params[:id])
  end

  def task_type_params
    params.require(:task_type).permit(:name, :short_name, :description)
  end
end
