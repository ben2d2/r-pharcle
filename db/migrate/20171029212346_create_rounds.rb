class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :game_id
      t.integer :player_id
      t.json :turns
      t.integer :total

      t.timestamps
    end
  end
end
