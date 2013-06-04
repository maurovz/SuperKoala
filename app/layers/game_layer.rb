class GameLayer < Joybox::Core::Layer

  def on_enter
    @world = World.new gravity: [0.0, -9.8]
    
    player_cotrols_setup

    @enemy_gorillas = NSMutableArray.alloc.init
    @moving_objects = NSMutableArray.alloc.init
    world_setup

    setup_enemy_player
    @player_front = true
    @timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "make_gorilla_jump", userInfo: nil, repeats: true)
    @fire_timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "make_gorilla_fire", userInfo: nil, repeats: true)
    @enemy_timer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: "setup_enemy_player", userInfo: nil, repeats: true)
  end


  def init_controls
    on_touches_began do |touches, event|
      starting_touch = touches.any_object
      @starting_touch_location = starting_touch.location        
    end

    on_touches_ended do |touches, event|
      end_touch = touches.any_object
      end_touch_location = end_touch.location
    end
  end


  def layout_menus
      menu_items = Array.new

      menu_image = MenuImage.new image_file_name: "btnRoundBlue.png", selected_image_file_name: "btnRoundBlue.png" do |menu_item|
          blue_menu_button
      end
      menu_items << menu_image 

      menu_image2 = MenuImage.new image_file_name: "btnRoundPurple.png", selected_image_file_name: "btnRoundPurple.png" do |menu_item|
          purple_menu_button
      end
      menu_items << menu_image2 

      menuRight = Menu.new items: menu_items,
      position: [400, 37]
      menuRight.align_items_horizontally_with_padding(20)
      self.add_child(menuRight, z: 1)


      menu_arrow_items = Array.new

      @menu_arrow_image = MenuImage.new image_file_name: "LeftArrow.png", selected_image_file_name: "LeftArrow.png" do |menu_item|
          left_arrow_menu_button
      end
      menu_arrow_items << @menu_arrow_image 

      @menu_arrow_image2 = MenuImage.new image_file_name: "RightArrow.png", selected_image_file_name: "RightArrow.png" do |menu_item|
          right_arrow_menu_button
      end
      menu_arrow_items << @menu_arrow_image2 

      menuLeft = Menu.new items: menu_arrow_items,
      position: [80, 37]
      menuLeft.align_items_horizontally_with_padding(20)
      self.add_child(menuLeft, z: 1)

  end


  def player_cotrols_setup
      schedule_update do |dt|
      @world.step delta: dt

      @world.when_collide @koalio.body do | collision_body, is_touching |
       if collision_body == @enemy_gorilla.body
         second_scene = EndScene.new
         director << second_scene
      end
      end

      if @menu_arrow_image.isSelected
        apply_move_action_left
      end

      if @menu_arrow_image2.isSelected
        apply_move_action_right
      end

      if @koalio.position.y < -30
        second_scene = GameScene.new
        director << second_scene
        end
      if @koalio.position.x <= 99 || @koalio.position.x >= 101
         @koalio.position = [200, @koalio.position.y]
      end 

    end
  end


  def world_setup
    floorBodySize = Sprite.new file_name: 'floor.png'

    floorBody = @world.new_body position: [1000, (floorBodySize.boundingBox.size.height / 2)] do
      polygon_fixture box: [(floorBodySize.boundingBox.size.width / 2 - 15), (floorBodySize.boundingBox.size.height / 2) - 4], friction: 0.3, density: 1.0
    end

    floorBody2 = @world.new_body position: [210, (floorBodySize.boundingBox.size.height / 2)] do
      polygon_fixture box: [(floorBodySize.boundingBox.size.width / 2 - 15), (floorBodySize.boundingBox.size.height / 2) - 4], friction: 0.3, density: 1.0
    end

    @level_floor = PhysicsSprite.new file_name: 'floor.png', body: floorBody
    @level_floor2 = PhysicsSprite.new file_name: 'floor.png', body: floorBody2

    @moving_objects.addObject(@level_floor)
    @moving_objects.addObject(@level_floor2)

    self << @level_floor
    self << @level_floor2

    @koalio = new_koalio_sprite
    self << @koalio

    init_controls
    layout_menus
  end


  def blue_menu_button
       @koalio.body.apply_force force: [0, 150]
  end


  def purple_menu_button
      @cactus = new_cactus_sprite

      self << @cactus
      @moving_objects.addObject(@cactus)


      if @player_front == true
        @cactus.body.apply_force force: [1000, 60]
      else
        @cactus.body.apply_force force: [-1000, 60]
      end
  end


  def left_arrow_menu_button
  end

  def right_arrow_menu_button
  end


  def new_cactus_sprite
    if @player_front
      direction = 10
    else
      direction = -10
    end

    @cactus_body = @world.new_body position: [@koalio.position.x + direction, @koalio.position.y], type: KDynamicBodyType do

        polygon_fixture box: [6, 6],
                        friction: 5.3,
                        density: 20.0
    end 
    @cactus_sprite = PhysicsSprite.new file_name: 'cactus.png', body: @cactus_body

    @world.when_collide @cactus_body do |collision_body, is_touching|
    end

    @cactus_sprite
  end

  def new_banana_sprite_gorilla
    if @koalio.position.x > @enemy_gorilla.position.x 
      direction = 20
    else
      direction = -20
    end

    @banana_body = @world.new_body position: [@enemy_gorilla.position.x + direction, @enemy_gorilla.position.y], type: KDynamicBodyType do

        polygon_fixture box: [3, 3],
                        friction: 0.3,
                        density: 5.0
    end 

    banana_sprite = PhysicsSprite.new file_name: 'banana.png', body: @banana_body
    @world.when_collide @banana_body do |collision_body, is_touching|
    end

    banana_sprite
  end


  def new_koalio_sprite
    koalio_body = @world.new_body position: [200, 150], type: KDynamicBodyType do

        polygon_fixture box: [16, 16],
                        friction: 0.3,
                        density: 1.0
    end 

    @koalio_sprite = PhysicsSprite.new file_name: 'koalio_stand.png', body: koalio_body
    @koalio_sprite
  end


  def apply_move_action_left
    
    if @player_front != false
      @player_front = false
      @koalio.file_name = 'koalio_stand_back.png'
    end

    i = 0
    while i < @moving_objects.count  do
      @ground_object = @moving_objects.objectAtIndex(i)
      @ground_object.position = [@ground_object.position[0] + 2, @ground_object.position.y]
      i +=1
    end
  end


  def apply_move_action_right
    if @player_front != true
      @player_front = true
      @koalio.file_name = 'koalio_stand.png'
    end

    i = 0
    while i < @moving_objects.count  do
       puts @moving_objects.count
      @ground_object = @moving_objects.objectAtIndex(i)
      @ground_object.position = [@ground_object.position[0] - 2, @ground_object.position.y]
      i +=1
    end
  end


  def setup_enemy_player
    body = @world.new_body position: [@koalio.position[0] + 150, @koalio.position.y + 50], type: KDynamicBodyType do
      polygon_fixture box: [30, 30], friction: 20.3, density: 20.0
    end

    @enemy_gorilla = PhysicsSprite.new file_name: 'gorilla.png', body: body
    @enemy_gorilla.position = [@koalio.position[0] + 150, @koalio.position.y]

    self << @enemy_gorilla
    @moving_objects.addObject(@enemy_gorilla)
    @enemy_gorillas.addObject(@enemy_gorilla)
  end


  def make_gorilla_jump
    i = 1
      if @koalio.position.x > @enemy_gorilla.position.x 
       @enemy_gorilla.body.apply_force force: [10000, 16000]
     else
       @enemy_gorilla.body.apply_force force: [-10000, 16000] 
     end
  end


  def make_gorilla_fire
    if @koalio.position.x > @enemy_gorilla.position.x 
     
      banana = new_banana_sprite_gorilla

      self << banana
      @moving_objects.addObject(banana)
      banana.body.apply_force force: [100 , @koalio.position.y - 90]
    else
      banana = new_banana_sprite_gorilla

      self << banana
      @moving_objects.addObject(banana)
      banana.body.apply_force force: [-100, @koalio.position.y - 90]
    end
  end


end



