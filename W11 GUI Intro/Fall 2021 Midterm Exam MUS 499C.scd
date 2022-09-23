//Midterm Exam Fall 2021
//Due 3pm Oct 15th

//----------
//Problem 0.
//The following code prints an error and fails to produce sound. Correct the error and add a comment indicating what the problem was.

s.boot;

(
x = {
	// The line below was missing the arg keyword.
	arg gate=1, freq=100, brownamp=0.04, amp=1;
	var sig, env;
	env = EnvGen.kr(
		Env.asr(3,1,2),
		gate,
		doneAction:2
	);
	sig = Pulse.ar(freq + [0,1], 0.5, 0.06);
	sig = sig + SinOsc.ar(1.5 * freq + [0,0.6], 0, 0.15);
	sig = sig + BrownNoise.ar(brownamp!2);
	sig = sig * env * amp;
}.play;
)

x.set(\gate, 0);

//----------
//Problem 1.
//Copy/Paste the corrected UGen function from the previous problem, and convert it to a SynthDef. You may add additional arguments if you wish, but this is not required. Add a line of code that creates a Synth, and another line that fades the Synth out, to demonstrate that the SynthDef works properly.

(
SynthDef.new(\pulse, {
	arg gate=1, freq=100, brownamp=0.04, amp=1;
	var sig, env;
	env = EnvGen.kr(
		Env.asr(3,1,2),
		gate,
		doneAction:2
	);
	sig = Pulse.ar(freq + [0,1], 0.5, 0.06);
	sig = sig + SinOsc.ar(1.5 * freq + [0,0.6], 0, 0.15);
	sig = sig + BrownNoise.ar(brownamp!2);
	sig = sig * env * amp;
	Out.ar(0, sig);
}).add;
)

x = Synth.new(\pulse);
x.set(\gate, 0);


//----------
//Problem 2.
//Use iteration to produce a chord containing 5 Synths, using the SynthDef from the previous problem. Write a second iteration block that fades out all 5 Synths. Choose five different pitches, and make sure the overall signal does not clip above 0 dB.

(
x = [40, 45, 50, 55, 60].collect({
	|i|
	Synth.new(\pulse, [
		\freq: i.midicps,
		\amp: 0.2
	]);
}
);
)

(
x.do({
	|i|
	i.set(\gate, 0);
}
);
)



//----------
//Problem 3.
//Modify the SynthDef so that the frequency slowly fluctuates by a small random amount. The resulting pitch deviation should be subtle, but audible. Create a different chord consisting of 5 unique pitches to demonstrate this change.


(
SynthDef.new(\pulse, {
	arg gate=1, freq=100, brownamp=0.04, amp=1, modhz;
	var sig, env, drift;
	env = EnvGen.kr(
		Env.asr(3,1,2),
		gate,
		doneAction:2
	);
	drift = LFNoise1.ar(modhz).range(0.95, 1.05);
	sig = Pulse.ar(freq * drift + [0,1], 0.5, 0.06);
	sig = sig + SinOsc.ar(1.5 * freq * drift + [0,0.6], 0, 0.15);
	sig = sig + BrownNoise.ar(brownamp!2);
	sig = sig * env * amp;
	Out.ar(0, sig);
}).add;
)

(
x = [ 40, 47, 54, 61, 68 ].collect({
	|i|
	Synth.new(\pulse, [
		\freq: i.midicps,
		\amp: 0.2
	]);
}
);
)

(
x.do({
	|i|
	i.set(\gate, 0);
}
);
)


