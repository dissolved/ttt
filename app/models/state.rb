class State < ActiveRecord::Base
  has_and_belongs_to_many :children, 
                          :class_name => 'State', 
                          :join_table => 'state_relationships',
                          :foreign_key => "state_id",
                          :association_foreign_key => 'child_id',
                          :order => "favorability DESC"
  composed_of :reference_board, :class_name => 'Board', :mapping => %w(reference_board board)
    
  def after_create
    self.reference_board.unique_children.each do |board|
      state = State.find_by_reference_board(board.board)
      if state.nil?
        state = State.create(:reference_board => board)
      end
      self.children << state
    end
  end
  
  def self.find_from_equivalent(board)
    ref = board.equivalents.detect { |equivalent| find_by_reference_board(equivalent.board) }
    return find_by_reference_board(ref.board), ref.translation(board)
  end
  
  
  def favorite_child_board
    children.first.reference_board
  end
  
  def adjust_favorability(value)
    new_value = favorability + value
    if new_value.abs <= 10000
      update_attribute(:favorability, new_value)
    end
  end
end