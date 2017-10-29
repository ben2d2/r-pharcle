class AddPlayerNumberToGamePlayers < ActiveRecord::Migration
  def change
    add_column :game_players, :player_number, :integer
  end
end
