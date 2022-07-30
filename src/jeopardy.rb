require "gosu"

class Jeopardy < Gosu::Window
  def initialize
    super 800, 600
    self.caption = "Jeopardy"
    @scene = :start
  end

  def initialize_game
    @scene = :game
    @grid = [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ]
  end
end
