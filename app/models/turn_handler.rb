class TurnHandler
  attr_reader :round, :turn, :opts

  def initialize(round, turn, opts={})
    @round = round
    @turn  = turn
    @opts  = opts
  end

  def save
    if game_over?
      round.game.update_attribute(:updated_at, Time.now)
      response
    elsif stayed?
      update_round
      response
    elsif high_roller?
      update_round
      response
    elsif score_zero?
      update_round(0)
      response
    elsif no_dice
      update_round
      response
    else
      update_round
      response
    end
  end

  def response
    if game_over?
      { game_path: true, message: "Game Over!", flash_type: "success" }
    elsif high_roller?
      type = turn[:score] == 1500 ? " Three Pairs " : " a Pharcle "
      { game_path: true, message: "Wow #{type} #{round.total}pts!", flash_type: "success" }
    elsif stayed?
      { game_path: true, message: "You stayed at #{round.total}pts!", flash_type: "info" }
    elsif score_zero?
      { game_path: true, message: "Womp womp... You scored 0pts!", flash_type: "danger" }
    elsif no_dice
      { game_path: true, message: "You scored #{round.total}pts!", flash_type: "info" }
    else
      {}
    end
  end

  def update_round(total=new_turns_total)
    round.turns = new_turns
    round.total = total
    round.save
  end

  def new_turns
    @new_turns ||= stayed? ? round_turns : round_turns.merge({ opts.fetch(:turn, 1) => turn }).with_indifferent_access
  end

  def round_turns
    round.turns || {}
  end

  def new_turns_total
    new_turns.map { |k, v| v["score"] }.reduce(:+)
  end

  def stayed?
    opts[:stay]
  end

  def score_zero?
    turn.with_indifferent_access["score"].zero?
  end

  def no_dice
    turn[:remaining_dice_count].to_i.zero? || opts[:turn].to_i == 4
  end

  def high_roller?
    [1500, 3000].include?(turn[:score])
  end

  def game_over?
    index = @round.game.game_players.find_by(player_id: @round.player.id).player_number
    scoreboard.totals_row[index] >= 10000 && last_player?
  end

  def last_player?
    game = @round.game
    players_count = game.players.count
    (game.rounds.where(number: @round.number).count + 1) == players_count
  end

  def scoreboard
    ScoreboardPresenter.new(@round.game)
  end
end
