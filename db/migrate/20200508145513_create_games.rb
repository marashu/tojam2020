class CreateGames < ActiveRecord::Migration[5.0]
  def up
    create_table :games do |t|
      t.text :map

      t.timestamps
    end
  end
  def down
    drop_table :games
  end
end
