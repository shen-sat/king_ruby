require 'json'
require 'gosu'
require 'gosu_tiled'

#sets the directory to where the game is located *DELETE IF NECCESSARY*
Dir.chdir "c:/"
Dir.chdir "users/shen/desktop/local_practice/line_practice"

	
	
#loads the json map file exported from Tiled
file = File.read("map_with_lines.json")
data_hash = JSON.parse(file)
#locates the array named "colliders" within the json file and assigns it to @landscape_colliders
data_hash["layers"].each do |x|
	if x["name"] == "colliders"
		@colliders =  x["objects"]
	end
end

@adjusted_colliders = []
@temp_collider_storage = []
@colliders.each do |line|
	@x_origin = line["x"]
	@y_origin = line["y"]
	#puts line["polyline"]
	line["polyline"].each do |point|
		@actual_x = point["x"] + @x_origin
		@actual_y = point["y"] + @y_origin 
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

#goes through each collider and picks out the top-left corner coordinates, and from this works out the other corners' coordinates
#Each coordinate is stored within a hash. Each group of four-corner hashes is stored as an object within a new array
=begin
	@rectangles = []
	@landscape_colliders.each do |c|
		x_lower_limit = c["x"]
		x_upper_limit = c["x"] + c["width"]
		y_lower_limit = c["y"]
		y_upper_limit = c["y"] + c["height"] 
		@rectangles.push ({rect_left: x_lower_limit, rect_right: x_upper_limit, rect_bottom: y_upper_limit, rect_top: y_lower_limit})
	end
	
	@king = Player.new(@rectangles)
	@king.warp(32,64)
=end	
