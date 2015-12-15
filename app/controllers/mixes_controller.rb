class MixesController < ApplicationController
  before_filter :authenticate_user!, except: [:all, :show, :download]

  def all
    if params[:search]    # if comments are requested by subject
      @mixes = Mix.search(params[:search]).order("created_at DESC")
    else # regular order
      @mixes = Mix.all #order("created_at DESC")
    end

    # hash to store tracks and their indentation level
    @visited = Hash.new 
    @mixes.each do |mix|
      if !mix.mix_id   # meaning it's an original mix
        indent = 0  
        mix_array = DFS(mix, indent, @visited)
      end
    end
  end

  def DFS (mix, indent, visited)
    visited[mix] = indent
    # recursively visit all mixes of track and mixes of mixes
    mix.mixes.each do |remix|
      DFS(remix, indent + 4, visited) # add 4 to each indent
    end
    visited
  end  

  def index
    @user = User.find(params[:user_id])
    @mixes = @user.mixes # change from tracks to mixes
  end

  def new
  	@mix = Mix.new
  	@user = current_user
  end

  def create
  	@mix = Mix.new(mix_params)
  	@mix.user_id = current_user.id

  	if @mix.save
  		redirect_to mixes_all_path, notice: 'Track uploaded.'
  	else
  		redirect_to new_mix_path(@mix), alert: 'Track could not be uploaded'
      if @mix.errors.messages.any?
        @mix.errors.full_messages.each do |message|
          message
        end
      end
  	end
  end

  def new_mix 
    @original_mix = Mix.find(params[:mix_id])
    @mix = @original_mix.mixes.new(user_id: current_user)
  end

  def create_mix 
    @original_mix = Mix.find(params[:mix_id])
    @mix = @original_mix.mixes.new(mix_params)
    
    @mix.user_id = current_user.id
    # assign the mix_id as the id of the original mix
    @mix.update(mix_id: @original_mix.id)

    if @mix.save
      redirect_to mixes_all_path, notice: 'Mix uploaded.'
    else
      redirect_to new_mix_path(@original_mix), alert: 'Mix could not be uploaded.'
    end  
  end

  def edit
    @mix = Mix.find(params[:id])
  end

  def update
    @mix = mix.find(params[:id])

    if @mix.update(mix_params)
      redirect_to track_mixes_path(Track.find(@mix.track_id)), notice: 'You updates a mix'
    else
      redirect_to edit_track_mix_path(Track.find(@mix.track_id)), notice: 'Mix could not be updated'
    end
  end

  def destroy
    # reassign all children mixes to '<mix removed>' parent
    if Mix.find(params[:id]).update(name: '<file removed>', audio_file: nil)
      redirect_to mixes_all_path, notice: "You've just deleted a mix"
    else
      redirect_to mix_path(mix), alert: 'Mix was not deleted!'
    end
  end

  def show
  	@mix = Mix.find(params[:id])
  end

  def mix_params
  	params.require(:mix).permit(:name, :audio_file)
  end

  def download
    data = open(Mix.find(params[:id]).audio_file_url)
    send_data data.read, :type => data.content_type, :x_sendfile => true
  end
end
