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

// Everything is in one block, so just run this:
(
// Set global vars and named functions
~turn = 0;
~xwin = 0;
~owin = 0;

~buttons = [
	[0,1,2],
	[0,1,2],
	[0,1,2]
];

// Helper, check all values in the ~buttons array
~checkValues = {
	~out = Array.new(3);
	~buttons.do({
		|row|
		~inner = Array.new(3);
		row.do({
			|b|
			~inner.add(b.value());
		});
		~out.add(~inner);
	});
	~out;
};

// Helper, set all buttons unclickable after the game ends
// Edited to also update x and o win counts
~setUnclickable = {
	~buttons.do({
		|rows|
		rows.do({
			|b|
			b.enabled_(false);
		});
	});
	~xWinView.string = "X Wins: " + ~xwin;
	~oWinView.string = "O Wins: " + ~owin;
};

~checkForWin = {
	// Easier typing, ~out is set by ~checkValues
	~checkValues.();
	x = ~out;

	// This is so repetitive there has to be a better way.
	// P1 is value 1 in button states array, so mul is 1
	// P2 is value 2 in button states array, so mul is 8
	case
	// P1
	{
		// Check columns
		(x[0][0] * x[1][0] * x[2][0] == 1) ||
		(x[0][1] * x[1][1] * x[2][1] == 1) ||
		(x[0][2] * x[1][2] * x[2][2] == 1) ||
		// Check rows
		(x[0][0] * x[0][1] * x[0][2] == 1) ||
		(x[1][0] * x[1][1] * x[1][2] == 1) ||
		(x[2][0] * x[2][1] * x[2][2] == 1) ||
		// Check diag
		(x[0][0] * x[1][1] * x[2][2] == 1) ||
		(x[0][2] * x[1][1] * x[2][0] == 1)
	} {
		"X Wins!".postln;
		~xwin = ~xwin + 1;
		~setUnclickable.value();
	}

	// P2
	{
		// Check columns
		(x[0][0] * x[1][0] * x[2][0] == 8) ||
		(x[0][1] * x[1][1] * x[2][1] == 8) ||
		(x[0][2] * x[1][2] * x[2][2] == 8) ||
		// Check rows
		(x[0][0] * x[0][1] * x[0][2] == 8) ||
		(x[1][0] * x[1][1] * x[1][2] == 8) ||
		(x[2][0] * x[2][1] * x[2][2] == 8) ||
		// Check diag
		(x[0][0] * x[1][1] * x[2][2] == 8) ||
		(x[0][2] * x[1][1] * x[2][0] == 8)
	} {
		"O Wins!".postln;
		~owin = ~owin + 1;
		~setUnclickable.value();
	}

	// Check draw
	// Since blank is 0 in Button array, it will mul to 0 unless it's a draw.
	{
		x[0][0] * x[1][0] * x[2][0] *
		x[0][1] * x[1][1] * x[2][1] *
		x[0][2] * x[1][2] * x[2][2] != 0
	} {"Draw!".postln;}
};

~resetAll = {
	~buttons.do({
		|rows|
		rows.do({
			|b|
			b.value = 0;
			b.enabled_(true);
		});
	});
	// Set X player turn
	~turn = 0;
};


////////////////////////////////////////////////////


// Create the window
Window.closeAll;
~wSize = 600;
w = Window.new("Yic Yac Yoe", Rect(
	Window.screenBounds.width/2 - (~wSize/2),
	Window.screenBounds.height/2 - (~wSize/2),
	~wSize,
	~wSize + 50
));
w.alwaysOnTop_(true);
w.front;

// Assign buttons
~left = 50;
~top = 50;
~buttons.do({
	|row|
	3.do({
		|b|
		row.put(b,Button.new(w, Rect(~left, ~top, 150, 150))
			.states_(
				[[], ["X", Color.red()], ["O", Color.blue()]]
			)
			.font_(Font.new(size:120))
			.action_({
				|view|
				if(
					~turn == 0,
					{
						view.value = 1;
						~turn = 1;
					},
					{
						view.value = 2;
						~turn = 0;
					}
				);
				~checkForWin.value();
				view.enabled_(false);
			})
		);
		~left = ~left + 175;
	});
	~left = 50;
	~top = ~top + 175;
});

// Reset button
~resetBtn = Button.new(w, Rect.new(	50,	575, 100, 50 ))
.states_(
	[["Reset", Color.gray(0.55), Color.white()]]
)
.action_({
	~resetAll.value()
})
// in testing, using a font not on the computer just used the default font, so I chose to use Courier New, even though it may not be on the computer used for grading.
.font_(Font.new("Courier New"));

// X win count
~xWinView = StaticText.new(w, Rect.new( 225, 575, 100, 50))
.string_("X Wins: 0")
.font_(Font.new("Courier New"));

// O win count
~oWinView = StaticText.new(w, Rect.new( 325, 575, 100, 50))
.string_("O Wins: 0")
.font_(Font.new("Courier New"));
\
)