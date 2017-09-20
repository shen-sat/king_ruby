require 'json'
require 'gosu'
require 'gosu_tiled'

#sets the directory to where the game is located *DELETE IF NECCESSARY*
Dir.chdir "c:/"
Dir.chdir "users/shen/desktop/local_practice"

class Game_Window < Gosu::Window
  
  def initialize
    #sets up the window space and title
	super(384, 192, false)
    self.caption = "game_practice"
	#loads images from Tiled *DELETE IF NECCESSARY*
	@background_image = Gosu::Tiled.load_json(self, "map.json")
	
	
	#loads the json map file exported from Tiled
	file = File.read("map.json")
	data_hash = JSON.parse(file)
	#locates the array named "colliders" within the json file and assigns it to @landscape_colliders
	data_hash["layers"].each do |x|
		if x["name"] == "colliders"
			@objects_from_tiled =  x["objects"]
		end
	end
	#line collider code begins
	@adjusted_colliders = []
	@temp_collider_storage = []
	@objects_from_tiled.each do |line|
		@collider_x_origin = line["x"]
		@collider_y_origin = line["y"]
		#puts line["polyline"]
		line["polyline"].each do |point|
			@actual_x = point["x"] + @collider_x_origin
			@actual_y = point["y"] + @collider_y_origin 
			#puts "This are the new points: #{point["x"] + @x_origin}, #{point["y"] + @y_origin}"
			#puts @actual_x
			#puts @actual_y
			@temp_collider_storage.push ({x: @actual_x, y: @actual_y})
		end
		@adjusted_colliders.push @temp_collider_storage
		@temp_collider_storage = []
	end

	#puts @adjusted_colliders[0]
	@adjusted_lines = []

	@adjusted_colliders.each do |collider|
		collider.each_with_index do |coordinate, i|  
			if collider[i + 1].nil?
				0
			else
				next_coordinate = collider[i+1]
				#puts "this line is #{coordinate} to #{next_coordinate}"

				@adjusted_lines.push [coordinate, next_coordinate]
				
			end

		end
		#puts "this is a collider: #{collider}"
	end

	@mins_and_maxs_for_lines = []
	@adjusted_lines.each do |l|
		@mins_and_maxs_for_lines.push ({x_range: [l[0][:x], l[1][:x]].sort!, y_range: [l[0][:y], l[1][:y]].sort!})
	end

	@mins_and_maxs_for_lines.each do |range|
		puts "This line's range is: #{range}"
	end
	#line collider code ends
	
	@king = Player.new(@mins_and_maxs_for_lines)
	@king.warp(32,64)
	
 end

  
  def update
  	

  	if Gosu.button_down? Gosu::KB_RIGHT
  		@king.right
  	elsif Gosu.button_down? Gosu::KB_LEFT
  		@king.left
  	elsif Gosu.button_down? Gosu::KB_UP
  		@king.up
  	elsif Gosu.button_down? Gosu::KB_DOWN
  		@king.down
  	end
  end
  
  
  
  def draw
	@background_image.draw(0,0)
	@king.draw
  end
end

class Player
	
	def initialize(mins_and_maxs_for_lines)
		@dummy_image = Gosu::Image.new("king_dummy.png", :tileable => true)
		@width = 32
		@height = 32
		@speed = 1
		@mins_and_maxs_for_lines = mins_and_maxs_for_lines
		@counter = 1
	end
	
	def warp(x,y)
		@x = x + @width/2
		@y = y + @height/2
	end

	def top_collision_check
		@top_collision = false
		@mins_and_maxs_for_lines.each do |check|
			if @x >= check[:x_range][0] && @x <= check[:x_range][1]
				#puts "Y boundary is #{check[:y_range][0]}"
				puts Gosu.distance(@x,@y,@x,check[:y_range][0])
				if Gosu.distance(@x,@y,@x,check[:y_range][0]) <= @height/2
					@top_collision = true
				end
			end
		end
		puts @top_collision
	end
	
	def right
		@x += @speed
	end

	def left
		@x-= @speed
	end

	def up
		top_collision_check
		@y -= @speed unless @top_collision == true
	end

	def down
		@y += @speed
	end
	
	def draw
		#.draw always draws an image from its top-left corner. We therefore can't pass it @x and @y because these are the player's centre coordinates.
		#We therefore modify @x and @y to give the image's top-left corner coordinates
		@dummy_image.draw(@x - @width/2, @y - @height/2, 10)
	end
end

game_window = Game_Window.new
game_window.show