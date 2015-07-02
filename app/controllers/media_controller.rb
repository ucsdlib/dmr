##
# @author tchu
#

class MediaController < ApplicationController

  def index
    @medias = Media.all
  end

  def show
    @media = Media.find(params[:id])
  end
  
  def new
    @media = Media.new
  end

  def create
    @media = Media.new(media_params)
    if @media.save
      redirect_to media_path, notice: 'A new Media Record has been created!'
    else
      render :new
    end
  end
  
  def edit 
    @media = Media.find(params[:id]) 
  end

  def update 
    @media = Media.find(params[:id])
    if @media.update_attributes(media_params) 
      redirect_to edit_medium_path(@media), :flash => { :notice => "The Media Record has been updated." }
    else
      render :edit
    end   
  end
       
  private
    ##
    # Specify which parameters are allowed into Media controller actions to prevent wrongful mass assignment.
    #
    # @!visibility private
      
    def media_params
      params.require(:media).permit(:title, :director, :call_number, :year, :file_name)
    end
  
end
