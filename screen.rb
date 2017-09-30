class Screen
	def initialize
		@screen = Gosu::Image.new("map.png", :tileable => true)
		@tree = Gosu::Image.new("tree.png", :tileable => true)
	end

	def draw(player_y, game_over_red, game_over_blue)
		@player_y = player_y
		@game_over_red = game_over_red
		@game_over_blue = game_over_blue
		puts "blue #{@game_over_blue}"
		puts "red #{@game_over_red}"
		@screen.draw(0,0,1)
		if @player_y > 50
    		@tree_depth = 3
  		else
    		@tree_depth = 30
  		end
  		@tree.draw(112,0,@tree_depth)
	end
end