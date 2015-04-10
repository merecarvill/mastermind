## The Scripts

- *game_script.rb* - Run in the command line to play a game of Mastermind versus the computer. You can easily edit the script to change the game's code length, code elements, and maximum number of turns. 
- *ai_tester_script.rb* - Run in the command line to see stats on how the AI does across 100 random games of Mastermind. You can easily edit this script as well to alter the number of tests or the test games' code length and code elements. 

FUN FACTS: The Mastermind AI takes about an extra turn, on average, to guess the code when I change the method - by which it chooses a guess from an array of possible guesses - from Array#sample to Array#first (4.63 vs. 5.75). The Array#sample method can, with a very small probability, behave exactly like Array#first - which makes the latter method a nice test of the worst-case scenario. After a 10000-test battery, Array#first's worst-case was 9 guesses to solve the code, which occurred about 0.4% of the time. 