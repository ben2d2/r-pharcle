class Player < ActiveRecord::Base
  has_many :game_players
  has_many :games, through: :game_players
  has_many :rounds

  attr_accessor :game_id, :player_number
end
