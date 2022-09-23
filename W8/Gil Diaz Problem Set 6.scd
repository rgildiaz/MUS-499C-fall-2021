//Problem Set 6
//Due 3pm CDT Thursday Oct 21st 2021

//Save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set 6.scd").

//----------
//Problem 0.
//Using a pattern (or combination of patterns), produce an infinite-length stream that outputs the number 1 approximately 97% of the time, and produces a random integer between 100-200 3% of the time. Include a line of code that uses .nextN to retrieve the first 50 values of this stream.

(
x = Pwrand(
	[1, Prand((100..200), 1)],
	[97, 3].normalizeSum,
	inf
).asStream;

x.nextN(50);
)


//----------
//Problem 1.
//Using a pattern (or combination of patterns), produce a finite-length stream whose outputs starts at 1. The output should be successively reduced by 0.01, and the sign should alternate between + and -. For example, the first few numbers will be: [1, -0.99, 0.98, -0.97, 0.96...]. The final value of the stream should be zero. For this problem, Pseq is not allowed!

(
x = (
	Pseries(1, -0.01, 101) * Pgeom(1, -1, inf);
).asStream;
// I am using two .nextN() to avoid the ...etc... for a list that is too long to fit in the post window.
x.nextN(50).round(0.01).postln;
x.nextN(51).round(0.01).postln;\
)

(
// Also, I emailed prof Fieldsteel about this already, but there is a rounding error bug if without the .round():
x = (
	Pseries(1, -0.01, 101) * Pgeom(1, -1, inf);
).asStream;
x.nextN(50).postln;
x.nextN(51).postln;\
)

//----------
//Problem 2.
//Using a pattern (or combination of patterns), produce a stream that outputs an infinite sequence of ascending integers. The stream should start at one, and skip every multiple of five. Include a line of code that uses .nextN to retrieve the first 50 values of this

(
x = (
	Pseq((1..4), inf) + (5 * Pseries(0, 0.25, inf).floor);
).asStream;
x.nextN(50).postln;\
)


//----------
//Problem 3.
//Using the SynthDef provided, create a Pbind, and play it to produce an EventStreamPlayer. The event stream should produce exactly five Synths with the following criteria:
//(1) Each Synth should have a total duration of 0.05 seconds,
//(2) each frequency should be higher than the one before it,
//(3) each Synth should occur 1/4 second after the one before it, and
//(4) the amplitude of each Synth should decrease exponentially over time.
//Other details are up to you.

s.boot;

(
SynthDef.new(\basic, {
	arg freq=500, atk=0.002, sus=0, rel=1, pan=0, amp=0.1, out=0;
	var sig, env;
	env = EnvGen.ar(
		Env.new([0,1,1,0],[atk,sus,rel],[2,0,-2]),
		doneAction:2
	);
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp) * env;
	Out.ar(out, sig);
}).add;
)

x = Synth(\basic); //testing

(
y = Pbind(
	\instrument, \basic,
	\dur, 1/4,
	\freq, Pgeom(rrand(200, 600), 1.5, 5),
	\amp, Pgeom(0.75, 0.5),
	\atk, 0.002,
	\rel, 0.048,
	\pan, Pseries(-1, 2/5) * Prand([1, -1], inf)
);

y.play;
)


//----------
//Problem 4.
//Copy, paste, and modify your work from the previous problem so that:
//(1) the pan position of each synth is a random float between -1 and 1 and
//(2) exactly one of these five notes is noticeably longer than the rest - but the note that becomes longer should be randomly chosen from the five each time the sequence is played.

(
y = Pbind(
	\instrument, \basic,
	\dur, 1/4,
	\freq, Pgeom(rrand(200, 600), 1.5, 5),
	\amp, Pgeom(0.75, 0.5),
	\atk, 0.002,
	\rel, Pshuf([0.048, 0.048, 0.048, 0.048, 1], inf),
	\pan, Pseries(-1, 2/5) * Prand([1, -1], inf)
);

y.play;
)


//----------
//Problem 5.
//Using the SynthDef provided (feel free to make additions/changes of your own), create and play a Pbind that produces a spectrally and spatially complex sustained drone/pad. There should be lots of simultaneous overlapping Synths, each with long attacks and long releases. For making pitch determinations, use a combination of \degree, \scale, and/or \mtranspose. Monitor your output amplitude and make sure the signal doesn't clip. Pitch content and other musical decisions are up to you. This is a semi-free composition exercise — make it sound awesome!

(
SynthDef.new(\basic1, {
	arg freq=500, atk=2, sus=0, rel=2, amp=0.1, pan=0, out=0;
	var sig, env, drift, modhz, white, whitemod;
	env = EnvGen.ar(
		Env.new([0,1,1,0],[atk,sus,rel],[2,0,-2]),
		doneAction:2
	);
	modhz = LFNoise0.ar(1).range(0.01, 1);
	drift = LFNoise1.ar(modhz).range(0.97, 1.03);
	white = BPF.ar(WhiteNoise.ar(0.03), freq);
	whitemod = WhiteNoise.ar().range(0.999, 1.01);
	sig = SinOsc.ar(freq*drift*whitemod) + white;
	sig = Pan2.ar(sig, pan, amp) * env * whitemod;
	Out.ar(out, sig);
}).add;
)


(
g = Pbind(
	\instrument, \basic1,
	\dur, Pwhite(0.5, 2),
	\scale, Scale.choose(5, 12),
	\degree, Pwrap(
		Pseries(0, 1, inf),
		0,
		5,
	),
	\mtranspose, Prand((-10..5), inf),
	\amp, Pwhite(0.01, 0.15, inf),
	\atk, Pwhite(3, 5, inf),
	\rel, Pwhite(2, 4, inf),
	\pan, Pwhite(-1, 1, inf),
).play;
)

g.stop;