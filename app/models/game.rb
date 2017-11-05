class Game < ActiveRecord::Base
  has_many :game_players
  has_many :players, through: :game_players
  has_many :rounds

  accepts_nested_attributes_for :game_players

  def started?
    self.rounds.any?
  end

  def over?
    self.updated_at > self.created_at
  end
end
