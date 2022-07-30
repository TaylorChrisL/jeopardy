class Question
  attr_reader :question, :answer, :value, :category, :row_number, :column_number

  def initialize(question, answer, value, category, row_number, column_number)
    @question = question
    @answer = answer
    @value = value
    @category = category
    @row_number = row_number
    @column_number = column_number
  end
end
