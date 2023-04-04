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
      render json: @pz, status: :created
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

  # POST /pzs/create_pz_file
  def create_pz_file
    blob = ActiveStorage::Blob.create_and_upload!(
      io: params[:file].tempfile,
      filename: params[:file].original_filename,
      content_type: params[:file].content_type
    )
    @pz = Pz.last
    @pz.file.attach(blob)

    if @pz.save
      render json: @pz, status: :created
    else
      render json: @pz.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pz
      @pz = Pz.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pz_params
      params.require(:pz).permit(:area_id, :name, :pz_type, :longitude, :latitude, :radius, :altitude)
    end
end
