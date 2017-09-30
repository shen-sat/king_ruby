require 'json'
require 'gosu'
require 'gosu_tiled'
require_relative 'player'
require_relative 'mages'
require_relative 'world'
require_relative 'snake'
require_relative 'mushrooms'
require_relative 'screen'

class Game_Window < Gosu::Window
  
  
  def initialize
    #sets up the window space and title
	super(384, 256, false)
    self.caption = "game_practice"
	#loads images from Tiled *DELETE IF NECCESSARY*
	#@background_image = Gosu::Tiled.load_json(self, "map.json")
  
  
	@game_screen = Screen.new 
	@king = Player.new(collider_layer_name = "colliders")
	@mages = Mages.new(collider_layer_name = "mages")
	@snake_red = Snake.new(collider_layer_name = "snake_red")
	@snake_blue = Snake.new(collider_layer_name = "snake_blue")
  @mushrooms = Mushrooms.new(collider_layer_name = "mushrooms")
	@king.warp(80,90)
	@snake_red.warp(48,96)
  @snake_blue.warp(304,32)
	
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
  	@snake_red.move(@king.x, @king.y, @mushrooms.eaten_shroom_red)
    @snake_blue.move(@king.x, @king.y, @mushrooms.eaten_shroom_blue)
    game_over
  end

  def game_over
    if @snake_red.player_dead == true
      @game_over_red = true
    end
    if @snake_blue.player_dead == true
      @game_over_blue = true
    end
  end
  
  
  
  def draw
	#@background_image.draw(0,0)
  @game_screen.draw(@king.y, @game_over_red, @game_over_blue)
	@king.draw
	@mages.draw
	@snake_red.draw
  @snake_blue.draw
	@mushrooms.draw
  end
end












game_window = Game_Window.new
game_window.show