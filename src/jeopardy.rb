require "gosu"
require_relative "trivia"
require_relative "gameboard"

class Jeopardy < Gosu::Window
  attr_reader :scene

  def initialize
    super 1000, 600
    self.caption = "Jeopardy"
    @scene = :start
    @trivia = Trivia.new
    @start_game_image = Gosu::Image.new("media/jeopardy_start.png", :tileable => true)
    @font_values = Gosu::Font.new(20)
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
    y = 0
    @board.grid.each do |row|
      x = 0
      row.each do
        if @board.grid[y][x] != 0
          @font_values.draw(@trivia.find_question(scene, x, y).value, (75 + (126 * x)), (140 + (90 * y)), 2)
        end
        x += 1
      end
      y += 1
    end
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

  def button_down_rounds(id)
    if id == Gosu::MsLeft
      y = 0
      @board.grid.each do |row|
        x = 0
        row.each do
          if mouse_x < (146 + (126 * (x))) && mouse_x > (30 + (126 * (x))) && mouse_y < (210 + (90 * (y))) && mouse_y > (128 + (90 * (y)))
            if @board.grid[y][x] == 1
              p @trivia.find_question(scene, x, y)
              @board.grid[y][x] = 0
            elsif @board.grid[x][y] == 2
              p "Daily Double"
              @board.grid[y][x] = 0
            end
          end
          x += 1
        end
        y += 1
      end
    end
  end
end
