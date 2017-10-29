class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @player = Player.new
    @game = Game.find(params[:id])
    @game_player = GamePlayer.new
  end
end
