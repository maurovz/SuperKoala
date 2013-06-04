class EndScene < Joybox::Core::Scene

  def on_enter
    background_layer = DeathLayer.new
    director << background_layer
  end
end