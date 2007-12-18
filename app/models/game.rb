class Game < ActiveRecord::Base
  belongs_to :state
  
  def before_create
    self.state = State.root
  end
end
