//Problem Set 8
//Due 3pm CDT Thursday Nov 11th 2021

//Save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set 8.scd").

/*
-------
Prompt:

Create a GUI for a tic-tac-toe game for two human players sharing the same computer. The game should have the following features:

- A window containing 9 buttons arranged in a 3x3 grid, each with three possible states (empty, X, O).

- The game should keep track of whose turn it is using a global variable. The X player should be first. When beginning a new game, the first clicked button should change to the "X" state, the second clicked button should change to the "O" state, and this process should alternate.

- Players should only be able to click blank buttons. Once a button is clicked, it should become un-clickable until the game is reset. This can be done using the 'enabled' attribute, i.e. button.enabled_(false);

- After each button click, the game should check for a win by examining all eight possible three-in-a-rows. If a win is detected, the game should declare the winner by posting "X wins!" or "O wins!" in the post window. If all buttons have been clicked but there is no win, post "draw!" in the post window.

- Finally, include a reset button that resets all buttons to their blank state, re-enables all buttons to be clickable, and makes it player X's turn.

Here is a video of what the result should look like:
https://uofi.box.com/s/abx428wbx2z7wkqnspvxozdozesmnbxk
*/
