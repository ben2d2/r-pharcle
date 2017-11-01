class TurnHandler
  attr_reader :round, :turn, :opts

  def initialize(round, turn, opts={})
    @round = round
    @turn  = turn
    @opts  = opts
  end

  def save
    if stayed?
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
    if high_roller?
      message = turn[:score] == 1500 ? " Three Pairs " : " a Pharcle "
      { game_path: true, message: "Wow #{message} #{round.total}pts!" }
    elsif stayed?
      { game_path: true, message: "You stayed at #{round.total}pts!" }
    elsif score_zero?
      { game_path: true, message: "Womp womp... You scored 0pts!" }
    elsif no_dice
      { game_path: true, message: "You scored #{round.total}pts!" }
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
    [1500, 3000].include?(turn["score"])
  end
end
