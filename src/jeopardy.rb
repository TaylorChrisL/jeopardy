require "gosu"
require_relative "trivia"
require_relative "gameboard"
require_relative "player"

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
    @player_one = Player.new
    @player_two = Player.new
    @player_three = Player.new
  end

  def initialize_question
    @current_question = @trivia.find_question(@scene_pass, @x_pass, @y_pass)
    @scene = :question
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
    draw_scores
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

  def draw_scores
    Gosu::Image.from_text(@player_one.score, 40, options = { :width => 200, :align => :center }).draw(800, 60, 2)
    Gosu::Image.from_text(@player_two.score, 40, options = { :width => 200, :align => :center }).draw(800, 260, 2)
    Gosu::Image.from_text(@player_three.score, 40, options = { :width => 200, :align => :center }).draw(800, 460, 2)
    Gosu::Image.from_text("Player One", 40, options = { :width => 200, :align => :center }).draw(800, 10, 2)
    Gosu::Image.from_text("Player Two", 40, options = { :width => 200, :align => :center }).draw(800, 210, 2)
    Gosu::Image.from_text("Player Three", 40, options = { :width => 200, :align => :center }).draw(800, 410, 2)
    draw_quad(800, 100, Gosu::Color::BLUE, 900, 100, Gosu::Color::BLUE, 900, 200, Gosu::Color::BLUE, 800, 200, Gosu::Color::BLUE)
    draw_quad(900, 100, Gosu::Color::RED, 1000, 100, Gosu::Color::RED, 1000, 200, Gosu::Color::RED, 900, 200, Gosu::Color::RED)
    draw_quad(800, 300, Gosu::Color::BLUE, 900, 300, Gosu::Color::BLUE, 900, 400, Gosu::Color::BLUE, 800, 400, Gosu::Color::BLUE)
    draw_quad(900, 300, Gosu::Color::RED, 1000, 300, Gosu::Color::RED, 1000, 400, Gosu::Color::RED, 900, 400, Gosu::Color::RED)
    draw_quad(800, 500, Gosu::Color::BLUE, 900, 500, Gosu::Color::BLUE, 900, 600, Gosu::Color::BLUE, 800, 600, Gosu::Color::BLUE)
    draw_quad(900, 500, Gosu::Color::RED, 1000, 500, Gosu::Color::RED, 1000, 600, Gosu::Color::RED, 900, 600, Gosu::Color::RED)
    Gosu::Image.from_text("O", 80, options = { :width => 100, :align => :center }).draw(800, 110, 2)
    Gosu::Image.from_text("X", 80, options = { :width => 100, :align => :center }).draw(900, 110, 2)
    Gosu::Image.from_text("O", 80, options = { :width => 100, :align => :center }).draw(800, 310, 2)
    Gosu::Image.from_text("X", 80, options = { :width => 100, :align => :center }).draw(900, 310, 2)
    Gosu::Image.from_text("O", 80, options = { :width => 100, :align => :center }).draw(800, 510, 2)
    Gosu::Image.from_text("X", 80, options = { :width => 100, :align => :center }).draw(900, 510, 2)
  end

  def draw_question
    @question_background.draw(0, 0, 0)
    Gosu::Image.from_text(@current_question.category, 40, options = { :width => 800, :align => :center }).draw(0, 10, 2)
    Gosu::Image.from_text(@current_question.value, 40, options = { :width => 800, :align => :center }).draw(0, 50, 2)
    Gosu::Image.from_text(@current_question.question, 40, options = { :width => 800, :align => :center }).draw(0, 100, 2)

    if @show_answer
      Gosu::Image.from_text(@current_question.answer, 40, options = { :width => 800, :align => :center }).draw(0, 450, 2)
    else
      Gosu::Image.from_text("Press 'spacebar' to Show Answer", 40, options = { :width => 800, :align => :center, :color => Gosu::Color::GREEN }).draw(0, 450, 2)
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
    if id == Gosu::KB_SPACE && !@show_answer
      @show_answer = true
    elsif id == Gosu::KB_SPACE && @show_answer
      @scene = @scene_pass
      @show_answer = false
    end
    if id == Gosu::MsLeft && @show_answer
      if 800 < mouse_x && mouse_x < 900 && 100 < mouse_y && mouse_y < 900
        @player_one.score += @current_question.value
      elsif 900 < mouse_x && mouse_x < 1000 && 100 < mouse_y && mouse_y < 900
        @player_one.score -= @current_question.value
      end
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
              @board.grid[y][x] = 0
              initialize_question
            elsif @board.grid[y][x] == 2
              p "Daily Double"
              @y_pass = y
              @x_pass = x
              @scene_pass = @scene
              @board.grid[y][x] = 0
              @board.grid[y][x] = 0
              initialize_question
            end
          end
          x += 1
        end
        y += 1
      end
    end
  end
end
