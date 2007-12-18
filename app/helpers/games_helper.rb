module GamesHelper
  
  def generate_squares(game)
    (0...9).collect do |n|
      content_tag( :div, 
                   link_to_remote( image_tag('blank.gif'), 
                   :url => game_path(game, :move => n), :method => :put),
                   :class => 'square', :id => "s#{n}")
    end.join("\n  ")
  end  
end

