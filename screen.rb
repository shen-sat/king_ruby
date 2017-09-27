
class Screen
	def initialize
		@background_image = Gosu::Image.new("map.png", :tileable => true)
		@tree_image = Gosu::Image.new("tree.png", :tileable => true)
	end

	def draw(player_y, game_state)
		@player_y = player_y
		#@background_image.draw(0,0)
  		if @player_y > 50
    		@tree_depth = 3
  		else
    		@tree_depth = 30
  		end		
		@tree_image.draw(112,0,@tree_depth)
		@background_image.draw(0,0,1)
	end


end