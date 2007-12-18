class State < ActiveRecord::Base
  acts_as_tree :order => "favorability DESC"
  
  def before_create
    # initial favorability ratings based on final outcome
    player = winner
    if player
      self.favorability = self.favorability + 50
      self.ancestors.each do |state|
        bias = state.turn_player == player ? 1 : -1
        state.update_attribute(:favorability, state.favorability + bias * state.turn)
      end
    end
  end

  def self.root
    self.find_by_board('         ')
  end
  
  def moves
    successor_states = self.children
    
    if successor_states.empty? &&  !finished?
      board.each_with_index do |mark, i|
        if mark.nil?
          child = board.clone
          child[i] = turn_player
          self.children.create(:board  => child, :move => i)
        end
      end
    end
    
    successor_states.collect{ |state| state.move }
  end
  
  def make_move(cell)
    raise RecordNotFound, "Invalid State Transition" unless moves.include?(cell)
    return children.find_by_move(cell)
  end
  
  def finished?
    winner || turn == 9
  end
  
  def winner
    diagonal_win || row_win || col_win
  end
  
  def board
    @board ||= read_attribute('board').scan(/./).collect {|c| c == ' ' ? nil : c}
  end
  
  def board=(newVal)
    @board = newVal
    write_attribute('board',encode_board(newVal))
  end
  
  def favorability=(newVal)
    newVal = 10000 if newVal > 10000
    write_attribute('favorability', newVal)
  end
  
  def turn
    board.compact.size
  end
  
  def turn_player(the_turn = self.turn)
    (the_turn % 2 == 0) ? 'X' : 'O'
  end
    
  protected
  
  def encode_board(newVal)
    newVal.collect { |c| c == nil ? ' ' : c }.to_s
  end

  def diagonal_win
    find_winner([0,4,8]) || find_winner([2,4,6])
  end
  
  def row_win
    result = nil
    0.upto(2){ |i| result ||= find_winner [i*3, i*3 + 1, i*3 + 2] }
    result
  end
  
  def col_win
    result = nil
    0.upto(2){ |i| result ||= find_winner [i, i+3, i+6] }
    result
  end
  
  def find_winner(indicies)
    indicies.inject(board[indicies[0]]) { |player, i| board[i] == player ? player : nil}
  end
  
end