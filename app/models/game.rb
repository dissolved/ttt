class Game < ActiveRecord::Base
  belongs_to :state
  
  def before_create
    self.state = State.root
  end
  
  def move(cell)
    new_state = self.state.make_move(cell.to_i)
    update_attribute(:state, new_state)
  end
  
  def computer_move
    new_state = self.state.make_move(self.state.moves.first)
    update_attribute(:state, new_state)
    new_state.move
  end
  
  def finished?
    self.state.board.finished?
  end
  
end
