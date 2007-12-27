class Game < ActiveRecord::Base
  composed_of :board, :mapping => %w(board board)
  
  # If the computer is playing 'X', make the first move immediately after creating the game
  def after_create
    computer_move if computer == "X"
  end
    
    
  def human_move(cell)
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
  
  
  # This is where the computer "learns" how to play better.  The general idea is to reward moves that lead
  # a win or a draw, and penalize moves that lead to a loss.  The weights were more or less chosen arbitrarily,
  # and I'm certain with more time or research, a better system could be used here.
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
