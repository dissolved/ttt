class State < ActiveRecord::Base
  has_many :games
  has_and_belongs_to_many :states, 
                          :class_name => 'State', 
                          :join_table => 'state_relationships',
                          :foreign_key => "state_id",
                          :association_foreign_key => 'child_id'
  composed_of :board, :mapping => %w(board board)
  
  def self.root
    self.find_by_board('---------')
  end

end


class Board
  
  # create a new Board object from the encoded string representation (empty board if no parameter given)
  def initialize(encoded_board = '---------', variation = 0)
    @board = encoded_board.scan(/./).collect {|c| c == '-' ? nil : c}
  end
  
  
  # returns the board in the encoded string representation
  def board
    @board.collect { |c| c == nil ? '-' : c }.to_s
  end
  
  
  # returns an array of legal moves
  def moves
    (0...9).collect { |i| @board[i].nil? ? i : nil }.compact
  end
  
  
  # returns an array of board rows
  def rows
    [0,3,6].collect { |i| @board.slice(i,3) }
  end
  
  
  # returns an array of board columns
  def cols
    (0...3).collect { |i| [ @board[i], @board[i+3], @board[i+6] ]}
  end
  
  
  # returns an array of board diagonals
  def diags
    [  [ @board[0], @board[4], @board[8] ],
       [ @board[2], @board[4], @board[6] ]  ]
  end
  
  
  # returns the turn number (starting from zero)
  def turn
    @board.compact.size
  end


  # returns a non-false (either true or the winner) result when the game is finished.
  def finished?
    winner || turn == 9
  end


  # checks the entire board for a winner, returning the winner if there is one, otherwise returns nil
  def winner
    (rows + cols + diags).inject(nil) { |winner, line| winner || find_winner(line) }
  end
  
  
  # returns a new Board rotated clockwise 90 degrees
  def rotate
    copy = Board.new(self.board)
    copy[0] = @board[6]
    copy[1] = @board[3]
    copy[2] = @board[0]
    copy[3] = @board[7]  
    copy[5] = @board[1]
    copy[6] = @board[8]
    copy[7] = @board[5]
    copy[8] = @board[2]
    copy
  end
  
  
  # returns a new Board that is a mirror image
  def mirror
    copy = Board.new(self.board)
    copy[0] = @board[2]
    copy[2] = @board[0]
    copy[3] = @board[5]  
    copy[5] = @board[3]
    copy[6] = @board[8]
    copy[8] = @board[6]
    copy
  end
  
  
  protected
  
  # checks the given line for a winner, returning the winner if there is one, otherwise returns nil
  def find_winner(line)
    line.inject { |player, cell| cell == player ? player : nil}
  end
  
  
  # useful in manipulating the underlying array for copied boards
  def []=(index, value)
    @board[index] = value
  end
end

#  
#    def after_create
#      self.update_favorability
#    end
#
#    def moves
#      successor_states = self.children
#    
#      if successor_states.empty? &&  !finished?
#        board.each_with_index do |mark, i|
#          if mark.nil?
#            child = board.clone
#            child[i] = turn_player
#            self.children.create(:board  => child, :move => i)
#          end
#        end
#      end
#    
#      successor_states.collect{ |state| state.move }
#    end
#  
#    def make_move(cell)
#      logger.info("CALLING make_move(#{cell})")
#      new_state = children.find_by_move(cell) if moves.include?(cell)
#      new_state.update_favorability if new_state.finished?
#      new_state
#    end
#  
#  
#    def favorability=(newVal)
#      newVal = 10000 if newVal > 10000
#      write_attribute('favorability', newVal)
#    end
#  
#  
#    def turn_player(the_turn = self.turn)
#      (the_turn % 2 == 0) ? 'X' : 'O'
#    end
#    
#    protected
#  
#    def update_favorability
#      player = winner
#      if player
#        self.update_attribute(:favorability, self.favorability + 1000)
#        self.ancestors.each do |ancestor|
#          equivalents = State.find_all_by_board(ancestor.read_attribute('board'))
#          equivalents.each do |old_state|
#            logger.info("UPDATING UP FAVORABILITY... for state=#{old_state.id}")
#            bias = (old_state.turn_player == player) ? -1 : 1
#            old_state.update_attribute(:favorability, old_state.favorability + bias * old_state.turn * old_state.turn)
#          end
#        end
#      else
#        if turn == 9
#        
#        end
#      end
#    end
#
