class RoundsController < ApplicationController
  def create
    round = Round.new(round_params)
    turn = Turn.new(6).create
    handler = TurnHandler.new(round, turn, params).save
    if handler[:game_path]
      redirect_to game_path(round.game)
    else
      redirect_to round_path(round)
    end
  end

  def update
    round = Round.find(params[:id])
    turn = Turn.new(params[:remaining_dice_count]).create
    handler = TurnHandler.new(round, turn, params).save
    if handler[:game_path]
      flash[:notice] = handler[:message]
      redirect_to game_path(round.game)
    else
      redirect_to round_path(round, { turn: params[:turn] })
    end
  end

  def show
    @round = Round.find(params[:id])
    range = params[:turn].present? ? (1..params[:turn].to_i).to_a : [1]
    @round_turns = @round.turns.select { |k, v| range.include?(k.to_i) }
  end

  private
  def fetch_round_turns
    range = params[:turn].present? ? (1..params[:turn].to_i).to_a : [1]
    @round_turns = @round.turns.select { |k, v| range.include?(k.to_i) }
  end

  def round_params
    params.require(:round).permit(:game_id, :player_id, :number, :remaining_dice_count)
  end

  def success_path
    redirect_to game_path(@round.game)
  end

  def success_path
    redirect_to game_path(@round.game)
  end
end
