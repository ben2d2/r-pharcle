class Dice
  attr_reader :dice_number, :value

  def initialize(dice_number)
    @dice_number = dice_number
    @value = rand(1..6)
  end
end
