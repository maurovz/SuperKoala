class BackgroundLayer < Joybox::Core::Layer

  def on_enter
    low_background_sprite = Sprite.new file_name: 'FloorBackground.png', position: [Screen.half_width, 40]
    self << low_background_sprite

    background_sprite = Sprite.new file_name: 'background.png', position: [Screen.half_width, 200]
    self << background_sprite
  end
end