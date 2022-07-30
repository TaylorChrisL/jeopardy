class GameBoard
  def initialize
    @grid = [
      [1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1],
    ]
  end

  def set_daily_double
    if jeopardy.scene == :round_one
      square = rand(1..25)
      row = square / 5
      column = square % 5
      @grid[row][column] = 2
    elsif jeopardy.scene == :round_two
      squares = (0..24).to_a.sort { rand() - 0.5 }[0..1]
      row_one = squares[0] / 5
      column_one = squares[0] % 5
      @grid[row_one][column_one] = 2
      row_two = squares[1] / 5
      column_two = squares[1] % 5
      @grid[row_two][column_two] = 2
    end
  end
end
