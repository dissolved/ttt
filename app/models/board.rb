class Board < Array
  
  # create a new Board object from the encoded string representation (empty board if no parameter given)
  def initialize(encoded_board = '---------')
    super encoded_board.scan(/./).collect {|c| c == '-' ? nil : c}
  end
  
  
  # returns the board in the encoded string representation
  def board
    collect { |c| c == nil ? '-' : c }.to_s
  end
  
  
  # returns an array of legal moves
  def moves
    (0...9).collect { |i| at(i).nil? ? i : nil }.compact
  end
  
  
  # returns a new board after making the specified move
  def move(pos)
    returning(dup) { |after| after[pos] = current_player }
  end


  # returns a new board as it existed before the given move was made
  def undo(pos)
    returning(dup) { |previous| previous[pos] = nil }
  end
  
  
  # returns an array of board rows
  def rows
    [0,3,6].collect { |i| slice(i,3) }
  end
  
  
  # returns an array of board columns
  def cols
    (0...3).collect { |i| [ at(i), at(i+3), at(i+6) ]}
  end
  
  
  # returns an array of board diagonals
  def diags
    [  [ at(0), at(4), at(8) ],
       [ at(2), at(4), at(6) ]  ]
  end
  
  
  # returns the turn number (starting from zero)
  def turn
    compact.size
  end


  # returns the player who's turn it is to play the next move
  def current_player
    (turn % 2 == 0) ? 'X' : 'O'
  end


  # returns a non-false (either true or the winner) result when the game is finished.
  def finished?
    winner || turn == 9
  end


  # checks the entire board for a winner, returning the winner if there is one, otherwise returns nil
  def winner
    (rows + cols + diags).inject(nil) { |winner, line| winner || find_winner(line) }
  end
  
  
  # returns an array of Boards that are unique successor boards to itself
  def unique_children
    return [] if finished?
    children, exclusions = [], []
    moves.each do |pos|
      child = move(pos)
      children << child unless exclusions.include?(child)
      exclusions.concat(child.equivalents)
    end
    children
  end


  # returns an array of Boards that are equivalent to itself
  def equivalents
    boards = [] << self << self.mirror
    3.times do
      boards << boards[-2].rotate
      boards << boards[-1].mirror
    end
    
    boards.uniq
  end
  
  
  # returns an array that can be used to map values from this board to those of the other board passed as a parameter
  def translation(other)
    mapping = translate_rotations(other)
    if mapping.nil?
      mapping = translate_rotations(other, true)
    end
    mapping.to_a
  end
  
  def translate_rotations(other, mirrored = false)
    mapping, copy = Board.new('012345678'), other.dup
    mapping, copy = mapping.mirror, copy.mirror if mirrored
    
    begin
      copy = copy.rotate
      mapping = mapping.rotate
    end until self == copy || other == copy

    self == copy ? mapping : nil
  end
  
  
  # returns the first cell that is different from the board being passed as a parameter
  def detect_move(other)
    each_index do |index|
      return index if at(index) != other[index]
    end
  end

 # protected
  
  # returns a new Board rotated clockwise 90 degrees
  def rotate
    copy = dup
    copy[0] = self[6]
    copy[1] = self[3]
    copy[2] = self[0]
    copy[3] = self[7]  
    copy[5] = self[1]
    copy[6] = self[8]
    copy[7] = self[5]
    copy[8] = self[2]
    copy
  end
  
  
  # returns a new Board that is a mirror image
  def mirror
    copy = dup
    copy[0] = self[2]
    copy[2] = self[0]
    copy[3] = self[5]  
    copy[5] = self[3]
    copy[6] = self[8]
    copy[8] = self[6]
    copy
  end
    
  
  # checks the given line for a winner, returning the winner if there is one, otherwise returns nil
  def find_winner(line)
    line.inject { |player, cell| cell == player ? player : nil}
  end
  
end
