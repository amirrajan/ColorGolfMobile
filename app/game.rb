class Game
  attr_accessor :hole,
                :player_color_r,
                :player_color_g,
                :player_color_b,
                :target_color_r,
                :target_color_g,
                :target_color_b,
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

  def over?
    hole == 9 and correct?
  end

  def score_string
    return "PAR" if score <= 0

    score
  end

  def self.stats history
    if history.length == 0
      return "First game huh? Select the right Red, Green, and Blue percentages to progress to the next hole. There are nine holes in total. Good luck."
    end

    perfect_score_count = history.find_all { |i| i == 0 }.count

    if perfect_score_count > 0
      return "I cannot believe this. You've gotten a perfect score #{perfect_score_count} time(s). Your average score across #{history.count} game(s) is #{history.inject{ |sum, el| sum + el }.fdiv(history.size)}."
    end

    if history.length == 1
      return "Excellent, you've got a game under your belt. Now to improve on your score of #{history.first} strokes."
    end

    return [
      "It helps if you where a black turtle neck sweater and barratte.",
      stats_average(history),
      stats_all_time_best(history),
    ].sample
  end

  def self.stats_average history
    "You've played #{history.length} game(s). Your average score across those game(s) is #{history.inject{ |sum, el| sum + el }.fdiv(history.size)}."
  end

  def self.stats_all_time_best history
    "Your all time best score is #{history.min}. Time will tell if you can beat that."
  end
end
