require 'json'
require 'gosu'
require 'gosu_tiled'
require_relative 'player'
require_relative 'mages'
require_relative 'world'
require_relative 'snake'
require_relative 'mushrooms'

class Game_Window < Gosu::Window
  
  def initialize
    #sets up the window space and title
	super(384, 256, false)
    self.caption = "game_practice"
	#loads images from Tiled *DELETE IF NECCESSARY*
	@background_image = Gosu::Tiled.load_json(self, "map.json")
  @tree_image = Gosu::Image.new("tree.png", :tileable => true)
	
	@king = Player.new(collider_layer_name = "colliders")
	@mages = Mages.new(collider_layer_name = "mages")
	@snake_red = Snake.new(collider_layer_name = "snake_red")
	@mushrooms = Mushrooms.new(collider_layer_name = "mushrooms")
	@king.warp(32,40)
	@snake_red.warp(48,96)
	
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
    @mushrooms.collision_checker(@king.x, @king.y)
  	@snake_red.move(@king.x, @king.y)
  end
  
  
  
  def draw
	@background_image.draw(0,0)
  if @king.y > 50
    @tree_depth = 1
  else
    @tree_depth = 30
  end
  @tree_image.draw(112,0,@tree_depth)
	@king.draw
	@mages.draw
	@snake_red.draw
	@mushrooms.draw
  end
end












game_window = Game_Window.new
game_window.show