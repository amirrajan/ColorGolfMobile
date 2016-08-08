class ColorGolfScreen < UI::Screen
  def on_show
    self.navigation.hide_bar
  end

  def on_load
    background = UI::View.new
    background.flex = 1
    background.margin = 25
    background.background_color = :white
    view.add_child(background)

    label = UI::Label.new
    label.margin = [10, 10, 5, 10]
    label.text = "Hello world"
    label.text_alignment = :center
    background.add_child(label)
    view.update_layout
  end
end
