class ColorGolfScreen < UI::Screen
  attr_accessor :game

  include ViewGeneration

  def on_show
    self.navigation.hide_bar
  end

  def on_load
    $self = self
    @game = Game.new(
      colors_options_r: ["00", "33", "66", "99", "cc", "ff"],
      colors_options_g: ["00", "33", "66", "99", "cc", "ff"],
      colors_options_b: ["00", "33", "66", "99", "cc", "ff"])
    render_view
    update
  end

  def update
    get_view(:hole).text = "Hole #{@game.hole} of 9"
    get_view(:target_color).background_color = @game.target_color

    if @game.player_color
      get_view(:player_color).background_color = @game.player_color
      get_view(:player_color).text = " "
    else
      get_view(:player_color).background_color = :white
      get_view(:player_color).text = "?"
    end

    cell_ids.each do |k, v|
      if(v[:value] == @game.send(v[:prop]))
        get_view(k).background_color = "f5f5f5"
      else
        get_view(k).background_color = :white
      end
    end
  end

  def cell_ids
    @cell_ids ||= {
      r_ff: { method: :swing_for_r, prop: :player_color_r, value: "ff", text: "100%" },
      g_ff: { method: :swing_for_g, prop: :player_color_g, value: "ff", text: "100%" },
      b_ff: { method: :swing_for_b, prop: :player_color_b, value: "ff", text: "100%" },
      r_cc: { method: :swing_for_r, prop: :player_color_r, value: "cc", text: "80%"  },
      g_cc: { method: :swing_for_g, prop: :player_color_g, value: "cc", text: "80%"  },
      b_cc: { method: :swing_for_b, prop: :player_color_b, value: "cc", text: "80%"  },
      r_99: { method: :swing_for_r, prop: :player_color_r, value: "99", text: "60%"  },
      g_99: { method: :swing_for_g, prop: :player_color_g, value: "99", text: "60%"  },
      b_99: { method: :swing_for_b, prop: :player_color_b, value: "99", text: "60%"  },
      r_66: { method: :swing_for_r, prop: :player_color_r, value: "66", text: "40%"  },
      g_66: { method: :swing_for_g, prop: :player_color_g, value: "66", text: "40%"  },
      b_66: { method: :swing_for_b, prop: :player_color_b, value: "66", text: "40%"  },
      r_33: { method: :swing_for_r, prop: :player_color_r, value: "33", text: "20%"  },
      g_33: { method: :swing_for_g, prop: :player_color_g, value: "33", text: "20%"  },
      b_33: { method: :swing_for_b, prop: :player_color_b, value: "33", text: "20%"  },
      r_00: { method: :swing_for_r, prop: :player_color_r, value: "00", text: "0%"   },
      g_00: { method: :swing_for_g, prop: :player_color_g, value: "00", text: "0%"   },
      b_00: { method: :swing_for_b, prop: :player_color_b, value: "00", text: "0%"   }
    }
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
    header_width = width_for(:target_color_wraper)

    cell_width = (header_width - 30).fdiv(3)

    render! :grid, UI::View do |grid|
      grid.width = header_width
      grid.margin = 10
      grid.flex_direction = :row
      grid.flex_wrap = :wrap
      grid.justify_content = :center
      grid.align_self = :center

      render :r_header, UI::Label do |label|
        label.width = cell_width
        label.text = "R"
        label.align_self = :center
        label.text_alignment = :center
        label.font = font
      end

      render :g_header, UI::Label do |label|
        label.width = cell_width
        label.text = "G"
        label.align_self = :center
        label.text_alignment = :center
        label.font = font
      end

      render :b_header, UI::Label do |label|
        label.width = cell_width
        label.text = "B"
        label.align_self = :center
        label.text_alignment = :center
        label.font = font
      end

      cell_ids.each do |k, v|
        render_rgb_button k, v[:method], v[:value], v[:text], cell_width
      end
    end
  end

  def render_rgb_button id, target_swing, value, text, width
    render id, UI::Button do |button|
      button.width = width
      button.height = 30
      button.margin = 1
      button.padding = 1
      button.title = text
      button.on :tap do
        @game.send(target_swing, value)
        update
      end
      button.font = font
      button.color = :black
      button.background_color = :white
    end
  end

  def font
    { name: 'Existence-Light', size: 16, extension: :otf }
  end

end
