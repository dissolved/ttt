class AddColumnsToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :computer, :string, :default => 'X'
    add_column :games, :cookie, :string
  end

  def self.down
    remove_column :games, :cookie
    remove_column :games, :computer
  end
end
