// 2021.09.02 Week

// Conditional Logic
if
then
else
while
for
do
switch (case)

// equality:
2 == 3;
2 != 3;

2 > 3;
2 < 3;

2 >= 3;
2 <= 3;

// if statement:
(
if(
	{conditional expression},
	{true function},
	{false function}
);
)

(
if(
	[0,1].choose == 0,
	{ "0 was chosen".postln; },
	{ "1 was chosen".postln; }
);
)

// Example
(
~func = {
	arg input;
	if(
		input > 5,
		{ "sine".postln; },
		{ "noise".postln; }
	);
};
)

~func.(5);

// Case
// evaluate many cases, first one that is true is executed
// You can use Shift + Tab to align second statement
(
~func = {
	arg input;
	case
	{input < 0}	 {"sine".postln;}
	{input > 10} {"noise".postln;}
	{true}		 {"sawtooth".postln;}
};
)

~func.(10);








// Randomness

// Ranged random:
// Returns a number between these two numbers, inclusive. Uniform distribution. Can use negatives.
// Returns an int if both inputs are ints
// Returns a float if one of the inputs is a float
rrand(10, 19);
10.rrand(19);
rrand(-10, 20);

rrand(10.0, 11);


// Exponential distribution
// randomness skewed toward 0
// Always returns floats
exprand(1, 100);
exprand(1, 100).round;
exprand(1, 100).asInteger;
exprand(1, 100).neg;

// Can't use negatives, unless both are negatives
exprand(-1, 100);
exprand(-1, -200);





// Useful audio server utilities

// Boot the server
s.boot;

// Server meter: Ctrl + M
s.meter;

// Scope: Ctrl + Shift + M
s.scope;

// Freq Scope (Spectrum Analyzer): Ctrl + Alt + M
s.freqscope;

// Master fader:
s.volume.gui;

// Show Node Tree: Ctrl + alt +  T



// Making sound: UGens and function.play
// can show reminder text with Ctrl + Shift + Spacebar or Ctrl + ,
(
~mysound = {
	arg freq=400;
	SinOsc.ar(freq, 0, 0.2, 0);
};
)

x = ~mysound.play(args: [\freq, 400]);

x.set(\freq, 300);
x.set(\freq, 200);

x.free;

// ~mysound defines the function. x is the actual live sound Synth, which produces noise.


// To plot:
// Tap m on keyboard to cycle views
~mysound.plot(0.003);




// So far, sound is monophonic
// All UGens in and output monophonic signal

// UGens will see arrays as multichannel signal:
(
~mysound = {
	arg freq=400;
	SinOsc.ar(freq, 0, 0.2, 0);
	// Last line is the output
	[sig, sig];
};
)



(
{
	var sig;
	sig = PinkNoise.ar(0.2);
	[sig, sig];
};
)


// Array functions
7.dup(5);
7!5;


(
{
	var sig;
	sig = PinkNoise.ar(0.2);
	sig!2;
};
)


// Multichannel Expansion
// Providing a UGen an array will make it evaluate for each element in the array:
(
{
	var sig;
	sig = PinkNoise.ar(0.2!2);
}.play;
)


// This will just copy the UGen, whereas the previous will copy the input amplitude but generate two separate UGens.
// This example will have the exact same output for both channels.
(
{
	var sig;
	sig = PinkNoise.ar(0.2)!2;
}.play;
)


/////////////////



// Since digital audio is stored as numbers (samples), you can use mathmatic operations on signals.
(
{
	arg freq=400;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig + SinOsc.ar(freq * 2);
	sig = sig * 0.2
	sig!2;
}.play;
)

// Can use the .range method to specify the range of outputs for a UGen
(
{
	arg freq=400;
	var sig, mod;
	sig = WhiteNoise.ar(0.1);
	mod = SinOsc.ar(1).range(0.1, 0.6);
	sig = sig * mod;
	sig!2;
}.play;
)

(
{
	arg freq=400;
	var sig, mod;
	sig = WhiteNoise.ar(0.1);
	mod = Pulse.ar(0.5).range(0.1, 0.6).poll;
	sig = sig * mod;
	sig!2;
}.play;
)

