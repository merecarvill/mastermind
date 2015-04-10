require_relative "../lib/mastermind_ai_tester"

code_elements = [:red, :blue, :yellow, :green, :purple, :orange]
code_length = 4
num_tests = 100
t = MastermindAITester.new(code_elements, code_length)
t.run_tests(num_tests)