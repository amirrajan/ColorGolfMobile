class ColorGolfScreen < UI::Screen
  attr_accessor :game

  def on_show
    navigation.hide_bar
  end

  def new_game
    rgb_options = available_percentages.map { |t| t[0] }
    @game = Game.new(colors_options_r: rgb_options,
                     colors_options_g: rgb_options,
                     colors_options_b: rgb_options)
    $game = @game
  end

  def on_load
    $self = self
    new_game
    load_game
    set_random_stat_text
    render markup, css
    view.update_layout
    update_view
  end

  def square id, color
    [:view, { id: id,
              width: 70,
              height: 70,
              margin: 5,
              align_self: :center,
              background_color: color,
              border_radius: 8,
              border_width: 1,
              border_color: :black }]
  end

  def swing_r _, attributes
    @game.swing_for_r attributes[:meta][:percentage]
    update_view
  end

  def swing_g _, attributes
    @game.swing_for_g attributes[:meta][:percentage]
    update_view
  end

  def swing_b _, attributes
    @game.swing_for_b attributes[:meta][:percentage]
    update_view
  end

  def update_view
    @classes[:r].each do |c|
      c[:view].background_color = if @game.player_color_r == c[:attributes][:meta][:percentage]
                                    '#f5f5f5'
                                  else
                                    :white
                                  end
    end

    @classes[:g].each do |c|
      c[:view].background_color = if @game.player_color_g == c[:attributes][:meta][:percentage]
                                    '#f5f5f5'
                                  else
                                    :white
                                  end
    end

    @classes[:b].each do |c|
      c[:view].background_color = if @game.player_color_b == c[:attributes][:meta][:percentage]
                                    '#f5f5f5'
                                  else
                                    :white
                                  end
    end

    @views[:target_color][:view].background_color = @game.target_color

    if @game.player_color
      @views[:player_color][:view].background_color = @game.player_color
    end
  end

  def button_row value, percentage
    row([:button, { title: value, class: :r, tap: :swing_r, meta: { color: :r, percentage: percentage } }],
        [:button, { title: value, class: :g, tap: :swing_g, meta: { color: :g, percentage: percentage } }],
        [:button, { title: value, class: :b, tap: :swing_b, meta: { color: :b, percentage: percentage } }])
  end

  def row *content
    [:view, { flex_direction: :row, margin: 3 }, content]
  end

  def markup
    [:view, { flex: 1, padding: 40 },
     [[:label, { text: 'Hole 1 of 9' }],
      [:label, { text: 'Par' }],
      square(:target_color, :white),
      square(:player_color, :white),
      row([:label, { text: 'Red', flex: 1 }],
          [:label, { text: 'Green', flex: 1 }],
          [:label, { text: 'Blue', flex: 1 }])] +
     available_percentages.map { |p| button_row(p[1], p[0]) }]
  end

  def css
    {
      label: { color: :black, text_alignment: :center },
      button: { color: :black,
                flex: 1,
                height: 40,
                background_color: :white,
                border_radius: 8,
                border_width: 1,
                border_color: :silver,
                margin: 2 }
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
    [:id, :tap, :meta, :class]
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

    attributes[:tap] && new_view.on(:tap) { send(attributes[:tap], new_view, attributes) }

    if attributes[:id]
      @views[attributes[:id]] = { view: new_view, attributes: attributes }
    end

    if attributes[:class]
      @classes[attributes[:class]] ||= []
      @classes[attributes[:class]] << { view: new_view, attributes: attributes }
    end

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
    @classes ||= {}
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
