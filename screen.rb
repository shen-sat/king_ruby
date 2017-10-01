class Screen
	def initialize
		@map_screen = Gosu::Image.new("map.png", :tileable => true)
		@game_over_screen = Gosu::Image.new("game_over.png", :tileable => true)
		@tree = Gosu::Image.new("tree.png", :tileable => true)
		@game_over_red_text = Gosu::Image.from_text("You were killed by a RED snake." + "\n" + "Press enter to restart.", 16, {})
		@game_over_blue_text = Gosu::Image.from_text("You were killed by a BLUE snake." + "\n" + "Press enter to restart.", 16, {})
	end

	def draw(player_y, game_over_red, game_over_blue)
		@player_y = player_y
		@game_over_red = game_over_red
		@game_over_blue = game_over_blue
		
		if @player_y > 50
    		@tree_depth = 3
  		else
    		@tree_depth = 30
  		end
  		@tree.draw(112,0,@tree_depth)
  		if @game_over_red
  			@game_over_screen.draw(0,0,50)
  			@game_over_red_text.draw(96, 176, 51)
  		elsif @game_over_blue
  			@game_over_screen.draw(0,0,50)
  			@game_over_blue_text.draw(96, 176, 51)
  		else
  			@map_screen.draw(0,0,1)
  		end
	end
end