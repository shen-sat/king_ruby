require 'json'
require 'gosu'
require 'gosu_tiled'
require_relative 'player'
require_relative 'mages'
require_relative 'world'
require_relative 'snake'

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
	@snake_green = Snake.new(collider_layer_name = "colliders")
	@king.warp(32,40)
	@snake_green.warp(32,256)
	
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
  	@snake_green.move
  end
  
  
  
  def draw
	@background_image.draw(0,0)
	@king.draw
	@mages.draw
	@snake_green.draw
  end
end












game_window = Game_Window.new
game_window.show