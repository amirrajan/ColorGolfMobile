class ColorGolfScreen < UI::Screen
  include ViewGeneration

  def on_show
    self.navigation.hide_bar
  end

  def on_load
    @game = Game.new(
      colors_options_r: ["00", "33", "66", "99", "CC", "FF"],
      colors_options_g: ["00", "33", "66", "99", "CC", "FF"],
      colors_options_b: ["00", "33", "66", "99", "CC", "FF"])
    $self = self
    render_view
    update
  end

  def font
    { name: 'Existence-Light', size: 16, extension: :otf }
  end

  def update
    get_view(:hole).text = "Hole #{@game.hole} of 9"
    get_view(:target_color).background_color = @game.target_color
    if @game.player_color
      get_view(:player_color).background_color = @game.player_color
    else
      get_view(:player_color).background_color = :white
      get_view(:player_color).text = "?"
    end
  end

  def render_view
    view.flex = 1
    view.margin = 5

    render_hole
    render_target_color_square
    render_player_color_square
    render_rgb_grid
  end

  def render_hole
    render :hole, UI::Label do |hole|
      hole.text = "Hole #{@game.hole} of 9"
      hole.margin = [25, 10, 5, 10]
      hole.text_alignment = :center
      hole.font = font
    end
  end

  def render_target_color_square
    render! :target_color_wraper, UI::View do |header|
      header.margin = 5
      render :target_color_border, UI::View do |border|
        border.background_color = :silver
        border.width = 82
        border.height = 82
        border.align_self = :center
        render :target_color, UI::View do |square|
          square.width = 80
          square.height = 80
          square.margin = 1
          square.align_self = :center
        end
      end
    end
  end

  def render_player_color_square
    render! :player_color_wraper, UI::View do |header|
      header.margin = 5
      render :player_color_border, UI::View do |border|
        border.background_color = :silver
        border.width = 82
        border.height = 82
        border.align_self = :center
        render :player_color, UI::Label do |square|
          square.width = 80
          square.height = 80
          square.margin = 1
          square.align_self = :center
          square.text_alignment = :center
          square.font = font.merge({ size: 30 })
        end
      end
    end
  end

  def render_rgb_grid
    @header_width = width_for(:target_color_wraper)

    render! :grid, UI::View do |grid|
      grid.width = @header_width
      grid.margin = 10
      grid.flex_direction = :row
      grid.flex_wrap = :wrap
      grid.justify_content = :center
      grid.align_self = :center

      render :r_header, UI::Label do |label|
        label.width = (@header_width - 30).fdiv(3)
        label.text = "R"
        label.align_self = :center
        label.text_alignment = :center
        label.font = font
      end

      render :g_header, UI::Label do |label|
        label.width = (@header_width - 30).fdiv(3)
        label.text = "G"
        label.align_self = :center
        label.text_alignment = :center
        label.font = font
      end

      render :b_header, UI::Label do |label|
        label.width = (@header_width - 30).fdiv(3)
        label.text = "B"
        label.align_self = :center
        label.text_alignment = :center
        label.font = font
      end

      21.times do |i|
        render_rgb_button i, "100%", (@header_width - 30).fdiv(3)
      end
    end
  end

  def render_rgb_button id, text, width
    render id, UI::Button do |button|
      button.width = width
      button.height = 30
      button.margin = 1
      button.padding = 1
      button.title = text
      button.on :tap do
        button.background_color = "f5f5f5"
      end
      button.font = font
      button.color = :black
      button.background_color = :white
    end
  end
end
