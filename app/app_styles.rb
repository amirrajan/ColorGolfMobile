module AppStyles
  def css
    { label: { color: :black,
               text_alignment: :center,
               font: { name: 'Existence-Light', size: 18, extension: :otf } },
      link: { border_width: 0, color: bluish, font: font.merge(size: 20) },
      button: { color: :black,
                flex: 1,
                height: 40,
                background_color: :white,
                border_radius: 8,
                border_width: 1,
                border_color: :black,
                font: font,
                margin: 2 } }
  end

  def font
    { name: 'Existence-Light', size: 18, extension: :otf }
  end

  def bluish
    '2a5db0'
  end
end
