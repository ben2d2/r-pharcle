class RoundsController < ApplicationController
  def new
    @round = Round.new(game_id: params[:game_id], player_id: params[:player_id])
    @roll_em = Round.new.turn
  end
end
