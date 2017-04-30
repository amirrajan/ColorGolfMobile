module ColorGolfScreenMarkup
  def square id, color
    [:view,
     { id: id,
       width: 70,
       height: 70,
       margin: 5,
       align_self: :center,
       background_color: color,
       border_radius: 8,
       border_width: 1,
       border_color: :black },
     [:label, { flex: 1 }]]
  end

  def row *content
    [:view, { flex_direction: :row, margin: 3 }, content]
  end

  def spacer height
    [:view, { height: height, margin: 0, padding: 0 }]
  end

  def markup button_options
    [:view, { flex: 1, padding: 40 },
     [[:label, { id: :hole, text: 'Hole 1 of 9' }],
      spacer(5),
      [:label, { id: :score, text: 'Par', margin_bottom: 10 }],
      square(:target_color, :white),
      square(:player_color, :white),
      spacer(15),
      row([:label, { text: 'Red', flex: 1 }],
          [:label, { text: 'Green', flex: 1 }],
          [:label, { text: 'Blue', flex: 1 }]),
      [:view,
       button_options.map do |p|
         row([:button, { title: p[1], class: :r_buttons, tap: :swing_r, meta: p[0] }],
             [:button, { title: p[1], class: :g_buttons, tap: :swing_g, meta: p[0] }],
             [:button, { title: p[1], class: :b_buttons, tap: :swing_b, meta: p[0] }])
       end],
      [:button,
       { id: :next_hole,
         class: :link,
         title: 'Next Hole',
         tap: :next_hole,
         align_self: :center }]]]
  end
end
