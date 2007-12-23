class Game < ActiveRecord::Base
  composed_of :board, :mapping => %w(board board)
    
  def move(cell)
    make_move(cell)
  end
  
  def computer_move
    state, translation = State.find_from_equivalent(board)
    returning(translation[state.children.first.reference_board.detect_move(state.reference_board)]) { |cell| make_move(cell) }
  end
  
  def finished?
    board.finished?
  end
  
  protected
  
  def make_move(cell)
    self.board = board.move(cell.to_i)
    self.history = history + cell
    save
    
    learn if finished?
  end
  
  
  
  def learn
    return unless board.winner
    favorability = 1000
    the_board = board.dup
    history.split(//).reverse.each do | move |
      state = State.find_from_equivalent(the_board).first
      state.adjust_favorability(favorability)
      favorability = favorability / -2
      the_board = the_board.undo(move.to_i)
    end
  end
end
