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
    @question_background = Gosu::Image.new("media/solid_blue.jpeg", :tileable => true)
    @font_values = Gosu::Font.new(40)
    @font_categories = Gosu::Font.new(18)
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
    when :question
      draw_question
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

  def draw_question
    @question_background.draw(0, 0, 0)
    Gosu::Image.from_text(@trivia.find_question(@scene_pass, @x_pass, @y_pass).category, 40, options = { :width => 500, :align => :center }).draw(100, 10, 2)
    Gosu::Image.from_text(@trivia.find_question(@scene_pass, @x_pass, @y_pass).value, 40, options = { :width => 500, :align => :center }).draw(100, 50, 2)
    Gosu::Image.from_text(@trivia.find_question(@scene_pass, @x_pass, @y_pass).question, 40, options = { :width => 500, :align => :center }).draw(100, 100, 2)

    if @show_answer
      Gosu::Image.from_text(@trivia.find_question(@scene_pass, @x_pass, @y_pass).answer, 40, options = { :width => 500, :align => :center }).draw(100, 450, 2)
    end
  end

  def draw_rounds
    @board.game_background_image.draw(0, 0, 0)
    y = 0
    6.times do
      Gosu::Image.from_text(@trivia.find_question(scene, y, 0).category, 24, options = { :width => 118, :align => :center }).draw((28 + (126 * y)), 25, 2)
      y += 1
    end
    y = 0
    @board.grid.each do |row|
      x = 0
      row.each do
        if @board.grid[y][x] != 0
          @font_values.draw(@trivia.find_question(scene, x, y).value, (60 + (126 * x)), (150 + (90 * y)), 2, scale_x = 1, scale_y = 1, color = Gosu::Color::YELLOW)
        end
        x += 1
      end
      y += 1
    end
  end

  def update
    case @scene
    when :round_one
      update_round
    when :round_two
      update_round
    end
  end

  def update_round
    if @board.check_board_clear && scene == :round_one
      initialize_round_two
    end
  end

  def update_question
  end

  def button_down(id)
    case @scene
    when :start
      button_down_start(id)
    when :question
      button_down_question(id)
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

  def button_down_question(id)
    if id == Gosu::MsLeft && !@show_answer
      @show_answer = true
    else
      @scene = @scene_pass
      @show_answer = false
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
              @y_pass = y
              @x_pass = x
              @scene_pass = @scene
              @scene = :question
              @board.grid[y][x] = 0
            elsif @board.grid[y][x] == 2
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
