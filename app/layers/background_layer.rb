class BackgroundLayer < Joybox::Core::Layer

  def on_enter
    background_sprite = Sprite.new file_name: 'background.bmp', position: [Screen.half_width, 55]
    self << background_sprite
  end
end