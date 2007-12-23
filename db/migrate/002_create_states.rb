class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string  :reference_board, :default => '---------'
      t.integer :favorability, :default => 0
    end
    
    add_index :states, :reference_board, :unique => true
    
    create_table :state_relationships, :id => false do |t|
      t.integer :state_id, :child_id
    end

    State.create()  # creating the empty board state
  end

  def self.down
    drop_table :state_relationships
    remove_index :states, :reference_board
    drop_table :states
  end
end
