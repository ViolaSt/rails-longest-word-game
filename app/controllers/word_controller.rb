require_relative "../../lib/longest_word"

class WordController < ApplicationController

  def game
    @grid = generate_grid(7).join("  ").upcase
    @start_time = Time.now

     # @grid = params["grid"]
  end

  def score
    @end_time = Time.now
    @grid = params[:grid].split("  ")
    @start_time =  Time.parse(params[:start_time])
    @attempt = params[:query]
    @answer = run_game(@attempt, @grid, @start_time, @end_time)
  end
end

