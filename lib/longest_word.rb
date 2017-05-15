# require 'open-uri'
# require 'json'

# def generate_grid(grid_size)
#   # TODO: generate random grid of letters
#   letter_grid = ('A'..'Z').to_a
#   random_grid = []
#   grid_size.times { random_grid << letter_grid[rand(letter_grid.length)] }
#   return random_grid
# end

# def run_game(attempt, grid, start_time, end_time)
#   time_to_run = end_time - start_time
#   attempt_array = attempt.upcase.chars
#   score = (100 - (end_time - start_time).to_f) * attempt.length
#   words = File.read('/usr/share/dict/words').upcase.split("\n")
#   return hash_gen(time_to_run, 0, "not an english word", nil) unless words.include? attempt.upcase
#   attempt_array.each do |letter|
#     if grid.include? letter
#       grid.delete_at(grid.index(letter))
#     else
#       return hash_gen(time_to_run, 0, "not in the grid", nil)
#     end
#   end
#   return hash_gen(time_to_run, score, "well done", generate_api(attempt))
# end

# def hash_gen(time_to_run, score, message, translation)
#   result_hash = {
#     time: time_to_run,
#     score: score,
#     message: message,
#     translation: translation
#   }
#   return result_hash
# end

# def generate_api(attempt)
#   key = "52fc809e-554e-4420-ad0b-99593b64f5fc"
#   url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{key}&input=#{attempt}"
#   attempt_serialized = open(url).read
#   JSON.parse(attempt_serialized)["outputs"][0]["output"]
# end

require 'open-uri'
require 'json'

def generate_grid(grid_size)
  # TODO: generate random grid of letters
  arr = ('A'..'Z').to_a.sample(grid_size)
  Array.new(grid_size) { arr.sample }
end

def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  result = { time: end_time - start_time, translation: "", score: 0, message: "not in the grid" }
  if english_word?(attempt)
    if word_in_grid?(attempt, grid)
      result[:score] = score_calc(attempt, result[:time])
      result[:message] = "well done"
      result[:translation] = translation(attempt)
    else
      result[:message] = "not in the grid"
    end
  else
    result[:message] = "not an english word"
    result[:translation] = nil
  end
  return result
end

def english_word?(attempt)
  words = File.read('/usr/share/dict/words').upcase.split("\n")
  words.include?(attempt.upcase)
end

def word_in_grid?(attempt, grid)
  attempt = attempt.upcase.split("")
  overlap = (attempt & grid).flat_map { |n| [n] * [attempt.count(n), grid.count(n)].min }
  overlap == attempt
end

def score_calc(attempt, time) # attempt, time needed, correct word true or false
  time > 60.0 ? 0 : attempt.split("").count * (1.0 - time / 60.0)
end

def translation(attempt)
  api = "72d6cd5e-0ecd-4546-b692-0a8980eefa74"
  url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{api}&input=#{attempt}"
  user_serialized = open(url).read
  user = JSON.parse(user_serialized)
  user["outputs"][0]["output"]
end
