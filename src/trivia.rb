require "http"

class Trivia
  def initialize
    round_one_cats = []
    round_two_cats = []
    @final_questions = []

    while round_one_cats.length < 5 && round_two_cats.length < 5 && @final_questions.length < 1
      response = HTTP.get("http://jservice.io/api/random?count=100").parse

      response.each do |question|
        case question["value"]
        when 100 || 300 || 500
          round_one_cats << question["category"]["id"]
        when 600 || 700 || 800 || 900 || 1000
          round_two_cats << question["category"]["id"]
        when nil
          @final_questions << question
        end
      end
    end

    @round_one_questions = []
    @round_one_categories = []

    round_one_cats.sample(5).each do |category|
      questions_one = []
      questions_two = []
      questions_three = []
      questions_four = []
      questions_five = []
      response = HTTP.get("https://jservice.io/api/category?id=#{category}").parse
      @round_one_categories << response["title"]
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
        end
      end

      @round_one_questions << [questions_one.sample, questions_two.sample, questions_three.sample, questions_four.sample, questions_five.sample]
    end

    @round_two_questions = []
    @round_two_categories = []

    round_two_cats.sample(5).each do |category|
      questions_one = []
      questions_two = []
      questions_three = []
      questions_four = []
      questions_five = []
      response = HTTP.get("https://jservice.io/api/category?id=#{category}").parse
      @round_two_categories << response["title"]
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
        end
      end

      @round_two_questions << [questions_one.sample, questions_two.sample, questions_three.sample, questions_four.sample, questions_five.sample]
    end
  end
end
