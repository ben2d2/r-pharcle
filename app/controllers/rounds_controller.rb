class RoundsController < ApplicationController
  def create
    turns = Turns.new.create
    round = Round.new(round_params)
    round.turns = turns[:data]
    if round.save
      redirect_to round_path(round)
    else
      redirect_to new_round_path({ game_id: round.game_id, player_id: round.player_id })
    end
  end

  def show
    @round = Round.find(params[:id])
    turn = TurnHandler.new(@round, params)
    if params[:stay]
      turn.stay
      success_path
    else
      round_turns = @round.turns
      first_score = round_turns.first.last["score"]
      if [1500, 3000].include?(first_score)
        turn.save_special
        success_path
      end
      range = params[:turn].present? ? (1..params[:turn].to_i).to_a : [1]
      @round_turns = round_turns.select { |k, v| range.include?(k.to_i) }
      if @round_turns[params.fetch(:turn, 1).to_s]["score"].zero?
        turn.save_zero
        success_path
      elsif params[:turn].present? && params[:turn].to_i == 4
        turn.save_all_turns
        success_path
      end
    end
  end

  private
  def round_params
    params.require(:round).permit(:game_id, :player_id, :number)
  end

  def success_path
    redirect_to game_path(@round.game)
  end
end
