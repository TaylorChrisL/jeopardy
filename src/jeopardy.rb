require "gosu"
require_relative "trivia"
require_relative "gameboard"

class Jeopardy < Gosu::Window
  def initialize
    super 800, 600
    self.caption = "Jeopardy"
    @scene = :start
    @trivia = Trivia.new
  end

  def initialize_round_one
    @scene = :round_one
    @board = GameBoard.new
    @board.set_daily_double
  end

  def initialize_round_two
    @scene = :round_two
    @board = GameBoard.new
    @board.set_daily_double
  end
end
