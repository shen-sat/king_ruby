class Player
	attr_reader :x
	attr_reader :y

	def initialize(colliders_name)
		@idle_anim = Gosu::Image.new("king_dummy_v4.png", :tileable => true)
		@right_walk_anim = Gosu::Image.load_tiles("king_walk_right.png", 32, 32)
		@left_walk_anim = Gosu::Image.load_tiles("king_walk_left.png", 32, 32)
		
		@right_flag = true
		@image = @idle_anim
		@width = 32
		@height = 32
		@speed = 1
		@counter = 1
		@gap_between_player_bottom_and_top_collider = 16
		@gap_between_player_top_and_bottom_collider = 16
		@gap_between_player_right_and_left_collider = 16
		@gap_between_player_left_and_right_collider = 16
		@colliders_name = colliders_name
		@player_colliders = Colliders.new("#{@colliders_name}")
		@line_ranges = @player_colliders.calculate_lines
	end
	
	def warp(x,y)
		@x = x + @width/2
		@y = y + @height/2
		
	end

	

	def bottom_collision_check
		player_top = @y
		player_right = @x + 8
		player_left = @x - 8
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
=begin
			if ((player_left || player_right) >= x_left) && ((player_left || player_right) <= x_right) && player_top < y_bottom && x_left != x_right
				if Gosu.distance(@x,player_top + @speed,@x,y_bottom) <= @gap_between_player_top_and_bottom_collider
					@bottom_collision = true
					puts player_left
					puts x_right
				end
			end
=end
		end

	end

	def left_collision_check
		player_top = @y
		player_bottom = @y + 16
		player_right = @x + 8
		player_left = @x - 8
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
=begin
			if ((player_bottom || player_top) >= y_top) && ((player_bottom || player_top) <= y_bottom) && @x > x_left && y_top != y_bottom
				puts "selected range: #{range}"
				#puts "player top: #{player_top}"
				#puts "top of line is #{y_top}"
				#puts "bottom of line is #{y_bottom}"
				if Gosu.distance(player_right - @speed,@y,x_left,@y) <= @gap_between_player_right_and_left_collider
					@left_collision = true
				end
=end
			#end
		end
	end

	def right_collision_check
		player_top = @y
		player_bottom = @y + 16
		player_left = @x - 8
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
=begin
			if ((player_bottom || player_top) >= y_top) && ((player_bottom || player_top) <= y_bottom) && @x < x_right && y_top != y_bottom
				if Gosu.distance(player_left + @speed,@y,x_right,@y) <= @gap_between_player_left_and_right_collider
					@right_collision = true
				end
			end
=end
		end

	end
	
	def idle
		@image = @idle_anim
	end

	def right
		@right_flag = true
		right_collision_check
		@x += @speed unless @right_collision == true
		@image = @right_walk_anim[Gosu.milliseconds / 200 % @right_walk_anim.size]
	end

	def left
		@right_flag = false
		left_collision_check
		@x-= @speed unless @left_collision ==true
		@image = @left_walk_anim[Gosu.milliseconds / 200 % @left_walk_anim.size]
	end

	def up
		@player_colliders.top_collision_check(@x, @y, @speed, @gap_between_player_bottom_and_top_collider)
		@y -= @speed unless @player_colliders.top_collision
		if @right_flag
			@image = @right_walk_anim[Gosu.milliseconds / 200 % @right_walk_anim.size]
		else
			@image = @left_walk_anim[Gosu.milliseconds / 200 % @left_walk_anim.size]
		end
	end

	def down
		bottom_collision_check
		@y += @speed unless @bottom_collision == true
		if @right_flag
			@image = @right_walk_anim[Gosu.milliseconds / 200 % @right_walk_anim.size]
		else
			@image = @left_walk_anim[Gosu.milliseconds / 200 % @left_walk_anim.size]
		end
	end
	
	def draw
		#.draw always draws an image from its top-left corner. We therefore can't pass it @x and @y because these are the player's centre coordinates.
		#We therefore modify @x and @y to give the image's top-left corner coordinates
		@image.draw(@x - @width/2, @y - @height/2, 10)
	end
end