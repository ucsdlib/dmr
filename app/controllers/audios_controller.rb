#
# @author Vivian <tchu@ucsd.edu>
#
class AudiosController < ApplicationController
  include Dmr::ControllerHelper
  before_action :authorize
  before_action :set_audio, only: [:show, :edit, :update, :destroy]

  # GET /audios
  def index
    @audios = Audio.order('created_at DESC').limit(10)
  end

  # GET /audios/1
  def show
    render layout: false
  end

  # GET /audios/new
  def new
    @audio = Audio.new
  end

  # GET /audios/1/edit
  def edit
  end

  # POST /audios
  def create
    @audio = Audio.new(audio_params)

    if @audio.save
      redirect_to edit_audio_path(@audio), notice: 'Audio was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /audios/1
  def update
    if @audio.update(audio_params)
      redirect_to edit_audio_path(@audio), notice: 'Audio was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /audios/1
  def destroy
    @audio.destroy
    redirect_to audios_path, notice: 'Audio was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_audio
    @audio = Audio.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def audio_params
    params.require(:audio).permit(:track, :album, :artist, :composer, :call_number, :year, :file_name)
  end
end
