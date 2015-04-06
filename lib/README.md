## The Classes:

- **Mastermind:** Runs the game, keeps track of the customizeable rules.
- **GameInterface:** Handles the command line interface for the game.
- **MastermindAI:** Handles logic and functions of the computer player.
- **GuessChecker:** Handles comparing guesses to a code and returning feedback about matching, missing, or close elements.

Note: game_script.rb will run the game in the command line. core_extensions.rb contains extensions to the Ruby core - specifically a couple of Array methods. It's often irked me that you can't subtract items one-for-one from an Array by default - though I'd think twice about extending the core in anything other than a personal project. 