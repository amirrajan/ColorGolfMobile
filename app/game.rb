class Game
  attr_accessor :hole,
                :player_color_r,
                :player_color_g,
                :player_color_b,
                :colors_options_r,
                :colors_options_g,
                :colors_options_b,
                :swings

  def initialize(opts)
    @hole = 0
    @colors_options_r = opts[:colors_options_r]
    @colors_options_g = opts[:colors_options_g]
    @colors_options_b = opts[:colors_options_b]
    @swings = 0
    next_hole
  end

  def correct?
    @target_color_r == @player_color_r &&
    @target_color_g == @player_color_g &&
    @target_color_b == @player_color_b
  end

  def target_color
    [@target_color_r,
     @target_color_g,
     @target_color_b].join
  end

  def player_color
    return nil if !@player_color_r
    return nil if !@player_color_g
    return nil if !@player_color_b

    [@player_color_r,
     @player_color_g,
     @player_color_b].join
  end

  def next_hole
    @target_color_r = @colors_options_r.sample
    @target_color_g = @colors_options_g.sample
    @target_color_b = @colors_options_b.sample

    @player_color_r = nil
    @player_color_g = nil
    @player_color_b = nil

    @hole += 1
  end

  def score
    @swings - @hole
  end

  def swing_for_r r
    @player_color_r = r
    return if !player_color
    @swings += 1
  end

  def swing_for_g g
    @player_color_g = g
    return if !player_color
    @swings += 1
  end

  def swing_for_b b
    @player_color_b = b
    return if !player_color
    @swings += 1
  end
end
