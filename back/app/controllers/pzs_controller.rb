class PzsController < ApplicationController
  before_action :set_pz, only: %i[ show update destroy ]

  # GET /pzs
  def index
    @pzs = Pz.all

    render json: @pzs
  end

  # GET /pzs/1
  def show
    render json: @pz
  end

  # POST /pzs
  def create
    @pz = Pz.new(pz_params)

    if @pz.save
      render json: @pz, status: :created, location: @pz
    else
      render json: @pz.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pzs/1
  def update
    if @pz.update(pz_params)
      render json: @pz
    else
      render json: @pz.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pzs/1
  def destroy
    @pz.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pz
      @pz = Pz.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pz_params
      params.require(:pz).permit(:area_id, :type, :name, :radius, :altitude)
    end
end
