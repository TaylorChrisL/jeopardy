require "http"
require_relative "question"

class Trivia
  attr_reader :round_one, :round_two, :final

  def initialize
    round_one_cats = []
    round_two_cats = []
    final_questions = []

    while round_one_cats.length < 6 || round_two_cats.length < 6 || final_questions.length < 1
      response = HTTP.get("http://jservice.io/api/random?count=100").parse

      response.each do |question|
        if question["category"]["clues_count"] >= 5
          case question["value"]
          when 100 || 300 || 500
            round_one_cats << question["category"]["id"]
          when 600 || 700 || 800 || 900 || 1000
            round_two_cats << question["category"]["id"]
          when nil
            final_questions << question
          end
        end
      end
    end

    round_one_questions = []
    round_one_categories = []

    round_one_cats.sample(6).each do |category|
      questions_one = []
      questions_two = []
      questions_three = []
      questions_four = []
      questions_five = []
      questions_nil = []
      response = HTTP.get("https://jservice.io/api/category?id=#{category}").parse
      round_one_categories << response["title"]
      response["clues"].each do |question|
        case question["value"]
        when 100
          questions_one << question
        when 200
          questions_two << question
        when 300
          questions_three << question
        when 400
          questions_four << question
        when 500
          questions_five << question
        else
          question["value"] = nil
          questions_nil << question
        end
      end
      if questions_one.empty?
        questions_one.push(questions_nil.delete_at(0))
        questions_one[0]["value"] = 100
      end
      if questions_two.empty?
        questions_two.push(questions_nil.delete_at(0))
        questions_two[0]["value"] = 200
      end
      if questions_three.empty?
        questions_three.push(questions_nil.delete_at(0))

        questions_three[0]["value"] = 300
      end
      if questions_four.empty?
        questions_four.push(questions_nil.delete_at(0))
        questions_four[0]["value"] = 400
      end
      if questions_five.empty?
        questions_five.push(questions_nil.delete_at(0))
        questions_five[0]["value"] = 500
      end

      round_one_questions << [questions_one.sample, questions_two.sample, questions_three.sample, questions_four.sample, questions_five.sample]
    end

    round_two_questions = []
    round_two_categories = []

    round_two_cats.sample(6).each do |category|
      questions_one = []
      questions_two = []
      questions_three = []
      questions_four = []
      questions_five = []
      questions_nil = []
      response = HTTP.get("https://jservice.io/api/category?id=#{category}").parse
      round_two_categories << response["title"]
      response["clues"].each do |question|
        case question["value"]
        when 200
          questions_one << question
        when 400
          questions_two << question
        when 600
          questions_three << question
        when 800
          questions_four << question
        when 1000
          questions_five << question
        else
          question["value"] = nil
          questions_nil << question
        end
      end

      if questions_one.empty?
        questions_one.push(questions_nil.delete_at(0))
        questions_one[0]["value"] = 200
      end
      if questions_two.empty?
        questions_two.push(questions_nil.delete_at(0))
        questions_two[0]["value"] = 400
      end
      if questions_three.empty?
        questions_three.push(questions_nil.delete_at(0))

        questions_three[0]["value"] = 600
      end
      if questions_four.empty?
        questions_four.push(questions_nil.delete_at(0))
        questions_four[0]["value"] = 800
      end
      if questions_five.empty?
        questions_five.push(questions_nil.delete_at(0))
        questions_five[0]["value"] = 1000
      end

      round_two_questions << [questions_one.sample, questions_two.sample, questions_three.sample, questions_four.sample, questions_five.sample]
    end

    @round_one = []
    @round_two = []

    column_number = 0
    for i in 0..5
      row_number = 0
      for j in 0..4
        @round_one << Question.new(round_one_questions[i][j]["question"], round_one_questions[i][j]["answer"], round_one_questions[i][j]["value"], round_one_categories[i], column_number, row_number)
        @round_two << Question.new(round_two_questions[i][j]["question"], round_two_questions[i][j]["answer"], round_two_questions[i][j]["value"], round_two_categories[i], column_number, row_number)
        row_number += 1
      end
      column_number += 1
    end

    final = final_questions.sample
    @final = Question.new(final["question"], final["answer"], "Final Jeopardy", final["category"]["title"], 0, 0)
  end

  def find_question(scene, row_number, column_number)
    if scene == :round_one
      @round_one.each do |question|
        if question.row_number == row_number && question.column_number == column_number
          return question
        end
      end
    end
    if scene == :round_two
      @round_two.each do |question|
        if question.row_number == row_number && question.column_number == column_number
          return question
        end
      end
    end
    if scene == :final
      return @final
    end
  end
end
