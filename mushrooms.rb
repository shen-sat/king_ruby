class Mushrooms
	attr_reader :eaten_shroom_blue
	attr_reader :eaten_shroom_red

	def initialize(colliders_name)
		@eaten_shroom_blue = false
		@eaten_shroom_red = false
		@blue_shroom_image = Gosu::Image.new("images/blue_mushrooom_big.png", :tileable => true)
  		@red_shroom_image = Gosu::Image.new("images/red_mushroom2_big.png", :tileable => true)
		@colliders_name = colliders_name
		@width = 16
		@height = 16
		file = File.read("map.json")
		data_hash = JSON.parse(file)
		data_hash["layers"].each do |x|
			if x["name"] == "#{@colliders_name}"
				@shroom_data_from_tiled =  x["objects"]
			end
		end
		@all_mushrooms = []
		@shroom_data_from_tiled.each do |data|
			centre_x = data["x"] + (data["width"]/2)
			centre_y = data["y"] + (data["height"]/2)
			if data["name"] == "red"
				@all_mushrooms.push ({shroom_type: "red", shroom_image: Gosu::Image.new("images/red_mushroom2.png"), centre_x: centre_x, centre_y: centre_y})
			end
			if data["name"] == "blue"
				@all_mushrooms.push ({shroom_type: "blue", shroom_image: Gosu::Image.new("images/blue_mushrooom.png"), centre_x: centre_x, centre_y: centre_y})
			end
		end
	end

	def collision_checker(player_x, player_y)
		@player_x = player_x
		@player_y = player_y
		@all_mushrooms.each do |shroom| 
			if Gosu.distance(@player_x,@player_y,shroom[:centre_x],shroom[:centre_y]) < 16
				@all_mushrooms.delete(shroom)
				if shroom[:shroom_type] == "red"
					@eaten_shroom_red = true
				end
				if shroom[:shroom_type] == "blue"
					@eaten_shroom_blue = true
				end
			end
		end
	end

	def draw
		@all_mushrooms.each do |mushroom|
			mushroom[:shroom_image].draw(mushroom[:centre_x] - @width/2, mushroom[:centre_y] - @height/2, 2)
		end
		if @eaten_shroom_red
			@red_shroom_image.draw(320, 176, 1)
		end
		if @eaten_shroom_blue
			@blue_shroom_image.draw(320, 208, 1)
		end
	end

end