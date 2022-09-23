//Problem Set 6
//Due 3pm CDT Thursday Oct 21st 2021

//Save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set 6.scd").

//----------
//Problem 0.
//Using a pattern (or combination of patterns), produce an infinite-length stream that outputs the number 1 approximately 97% of the time, and produces a random integer between 100-200 3% of the time. Include a line of code that uses .nextN to retrieve the first 50 values of this stream.




//----------
//Problem 1.
//Using a pattern (or combination of patterns), produce an finite-length stream whose outputs starts at 1. The output should be successively reduced by 0.01, and the sign should alternate between + and -. For example, the first few numbers will be: [1, -0.99, 0.98, -0.97, 0.96...]. The final value of the stream should be zero. For this problem, Pseq is not allowed!




//----------
//Problem 2.
//Using a pattern (or combination of patterns), produce a stream that outputs an infinite sequence of ascending integers. The stream should start at one, and skip every multiple of five. Include a line of code that uses .nextN to retrieve the first 50 values of this




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




//----------
//Problem 4.
//Copy, paste, and modify your work from the previous problem so that:
//(1) the pan position of each synth is a random float between -1 and 1 and
//(2) exactly one of these five notes is noticeably longer than the rest - but the note that becomes longer should be randomly chosen from the five each time the sequence is played.




//----------
//Problem 5.
//Using the SynthDef provided (feel free to make additions/changes of your own), create and play a Pbind that produces a spectrally and spatially complex sustained drone/pad. There should be lots of simultaneous overlapping Synths, each with long attacks and long releases. For making pitch determinations, use a combination of \degree, \scale, and/or \mtranspose. Monitor your output amplitude and make sure the signal doesn't clip. Pitch content and other musical decisions are up to you. This is a semi-free composition exercise — make it sound awesome!
