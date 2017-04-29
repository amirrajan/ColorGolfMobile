class ColorGolfScreen < UI::Screen
  include Hiccup

  attr_accessor :game

  def on_show
    navigation.hide_bar
    update_view
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
  end

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

  def swing_r _, attributes
    @game.swing_for_r attributes[:meta]
    update_view
  end

  def swing_g _, attributes
    @game.swing_for_g attributes[:meta]
    update_view
  end

  def swing_b _, attributes
    @game.swing_for_b attributes[:meta]
    update_view
  end

  def update_view
    @views[:hole][:view].text = "Hole #{@game.hole} of 9"
    @views[:score][:view].text = "Score: #{@game.score_string}"

    @classes[:r_buttons].each do |c|
      c[:view].background_color = if @game.player_color_r == c[:attributes][:meta]
                                    'd0d0d0'
                                  else
                                    :white
                                  end
    end

    @classes[:g_buttons].each do |c|
      c[:view].background_color = if @game.player_color_g == c[:attributes][:meta]
                                    'd0d0d0'
                                  else
                                    :white
                                  end
    end

    @classes[:b_buttons].each do |c|
      c[:view].background_color = if @game.player_color_b == c[:attributes][:meta]
                                    'd0d0d0'
                                  else
                                    :white
                                  end
    end

    @views[:target_color][:view].background_color = @game.target_color
    @views[:target_color][:view].children.first.text = ''

    if @game.player_color
      @views[:player_color][:view].background_color = @game.player_color
      @views[:player_color][:view].children.first.text = ''
    else
      @views[:player_color][:view].background_color = :white
      @views[:player_color][:view].children.first.text = '?'
    end

    @views[:next_hole][:view].hidden = !@game.correct?

    view.update_layout
  end

  def row *content
    [:view, { flex_direction: :row, margin: 3 }, content]
  end

  def spacer height
    [:view, { height: height, margin: 0, padding: 0 }]
  end

  def markup
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
      [:view, {},
       available_percentages.map do |p|
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

  def next_hole *_
    @game.next_hole
    update_view
  end

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
    update_view
  end
end
