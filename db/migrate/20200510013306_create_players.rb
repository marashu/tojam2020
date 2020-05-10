class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.integer :avatar
      t.belongs_to :game, index: true
      t.boolean :host

      t.timestamps
    end
  end
end
