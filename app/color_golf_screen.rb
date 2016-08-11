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

    render_root UI::View do |view|
      view.flex = 1
      view.margin = 25
      view.background_color = :white

      render :hole, UI::Label do |hole|
        hole.margin = [10, 10, 5, 10]
        hole.text = "Hole 1 of 9"
        hole.text_alignment = :center
        hole.font = { name: 'Existence-Light', size: 16, extension: :otf }
      end

      render :header, UI::View do |header|
        header.height = 100
        header.margin = 0
        render :square, UI::View do |square|
          square.width = 80
          square.height = 80
          square.margin = 10
          square.align_self = :center
          square.background_color = :red
        end
      end
    end

    view.update_layout
  end
end
