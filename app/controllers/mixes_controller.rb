class MixesController < ApplicationController
  before_filter :authenticate_user!, except: [:all, :show, :index, :download]

  def all
    @visited = Hash.new 
    if params[:search]  
      @search = params[:search]  
      #search by name
      @mixes = Mix.search(@search)

      # add tracks with tags that match query
      @tag_matches = Mix.tagged_with(@search)

      # sort alphabetically
      @mixes.sort 
      @tag_matches.sort
      # add to hash
      @mixes.each do |track|
        @visited[track] = 0
      end
      @tag_matches.each do |track|
        @visited[track] = 4 # indent the tag matches 4 times
      end
    else # regular order
      @mixes = Mix.all.sort
      # hash to store tracks and their indentation level
      @mixes.each do |mix|
        if !mix.mix_id   # meaning it's an original mix
          indent = 0  
          DFS(mix, indent, @visited)
        end
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

    #@mix.tag_list.add(params[:tag_list])

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
      Notification.create(user_id: @original_mix.user_id, mix_id: @original_mix.id, state: 0) # Create notification for creator of original mix
      redirect_to mixes_all_path, notice: 'Mix uploaded.'
    else
      redirect_to new_mix_path(@original_mix), alert: 'Mix could not be uploaded.'
    end  
  end

  def edit
    @mix = Mix.find(params[:id])
  end

  def update
    @mix = Mix.find(params[:id])
    # gets current tags
    @tags = ActsAsTaggableOn::Tag.most_used
    # add tags to current
    @mix.tag_list.add(params[:tag_list])

    if @mix.update(mix_params)
      redirect_to mix_path(@mix), notice: 'You\'ve updated a mix'
    else
      redirect_to edit_mix_path(@mix), notice: 'Mix could not be updated'
    end
  end

  def destroy
    track = Mix.find(params[:id])

    track.mixes.each do |remix|
      if track.mix_id
        Mix.update(remix.id, :mix_id => track.mix_id)
      else
        remix.update_attribute(:mix_id, nil)
      end
    end
    # and destroy all notifications with this mix_id
    Notification.destroy_all(mix_id: track.id)

    if track.destroy
      redirect_to mixes_all_path, notice: 'You\'ve just deleted a mix.'
    else
      redirect_to mix_mix_path(track), alert: 'Unable to delete mix.'
    end
  end

  def show
  	@mix = Mix.find(params[:id])
    # remove any notifications about this mix -->
    if user_signed_in?
      if current_user.id == @mix.user_id
        @mix.notifications.each do |notification|
          Notification.update(notification, state: 1) # mark all notifications as read
        end
      end
    end
    @mixes = @mix.mixes
  end

  def mix_params
  	params.require(:mix).permit(:name, :audio_file, :tag_list)
  end

  def download
    data = open(Mix.find(params[:id]).audio_file_url)
    send_data data.read, :type => data.content_type, :x_sendfile => true
  end
end
