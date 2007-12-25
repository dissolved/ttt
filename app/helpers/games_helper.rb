module GamesHelper
  
  def generate_squares(game)
    (0...9).collect do |n|
      if @game[n].nil?
        if @game.finished?
          cell = image_tag('blank.gif')
        else
          cell = link_to_remote( image_tag('blank.gif'), :url => game_path(game, :move => n), :method => :put)
        end
      else
        cell = @game[n]
      end
      content_tag( :div, cell, :class => 'square', :id => "s#{n}")
    end.join("\n  ")
  end  
end

