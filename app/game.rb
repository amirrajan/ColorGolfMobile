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
    return nil unless @player_color_r
    return nil unless @player_color_g
    return nil unless @player_color_b

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
    @swings - (@hole * 3)
  end

  def swing_for_r r
    @player_color_r = r
    @swings += 1
  end

  def swing_for_g g
    @player_color_g = g
    @swings += 1
  end

  def swing_for_b b
    @player_color_b = b
    @swings += 1
  end

  def over?
    hole == 9 && correct?
  end

  def score_string
    return 'PAR' if score <= 0

    score
  end

  def self.stats history, current_hole = 1
    if history.length.zero? && current_hole > 3
      return random_color_message
    end

    if history.length.zero? && current_hole == 3
      return 'Thirty percent there! More help. Red at 0xff and Green and 0x80 make orange (kinda). Blue at 0xff and Red at 0x80 make purple (kinda).'
    end

    if history.length.zero? && current_hole == 2
      return 'Excellent. Hole number two. Here\'s some help. Red at 0xff and green at 0xff make yellow. Red 0xff and blue 0xff make magenta. Blue and green 0xff make cyan.'
    end

    if history.length.zero? && current_hole == 1
      return 'First game huh? Select the right Red, Green, and Blue hex values to progress to the next hole. There are nine holes in total. Good luck.'
    end

    perfect_score_count = history.find_all { |i| i == 0 }.count

    if perfect_score_count > 0
      return "I cannot believe this. You\'ve gotten a perfect score #{perfect_score_count} time(s). Your average score across #{history.count} game(s) is #{history.inject { |a, e| a + e }.fdiv(history.size)}."
    end

    if history.length == 1
      return "Excellent, you\'ve got a game under your belt. Now to improve on your score of #{history.first} strokes."
    end

    [
      random_color_message,
      stats_average(history),
      stats_all_time_best(history)
    ].sample
  end

  def cheat
    swing_for_r @target_color_r
    swing_for_g @target_color_g
    swing_for_b @target_color_b
  end

  def self.stats_average history
    "You\'ve played #{history.length} game(s). Your average score across those game(s) is #{history.inject { |a, e| a + e }.fdiv(history.size).round(2)}."
  end

  def self.stats_all_time_best history
    "Your all time best score is #{history.min}. Time will tell if you can beat that."
  end

  def self.random_color_message
    [
      'Chromophobia, also known as chromatophobia is a persistent, irrational fear of colors.',
      'It helps if you where a black turtle neck sweater and barratte while you play.',
      'The main purpose of the RGB color model is for the sensing, representation and display of images in electronic systems.',
      'Trichromacy or trichromaticism is the condition of possessing three independent channels for conveying color information, derived from the three different cone types.',
      'Organisms with trichromacy (having three color cones), are called trichromats.',
      'Humans have three color cones. One for detecting short wave lengths (blue), one for medium (green), and one for long (red).',
      'Dogs only have two color cones, yellow and blue.',
      'Cats are also thought to be trichromats (three coned), but not in the same way that humans are. A cat\'s vision is similar to a human who is color blind.',
      'Color is not a property of electromagnetic radiation, but a feature of visual perception by an observer.',
      'The bluebottle butterfly has 15 color cones.',
      'The mantis shrimp has 12 color cones.',
      'The human eye can see 2.4 million colors.',
      'Some women have a unique fourth color cone which is sensitive to orange light.',
      'The human eye can detect more shades of green than any other color.',
      'Red, orange, and yellow evoke so-called active emotions, or feelings that involve physical arousal.',
      'Blue is associated with low anxiety levels, calm, and comfort.',
      'Yellow has been linked to happiness and excitement because it evokes the sun and summer time.',
      'Red provokes more anxiety than blue, and that affects the way users perceive wait times.',
      'Green and pink backgrounds enhanced happy face recognition and impaired sad face recognition.',
      'Black, purple, and violet is widely associated with bitter. Salty is associated with white, and blue. Sour is often related to yellow and green. Sweet is linked to pink and red.',
      'Red, relative to other colors, leads men to view women as more attractive and more sexually desirable.',
      'A study on color associations in children showed that they link red with love and anger, while black evokes death. White was the color most often named for honesty.',
      'The \'blue is a boy\'s color, and ping is a girl\'s color\' phenomenon takes place despite efforts to ban stereotyping and discrimination among children.',
      'Yellow, white, and grey are associated with weakness, while red and black are associated with strength. Black and grey are passive, while red is active.',
      'Purple is associated with sophistication, including traits like \'feminine\', \'glamorous\', and \'charming\'.',
      'Blue is associated with competence (confident, corporate, reliable).',
      'Green is associated with ruggedness (outdoorsy, rugged, masculine).',
      'More simulated purchases, fewer purchase postponements, and a stronger inclination to shop and browse were found in blue retail environments (as oppoosed to red).',
      'When asked about colors that matched a certain brand\'s qualities, respondents associated stability with blue/brown, fun and energy with yellow, and excitement with red/purple.',
      'Websites of blue hue, medium brightness or medium and high saturation received the high overall aesthetics ratings.',
      'Websites receive more favorable perceptions when cool color combinations (blue-light blue) are used, as opposed to warm color combinations (red-orange).',
      'Color can affect the way in which we process faces. Red backgrounds resulted in more negative face perception than green backgrounds, whether the poser was female or male.',
      'Hue: the perceived value of a color, the color itself.',
      'Saturation or Chroma: the overall intensity or brightness of a color.',
      'Value: the lightness or darkness of a color.',
      'Tone: addition of gray to a pure hue or color.',
      'Shade: addition of black to a pure hue or color.',
      'Tint: addition of white to a hue or color.',
      'Complementary color are opposite each other on the color wheel are considered to be complementary colors (example: red and green).',
      'Analogous colors are next to each other on the color wheel. They usually match well and create serene and comfortable designs.',
      'A triadic color scheme uses colors that are evenly spaced around the color wheel.',
      'The split-complementary color scheme is a variation of the complementary color scheme. In addition to the base color, it uses the two colors adjacent to its complement.',
      'The rectangle or tetradic color scheme uses four colors arranged into two complementary pairs.',
      'The square color scheme is similar to the rectangle, but with all four colors spaced evenly around the color circle.'
    ].sample
  end
end
