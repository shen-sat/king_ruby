class Chest

	def initialize(colliders_name)
		@closed_chest_image = Gosu::Image.new("chest_closed_trans.png", :tileable => true)
		@open_chest_image = Gosu::Image.new("chest_open_trans.png", :tileable => true)
		@win_text = Gosu::Image.from_text("You win!", 16, {})
		@width = 16
		@height = 14
		@colliders_name = colliders_name
		file = File.read("map.json")
		data_hash = JSON.parse(file)
		data_hash["layers"].each do |x|
			if x["name"] == "#{@colliders_name}"
				@chest_data_from_tiled =  x["objects"]
			end
		end
		@all_chests = []
		@chest_data_from_tiled.each do |data|
			centre_x = data["x"] + (data["width"]/2)
			centre_y = data["y"] + (data["height"]/2)
			@all_chests.push ({chest_image: @closed_chest_image, centre_x: centre_x, centre_y: centre_y, closed: true})
		end
		@win = false
	end

	def collision_checker(player_x, player_y)
		@player_x = player_x
		@player_y = player_y
		@all_chests.each do |chest| 
			if Gosu.distance(@player_x,@player_y,chest[:centre_x],chest[:centre_y]) < 17
				chest[:chest_image] = @open_chest_image
				@win = true
			end
		end
	end

	def draw
		@all_chests.each do |chest|
			if @player_y > chest[:centre_y]
				chest_depth = 1
			else
				chest_depth = 10
			end 
			chest[:chest_image].draw(chest[:centre_x] - @width/2, chest[:centre_y] - @height/2, chest_depth)
		end
		if @win
			@win_text.draw(96, 176, 51)
		end
	end


	
end