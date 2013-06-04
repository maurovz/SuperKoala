class DeathLayer < Joybox::Core::Layer

  scene

  def on_enter
    title = Label.new text: 'Gorilla ate your face',
                      font_size: 50,
                      position: [Screen.half_width, Screen.half_height]
    self << title
    @timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "restart_game", userInfo: nil, repeats: false)
  end

  def restart_game
    first_scene = GameScene.new
    self << first_scene
  end

end