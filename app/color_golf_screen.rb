class ColorGolfScreen < UI::Screen
  def on_load
    50.times do
      v = UI::Button.new
      v.title = "x"
      v.height = 30
      v.color = :black
      view.add_child(v)
    end

    view.update_layout
  end
end
