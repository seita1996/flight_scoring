# This class is hot air balloon competition class.
class EventsController < ApplicationController
  before_action :set_event, only: %i[show update destroy]

  def index
    @events = Event.includes(:area).all
    render json: @events, include: :area
  end

  def show
    render json: @event, include: :area
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      render json: @event, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :area_id, :director, :start_term, :end_term)
  end
end
