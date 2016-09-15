module ColorGolfScreenLayout
  def another_fancy_layout_definition
    ui_view(
      id: :wrapper,
      children: [
        hole,
        score,
        target_color_wrapper,
        player_color_wrapper,
        rgb_grid
      ]
    )
  end

  def hole
    ui_label(
      id: :hole,
      text: "Hole #{game.hole} of 9",
      margin: [20, 10, 50, 10],
      text_alignment: :center
    )
  end

  def score
    ui_label(
      id: :score,
      text_alignment: :center
    )
  end

  def target_color_wrapper
    ui_view(
      id: :target_color_wrapper,
      margin: 5,
      children: ui_view(
        background_color: :silver,
        height: 72,
        width: 72,
        align_self: :center,
        children: ui_view(
          id: :target_color,
          width: 70,
          height: 70,
          margin: 1,
          align_self: :center
        )
      )
    )
  end

  def player_color_wrapper
    ui_view(
      id: :player_color_wrapper,
      margin: 5,
      children: ui_view(
        background_color: :silver,
        height: 72,
        width: 72,
        align_self: :center,
        children: ui_view(
          id: :player_color,
          width: 70,
          height: 70,
          margin: 1,
          align_self: :center
        )
      )
    )
  end

  def rgb_grid
    ui_view(
      width: :header_width,
      margin: 5,
      flex_direction: :row,
      flex_wrap: :wrap,
      justify_content: :center,
      align_self: :center,
      children: [
        ui_label(
          width: :cell_width,
          text: 'Red',
          align_self: :center,
          text_alignment: :center
        ),
        ui_label(
          width: :cell_width,
          text: 'Green',
          align_self: :center,
          text_alignment: :center
        ),
        ui_label(
          width: :cell_width,
          text: 'Blue',
          align_self: :center,
          text_alignment: :center
        )
      ]
    )
  end
end
