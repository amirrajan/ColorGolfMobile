#fswatch spec/game_spec.rb | xargs -n1 -I{} rake ios:spec

describe "game" do
  describe "playing" do
    it "hole in one" do
      game = Game.new(colors_options_r: ["00"],
                      colors_options_g: ["00"],
                      colors_options_b: ["00"])

      game.hole.should.equal 1
      game.target_color.should.equal "000000"

      game.correct?.should.equal false
      game.swings.should.equal 0

      game.swing_for_r("00")
      game.correct?.should.equal false
      game.swings.should.equal 0

      game.swing_for_g("00")
      game.correct?.should.equal false
      game.swings.should.equal 0

      game.swing_for_b("00")
      game.correct?.should.equal true
      game.swings.should.equal 1

      game.score.should.equal 0
    end

    it "hole in two" do
      game = Game.new(colors_options_r: ["00"],
                      colors_options_g: ["00"],
                      colors_options_b: ["00"])

      game.hole.should.equal 1
      game.target_color.should.equal "000000"

      game.swing_for_r("00")
      game.swings.should.equal 0

      game.swing_for_g("00")
      game.swings.should.equal 0

      game.swing_for_b("ff")
      game.swings.should.equal 1

      game.swing_for_b("00")
      game.swings.should.equal 2

      game.score.should.equal 1
    end
  end

  describe "stats" do
    it "works" do
      Game.stats([]).should.equal "First game huh? Select the right Red, Green, and Blue percentages to progress to the next hole. There are nine holes in total. Good luck."

      Game.stats([0]).should.equal "I cannot believe this. You've gotten a perfect score 1 time(s). Your average score across 1 game(s) is 0.0."

      Game.stats([15]).should.equal "Excellent, you've got a game under your belt. Now to improve on your score of 15 strokes."

      Game.stats_average([10, 10, 30, 15]).should.equal "You've played 4 game(s). Your average score across those game(s) is 16.25."

      Game.stats_all_time_best([10, 10, 30, 15]).should.equal "Your all time best score is 10. Time will tell if you can beat that."
    end
  end
end
