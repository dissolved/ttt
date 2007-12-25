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

  # GET /games/new
  def new
    @game = Game.new
  end

  # POST /games
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        flash[:notice] = 'Good luck.'
        format.html { redirect_to(@game) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /games/1
  def update
    @game = Game.find(params[:id])
    
    render :update do |page|
      @game.move(params[:move])
      page["s#{params[:move]}"].replace_html @game[params[:move]]
      unless @game.finished?
        computer_move = @game.computer_move
        page["s#{computer_move}"].replace_html @game[computer_move]
      end
      page[:NewGameBtn].show if @game.finished?
    end
  end

  def teach
    100.times do
      game = Game.new
      until game.finished? do
        game.computer_move
      end
    end
    render :text => 'Thank you sir may I have another.'
  end
end
