class Colliders
	attr_reader :top_collision
	attr_reader :bottom_collision
	attr_reader :left_collision
	attr_reader :right_collision

	def initialize(collider_name)
		@collider_name = collider_name
	end

	def calculate_lines
	#----colllider code begins----
	#loads the json map file exported from Tiled
	file = File.read("map.json")
	data_hash = JSON.parse(file)
	#locates the array named "objects" within the json file and assigns it. "objects" in the json file contains the coordinates for each collider
	data_hash["layers"].each do |x|
		if x["name"] == "#{@collider_name}"
			@data_from_tiled =  x["objects"]
		end
	end
	#the coordinates for each collider within the json file are relative and not actual. We'll need to adjust them using the origin of each collider
	
	#first we set up an array to collect the colliders once we've adjusted them
	@colliders = []
	#this is a temp storage for each collider. We'll use it later to pass each coller seperately to @colliders
	@temp_collider_storage = []
	#then we go into the data from teh json file and retrieve and assign the origin of each collider 
	@data_from_tiled.each do |data|
		polyline_x_origin = data["x"]
		polyline_y_origin = data["y"]
		#then we take every coordinate within each collider and adjust it relative to the collider's origin
		data["polyline"].each do |polyline_point|
			adjusted_polyline_x = polyline_point["x"] + polyline_x_origin
			adjusted_polyline_y = polyline_point["y"] + polyline_y_origin 
			#then we pass the adjusted coordinates of each collider to the temp storage array
			@temp_collider_storage.push ({x: adjusted_polyline_x, y: adjusted_polyline_y})
		end
		#then we pass the adjusted coordinates to @colliders. Doing it like this ensures that the colliders are passed one at a time, as seperate objects
		@colliders.push @temp_collider_storage
		#this resets the temp storage array so it can be used to collect the next collider's adjusted coordinates
		@temp_collider_storage = []
	end
	
	#next, we set up an array to collect the coordinates of each line that makes up wevery collider. 
	#Each line (like any line) will have two coordinates. The end coordinate of one line will be the starting coordinate of the next line in the collider
	@lines = []
	#then we take each collider...
	@colliders.each do |collider|
		#...and access each of its coordinates, along with each coordinate's array index (its numercal location in the array)
		collider.each_with_index do |coordinate, i|  
			#if the coordinate doesn't have a following coordinate, nothing happens. 
			#Otherwise the coordinate is pushed with its ajacent coordinate into @lines (each pair of coordinates now represents a line in its collider)
			if collider[i + 1].nil?
				0
			else
				next_coordinate = collider[i+1]
				@lines.push [coordinate, next_coordinate]
			end
		end
	end
	#Now we want to work out the 'range' of each line so we can find out if the player will bump into it
	#Fisrt set up an array to collect the ranges for each line
	@line_ranges = []
	#Then for each line we extract the two x values and sort them from low to high. Same with y values. Then push to @ines_ranges.
	@lines.each do |line|
		x_values_sorted = [line[0][:x], line[1][:x]].sort!
		y_values_sorted = [line[0][:y], line[1][:y]].sort!
		@line_ranges.push ({x_range: x_values_sorted, y_range: y_values_sorted})
	end
	#@lines_ranges can now be passed to whatever character needs to know environmental colliders
	#----collider code ends----
	@line_ranges
	end
	
	def top_collision_check(x, y, speed, gap_between_player_bottom_and_top_collider)
		@x = x
		@y = y
		@speed = speed
		@gap_between_player_bottom_and_top_collider = gap_between_player_bottom_and_top_collider
		player_bottom = @y + 12
		player_right = @x + 6
		player_left = @x - 6
		#at the start of every check, we assume there is no collision
		@top_collision = false
		#Then we look to see if we are within the x values in all the lines (colliders) we have. 
		@line_ranges.each do |range|
			x_left = range[:x_range][0]
			x_right = range[:x_range][1]
			y_top = range[:y_range][0]
			#if we are within x range, then check to see we are below the line (as that's the only way we can top collide with it)
			# I've used '&& x_left != x_right' to exclude vertical lines
			if (player_left >= x_left) && (player_left <= x_right) && player_bottom > y_top && x_left != x_right
				if Gosu.distance(@x,player_bottom - @speed,@x,y_top) <= @gap_between_player_bottom_and_top_collider	
					@top_collision = true
				end
			end
			if (player_right >= x_left) && (player_right <= x_right) && player_bottom > y_top && x_left != x_right
				if Gosu.distance(@x,player_bottom - @speed,@x,y_top) <= @gap_between_player_bottom_and_top_collider	
					@top_collision = true
				end
			end 
		end
		@top_collision
	end

	def bottom_collision_check(x, y, speed, gap_between_player_top_and_bottom_collider)
		@x = x
		@y = y
		@speed = speed
		@gap_between_player_top_and_bottom_collider = gap_between_player_top_and_bottom_collider
		player_top = @y + 4
		player_right = @x + 6
		player_left = @x - 6
		@bottom_collision = false 
		@line_ranges.each do |range|
			x_left = range[:x_range][0]
			x_right = range[:x_range][1]
			y_bottom = range[:y_range][0]
			if (player_left >= x_left) && (player_left <= x_right) && player_top < y_bottom && x_left != x_right
				if Gosu.distance(@x,player_top + @speed,@x,y_bottom) <= @gap_between_player_top_and_bottom_collider
					@bottom_collision = true
				end
			end
			if (player_right >= x_left) && (player_right <= x_right) && player_top < y_bottom && x_left != x_right
				if Gosu.distance(@x,player_top + @speed,@x,y_bottom) <= @gap_between_player_top_and_bottom_collider
					@bottom_collision = true
				end
			end 

		end

	end

	def left_collision_check(x, y, speed, gap_between_player_right_and_left_collider)
		@x = x
		@y = y
		@speed = speed
		@gap_between_player_right_and_left_collider = gap_between_player_right_and_left_collider
		player_top = @y + 4
		player_bottom = @y + 12
		player_right = @x + 6
		player_left = @x - 6
		@left_collision = false 
		@line_ranges.each do |range|
			y_top = range[:y_range][0]
			y_bottom = range[:y_range][1]
			x_left = range[:x_range][0]
			if (player_top >= y_top) && (player_top <= y_bottom) && @x > x_left && y_top != y_bottom
				if Gosu.distance(player_right - @speed,@y,x_left,@y) <= @gap_between_player_right_and_left_collider
					@left_collision = true
				end
			end
			if (player_bottom >= y_top) && (player_bottom <= y_bottom) && @x > x_left && y_top != y_bottom
				if Gosu.distance(player_right - @speed,@y,x_left,@y) <= @gap_between_player_right_and_left_collider
					@left_collision = true
				end
			end 
		end
	end

	def right_collision_check(x, y, speed, gap_between_player_left_and_right_collider)
		@x = x
		@y = y
		@speed = speed
		@gap_between_player_left_and_right_collider = gap_between_player_left_and_right_collider
		player_top = @y + 4
		player_bottom = @y + 12
		player_left = @x - 6
		@right_collision = false 
		@line_ranges.each do |range|
			y_top = range[:y_range][0]
			y_bottom = range[:y_range][1]
			x_right = range[:x_range][1]
			if (player_top >= y_top) && (player_top <= y_bottom) && @x < x_right && y_top != y_bottom
				if Gosu.distance(player_left + @speed,@y,x_right,@y) <= @gap_between_player_left_and_right_collider
					@right_collision = true
				end
			end
			if (player_bottom >= y_top) && (player_bottom <= y_bottom) && @x < x_right && y_top != y_bottom
				if Gosu.distance(player_left + @speed,@y,x_right,@y) <= @gap_between_player_left_and_right_collider
					@right_collision = true
				end
			end
		end

	end

end