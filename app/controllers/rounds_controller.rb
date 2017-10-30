class RoundsController < ApplicationController
  def new
    @game = Game.find(params[:game_id])
    @player = Player.find(params[:player_id])
    @round = Round.new
  end

  def show
    @round = Round.find(params[:id])
    if params[:stay]
      range = (1..params[:stopped_at].to_i)
      turns = @round.turns.select { |k, v| range.include?(k.to_i) }
      @round.turns = turns
      @round.total = turns.map { |k, v| v["score"] }.reduce(:+)
      @round.save
      redirect_to game_path(@round.game)
    else
      first_score = @round.turns.first.last["score"]
      if [1500, 3000].include?(first_score)
        @round.total = first_score
        @round.save
        redirect_to game_path(@round.game)
      end
      range = params[:turn].present? ? (1..params[:turn].to_i).to_a : [1]
      @round_turns = @round.turns.select { |k, v| range.include?(k.to_i) }
      if @round_turns[params.fetch(:turn, 1).to_s]["score"].zero?
        @round.total = 0
        @round.save
        redirect_to game_path(@round.game)
      elsif params[:turn].present? && params[:turn].to_i == 4
        @round.total = @round_turns.map { |k, v| v["score"] }.reduce(:+)
        @round.save
        redirect_to game_path(@round.game)
      end
    end
  end

  def create
    turns = SpikeRound.new.turn
    round = Round.new(round_params)
    round.turns = turns[:data]
    if round.save
      redirect_to round_path(round)
    else
      redirect_to new_round_path({ game_id: round.game_id, player_id: round.player_id })
    end
  end

  private
  def round_params
    @round_params ||= params.require(:round).permit(:game_id, :player_id, :number)
  end
end
