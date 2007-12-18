class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.integer :parent_id, :move
      t.string  :board
      t.integer :favorability, :default => 0
    end
    
    add_index :states, :board
    State.create(:board => Array.new(9,nil))
  end

  def self.down
    remove_index :states, :board
    drop_table :states
  end
end
