// 2021.08.26 Introduction

7 + 32;

// To run a piece of code, use Ctrl + Enter or Shift + Enter

// Supercollider does not care about whitespace:
(
7+32

;
)


// You need to declare variables:
(
var num;
num = 6;
num = num * 4;
num = num -1;
)

// Supercollider will "forget" about variables unless it is defined and modified at the same time. e.g.

var num;

// This will give an error message "Variable 'num' not defined." even though it is defined in the previous line. This is because num is a local variable.
num = 6 + 12;

// To make a global variable, use ~
~num = 6;
~num = ~num * 4;

// ~num is remembered here
~num;

// These are actually "environment variables". They are remembered accross files.
// For other global variables, you can use the lowercase letters:
n = 6;

n;

// s is automatically tied to the local server, so don't use it.
s;








// Functions
// Functions define code but do not run them.

(
~func = {
	var num;
	num = 6;
	num = num * 4;
	num = num -1;
};
)
// The last line of the fucnction is what is returned automatically (no need to use return)

// Here, ~func is the reciever and .value is the method
~func.value;

~num = ~func.value;



// Arguments define an input for the function:
(
~func = {
	arg num;
	num = num * 4;
	num = num -1;
};
)

~num = ~func.value(8);
// Can also use use .({arg}) instead of .value({arg});
// Can also use || to declare args: |num|  is the same as arg num;

(
~func = {
	|num|
	num = num * 4;
	num = num -1;
};
)

~num = ~func.(8);






// To look up documentation, can use Ctrl + D
SinOsc;

// To bring up search bar for documentation, use Shift + Ctrl + D





// You can check an object's class using .class method:
14.class;

// Some common classes
String;
Integer;
Float;
Character;
Symbol;
Array;

// Character needs to be preceded with $:
$i.class;
// Symbols need \ or '':
'sym'.class;
\sym.class;

// The largest difference between symbols and strings is that Strings have a size, while Symbols have a size of 0:
"string".size;
\string.size;

// Arrays are ordered collections. They are not class specific by default.
~myArray = [1, "hi", 3.5, 7, \there, -12.001];

~nums = [150, 190, 240, 345];

// You can fetch the value stored at a position in an array using .at():
// Arrays use 0-indexing, so 0 is position 1
~nums.at(0);

~myArray.at(4).class;

// Syntax shortcut for .at():
~nums[0];

// Some methods:
~nums.reverse;
~nums.scramble;

// These methods do not alter the receiver array. They instead return a new array.
// To alter the receiver, use something like this:
~myArray = ~myArray.scramble;




// Making sound
// Supercollider is actually three languages: SC IDE (where you type), SCLang (all the methods, classes, etc.), and SCSynth (the interpreter that actually makes the sound).
// I might have misheard this last part :)
// Fist, boot the audio server
s.boot;

// UGen functions: Unit Generator -> things that do things with signals
(
~mySound = {
	// SinOsc: Sinusoid Oscillator
	// .ar Run this oscillator at the audio rate

	// Play a sine wave at 200 Hz at 0.2 volume:
	SinOsc.ar(200, 0, 0.2, 0);
};
)

x = ~mySound.play;

// *********IMPORTANT*********
// Ctrl + . stops synths that are playing.
// Instead of that, you can use .free;
x.free;


// To use a UGen with args:
(
~mySound = {
	|freq|
	SinOsc.ar(freq, 0, 0.2, 0);
};
)

x = ~mySound.play(args: [\freq, 400]);

