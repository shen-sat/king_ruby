class Mushrooms
	def initialize(colliders_name)
		@colliders_name = colliders_name
		@red_mushroom_image = Gosu::Image.new("red_mushroom.png")
		@red_mushroom_image_width = 32
		@red_mushroom_image_height = 32
		file = File.read("map.json")
		data_hash = JSON.parse(file)
		data_hash["layers"].each do |x|
			if x["name"] == "#{@colliders_name}"
				@shroom_data_from_tiled =  x["objects"]
			end
		end
		@shroom_data_from_tiled.each do |data|
			centre_x = data["x"] + (data["width"]/2)
			centre_y = data["y"] + (data["height"]/2)
			if data["name"] == "red"
				@red_mushroom_image_centre_x = centre_x
				@red_mushroom_image_centre_y = centre_y
			end
		end
	end

	def draw
		@red_mushroom_image.draw(@red_mushroom_image_centre_x - @red_mushroom_image_width/2, @red_mushroom_image_centre_y - @red_mushroom_image_height/2, 20)
	end
end