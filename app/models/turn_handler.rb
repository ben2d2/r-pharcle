class TurnHandler
  attr_reader :round, :round_turns, :options

  def initialize(round, options)
    @round       = round
    @round_turns = round.turns
    @options     = options
  end

  def score_zero?
    round_turns[options.fetch(:turn, 1).to_s]["score"].zero?
  end

  def stay
    turns = (1..options[:stopped_at].to_i).map do |i|
      [i, round_turns[i.to_s]]
    end.to_h
    round.turns = turns
    round.total = turns.map { |k, v| v["score"] }.reduce(:+)
    round.save
  end

  def save_all_turns
    round.total = round_turns.map { |k, v| v["score"] }.reduce(:+)
    round.save
  end

  def save_special
    round.total = round_turns["1"]["score"]
    round.save
  end

  def save_zero
    round.total = 0
    round.save
  end
end
