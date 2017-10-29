class Round
  PHARCLE = [1, 2, 3, 4, 5, 6]

  def turn
    grouped_by_value = roll(6)
    turn_one = score_and_such(grouped_by_value, 6)
    hash = { "1" => turn_one }
    if !turn_one[:score].zero?
      dice_count = turn_one[:remaining_dice_count]
      grouped_by_value = roll(dice_count)
      turn_two = score_and_such(grouped_by_value, dice_count)
      hash.merge!("2" => turn_two)
      if !turn_two[:score].zero?
        dice_count = turn_two[:remaining_dice_count]
        grouped_by_value = roll(dice_count)
        turn_three = score_and_such(grouped_by_value, dice_count)
        hash.merge!("3" => turn_three)
        if !turn_three[:score].zero?
          dice_count = turn_three[:remaining_dice_count]
          grouped_by_value = roll(dice_count)
          turn_four = score_and_such(grouped_by_value, dice_count)
          hash.merge!("4" => turn_four)
        end
      end
    end
    { total: hash.map { |k, h| h[:score] }.reduce(:+), data: hash }
  end

  def roll(dice_count)
    DiceSet.new(dice_count).collection
  end

  def score_and_such(grouped_by_value, dice_count)
    score = 0
    pairs = []
    values = grouped_by_value.map { |k, v| v.map(&:value) }.flatten
    return pharcle if values.sort == PHARCLE
    grouped_by_value.each do |k, v|
      count = v.count
      if count >= 3
        if k == 1
          score += 1000
          count -= 3
          dice_count -= 3
          score += (100 * count)
          dice_count -= count
        elsif k == 5
          score += 500
          count -= 3
          dice_count -= 3
          score += (50 * count)
          dice_count -= count
        else
          score += (100 * count)
        end
      elsif count == 2
        pairs << v
      else
        new_score = (mapping[k].to_i * count)
        score += new_score
        dice_count -= count unless new_score.zero?
      end
    end

    return three_pairs(values) if pairs.size == 3

    {
      score: score,
      values: values,
      remaining_dice_count: dice_count
    }
  end

  def sum_after_three(key, value)
    sum_of_value = value.reduce(:+)
    (mapping.fetch(key, 0) * (sum_of_value - (key * 3)))
  end

  def mapping
    { 1 => 100, 5 => 50 }
  end

  def values(grouped_by_value)
    grouped_by_value.map { |k, v| v.map { |dice| dice.value } }.flatten
  end

  def three_pairs(values)
    { score: 1500, values: values, remaining_dice_count: 0 }
  end

  def pharcle
    { score: 3000, values: PHARCLE, remaining_dice_count: 0 }
  end
end
