class Snake	
	attr_reader :player_dead

	def initialize(colliders_name)
		@blue_right_anim = Gosu::Image.load_tiles("snake_moves_blue_right.png", 32, 32)
		@blue_left_anim = Gosu::Image.load_tiles("snake_moves_blue_left.png", 32, 32)
		@red_right_anim = Gosu::Image.load_tiles("snake_moves_red_right.png", 32, 32)
		@red_left_anim = Gosu::Image.load_tiles("snake_moves_red_left.png", 32, 32)
		@height = 32
		@width = 32
		@speed = 1
		@centre_and_top_gap = 0
		@centre_and_bottom_gap = 8
		@centre_and_left_gap = 6
		@centre_and_right_gap = 6
		@buffer = 4
		@colliders_name = colliders_name
		@snake_colliders = Colliders.new("#{@colliders_name}", @buffer, @centre_and_top_gap, @centre_and_bottom_gap, @centre_and_left_gap, @centre_and_right_gap)
		@line_ranges = @snake_colliders.calculate_lines
		@moving_right = true
		@moving_up = true
		@move_counter = 1
		@frame_speed = 1
		@chase = false
		#@x_limits = []
		#@y_limts = []
		#@line_ranges.each do |line|
			#@x_limits.push(line[:x_range][0..1])
			#@y_limits.push(line[:y_range][0..1])
		#end
		#@x_limits.sort!
		#@y_limits.sort!
	end

	def warp(x,y)
		@x = x + (@width/2)
		@y = y + (@height/2)
	end

	def move(player_x, player_y, eaten_shroom)
		@player_x = player_x
		@player_y = player_y
		@eaten_shroom = eaten_shroom
		kill_checker(@player_x, @player_y, @eaten_shroom)
		chase_checker(@player_x, @player_y)
		collision_checker
		if @move_counter == 1
			@move_counter = 0
			if @chase == false
				if @moving_right && @moving_up
					@x += @speed
					@y -= @speed
					if @colliders_name == "snake_blue"
						@image = @blue_right_anim[Gosu.milliseconds / 200 % @blue_right_anim.size]
					else
						@image = @red_right_anim[Gosu.milliseconds / 200 % @red_right_anim.size]
					end 
				elsif @moving_right && @moving_up == false
					@x += @speed
					@y += @speed
					if @colliders_name == "snake_blue"
						@image = @blue_right_anim[Gosu.milliseconds / 200 % @blue_right_anim.size]
					else
						@image = @red_right_anim[Gosu.milliseconds / 200 % @red_right_anim.size]
					end 
				elsif @moving_right == false && @moving_up
					@x -= @speed
					@y -= @speed
					if @colliders_name == "snake_blue"
						@image = @blue_left_anim[Gosu.milliseconds / 200 % @blue_left_anim.size]
					else
						@image = @red_left_anim[Gosu.milliseconds / 200 % @red_left_anim.size]
					end
				else
					@x -= @speed
					@y += @speed
					if @colliders_name == "snake_blue"
						@image = @blue_left_anim[Gosu.milliseconds / 200 % @blue_left_anim.size]
					else
						@image = @red_left_anim[Gosu.milliseconds / 200 % @red_left_anim.size]
					end
				end
			else
				if @x > @player_x 
					@x -= @speed*2 unless @snake_colliders.left_collision
					if @colliders_name == "snake_blue"
						@image = @blue_left_anim[Gosu.milliseconds / 200 % @blue_left_anim.size]
					else
						@image = @red_left_anim[Gosu.milliseconds / 200 % @red_left_anim.size]
					end
				elsif @x < @player_x
					@x += @speed*2 unless @snake_colliders.right_collision
					if @colliders_name == "snake_blue"
						@image = @blue_right_anim[Gosu.milliseconds / 200 % @blue_right_anim.size]
					else
						@image = @red_right_anim[Gosu.milliseconds / 200 % @red_right_anim.size]
					end 
				end
				if @y > @player_y
					@y -= @speed*2 unless @snake_colliders.top_collision
				elsif @y < @player_y
					@y += @speed*2 unless @snake_colliders.bottom_collision
				end
			end
		else
		@move_counter += 1
		end	
	end

	def collision_checker
			@snake_colliders.top_collision_check(@x, @y, @speed)
			@snake_colliders.bottom_collision_check(@x, @y, @speed)
			@snake_colliders.right_collision_check(@x, @y, @speed)
			@snake_colliders.left_collision_check(@x, @y, @speed)
			if @snake_colliders.top_collision then @moving_up = false end
			if  @snake_colliders.bottom_collision then @moving_up = true end
			if @snake_colliders.right_collision then @moving_right = false end
			if @snake_colliders.left_collision then @moving_right = true end
	end

	def chase_checker(player_x, player_y)
		 @chase_x_range = false
		 @chase_y_range = false
		 @player_x = player_x
		 @player_y = player_y
		 @line_ranges.each do |line|
		 	x_min = line[:x_range][0]
		 	x_max = line[:x_range][1]
		 	y_min = line[:y_range][0]
		 	y_max = line[:y_range][1]  
		 	@chase_x_range = true if @player_x > x_min && @player_x < x_max
		 	@chase_y_range = true if @player_y > y_min && @player_y < y_max
		 end
		 @chase_x_range && @chase_y_range ? @chase = true : @chase = false
	end

	def kill_checker(player_x, player_y, eaten_shroom)
		@player_x = player_x
		@player_y = player_y
		@eaten_shroom = eaten_shroom
		if @colliders_name == "snake_red" && Gosu.distance(@x, @y, @player_x, @player_y) < 4 && @eaten_shroom == false
			@player_dead = true
		elsif @colliders_name == "snake_blue" && Gosu.distance(@x, @y, @player_x, @player_y) < 4 && @eaten_shroom == false
			@player_dead = true
		#else
			#@player_dead = false
		end
	end

	def draw
		@image.draw(@x - @width/2, @y - @height/2, 11)
	end

end