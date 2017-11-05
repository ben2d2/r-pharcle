class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def create
    game = Game.create
    redirect_to game_path(game)
  end

  def show
    @player = Player.new
    @game_player = GamePlayer.new
    @game = Game.find(params[:id])
    @scoreboard = ScoreboardPresenter.new(@game).to_h
    @flash_type = params[:flash_type]
  end
end
