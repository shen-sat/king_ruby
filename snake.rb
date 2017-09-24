class Snake
	def initialize(colliders_name)
		@idle_anim = Gosu::Image.new("snake_idle.png", :tileable => true)
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
		puts @line_ranges
	end

	def warp(x,y)
		@x = x + (@width/2)
		@y = y + (@height/2)
	end

	def move(player_x, player_y)
		@player_x = player_x
		@player_y = player_y
		chase_checker(@player_x, @player_y)
		collision_checker
		if @move_counter == 1
			@move_counter = 0
			if @chase == false
				if @moving_right && @moving_up
					@x += @speed
					@y -= @speed
				elsif @moving_right && @moving_up == false
					@x += @speed
					@y += @speed
				elsif @moving_right == false && @moving_up
					@x -= @speed
					@y -= @speed
				else
					@x -= @speed
					@y += @speed
				end
			else
				if @x > @player_x
					@x -= @speed*3
				elsif @x < @player_x
					@x += @speed*3
				end
				if @y > @player_y
					@y -= @speed*3
				elsif @y < @player_y
					@y += @speed*3
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
		 #puts @player_x
		 #puts @player_y
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


	def draw
		@idle_anim.draw(@x - @width/2, @y - @height/2, 11)
	end

end