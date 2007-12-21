class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string  :board
      t.integer :favorability, :default => 0
    end
    
    add_index :states, :board
    #State.create(:board => Array.new(9,nil))  # creating the empty board state
    
    create_table :state_relationships, :id => false do |t|
      t.integer :state_id, :child_id
    end
  end

  def self.down
    drop_table :state_relationships
    remove_index :states, :board
    drop_table :states
  end
end
