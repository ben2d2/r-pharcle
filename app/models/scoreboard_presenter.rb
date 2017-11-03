class ScoreboardPresenter
  attr_reader :game, :round_number

  def initialize(game)
    @game         = game
    @round_number = determine_round_number
  end

  def to_h
    {
      header_row: header_row,
      totals_row: totals_row,
      data_rows: data_rows,
      next_round_row: next_round_row,
      add_next_row: add_next_row?
    }
  end

  def header_row
    players.pluck(:username).unshift("Round")
  end

  def data_rows
    grouped_and_sorted_rounds.map do |k, rounds|
      row = [k]
      by_player = rounds_by_player(rounds)
      players.each do |player|
        if player_round = by_player[player.id]
          row << player_round.first.total
        else
          row << form_data_for(player.id)
        end
      end
      row
    end
  end

  def totals_row
    players.map do |player|
      rounds = rounds_by_player.fetch(player.id, [])
      rounds.map(&:total).reduce(0, :+)
    end.unshift("Total")
  end

  def next_round_row
    players.map { |player| form_data_for(player.id) }.unshift(round_number)
  end

  private
  def form_data_for(player_id)
    { form_data: { game_id: game.id, player_id: player_id, number: round_number } }
  end

  def players
    @players ||= game.players.order('game_players.player_number')
  end

  def game_rounds
    @game_rounds ||= game.rounds
  end

  def grouped_and_sorted_rounds
    @grouped_and_sorted_rounds ||= game_rounds.group_by(&:number).sort_by { |k, v| k }
  end

  def rounds_by_player(rounds=game_rounds)
    rounds.group_by(&:player_id)
  end

  def add_next_row?
    game_rounds.where(number: round_number).any?
  end

  def determine_round_number
    return 1 if game_rounds.blank?
    number = 0
    grouped_and_sorted_rounds.each do |k, v|
      if v.to_a.count < players.count
        number = k
      else
        number = k.to_i + 1
      end
    end
    number
  end
end
