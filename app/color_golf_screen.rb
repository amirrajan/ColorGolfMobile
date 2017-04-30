class ColorGolfScreen < UI::Screen
  include Hiccup
  include AppStyles
  include ColorGolfScreenMarkup

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
    render markup(available_percentages), css
    update_view @game
  end

  def swing_r _, attributes
    if @game.correct?
      @game.next_hole
    else
      @game.swing_for_r attributes[:meta]
    end
    update_view @game
  end

  def swing_g _, attributes
    if @game.correct?
      @game.next_hole
    else
      @game.swing_for_g attributes[:meta]
    end
    update_view @game
  end

  def swing_b _, attributes
    if @game.correct?
      @game.next_hole
    else
      @game.swing_for_b attributes[:meta]
    end
    update_view @game
  end

  def next_hole *_
    @game.next_hole
    update_view @game
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
    update_view @game
  end
end
