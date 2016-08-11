class ColorGolfScreen < UI::Screen
  include ViewGeneration

  def on_show
    self.navigation.hide_bar
  end

  def on_load
    $self = self
    reload
  end

  def reload
    view.children.each { |x| view.delete_child(x) }
    view.flex = 1
    view.background_color = :white
    view.margin = 5

    render :hole, UI::Label do |hole|
      hole.margin = [25, 10, 5, 10]
      hole.text = "Hole 1 of 9"
      hole.text_alignment = :center
      hole.font = { name: 'Existence-Light', size: 16, extension: :otf }
    end

    render! :header, UI::View do |header|
      header.margin = 0
      header.background_color = :white
      render :square, UI::View do |square|
        square.width = 80
        square.height = 80
        square.margin = 10
        square.align_self = :center
        square.background_color = :pink
      end
    end

    header_width = get_view(:header).layout[2]

    render :grid, UI::View do |grid|
      grid.width = header_width
      grid.margin = 10
      grid.background_color = :white
      grid.flex_direction = :row
      grid.flex_wrap = :wrap
      grid.justify_content = :center
      grid.align_self = :center
      21.times do |i|
        render "button#{i}", UI::Button do |button|
          button.width = (header_width - 10 - 6 - 5) / 3
          button.height = 30
          button.margin = 1
          button.padding = 1
          button.title = "100%"
          button.font = { name: 'Existence-Light', size: 16, extension: :otf }
          button.background_color = :white
          button.color = :black
        end
      end
    end

    view.update_layout
  end
end
