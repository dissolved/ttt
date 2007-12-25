class Game < ActiveRecord::Base
  composed_of :board, :mapping => %w(board board)
  
  def after_create
    computer_move if computer == "X"
  end
    
  def move(cell)
    make_move(cell)
  end
  
  def computer_move
    state, translation = State.find_from_equivalent(board)
    returning(translation[state.favorite_child_board.detect_move(state.reference_board)]) { |cell| make_move(cell) }
  end
  
  def finished?
    board.finished?
  end
  
  def [](index)
    board[index.to_i]
  end
  
  protected
  
  def make_move(cell)
    self.board = board.move(cell.to_i)
    self.history = history + cell
    save
    
    learn if finished?
  end
  
  
  
  def learn
    if board.winner
      favorability = 100
      decay = -2
    else
      favorability = 1
      decay = 1
    end
    the_board = board.dup
    history.split(//).reverse.each do | move |
      state = State.find_from_equivalent(the_board).first
      state.adjust_favorability(favorability)
      favorability = favorability / decay
      the_board = the_board.undo(move.to_i)
    end
  end
end
