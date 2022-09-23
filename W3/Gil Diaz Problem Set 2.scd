//Problem Set 2
//Due 3pm Sept 16th 2021

//First, save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set 2.scd"), and upload this renamed file to the course website for your submission.

//----------
//Problem 0.
//Write some code which iterates over the array of integers from 1 to 10 and returns a new array containing the reciprocal of each value (in other words, 1 divided by each number).

(
~func = {
	Array.fill(10, {|i| i+1;})
	.collect({
		|n|
		n = 1/n;
	});
};
)

~func.value();

//----------
//Problem 1.
//Modify the code in the previous problem so that the iteration code is enclosed within a named function that includes a single declared argument, so that it is possible to pass any array of numbers into the function and have it return an array of reciprocals. Add an additional line of code that evaluates your function to demonstrate that it works properly.

(
~func2 = {
	arg in;
	in.collect({
		|n|
		n = 1/n;
	});
};
)

~func2.value([1, 2, 3, 10]);


//----------
//Problem 2.
//Create and plot an envelope that roughly approximates the shape seen in the following link. The total duration of the envelope must be exactly three seconds. <https://uofi.box.com/s/b1vusvzpvfj4g99zavrjrcrktgfi0mmj>

(
Env.new(
	[0, 1, 0.1, 1, 0],
	[0.02, 1.48, 1.48, 0.02],
	['lin', -4.5, 4.5, 'lin']
).plot;
)


//----------
//Problem 3.
//Create and plot an instance of the Env class that re-creates the exact shape produced by half a second of a 5 Hz triangle wave. Keep in mind that the high points of this shape have a value of +1 and the low points have a value of -1.

s.boot;

{LFTri.ar(5)}.plot(0.5); //imitate this shape

(
Env.new(
	[0, 1, -1, 1, -1, 1, 0],
	[1/20, 1/10, 1/10, 1/10, 1/10, 1/20]
).plot();
)

//----------
//Problem 4.
//Rewrite the following code using Synth and SynthDef. Keep all parameter values exactly as they appear. The result should sound exactly the same.

(
~fn = {
	arg freq=300, modhz=1, amp=0.1;
	var sig, mod;
	sig = SinOsc.ar(freq);
	mod = SinOsc.ar(modhz).range(0.4, 1);
	sig = sig * mod;
	sig = sig * amp;
	sig = sig!2;
};
)

x = ~fn.play(args: [\freq, 70.midicps, \modhz, 3]);

x.free;



(
SynthDef.new(\fns, {
	arg freq=300, modhz=1, amp=0.1;
	var sig, mod;
	sig = SinOsc.ar(freq);
	mod = SinOsc.ar(modhz).range(0.4, 1);
	sig = sig * mod;
	sig = sig * amp;
	sig = sig!2;
	Out.ar(0, sig);
}).add;
)

x = Synth(\fns, [\freq, 70.midicps, \modhz, 3]);

x.free;


//----------
//Problem 5.
//Copy, paste, and modify the SynthDef you created in the previous problem so that it creates and applies an envelope to the overall amplitude of the output signal. The envelope should move from zero to one over 2 seconds, and from one back to zero over 4 seconds. Make sure the Synth frees itself when the envelope finishes. Include a Synth.new statement to demonstrate that the amplitude envelope works correctly.

(
SynthDef.new(\fns, {
	arg freq=300, modhz=1, amp=0.1;
	var sig, mod, env;
	env = EnvGen.ar(
		Env.new(
			[0, 1, 0],
			[2, 4]
		),
		doneAction: 2
	);
	sig = SinOsc.ar(freq);
	mod = SinOsc.ar(modhz).range(0.4, 1);
	sig = sig * mod;
	sig = sig * amp;
	sig = sig * env;
	sig = sig!2;
	Out.ar(0, sig);
}).add;
)

x = Synth(\fns, [\freq, 70.midicps, \modhz, 3]);



//----------
//Problem 6.
//Modify the SynthDef you created in the previous problem by declaring two new arguments named 'atk' and 'rel' and incorporating them into the envelope. These values will represent the attack time and release time of the envelope. Include a new Synth.new statement that passes in custom values for these arguments, to demonstrate the flexible duration of your modified envelope.

(
SynthDef.new(\fns, {
	arg freq=300, modhz=1, amp=0.1,
	atk=2, rel=4;
	var sig, mod, env;
	env = EnvGen.ar(
		Env.new(
			[0, 1, 0],
			[atk, rel]
		),
		doneAction: 2
	);
	sig = SinOsc.ar(freq);
	mod = SinOsc.ar(modhz).range(0.4, 1);
	sig = sig * mod;
	sig = sig * amp;
	sig = sig * env;
	sig = sig!2;
	Out.ar(0, sig);
}).add;
)

x = Synth(\fns, [\freq, 70.midicps, \modhz, 3, \atk, 0.02, \rel, 0.2]);
x = Synth(\fns, [\freq, 70.midicps, \modhz, 3, \atk, 3, \rel, 4]);


//----------
//Problem 7.
//Modify the SynthDef from the previous problem so that the envelope sustains indefinitely at its highest point. You will need to declare and implement a 'gate' argument for the envelope. Include a new Synth.new statement that demonstrates the ability of your envelope to sustain indefinitely, and include a second line which closes the gate and causes a fade-out.

(
SynthDef.new(\fns, {
	arg freq=300, modhz=1, amp=0.1,
	atk=2, rel=4, gate=1, pan=0;
	var sig, mod, env;
	env = EnvGen.ar(
		Env.new(
			[0, 1, 0],
			[atk, rel],
			releaseNode:1
		),
		gate: gate,
		doneAction: 2
	);
	sig = SinOsc.ar(freq);
	mod = SinOsc.ar(modhz).range(0.4, 1);
	sig = sig * mod;
	sig = sig * amp;
	sig = sig * env;
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add;
)

x = Synth(\fns, [\freq, 70.midicps, \modhz, 3, \atk, 0.1, \rel, 3]);
x.set(\gate, 0);


//----------
//Problem 8.
//Use iteration to generate a chord of 5 Synths, using the SynthDef from the previous problem, and write a second iteration block that fades out all 5 Synths. The following conditions must be met:

// -- The 5 pitches of these Synths must be unique (no duplicates, but octaves are ok), but you can select any pitches you like

// -- The overall signal level must not go above 0 dB (watch your level meters!)

// -- The frequency of the modulating sine wave (modhz) should be a random float value between 5.0 and 6.0. Each Synth should have its own uniquely generated random value (rather than one random value applied to all 5 Synths)

// Generate list of notes
(
~ton = rrand(40, 60);
~ton.postln;
~index = 0;
~notes = Array.fill(5, {
	~index = ~index + 1;
	~ton + (~index * rrand(5, 7));
});
~notes.postln;
)

// Play all
(
~chord = ~notes.collect({
	|in|
	Synth(\fns, [
		\freq, in.midicps,
		\modhz, rrand(5.0, 6.0),
		\amp, rrand(0.05, 0.15),
		\atk, 0.1,
		\rel, 3,
		\pan, rrand(-0.5, 0.5)
	])
});
)

// Release all
(
~chord.do({|in| in.set(\gate, 0)});
)



//----------
//Problem 9.
//The following UGen function applies an envelope to the amplitude of the output signal. Everything seems to work fine — it produces sound and there are no errors. But, there's a problem. What is it? Fix the issue and add a comment indicating what the problem was.

(
{
	var sig, env;
	env = EnvGen.kr(
		Env.new([1, 0], [4], [-3]),
		// doneAction was not set here, so the Synth did not free itself
		doneAction: 2
	);
	sig = Blip.ar([300,305], 16);
	sig = sig * LFPulse.kr(12, width:0.2);
	sig = sig * env;
	sig = sig * 0.4!2;
}.play;
)



//----------
//Problem 10.
//The following UGen function is supposed to play a filtered sawtooth tone with a 1 second attack and a 1 second release. But, we just hear a steady tone with a uniform amplitude for 2 seconds. What's wrong? Fix the issue and add a comment indicating what the problem was.

(
{
	var sig, env;
	sig = Saw.ar([250, 251]);
	sig = LPF.ar(sig, 1500);
	env = EnvGen.kr(
		Env.new([0, 1, 0], [1, 1], [0, 0]),
		doneAction:2
	);
	// While env is defined in the lines above, it is never applied to sig. I multiplied sig * env to do this in the line below.
	sig = sig * env;
	sig = sig * 0.2!2;
}.play
)





