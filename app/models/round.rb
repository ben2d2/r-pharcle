class Round < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  attr_accessor :remaining_dice_count
end
