class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @player = Player.new
    @game_player = GamePlayer.new
    @game = Game.find(params[:id])
    determine_round_number
    @scoreboard = calculate_scores
    @round = Round.new
  end

  private
  def calculate_scores
    players = @game.players
    header = players.pluck(:username).unshift("Round")
    array = @game.rounds.group_by(&:number).sort_by { |k, v| v }.map do |k, v|
      scores = [k]
      players.map do |player|
        v.each do |round|
          scores << round.total if round.player_id == player.id
        end
      end
      scores
    end.unshift(header)

    footer = ["Total"]
    @game.rounds.group_by(&:player_id).each do |player_id, rounds|
      players.each do |player|
        footer << rounds.map(&:total).reduce(0, :+) if player_id == player.id
      end
    end
    array << footer
    array
  end

  def determine_round_number
    if @game.rounds.blank?
      @round_number = 1
    else
      grouped_by_number = @game.rounds.group_by { |r| r.number }
      grouped_by_number.each do |k, v|
        if v.to_a.count < @game.players.count
          @round_number = k
        else
          @round_number = k.to_i + 1
        end
      end
    end
  end
end
