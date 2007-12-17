class State < ActiveRecord::Base
  
  has_many :moves
  
  def self.root
    self.find_by_value('         ')
  end
  
  def after_create
    
  end
  
  def finished?
    winner || @turn == 9
  end
  
  def board
    @board ||= extract_board
  end
  
  def extract_board
    @board = self.value.scan(/./).collect {|c| c == ' ' ? nil : c}
    @turn = @board.compact.size
  end
end
