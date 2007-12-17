module GamesHelper
  
  def generate_squares
    (0...9).collect do |n|
      content_tag( :div, 
                   link_to_function( image_tag('blank.gif'), "theGame.humanMove(#{n})"),
                   #link_to_function( image_tag('blank.gif'), click_square("s#{n}")),
                   :class => 'square', :id => "s#{n}")
    end.join("\n  ")
  end
  
  def click_square(id)
    update_page do |page|
      page[id].replace_html 'X'
      page[id].visual_effect :highlight
    end
  end
  
end

