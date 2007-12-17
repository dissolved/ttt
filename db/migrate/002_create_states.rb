class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string :value
    end
    
    add_index :states, :value
    State.create(:value => '         ') #root of the tree
  end

  def self.down
    remove_index :states, :value
    drop_table :states
  end
end
