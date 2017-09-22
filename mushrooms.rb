class Mushrooms
	def initialize(colliders_name)
		@colliders_name = colliders_name
		file = File.read("map.json")
		data_hash = JSON.parse(file)
		data_hash["layers"].each do |x|
			if x["name"] == "#{@colliders_name}"
				@mages_data_from_tiled =  x["objects"]
			end
		end
		@red_mushroom_image = Gosu::Image.new("kratos.png")
	end


end