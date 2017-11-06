class Dice
  attr_reader :dice_number, :value
  attr_accessor :counted

  def initialize(dice_number)
    @dice_number = dice_number
    @value = rand(1..6)
    @counted = false
  end
end
