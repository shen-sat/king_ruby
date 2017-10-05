class Player
	attr_reader :x
	attr_reader :y

	def initialize(colliders_name)
		@idle_anim = Gosu::Image.new("images/king_dummy_v4.png", :tileable => true)
		@right_walk_anim = Gosu::Image.load_tiles("images/king_walk_right.png", 32, 32)
		@left_walk_anim = Gosu::Image.load_tiles("images/king_walk_left.png", 32, 32)
		@right_flag = true
		@image = @idle_anim
		@width = 32
		@height = 32
		@speed = 1
		@centre_and_top_gap = 6
		@centre_and_bottom_gap = 16
		@centre_and_left_gap = 6
		@centre_and_right_gap = 6
		@buffer = 4
		@colliders_name = colliders_name
		@player_colliders = Colliders.new("#{@colliders_name}", @buffer, @centre_and_top_gap, @centre_and_bottom_gap, @centre_and_left_gap, @centre_and_right_gap)
		@line_ranges = @player_colliders.calculate_lines
	end
	
	def warp(x,y)
		@x = x + @width/2
		@y = y + @height/2
	end

	def idle
		@image = @idle_anim
	end

	def right
		@right_flag = true
		@player_colliders.right_collision_check(@x, @y, @speed)
		@x += @speed unless @player_colliders.right_collision
		@image = @right_walk_anim[Gosu.milliseconds / 200 % @right_walk_anim.size]
	end

	def left
		@right_flag = false
		@player_colliders.left_collision_check(@x, @y, @speed)
		@x-= @speed unless @player_colliders.left_collision
		@image = @left_walk_anim[Gosu.milliseconds / 200 % @left_walk_anim.size]
	end

	def up
		@player_colliders.top_collision_check(@x, @y, @speed)
		@y -= @speed unless @player_colliders.top_collision
		if @right_flag
			@image = @right_walk_anim[Gosu.milliseconds / 200 % @right_walk_anim.size]
		else
			@image = @left_walk_anim[Gosu.milliseconds / 200 % @left_walk_anim.size]
		end
	end

	def down
		@player_colliders.bottom_collision_check(@x, @y, @speed)
		@y += @speed unless @player_colliders.bottom_collision
		if @right_flag
			@image = @right_walk_anim[Gosu.milliseconds / 200 % @right_walk_anim.size]
		else
			@image = @left_walk_anim[Gosu.milliseconds / 200 % @left_walk_anim.size]
		end
	end
	
	def draw
		@image.draw(@x - @width/2, @y - @height/2, 10)
	end
	
end