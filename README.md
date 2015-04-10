# Mastermind

Mastermind is a two-player code-breaking game where one player makes a code (the human player in this case) and another player guesses the code (the computer player in this case).

The task is to create a game that allows a human to play against the computer. The computer should be able to guess the correct code (created by the human player) within 10 turns. The code is made up of four colors and can include duplicates. There are six available colors from which to choose: red, green, orange, yellow, blue, purple.

### Brief description of the classes:

- **Mastermind:** Runs the game, keeps track of the customizeable rules.
- **MastermindInterface:** Handles the command line interface for the game.
- **MastermindAI:** Handles logic and functions of the computer player.
- **GuessChecker:** Handles comparing guesses to a code and returning feedback about matching, missing, or close elements.
- **MastermindAITester:** A simple class for evaluating the performance of the Mastermind AI.

Note: core_extensions.rb contains extensions to the Ruby core - specifically a couple of Array methods. It's often irked me that you can't subtract items one-for-one from an Array by default - though I'd think twice about extending the core in anything other than a personal project. 

### Scripts

- *game_script.rb* - Run in the command line to play a game of Mastermind versus the computer. You can easily edit the script to change the game's code length, code elements, and maximum number of turns. 
- *ai_tester_script.rb* - Run in the command line to see stats on how the AI does across 100 random games of Mastermind. You can easily edit this script as well to alter test games' code length and code elements. 