class Mushrooms
	def initialize(colliders_name)
		@colliders_name = colliders_name
		@width = 32
		@height = 32
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
				@all_mushrooms.push ({shroom_image: Gosu::Image.new("red_mushroom1.png"), centre_x: centre_x, centre_y: centre_y})
			end
		end
	end

	def collision_checker(player_x, player_y)
		@player_x = player_x
		@player_y = player_y
		@all_mushrooms.reject! {|shroom| Gosu.distance(@player_x,@player_y,shroom[:centre_x],shroom[:centre_y]) < 16}
	end

	def draw
		@all_mushrooms.each do |mushroom|
			mushroom[:shroom_image].draw(mushroom[:centre_x] - @width/2, mushroom[:centre_y] - @height/2, 20)
		end
	end

	
end