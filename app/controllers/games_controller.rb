require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('a'..'z').to_a[rand(26)]
    end
    @start_time = Time.now
    @letters
  end

  def score
    if params[:word]
      attempt = params[:word]
      grid = params[:grid].split(' ')
      start_time = DateTime.parse(params[:start_time]).to_datetime
      @result = { time: Time.now - start_time }

      score_and_message = score_and_message(attempt, grid, @result[:time])
      @result[:score] = score_and_message.first
      @result[:message] = score_and_message.last

      @result
    end
  end

  private

  def grid_inclusion(attempt, grid)
    attempt.chars.all? do |letter|
      attempt.count(letter) <= grid.count(letter)
    end
  end

  def english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    response_serialized = open(url).read
    response = JSON.parse(response_serialized)
    response["found"]
  end

  def score_and_message(attempt, grid, time)
    if grid_inclusion(attempt, grid)
      if english_word?(attempt)
        score = compute_score(attempt, time)
        [score, "Congratulations! #{attempt.upcase} is a valid English word!"]
      else
        [0, "Sorry but #{attempt.upcase} does not seem to be a valid English word..."]
      end
    else
      [0, "Sorry but #{attempt.upcase} cannot be built out of #{grid.join(", ").upcase}"]
    end
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end
end
