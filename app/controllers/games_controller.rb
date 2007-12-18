class GamesController < ApplicationController

  # GET /games
  def index
    @games = Game.find(:all)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /games/1
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # POST /games
  def create
    @game = Game.new()
  end

  # PUT /games/1
  def update
    @game = Game.find(params[:id])
    
    
    render :update do |page|
      page["s#{params[:move]}"].replace_html 'X'
      
      page[id].visual_effect :highlight
    end
  end
end
