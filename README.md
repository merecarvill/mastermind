# Mastermind

Mastermind is a two-player code-breaking game where one player makes a code (the human player in this case) and another player guesses the code (the computer player in this case).

The task is to create a game that allows a human to play against the computer. The computer should be able to guess the correct code (created by the human player) within 10 turns. The code is made up of four colors and can include duplicates. There are six available colors from which to choose: red, green, orange, yellow, blue, purple.

### Brief description of the classes:

- **Mastermind:** Runs the game, keeps track of its state and customizeable rules.
- **GameInterface:** Handles the command line interface for the game.
- **MastermindAI:** Handles logic and functions of the computer player.
- **GuessChecker:** Handles comparing guesses to a code and returning feedback about matching, missing, or close elements.

Note: core_extensions.rb contains extensions to the Ruby core. game_script.rb will run the game in the command line.