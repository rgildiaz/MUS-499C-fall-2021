//Problem Set 4
//Due 3pm Sept 30th 2021

//----------
//Problem 0.
//Download the following two audio samples (a desk bell and a drum loop):

https://uofi.box.com/s/vrh8j78mhend29hvyydpt4gygtlb0wfh //drum loop
https://uofi.box.com/s/2jcyp9wic50dqs78fa1weyijihldwwtj //desk bell

//Boot the audio server. As demonstrated in class, create a project folder named "[your last name] Problem Set 4." Save this code file in that folder, naming it "[your last name] Problem Set 4.scd," and also move or copy these two audio files into this folder.

s.boot;

/**NOTE: when you submit your assignment, make sure to compress this folder as a zip file and submit the zip file, so that your submission contains code and audio — don't submit only the scd file!!**/

//Using the "thisProcess.nowExecutingPath" approach, write some code that reads these two files into Buffers, and stores each Buffer in a unique global variable name. If you've done this correctly, I should be able to run this code on my own computer to read these files into buffers, without having to change any of your code.

~path = PathName(thisProcess.nowExecutingPath).parentPath;

(
b = (
	bell: Buffer.read(s, ~path ++ "deskBell.aiff"),
	drum: Buffer.read(s, ~path ++ "drumloop1.wav")
);
)

b[\bell].play;
b[\drum].play;


//----------
//Problem 1.
//Write a line of code that returns the number of audio channels in the drum loop file, and another line of code that returns the number of audio channels in the desk bell file. No need to produce any sound here — just print/return the channel size information.

b[\bell].numChannels;
b[\drum].numChannels;


//----------
//Problem 2.
//Write a UGen function (not a SynthDef) that plays the desk bell sample once, at its original playback rate. The Synth should free itself when we reach the end of the sound file. Make sure to compensate for the possibility of a mismatch between the server's sampling rate and the sampling rate at which the sound file was created.

(
f = {
	PlayBuf.ar(2, b[\bell], BufRateScale.kr(b[\bell]), doneAction:2);
}
)

f.play;


//----------
//Problem 3.
//Convert the UGen function from the previous problem into a SynthDef. In the SynthDef, declare arguments for the bufnum, the playback rate, the overall signal amplitude, and the output bus. Then, use iteration to play the desk bell sample at five different pitches simultaneously, to create a five-voice chord. Make sure the amplitude of the overall sound doesn't clip above 0 dB.

(
SynthDef(\playBell, {
	arg bufnum, rate=1, amp=1, out=0;
	var sig;
	sig = PlayBuf.ar(2, bufnum, rate * BufRateScale.kr(bufnum), doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
[0, 3, 7, 8, 10].do({
	|in|
	Synth(\playBell, [
		\bufnum, b[\bell],
		\rate, in.midiratio,
		\amp, 1/5
	]);
});
)



//----------
//Problem 4.
//Create a new SynthDef or modify the existing SynthDef so that it is capable of looping and non-looping playback. Include a sustaining envelope with a gate argument that controls overall amplitude. Below this new/modified SynthDef, include a line of code that creates a Synth which endlessly loops through the drum sample at its original rate, and a second line of code that closes the envelope gate to fade out the sound.

(
SynthDef(\play, {
	arg bufnum, rate=1, amp=1, out=0, loop=0, gate=1;
	var sig, env;
	env = EnvGen.ar(
		Env(
			[0, 1, 0],
			[0.001, 4],
			releaseNode: 1
		),
		gate: gate,
		doneAction: 2
	);
	sig = PlayBuf.ar(2, bufnum, rate * BufRateScale.kr(bufnum), loop: loop, doneAction: 2);
	sig = sig * amp * env;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\play, [\bufnum: b[\drum], \loop, 1]);
x.set(\gate, 0);



//----------
//Problem 5.
//Add a similar line of code that creates a Synth that endlessly loops through the drum sample, but backward. Add a second line of code that closes the envelope gate and fades out the sound.

x = Synth.new(\play, [\bufnum: b[\drum], \loop, 1, \rate, -1]);
x.set(\gate, 0);


//----------
//Problem 6.
//Use iteration to play three copies of the backward-looping drum sample at very slightly different playback rates (e.g. -0.99, -1.0, -1.01), so that these three Synths drift out of phase with each other over time. Make sure the amplitude of the overall sound doesn't clip above 0 dB. Write another line of code that fades out all three Synths.

(
x = [-0.99, -1, -1.01].collect({
	|in|
	Synth.new(\play, [
		\bufnum: b[\drum],
		\loop, 1,
		\amp, 1/3,
		\rate, in
	]);
});
)

x.do({|in| in.set(\gate, 0)});



