class GameLayer < Joybox::Core::Layer

  def on_enter
    @world = World.new gravity: [0.0, -9.8]
    schedule_update do |dt|
      @world.step delta: dt

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

    end

    floorBodySize = Sprite.new file_name: 'floor.png'

    floorBody = @world.new_body position: [1200, (floorBodySize.boundingBox.size.height / 2)] do
      polygon_fixture box: [(floorBodySize.boundingBox.size.width / 2 - 15), (floorBodySize.boundingBox.size.height / 2) - 4], friction: 0.3, density: 1.0
    end

    floorBody2 = @world.new_body position: [210, (floorBodySize.boundingBox.size.height / 2)] do
      polygon_fixture box: [(floorBodySize.boundingBox.size.width / 2 - 15), (floorBodySize.boundingBox.size.height / 2) - 4], friction: 0.3, density: 1.0
    end

    @level_floor = PhysicsSprite.new file_name: 'floor.png', body: floorBody
    @level_floor2 = PhysicsSprite.new file_name: 'floor.png', body: floorBody2

    self << @level_floor
    self << @level_floor2

    @koalio = new_koalio_sprite  
    self << @koalio

    init_controls
    layout_menus
  end

  def init_controls

    on_touches_began do |touches, event|
      starting_touch = touches.any_object
      @starting_touch_location = starting_touch.location
            
    end

    on_touches_ended do |touches, event|
      end_touch = touches.any_object
      end_touch_location = end_touch.location
      
      @isHolding = false
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


  def blue_menu_button
       @koalio.body.apply_force force: [0, 150]
  end


  def purple_menu_button
      banana = new_banana_sprite
      self << banana
      banana.body.apply_force force: [300, 300]
  end

  def left_arrow_menu_button
 
  end

  def right_arrow_menu_button
      @isHolding = true
  end


  def new_banana_sprite
    banana_body = @world.new_body position: [@koalio.position.x + 10, @koalio.position.y], type: KDynamicBodyType do

        polygon_fixture box: [16, 16],
                        friction: 0.3,
                        density: 1.0
    end 

    @banana_sprite = PhysicsSprite.new file_name: 'banana.png', body: banana_body

    @world.when_collide banana_body do |collision_body, is_touching|

    end

    @banana_sprite
  end


  def new_koalio_sprite
    koalio_body = @world.new_body position: [100, 150], type: KDynamicBodyType do

        polygon_fixture box: [16, 16],
                        friction: 0.3,
                        density: 1.0
    end 

    @koalio_sprite = PhysicsSprite.new file_name: 'koalio_stand.png', body: koalio_body


    @koalio_sprite
  end

  def apply_move_action_left
       @koalio.body.apply_force force: [0,0.1]
       @level_floor.position = [@level_floor.position[0] + 2, @level_floor.position.y]
       @level_floor2.position = [@level_floor2.position[0] + 2, @level_floor2.position.y]
  end


  def apply_move_action_right
       @koalio.body.apply_force force: [0,0.1]
       @level_floor.position = [@level_floor.position[0] - 2, @level_floor.position.y]
       @level_floor2.position = [@level_floor2.position[0] - 2, @level_floor2.position.y]
  end


end



