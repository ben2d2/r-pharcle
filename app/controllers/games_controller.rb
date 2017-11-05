class GamesController < ApplicationController
  expose(:games) { Game.all }
  expose(:game)
  expose(:player) { Player.new }
  expose(:game_player) { GamePlayer.new }
  expose(:scoreboard) { ScoreboardPresenter.new(game) }
  expose(:flash_type) { params[:flash_type] }

  def index; end

  def create
    if game.save
      redirect_to game_path(game)
    end
  end

  def show; end
end
