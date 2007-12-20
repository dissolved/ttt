class State < ActiveRecord::Base
  has_many :games
  acts_as_tree :order => "favorability DESC"
  
  def after_create
    self.update_favorability
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
    logger.info("CALLING make_move(#{cell})")
    new_state = children.find_by_move(cell) if moves.include?(cell)
    new_state.update_favorability if new_state.finished?
    new_state
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
  
  def update_favorability
    player = winner
    if player
      self.update_attribute(:favorability, self.favorability + 1000)
      self.ancestors.each do |ancestor|
        equivalents = State.find_all_by_board(ancestor.read_attribute('board'))
        equivalents.each do |old_state|
          logger.info("UPDATING UP FAVORABILITY... for state=#{old_state.id}")
          bias = (old_state.turn_player == player) ? -1 : 1
          old_state.update_attribute(:favorability, old_state.favorability + bias * old_state.turn * old_state.turn)
        end
      end
    else
      if turn == 9
        
      end
    end
  end
  
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
