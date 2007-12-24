class AddComputerToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :computer, :string, :default => 'O'
  end

  def self.down
    remove_column :games, :computer
  end
end
