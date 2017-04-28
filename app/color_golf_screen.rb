class ColorGolfScreen < UI::Screen
  attr_accessor :game

  # include ViewGeneration

  def on_show
    navigation.hide_bar
  end

  def new_game
    rgb_options = available_percentages.map { |t| t[0] }
    @game = Game.new(colors_options_r: rgb_options,
                     colors_options_g: rgb_options,
                     colors_options_b: rgb_options)
  end

  def on_load
    $self = self
    new_game
    load_game
    set_random_stat_text
    render markup, css
    view.update_layout
  end

  def square_with_border color
    [:view, { id: :row, margin: 5 },
     [:view, { id: :border, background_color: :silver, width: 72, height: 72, align_self: :center },
      [:view, { id: :color, width: 70, height: 70, margin: 1, align_self: :center, background_color: color }]]]
  end

  def button_row value
    row(*3.times.map { [:button, { title: value }] })
  end

  def row *content
    [:view, { flex_direction: :row, margin: 3 }, content]
  end

  def markup
    [:view, { flex: 1, padding: 40 },
     [[:label, { text: 'Hole 1 of 9' }],
      [:label, { text: 'Par' }],
      square_with_border(:red),
      square_with_border(:blue),
      row([:label, { text: 'Red', flex: 1 }],
          [:label, { text: 'Green', flex: 1 }],
          [:label, { text: 'Blue', flex: 1 }])] +
     available_percentages.map { |p| button_row(p[1]) }]
  end

  def css
    {
      label: { color: :black, text_alignment: :center },
      button: { color: :black, flex: 1, height: 40 }
    }
  end

  def set_prop_for_view view, prop, value
    view.send("#{prop}=", value)
  end

  def set_prop view, k, v
    view.send("#{k}=", v)
  end

  def control_map
    {
      view: UI::View,
      label: UI::Label,
      button: UI:: Button
    }
  end

  def special_keys
    [:id, :tap]
  end

  def set_attribute view, k, v
    return if special_keys.include? k

    if v == :center
      view.send("#{k}=", :center)
    elsif v == :row
      view.send("#{k}=", :row)
    else
      view.send("#{k}=", v)
    end
  end

  def new_view view_symbol, attributes, styles
    unless control_map.keys.include? view_symbol
      puts "#{view_symbol} not supported"
      return nil
    end

    attributes = (styles[view_symbol] || {}).merge(attributes)

    new_view = control_map[view_symbol].new

    attributes.each do |k, v|
      set_attribute new_view, k, v
    end

    attributes[:tap] && new_view.on(:tap) { send attributes[:tap] }

    @views[attributes[:id]] = new_view if attributes[:id]

    new_view
  end

  def control_definition? o
    return false unless o
    return false unless [2, 3].include? o.length
    return false unless control_map.keys.include? o.first
    true
  end

  def add_to_parent parent, definition, styles
    v = new_view definition[0], definition[1], styles
    content = definition[2]

    if content
      if control_definition?(content)
        add_to_parent v, content, styles
      elsif content.is_a? Array
        content.each { |d| add_to_parent v, d, styles }
      else
        puts "#{content} is not supported"
      end
    end

    parent.add_child v if v
  end

  def render definition, styles
    @views ||= {}
    add_to_parent view, definition, styles
  end

  def set_random_stat_text
    @random_stat_text = Game.stats(Store['history'] || [], @game.hole)
  end

  def available_percentages
    @available_percentages ||= [
      %w(ff 0xff),
      %w(bf 0xbf),
      %w(80 0x80),
      %w(3f 0x3f),
      %w(00 0x00)
    ]
  end

  def font
    { name: 'Existence-Light', size: 18, extension: :otf }
  end

  def bluish
    '2a5db0'
  end

  def white_smoke
    'f5f5f5'
  end

  def save_game
    Store['hole'] = game.hole
    Store['swings'] = game.swings
    Store['player_color_r'] = game.player_color_r
    Store['player_color_g'] = game.player_color_g
    Store['player_color_b'] = game.player_color_b
    Store['target_color_r'] = game.target_color_r
    Store['target_color_g'] = game.target_color_g
    Store['target_color_b'] = game.target_color_b
  end

  def save_history
    Store['history'] = (Store['history'] || []) + [game.score] if game.over?
  end

  def load_game
    game.hole = Store['hole'] || game.hole
    game.swings = Store['swings'] || game.swings || 0
    game.player_color_r = Store['player_color_r'] || game.player_color_r
    game.player_color_g = Store['player_color_g'] || game.player_color_g
    game.player_color_b = Store['player_color_b'] || game.player_color_b
    game.target_color_r = Store['target_color_r'] || game.target_color_r
    game.target_color_g = Store['target_color_g'] || game.target_color_g
    game.target_color_b = Store['target_color_b'] || game.target_color_b

    game.target_color_r = '00' if game.target_color_r == 0
    game.target_color_g = '00' if game.target_color_g == 0
    game.target_color_b = '00' if game.target_color_b == 0
    game.player_color_r = '00' if game.player_color_r == 0
    game.player_color_g = '00' if game.player_color_g == 0
    game.player_color_b = '00' if game.player_color_b == 0
  end

  def cheat
    @game.cheat
    update
  end
end
