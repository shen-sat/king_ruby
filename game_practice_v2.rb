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
	@background_image = Gosu::Tiled.load_json(self, "map.json")
  @start_screen_image = Gosu::Image.new("start_screen.png", :tileable => true)
  @game_over_image = Gosu::Image.new("game_over.png", :tileable => true)
  @tree_image = Gosu::Image.new("tree.png", :tileable => true)
  @game_start_text = Gosu::Image.from_text("All hail King Ruby!" + "\n" + "Press enter to begin.", 16, {})
  @game_over_red_text = Gosu::Image.from_text("The King is dead!" + "\n" + "You were bitten by a RED snake." + "\n" + "Enter to restart, esc to quit.", 16, {})
  @game_over_blue_text = Gosu::Image.from_text("The King is dead!" + "\n" + "You were bitten by a BLUE snake." + "\n" + "Enter to restart, esc to quit.", 16, {})
	@king = Player.new(collider_layer_name = "colliders")
	@mages = Mages.new(collider_layer_name = "mages")
	@snake_red = Snake.new(collider_layer_name = "snake_red")
	@snake_blue = Snake.new(collider_layer_name = "snake_blue")
  @mushrooms = Mushrooms.new(collider_layer_name = "mushrooms")
	@king.warp(64,96)
	@snake_red.warp(48,96)
  @snake_blue.warp(304,32)
  @game_state = "start"
	
 end
  
  def update
  	if @game_state == "start"
      if Gosu.button_down? Gosu::KB_RETURN
        @game_state = "game"
        puts "pressed enter"
      elsif Gosu.button_down? Gosu::KB_ESCAPE
        close
      end
    elsif @game_state == "end"
      if Gosu.button_down? Gosu::KB_RETURN
        initialize
      elsif Gosu.button_down? Gosu::KB_ESCAPE
        close
      end
    else
      if Gosu.button_down? Gosu::KB_ESCAPE
        close
      elsif Gosu.button_down? Gosu::KB_RIGHT
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
      if @snake_red.player_dead == true
        @game_state = "end"
        @red_flag = true
      elsif @snake_blue.player_dead == true
        @game_state = "end"
        @blue_flag = true
      end
    end
  end
  
  
  
  def draw
    if @game_state == "start"
      @start_screen_image.draw(0,0,1)
      @game_start_text.draw(137, 176, 10)
    elsif @game_state == "end"
      @game_over_image.draw(0,0,1)
        if @red_flag
          @game_over_red_text.draw(96, 176, 10)
        elsif @blue_flag
          @game_over_blue_text.draw(96, 176, 10)
        end
    elsif @game_state == "game"
    	@background_image.draw(0,0)
      if @king.y > 50
        @tree_depth = 3
      else
        @tree_depth = 30
      end
      @tree_image.draw(112,0,@tree_depth)
      @king.draw
    	@mages.draw
    	@snake_red.draw
      @snake_blue.draw
    	@mushrooms.draw
    end
  end
end












game_window = Game_Window.new
game_window.show