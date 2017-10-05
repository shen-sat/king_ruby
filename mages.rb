class Mages
	def initialize(colliders_name)
		@colliders_name = colliders_name
		file = File.read("map.json")
		data_hash = JSON.parse(file)
		data_hash["layers"].each do |x|
			if x["name"] == "#{@colliders_name}"
				@mages_data_from_tiled =  x["objects"]
			end
		end
		@mage_head_image = Gosu::Image.new("mage_head.png", :tileable => true)
	end
	def collision_checker(player_x, player_y)
		@player_x = player_x
		@player_y = player_y
		@mage_collision = false
		@mages_data_from_tiled.each do |data|
			centre_x = data["x"] + (data["width"]/2)
			centre_y = data["y"] + (data["height"]/2)
			if Gosu.distance(@player_x,@player_y,centre_x,centre_y) < 10
				@mage_collision = true
				if data["name"] == "mage_1"
					@mage_text = Gosu::Image.from_text("The shrooms here taste great." + "\n" + "They also contain anti-venom.", 16, {})
				elsif data["name"] == "mage_2"
					@mage_text = Gosu::Image.from_text("Blue shrooms only grow" + "\n" + "behind trees.", 16, {})
				elsif data["name"] == "mage_3"
					@mage_text = Gosu::Image.from_text("The prophecy tells of king who can" + "\n" + "complete levels by opening chests.", 16, {})
				end
			end
		end
	end
	def draw
		if @mage_collision == true
			@mage_head_image.draw(16,176,10)
			@mage_text.draw(96, 176, 10)
		end
	end
end