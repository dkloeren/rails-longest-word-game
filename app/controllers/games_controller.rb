class GamesController < ApplicationController
  # require "open-uri"
  # require "json"

  def new
    alphabet = ("A".."Z").to_a
    @grid = []
    10.times do |letter|
      @grid << alphabet.sample
    end
  end

  def score
    word = params[:word].upcase
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    result_serialized = URI.open(url).read
    @result = JSON.parse(result_serialized)

    # check if word only has grid letters
    @grid = params[:grid].split(//)
    letters = params[:word].split(//)

    valid_combination = true
    letters.each do |x|
      if !@grid.include?(x)
        valid_combination = false
      end
    end

    cookies[:username] = "David"
    cookies[:score] = word.length
    # binding.pry

    if @result["found"]
      @answer = "Congratulations! #{word} is a valid English word!"
    else
      if valid_combination
        @answer = "#{word} does not seem to be a valid English word..."
      else
        @answer = "Sorry but #{word} can't be build out of #{@grid.join(", ")}"
      end
    end
  end
end
