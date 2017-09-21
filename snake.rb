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
	end

	def warp(x,y)
		@x = x + (@width/2)
		@y = y + (@height/2)
	end

	def move
		@snake_colliders.top_collision_check(@x, @y, @speed, @gap_between_player_bottom_and_top_collider)
		@y -= @speed unless @snake_colliders.top_collision
	end

	def draw
		@idle_anim.draw(@x - @width/2, @y - @height/2, 11)
	end

end