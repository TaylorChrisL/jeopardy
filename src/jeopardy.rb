require "gosu"
require_relative "trivia"
require_relative "gameboard"

class Jeopardy < Gosu::Window
  attr_reader :scene

  def initialize
    super 800, 600
    self.caption = "Jeopardy"
    @scene = :start
    @trivia = Trivia.new
    @start_game_image = Gosu::Image.new("media/jeopardy_start.png", :tileable => true)
  end

  def initialize_round_one
    @scene = :round_one
    @board = GameBoard.new
    @board.set_daily_double(@scene)
  end

  def initialize_round_two
    @scene = :round_two
    @board = GameBoard.new
    @board.set_daily_double(@scene)
  end

  def initialize_final
    @scene = :final
  end

  def draw
    case @scene
    when :start
      draw_start
    when :round_one
      draw_rounds
    when :round_two
      draw_rounds
    when :final
      draw_final
    when :end
      draw_end
    end
  end

  def draw_start
    @start_game_image.draw(0, 0, 0)
  end

  def draw_rounds
    @board.game_background_image.draw(0, 0, 0)
  end

  def update
  end

  def button_down(id)
    case @scene
    when :start
      button_down_start(id)
    when :round_one
      button_down_rounds(id)
    when :round_two
      button_down_rounds(id)
    when :final
      button_down_final(id)
    when :end
      button_down_end(id)
    end
  end

  def button_down_start(id)
    if id == Gosu::MsLeft && mouse_x < 550 && mouse_x > 268 && mouse_y < 402 && mouse_y > 368
      initialize_round_one
    end
  end
end
