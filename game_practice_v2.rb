require 'json'
require 'gosu'
require 'gosu_tiled'
require_relative 'player'
require_relative 'mages'
require_relative 'world'

#sets the directory to where the game is located *DELETE IF NECCESSARY*
Dir.chdir "c:/"
Dir.chdir "users/shen/desktop/local_practice"

class Game_Window < Gosu::Window
  
  def initialize
    #sets up the window space and title
	super(384, 256, false)
    self.caption = "game_practice"
	#loads images from Tiled *DELETE IF NECCESSARY*
	@background_image = Gosu::Tiled.load_json(self, "map.json")
	
	@king = Player.new(collider_layer_name = "colliders")
	@mages = Mages.new(collider_layer_name = "mages")
	#@snake_green = Snake.new(collider_layer_name = "colliders")
	@king.warp(32,40)
	#@snake_green.warp(32,256)
	
 end
  
  def update
  	if Gosu.button_down? Gosu::KB_RIGHT
  		@king.right
  		if Gosu.button_down? Gosu::KB_UP
  			@king.up
  		elsif Gosu.button_down? Gosu::KB_DOWN
  			@king.down
  		end  			
  	elsif Gosu.button_down? Gosu::KB_LEFT
  		@king.left
   		if Gosu.button_down? Gosu::KB_UP
  			@king.up
  		elsif Gosu.button_down? Gosu::KB_DOWN
  			@king.down
  		end 		
  	elsif Gosu.button_down? Gosu::KB_UP
  		@king.up
  	elsif Gosu.button_down? Gosu::KB_DOWN
  		@king.down
  	else
  		@king.idle
  	end

  	@mages.collision_checker(@king.x, @king.y)
  	#@snake_green.move
  end
  
  
  
  def draw
	@background_image.draw(0,0)
	@king.draw
	@mages.draw
	#@snake_green.draw
	#Gosu.draw_rect(0, 192, 384, 48, Gosu::Color::BLUE, 11) 
  end
end







=begin
class Snake < Player
	def initialize(colliders_name)
		@idle_anim = Gosu::Image.new("snake_idle.png", :tileable => true)
		@height = 32
		@width = 32
		@colliders_name = colliders_name
		@snake_colliders = Colliders.new("#{@colliders_name}")
		@line_ranges = @snake_colliders.calculate_lines
		@speed = 1
		@gap_between_player_bottom_and_top_collider	= 16
	end

	def top_collision_check
		super
		puts @top_collision
	end

	def warp(x,y)
		@x = x + (@width/2)
		@y = y + (@height/2)
	end

	def move
		top_collision_check
		@y -= @speed
	end

	def draw
		@idle_anim.draw(@x - @width/2, @y - @height/2, 11)
	end

end
=end




game_window = Game_Window.new
game_window.show