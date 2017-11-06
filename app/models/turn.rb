class Turn
  PHARCLE = [1, 2, 3, 4, 5, 6]
  THREE_PAIRS = [2, 2, 2]

  attr_reader :roll, :dice_count

  def initialize(dice_count)
    @dice_count = dice_count.to_i
    @roll = DiceSet.new(dice_count).collection
  end

  def create
    return pharcle if values.sort == PHARCLE
    return three_pairs(values) if has_three_pairs?
    score_it
  end

  def score_it
    score = 0
    remaining_dice_count = dice_count
    grouped.each do |k, v|
      count = v.count
      if count >= 3
        if k == 1
          score += 1000
          count -= 3
          remaining_dice_count -= 3
          score += (100 * count)
          remaining_dice_count -= count
          update_counted(v)
        elsif k == 5
          score += 500
          count -= 3
          remaining_dice_count -= 3
          score += (50 * count)
          remaining_dice_count -= count
          update_counted(v)
        else
          score += (100 * k)
          remaining_dice_count -= 3
          update_counted(v.first(3))
        end
      else
        new_score = (mapping[k].to_i * count)
        score += new_score
        remaining_dice_count -= count unless new_score.zero?
        update_counted(v) unless new_score.zero?
      end
    end
    {
      score: score,
      values: values,
      roll: roll,
      remaining_dice_count: remaining_dice_count
    }
  end

  def update_counted(set)
    set.each { |dice| dice.counted = true }
  end

  def mapping
    { 1 => 100, 5 => 50 }
  end

  def values
    @values ||= roll.map(&:value)
  end

  def has_three_pairs?
    grouped.map { |k, v| v.count } == THREE_PAIRS
  end

  def three_pairs(values)
    { score: 1500, values: values, remaining_dice_count: 0 }
  end

  def pharcle
    { score: 3000, values: PHARCLE, remaining_dice_count: 0 }
  end

  def grouped
    roll.group_by { |dice| dice.value }
  end
end
