class GamePlayersController < ApplicationController
  def create
    game_player = GamePlayer.new(game_player_params)
    if game_player.save
      redirect_to game_path(game_player_params[:game_id])
    else
      flash[:notice] = "Did not save"
      redirect_to game_path(game_player_params[:game_id])
    end
  end

  private
  def game_player_params
    params.require(:game_player).permit(:player_id, :game_id, :player_number)
  end
end
