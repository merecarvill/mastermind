require_relative 'mastermind_ai'
require_relative 'guess_checker'

class MastermindAITester

  def initialize(code_elements, code_length)
    @code_elements = code_elements
    @code_length = code_length
  end

  def run_tests(num)
    test_data = []
    num.times do 
      test_data << run_one_test(MastermindAI.new(@code_elements, @code_length))
    end
    avg, max, percent_max = calculate_stats(test_data)
    puts <<-eos
===== Mastermind AI Tests =====
Number of tests run: #{num}
Average turns to win: #{avg}
Max turns to win: #{max}
% of tests where it took #{max} turns: #{percent_max.round(1)}
eos
  end

  def calculate_stats(test_data)
    avg = test_data.reduce(:+).to_f / test_data.length
    max = test_data.max
    percent_max = test_data.count(max).to_f / test_data.length * 100.0
    return [avg, max, percent_max]
  end

  def run_one_test(ai)
    checker = GuessChecker.new(generate_code)
    feedback = {}
    turn_counter = 0

    until feedback[:match] == @code_length
      guess = ai.make_guess
      feedback = checker.compare_to_code(guess)
      ai.receive_feedback(feedback)
      turn_counter += 1
    end

    return turn_counter
  end

  def generate_code
    (1..@code_length).map{ @code_elements.sample }
  end
end