class Dice
  attr_reader :dice_number, :value

  def initialize(dice_number)
    @dice_number = dice_number
    @value = roll
  end

  def roll
    value = (1..6).to_a.sample
  end
end
