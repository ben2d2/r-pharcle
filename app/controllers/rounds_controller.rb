class RoundsController < ApplicationController
  expose(:round)
  expose(:turn) { Turn.new(params.fetch(:remaining_dice_count, 6)).create }
  expose(:turn_handler) { TurnHandler.new(round, turn, params) }
  expose(:scoreboard) { ScoreboardPresenter.new(round.game) }
  expose(:round_turns) do
    range = params[:turn].present? ? (1..params[:turn].to_i).to_a : [1]
    round.turns.select { |k, v| range.include?(k.to_i) }
  end

  def create
    if handler = turn_handler.save
      if handler[:game_path]
        flash[:notice] = handler[:message]
        redirect_to game_path(round.game, { flash_type: handler[:flash_type] })
      else
        redirect_to round_path(round, { flash_type: handler[:flash_type] })
      end
    end
  end

  def update
    if handler = turn_handler.save
      if handler[:game_path]
        flash[:notice] = handler[:message]
        redirect_to game_path(round.game, { flash_type: handler[:flash_type] })
      else
        redirect_to round_path(round, { turn: params[:turn], flash_type: handler[:flash_type] })
      end
    end
  end

  def show; end

  private
  def round_params
    params.require(:round).permit(:game_id, :player_id, :number, :remaining_dice_count)
  end
end
