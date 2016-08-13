describe "game" do
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
