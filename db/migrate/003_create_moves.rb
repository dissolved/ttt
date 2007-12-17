class CreateMoves < ActiveRecord::Migration
  def self.up
    create_table :moves do |t|
      t.belongs_to :state, :null => false
      t.integer :x_favorability, :o_favorability
    end
  end

  def self.down
    drop_table :moves
  end
end
