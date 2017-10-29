class PlayersController < ApplicationController
  def create
    player = Player.new(player_params)
    if player.save
      player.game_players.create(game_id: player_params[:game_id], player_number: player_params[:player_number])
      redirect_to game_path(player_params[:game_id])
    else
      flash[:notice] = "Did not save"
      redirect_to game_path(player_params[:game_id])
    end
  end

  private
  def player_params
    params.require(:player).permit(:first_name, :last_name, :username, :email, :game_id, :player_number)
  end
end
