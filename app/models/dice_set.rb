class DiceSet
  attr_reader :turn_number, :collection

  def initialize(turn_number)
    @turn_number = turn_number
    @collection  = (1..6).map { |i| Dice.new(i) }
  end
end
