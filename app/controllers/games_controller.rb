class GamesController < ApplicationController

  # GET /games/1
  def show
    @game = Game.find(params[:id])
    render_404("Authorization Denied") unless cookies[:lazy_authentication] == @game.cookie
  end

  # GET /games/new
  def new
    cookies[:lazy_authentication] ||= (request.remote_ip + Time.now.to_s).tr("A-Ma-mN-Zn-z0-9","N-ZN-ZA-MA-Mb-k")
    flash[:notice] = 'Would you like to play a game?'
    @game = Game.new
  end

  # POST /games
  def create
    @game = Game.new(params[:game])
    @game.cookie = cookies[:lazy_authentication]
    
    if @game.save
      flash[:notice] = 'Good luck.'
      redirect_to(@game)
    else
      flash[:notice] = 'Sorry, there was a problem starting your game.'
      render :action => "new"
    end
  end

  # PUT /games/1
  def update
    @game = Game.find(params[:id])
    return unless cookies[:lazy_authentication] == @game.cookie
    
    render :update do |page|
      @game.human_move(params[:move])
      page["s#{params[:move]}"].replace_html @game[params[:move]]
      unless @game.finished?
        computer_move = @game.computer_move
        page["s#{computer_move}"].replace_html @game[computer_move]
      end
      if @game.finished?
        case @game.board.winner
        when nil
          page[:flash].replace_html "The only winning move is not to play. #{link_to 'Play Again?', new_game_path}"
        when @game.computer
          page[:flash].replace_html "You lost. #{link_to 'Play Again?', new_game_path}"
        else
          page[:flash].replace_html "You're a winner! #{link_to 'Play Again?', new_game_path}"
        end
      end
    end
  end

end
