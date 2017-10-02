class Chest

	def initialize(colliders_name)
		@chest_image = Gosu::Image.new("chest_closed_trans.png", :tileable => true)
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
			@all_chests.push ({chest_image: @chest_image, centre_x: centre_x, centre_y: centre_y, closed: true})
		end
		puts @all_chests
	end

	def collision_checker(player_x, player_y)
		@player_x = player_x
		@player_y = player_y
		@all_chests.each do |chest| 
			if Gosu.distance(@player_x,@player_y,chest[:centre_x],chest[:centre_y]) < 6
				chest[:closed] = false
				puts "chest opened"
			end
		end
	end

	def draw
		@all_chests.each do |chest|
			chest[:chest_image].draw(chest[:centre_x] - @width/2, chest[:centre_y] - @height/2, 2)
		end
	end


	
end