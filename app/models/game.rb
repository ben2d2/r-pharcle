class Game < ActiveRecord::Base
  has_many :game_players
  has_many :players, through: :game_players

  accepts_nested_attributes_for :game_players
end
