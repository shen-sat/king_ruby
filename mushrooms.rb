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
				@all_mushrooms.push ({shroom_image: Gosu::Image.new("red_mushroom.png"), draw_x: centre_x - @width/2, draw_y: centre_y - @height/2})
			end
		end
	puts @all_mushrooms
	end

	def draw
		@all_mushrooms.each do |mushroom|
			mushroom[:shroom_image].draw(mushroom[:draw_x], mushroom[:draw_y], 20)
		end
	end

	
end