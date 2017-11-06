class DiceSet
  attr_reader :dice_count

  def initialize(dice_count=6)
    @dice_count = dice_count.to_i
  end

  def collection
    (1..dice_count).map { |i| Dice.new(i) }
  end
end
