class Snake
	def initialize(colliders_name)
		@idle_anim = Gosu::Image.new("snake_idle.png", :tileable => true)
		@height = 32
		@width = 32
		@colliders_name = colliders_name
		@snake_colliders = Colliders.new("#{@colliders_name}")
		@line_ranges = @snake_colliders.calculate_lines
		@speed = 1
		@gap_between_player_bottom_and_top_collider = 16
		@gap_between_player_top_and_bottom_collider = 16
		@gap_between_player_right_and_left_collider = 16
		@gap_between_player_left_and_right_collider = 16
		@colliders_name = colliders_name
		@snake_colliders = Colliders.new("#{@colliders_name}")
		@line_ranges = @snake_colliders.calculate_lines
		@moving_right = true
		@moving_up = true
		@move_counter = 1
	end

	def warp(x,y)
		@x = x + (@width/2)
		@y = y + (@height/2)
	end

	def move
		if @move_counter == 1
			@move_counter = 0
			@snake_colliders.top_collision_check(@x, @y, @speed, @gap_between_player_bottom_and_top_collider)
			@snake_colliders.bottom_collision_check(@x, @y, @speed, @gap_between_player_top_and_bottom_collider)
			@snake_colliders.right_collision_check(@x, @y, @speed, @gap_between_player_left_and_right_collider)
			@snake_colliders.left_collision_check(@x, @y, @speed, @gap_between_player_right_and_left_collider)
			if @snake_colliders.top_collision then @moving_up = false end
			if  @snake_colliders.bottom_collision then @moving_up = true end
			if @snake_colliders.right_collision then @moving_right = false end
			if @snake_colliders.left_collision then @moving_right = true end
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
			@move_counter = 1
		end	
	end

	def draw
		@idle_anim.draw(@x - @width/2, @y - @height/2, 11)
	end

end