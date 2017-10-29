class DiceSet
  attr_reader :dice_count

  def initialize(dice_count=6)
    @dice_count = dice_count
  end

  def collection
    fetch = (1..dice_count).map { |i| Dice.new(i) }
    fetch.group_by { |dice| dice.value }
  end
end
